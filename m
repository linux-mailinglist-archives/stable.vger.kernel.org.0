Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CA3333E79
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhCJN0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhCJNZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3611650EE;
        Wed, 10 Mar 2021 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382724;
        bh=MiV04bqF3ixUNe7h/QK4ahwdf1u6hJlFjfA3uVWr7UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlEgkw5E86hY3ht/U4RwXUzeSFKIL8q3tbAdqOHcrDNepT0526RWmkAH1i+gX5Cdm
         DfaUqcQBhDQxkSjqOMOD3rwQxA+4Lj0xjtT39xkYzHQuQQ2/z68kA2ZC91wc0G5+N2
         M/XgQpbaFXWUEymScvlirf76fA4hxqazEs6Clxhw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/11] rsxx: Return -EFAULT if copy_to_user() fails
Date:   Wed, 10 Mar 2021 14:25:04 +0100
Message-Id: <20210310132320.559778671@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
References: <20210310132320.393957501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index 6beafaa335c7..97b678c0ea13 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -180,15 +180,17 @@ static ssize_t rsxx_cram_read(struct file *fp, char __user *ubuf,
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



