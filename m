Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F44615F01B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388788AbgBNRwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:52:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388524AbgBNP6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 611D62082F;
        Fri, 14 Feb 2020 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695912;
        bh=yroluB80juEOBOMZpHb7UIBLBNUqDczFT6GWjTSJ5BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O78SqoI9Mmm+XgxQJtkQLG0dToBz+V3PROs1Q2u/ar2QOb++R5/LgaPWW1EsoVnN/
         taH9Ax3ryhS1H6Ysk46gMzhLKqSB/YQBpu62PyuGJ8l6ogfam0QNPidMkdgI5S+SbN
         5B1wT8g+cvy60LqPj0o3WYjxfVQwzyjTA1HZ2UmQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 451/542] tty: n_hdlc: Use flexible-array member and struct_size() helper
Date:   Fri, 14 Feb 2020 10:47:23 -0500
Message-Id: <20200214154854.6746-451-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit 85f4c95172d606dd66f7ee1fa50c45a245535ffd ]

Old code in the kernel uses 1-byte and 0-byte arrays to indicate the
presence of a "variable length array":

struct something {
    int length;
    u8 data[1];
};

struct something *instance;

instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
instance->length = size;
memcpy(instance->data, source, size);

There is also 0-byte arrays. Both cases pose confusion for things like
sizeof(), CONFIG_FORTIFY_SOURCE, etc.[1] Instead, the preferred mechanism
to declare variable-length types such as the one above is a flexible array
member[2] which need to be the last member of a structure and empty-sized:

struct something {
        int stuff;
        u8 data[];
};

Also, by making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertenly introduced[3] to the codebase from now on.

Lastly, make use of the struct_size() helper to safely calculate the
allocation size for instances of struct n_hdlc_buf and avoid any potential
type mistakes[4][5].

[1] https://github.com/KSPP/linux/issues/21
[2] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
[4] https://lore.kernel.org/lkml/60e14fb7-8596-e21c-f4be-546ce39e7bdb@embeddedor.com/
[5] commit 553d66cb1e86 ("iommu/vt-d: Use struct_size() helper")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20200121172138.GA3162@embeddedor
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_hdlc.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index 98361acd3053f..27b506bf03ced 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -115,11 +115,9 @@
 struct n_hdlc_buf {
 	struct list_head  list_item;
 	int		  count;
-	char		  buf[1];
+	char		  buf[];
 };
 
-#define	N_HDLC_BUF_SIZE	(sizeof(struct n_hdlc_buf) + maxframe)
-
 struct n_hdlc_buf_list {
 	struct list_head  list;
 	int		  count;
@@ -524,7 +522,8 @@ static void n_hdlc_tty_receive(struct tty_struct *tty, const __u8 *data,
 		/* no buffers in free list, attempt to allocate another rx buffer */
 		/* unless the maximum count has been reached */
 		if (n_hdlc->rx_buf_list.count < MAX_RX_BUF_COUNT)
-			buf = kmalloc(N_HDLC_BUF_SIZE, GFP_ATOMIC);
+			buf = kmalloc(struct_size(buf, buf, maxframe),
+				      GFP_ATOMIC);
 	}
 	
 	if (!buf) {
@@ -853,7 +852,7 @@ static struct n_hdlc *n_hdlc_alloc(void)
 
 	/* allocate free rx buffer list */
 	for(i=0;i<DEFAULT_RX_BUF_COUNT;i++) {
-		buf = kmalloc(N_HDLC_BUF_SIZE, GFP_KERNEL);
+		buf = kmalloc(struct_size(buf, buf, maxframe), GFP_KERNEL);
 		if (buf)
 			n_hdlc_buf_put(&n_hdlc->rx_free_buf_list,buf);
 		else if (debuglevel >= DEBUG_LEVEL_INFO)	
@@ -862,7 +861,7 @@ static struct n_hdlc *n_hdlc_alloc(void)
 	
 	/* allocate free tx buffer list */
 	for(i=0;i<DEFAULT_TX_BUF_COUNT;i++) {
-		buf = kmalloc(N_HDLC_BUF_SIZE, GFP_KERNEL);
+		buf = kmalloc(struct_size(buf, buf, maxframe), GFP_KERNEL);
 		if (buf)
 			n_hdlc_buf_put(&n_hdlc->tx_free_buf_list,buf);
 		else if (debuglevel >= DEBUG_LEVEL_INFO)	
-- 
2.20.1

