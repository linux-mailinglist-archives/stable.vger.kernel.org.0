Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB8173ACD
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbfGXTxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387824AbfGXTxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:53:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A09CA22ADA;
        Wed, 24 Jul 2019 19:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998034;
        bh=orXWRKi23+doYAm/aUIa5cUQ8AntowNvjpxvHo18py4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGK7+G9ATTqDc0P+a2vAV1gdw8WYdK+1YHsOVjgd5axabWX+ljidCM5zp/FpKBAxq
         I1kCoj8z1daU2nfvCVMapChSsOYHlQ+nuxuryiZ/0zr/PwRHAa9Pte741SIUQHx2Jk
         W+SfUhNGso8hu2c8gm0XWc3vqossYZf5IZWsewPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@ispras.ru>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 224/371] floppy: fix div-by-zero in setup_format_params
Date:   Wed, 24 Jul 2019 21:19:36 +0200
Message-Id: <20190724191741.372895498@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f3554aeb991214cbfafd17d55e2bfddb50282e32 ]

This fixes a divide by zero error in the setup_format_params function of
the floppy driver.

Two consecutive ioctls can trigger the bug: The first one should set the
drive geometry with such .sect and .rate values for the F_SECT_PER_TRACK
to become zero.  Next, the floppy format operation should be called.

A floppy disk is not required to be inserted.  An unprivileged user
could trigger the bug if the device is accessible.

The patch checks F_SECT_PER_TRACK for a non-zero value in the
set_geometry function.  The proper check should involve a reasonable
upper limit for the .sect and .rate fields, but it could change the
UAPI.

The patch also checks F_SECT_PER_TRACK in the setup_format_params, and
cancels the formatting operation in case of zero.

The bug was found by syzkaller.

Signed-off-by: Denis Efremov <efremov@ispras.ru>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 95f608d1a098..e2f742e17683 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2119,6 +2119,9 @@ static void setup_format_params(int track)
 	raw_cmd->kernel_data = floppy_track_buffer;
 	raw_cmd->length = 4 * F_SECT_PER_TRACK;
 
+	if (!F_SECT_PER_TRACK)
+		return;
+
 	/* allow for about 30ms for data transport per track */
 	head_shift = (F_SECT_PER_TRACK + 5) / 6;
 
@@ -3231,6 +3234,8 @@ static int set_geometry(unsigned int cmd, struct floppy_struct *g,
 	/* sanity checking for parameters. */
 	if (g->sect <= 0 ||
 	    g->head <= 0 ||
+	    /* check for zero in F_SECT_PER_TRACK */
+	    (unsigned char)((g->sect << 2) >> FD_SIZECODE(g)) == 0 ||
 	    g->track <= 0 || g->track > UDP->tracks >> STRETCH(g) ||
 	    /* check if reserved bits are set */
 	    (g->stretch & ~(FD_STRETCH | FD_SWAPSIDES | FD_SECTBASEMASK)) != 0)
-- 
2.20.1



