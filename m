Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD8A333E7A
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhCJN0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233356AbhCJNZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02D5A65048;
        Wed, 10 Mar 2021 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382724;
        bh=DaZjTtdi5Bkrn+oxuyZCBH9oot1Hoa7szxfIGlHnk6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMkJiGB/hqwWH84HpsBRG0L7omZAHMiEZjE4NqbhbPbKqeTSZcTKeK/DFAJSPd3XD
         54016agPPP0KeP+Hv//IqJ64shYuQ/7G2nK4Waaor1rESTLqNXqBxwO5C0y7Y9cfel
         nzd3yqryCQPFKh9/D5vHiX1fLvKXvC3D43czOYQE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/39] rsxx: Return -EFAULT if copy_to_user() fails
Date:   Wed, 10 Mar 2021 14:24:26 +0100
Message-Id: <20210310132320.296254245@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
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
 drivers/block/rsxx/core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -179,15 +179,17 @@ static ssize_t rsxx_cram_read(struct fil
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


