Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0E20DC78
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgF2UPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732819AbgF2TaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13A4A2527B;
        Mon, 29 Jun 2020 15:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444987;
        bh=Gm6NB5OaSRX0V3apjQo3zJ4NUY4P+FuV6gxdeznFVKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ni8H6Nh2mNh+MpoZHBmrw9hCm2+831VE6TwAv8nMO3rLHTjmSKBSjS/DULb4mlmBG
         4rLTWEfIeg4Ek7hhBhgG/Q+/sH73iKeeTKV6gx+V8WSp6WDwtluRtXveD2nPGAWTlz
         /UMtj+2BBkKCxDgFdLmq5s+o/bIPbyYS5WWRJzFU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mans Rullgard <mans@mansr.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/131] i2c: core: check returned size of emulated smbus block read
Date:   Mon, 29 Jun 2020 11:34:18 -0400
Message-Id: <20200629153502.2494656-88-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>

[ Upstream commit 40e05200593af06633f64ab0effff052eee6f076 ]

If the i2c bus driver ignores the I2C_M_RECV_LEN flag (as some of
them do), it is possible for an I2C_SMBUS_BLOCK_DATA read issued
on some random device to return an arbitrary value in the first
byte (and nothing else).  When this happens, i2c_smbus_xfer_emulated()
will happily write past the end of the supplied data buffer, thus
causing Bad Things to happen.  To prevent this, check the size
before copying the data block and return an error if it is too large.

Fixes: 209d27c3b167 ("i2c: Emulate SMBus block read over I2C")
Signed-off-by: Mans Rullgard <mans@mansr.com>
[wsa: use better errno]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-smbus.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/i2c/i2c-core-smbus.c b/drivers/i2c/i2c-core-smbus.c
index 9cd66cabb84fd..8d6fad05b0c7f 100644
--- a/drivers/i2c/i2c-core-smbus.c
+++ b/drivers/i2c/i2c-core-smbus.c
@@ -497,6 +497,13 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
 			break;
 		case I2C_SMBUS_BLOCK_DATA:
 		case I2C_SMBUS_BLOCK_PROC_CALL:
+			if (msg[1].buf[0] > I2C_SMBUS_BLOCK_MAX) {
+				dev_err(&adapter->dev,
+					"Invalid block size returned: %d\n",
+					msg[1].buf[0]);
+				status = -EPROTO;
+				goto cleanup;
+			}
 			for (i = 0; i < msg[1].buf[0] + 1; i++)
 				data->block[i] = msg[1].buf[i];
 			break;
-- 
2.25.1

