Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1A7330DC1
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhCHMcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhCHMby (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:31:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF45C651D3;
        Mon,  8 Mar 2021 12:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206714;
        bh=KsUzA5GS3Dks1R2FGSaF9xRXp9SszcEGq5jm5DJKKdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B99Jrap9X3LERxYsgiYYpHIQ5HCUEl8dR9SZbZr4gzDRdlMjUntU81zXpONGBJqkL
         RvYINicFIXmEbh15EkUSMBnf7WlEkvXUdYMpxMM0O9B0HT0uWtuHy76WNfp6FBT+4x
         HJmExzOzq5FFoOT0Wpo8Din/BqDHfkUIWmDjvqrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/22] rsxx: Return -EFAULT if copy_to_user() fails
Date:   Mon,  8 Mar 2021 13:30:38 +0100
Message-Id: <20210308122715.424235770@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 77516d25f54912a7baedeeac1b1b828b6f285152 ]

The copy_to_user() function returns the number of bytes remaining but
we want to return -EFAULT to the user if it can't complete the copy.
The "st" variable only holds zero on success or negative error codes on
failure so the type should be int.

Fixes: 36f988e978f8 ("rsxx: Adding in debugfs entries.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rsxx/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index 10f6368117d8..804d28faa97b 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -165,15 +165,17 @@ static ssize_t rsxx_cram_read(struct file *fp, char __user *ubuf,
 {
 	struct rsxx_cardinfo *card = file_inode(fp)->i_private;
 	char *buf;
-	ssize_t st;
+	int st;
 
 	buf = kzalloc(cnt, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
 	st = rsxx_creg_read(card, CREG_ADD_CRAM + (u32)*ppos, cnt, buf, 1);
-	if (!st)
-		st = copy_to_user(ubuf, buf, cnt);
+	if (!st) {
+		if (copy_to_user(ubuf, buf, cnt))
+			st = -EFAULT;
+	}
 	kfree(buf);
 	if (st)
 		return st;
-- 
2.30.1



