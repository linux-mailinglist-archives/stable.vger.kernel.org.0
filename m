Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728EF37CB0B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241136AbhELQeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241387AbhELQ1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41ED8619D4;
        Wed, 12 May 2021 15:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834730;
        bh=2UqnH8t00UeXiH2AF0+z7Cbg+WQMWmL2oDAwOHP4aSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vgk1/BFQL9I8zaqz3zXJZdhrukLa7BxmR6O6slcwtX2E7VQYkOuenF0+FmHkUqnjM
         nTesIENSeq2S0OtKGvCI82l7HL1d5Qr3PvuVZo1coTqMVRoA2nKrB2np1Kbm/5hZuK
         ab1DyQ1buUhOLi4oI01EWDWEL6/KE+FwJkEZcxAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Glauber <jglauber@digitalocean.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.12 061/677] md: Fix missing unused status line of /proc/mdstat
Date:   Wed, 12 May 2021 16:41:47 +0200
Message-Id: <20210512144839.235519709@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
@@ -8172,7 +8172,11 @@ static void *md_seq_start(struct seq_fil
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


