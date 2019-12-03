Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B7F111EB8
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfLCWwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:52:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729739AbfLCWwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DC0D20863;
        Tue,  3 Dec 2019 22:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413541;
        bh=HB5lXUSzpl8k8VPM+f95nsCXDStsmwdSJQzLR6O5n0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7LF3RUfMsuZ/6d2XtUWhcRpvO/BMd+MZrTbHWi4p1ktx2YgsGjx5GRfIoMEYSdYU
         rHuPFxOO8h9kpWViI5tTabYJIZPIEDxoY6z3r9QCCctdHBrJcMGx0WluicI2H8GXsT
         3sz8ofWssTd+y02g4kbWkktnBkrD4M86n9lieY4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/321] vfio-mdev/samples: Use u8 instead of char for handle functions
Date:   Tue,  3 Dec 2019 23:33:16 +0100
Message-Id: <20191203223433.916135437@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 8ba35b3a0046d6573c98f00461d9bd1b86250d35 ]

Clang warns:

samples/vfio-mdev/mtty.c:592:39: warning: implicit conversion from 'int'
to 'char' changes value from 162 to -94 [-Wconstant-conversion]
                *buf = UART_MSR_DSR | UART_MSR_DDSR | UART_MSR_DCD;
                     ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~
1 warning generated.

Turns out that all uses of buf in this function ultimately end up stored
or cast to an unsigned type. Just use u8, which has the same number of
bits but can store this larger number so Clang no longer warns.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/vfio-mdev/mtty.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 7abb79d8313d9..f6732aa16bb1f 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -171,7 +171,7 @@ static struct mdev_state *find_mdev_state_by_uuid(uuid_le uuid)
 	return NULL;
 }
 
-void dump_buffer(char *buf, uint32_t count)
+void dump_buffer(u8 *buf, uint32_t count)
 {
 #if defined(DEBUG)
 	int i;
@@ -250,7 +250,7 @@ static void mtty_create_config_space(struct mdev_state *mdev_state)
 }
 
 static void handle_pci_cfg_write(struct mdev_state *mdev_state, u16 offset,
-				 char *buf, u32 count)
+				 u8 *buf, u32 count)
 {
 	u32 cfg_addr, bar_mask, bar_index = 0;
 
@@ -304,7 +304,7 @@ static void handle_pci_cfg_write(struct mdev_state *mdev_state, u16 offset,
 }
 
 static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
-				u16 offset, char *buf, u32 count)
+				u16 offset, u8 *buf, u32 count)
 {
 	u8 data = *buf;
 
@@ -475,7 +475,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
 }
 
 static void handle_bar_read(unsigned int index, struct mdev_state *mdev_state,
-			    u16 offset, char *buf, u32 count)
+			    u16 offset, u8 *buf, u32 count)
 {
 	/* Handle read requests by guest */
 	switch (offset) {
@@ -650,7 +650,7 @@ static void mdev_read_base(struct mdev_state *mdev_state)
 	}
 }
 
-static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
+static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
 			   loff_t pos, bool is_write)
 {
 	struct mdev_state *mdev_state;
@@ -698,7 +698,7 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 #if defined(DEBUG_REGS)
 			pr_info("%s: BAR%d  WR @0x%llx %s val:0x%02x dlab:%d\n",
 				__func__, index, offset, wr_reg[offset],
-				(u8)*buf, mdev_state->s[index].dlab);
+				*buf, mdev_state->s[index].dlab);
 #endif
 			handle_bar_write(index, mdev_state, offset, buf, count);
 		} else {
@@ -708,7 +708,7 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 #if defined(DEBUG_REGS)
 			pr_info("%s: BAR%d  RD @0x%llx %s val:0x%02x dlab:%d\n",
 				__func__, index, offset, rd_reg[offset],
-				(u8)*buf, mdev_state->s[index].dlab);
+				*buf, mdev_state->s[index].dlab);
 #endif
 		}
 		break;
@@ -827,7 +827,7 @@ ssize_t mtty_read(struct mdev_device *mdev, char __user *buf, size_t count,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (char *)&val, sizeof(val),
+			ret =  mdev_access(mdev, (u8 *)&val, sizeof(val),
 					   *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -839,7 +839,7 @@ ssize_t mtty_read(struct mdev_device *mdev, char __user *buf, size_t count,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -851,7 +851,7 @@ ssize_t mtty_read(struct mdev_device *mdev, char __user *buf, size_t count,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -889,7 +889,7 @@ ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -901,7 +901,7 @@ ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -913,7 +913,7 @@ ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
-- 
2.20.1



