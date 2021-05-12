Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5881137C6F9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhELP5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233696AbhELPvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62905619D5;
        Wed, 12 May 2021 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833188;
        bh=u8DTeNU9PR7drrQsSPr8yuvabY5xeHIC6Zj/xahhxlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7lmsSFiEincGEt4OhyXsUVez/V5OViqyI2Pz0Zvru/IGXRBZtc0XscrObXBLq1Vh
         GyWoj0XE2zO3vX0LBzreFIVqQwM55GTdbk6r2QpeUyuHBwFD0v07jm9Qfetoj9cvxG
         +DDxKVat8wt1UW+/mwc/dbtm0FxJpo5adcLv/Z/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Glauber <jglauber@digitalocean.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.11 053/601] md: Fix missing unused status line of /proc/mdstat
Date:   Wed, 12 May 2021 16:42:10 +0200
Message-Id: <20210512144829.559879635@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Glauber <jglauber@digitalocean.com>

commit 7abfabaf5f805f5171d133ce6af9b65ab766e76a upstream.

Reading /proc/mdstat with a read buffer size that would not
fit the unused status line in the first read will skip this
line from the output.

So 'dd if=/proc/mdstat bs=64 2>/dev/null' will not print something
like: unused devices: <none>

Don't return NULL immediately in start() for v=2 but call
show() once to print the status line also for multiple reads.

Cc: stable@vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: Jan Glauber <jglauber@digitalocean.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8187,7 +8187,11 @@ static void *md_seq_start(struct seq_fil
 	loff_t l = *pos;
 	struct mddev *mddev;
 
-	if (l >= 0x10000)
+	if (l == 0x10000) {
+		++*pos;
+		return (void *)2;
+	}
+	if (l > 0x10000)
 		return NULL;
 	if (!l--)
 		/* header */


