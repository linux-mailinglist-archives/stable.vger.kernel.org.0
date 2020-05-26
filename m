Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155D41E2E15
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390877AbgEZTEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390954AbgEZTEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:04:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A904C20849;
        Tue, 26 May 2020 19:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519885;
        bh=LD/o2ex+Rt0c8iOqqjBxp9ea9Wl/TTj5tKRfuQmvYvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0XwiO10VsfZkG7cGwdrVnVN0WIe6So1MuDx2+iLh+f4oYclnQSp9QL7ucWpjJ8qm
         Cbi2Ef3+i7ZsnWkWmhByFJXIceExaZHU8Aj4npXc66/Ngi74HXCx0RM2GkWN7mG0Ai
         7zKqlDDhi+02mtqBFLV/DanZwXKUBGo2pDWiyIYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/81] ubi: Fix seq_file usage in detailed_erase_block_info debugfs file
Date:   Tue, 26 May 2020 20:52:49 +0200
Message-Id: <20200526183927.892759145@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 0e7572cffe442290c347e779bf8bd4306bb0aa7c ]

3bfa7e141b0b ("fs/seq_file.c: seq_read(): add info message about buggy .next functions")
showed that we don't use seq_file correctly.
So make sure that our ->next function always updates the position.

Fixes: 7bccd12d27b7 ("ubi: Add debugfs file for tracking PEB state")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/debug.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index 7bc96294ae4d..b108e1f04bf6 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -405,9 +405,6 @@ static void *eraseblk_count_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct ubi_device *ubi = s->private;
 
-	if (*pos == 0)
-		return SEQ_START_TOKEN;
-
 	if (*pos < ubi->peb_count)
 		return pos;
 
@@ -421,8 +418,6 @@ static void *eraseblk_count_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct ubi_device *ubi = s->private;
 
-	if (v == SEQ_START_TOKEN)
-		return pos;
 	(*pos)++;
 
 	if (*pos < ubi->peb_count)
@@ -444,11 +439,8 @@ static int eraseblk_count_seq_show(struct seq_file *s, void *iter)
 	int err;
 
 	/* If this is the start, print a header */
-	if (iter == SEQ_START_TOKEN) {
-		seq_puts(s,
-			 "physical_block_number\terase_count\tblock_status\tread_status\n");
-		return 0;
-	}
+	if (*block_number == 0)
+		seq_puts(s, "physical_block_number\terase_count\n");
 
 	err = ubi_io_is_bad(ubi, *block_number);
 	if (err)
-- 
2.25.1



