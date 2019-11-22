Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572A51065C3
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfKVFur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbfKVFur (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B9B42072E;
        Fri, 22 Nov 2019 05:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401845;
        bh=HB5lXUSzpl8k8VPM+f95nsCXDStsmwdSJQzLR6O5n0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXX9ywVwhTk0UJPbWm3KUbd/kRH2Vzizh4JbxljHjka+rfPqHkPjL+kgrSuU/crzv
         VVfT0KKdmNwj13uiFjUWL+lg4Y9Lv/I0YlqeLDGNhx6nNlk/+2XgkMVVXhGxvczZW1
         WN8HiOL22Iy5iADzBtyiXTe1t7eUpgC62y1E1xyY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 084/219] vfio-mdev/samples: Use u8 instead of char for handle functions
Date:   Fri, 22 Nov 2019 00:46:56 -0500
Message-Id: <20191122054911.1750-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

