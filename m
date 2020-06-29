Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C3E20D0B6
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgF2SfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgF2SfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB00124749;
        Mon, 29 Jun 2020 15:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444068;
        bh=YcBvkHLseg2B1KadSr98e/e+pOnVHrMnbfzANZoWk7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOP7MwMqWc1zEQUxwvWPEHvhPxK7pCjIv0iBN2dD7GdwQu5YkB5tV1pR1crzsP8Gh
         P6SAGwQaJAue3ZGiOAav3o1164LJJN7qwYsT2vxE9Cq2yYD6EddzyjsWQB+uikLwft
         PsnAu0YqQbKeajNpefEyozJYn/4ZsFh1Jhm7/01U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mans Rullgard <mans@mansr.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 177/265] i2c: core: check returned size of emulated smbus block read
Date:   Mon, 29 Jun 2020 11:16:50 -0400
Message-Id: <20200629151818.2493727-178-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index b34d2ff069318..bbb70a8a411e3 100644
--- a/drivers/i2c/i2c-core-smbus.c
+++ b/drivers/i2c/i2c-core-smbus.c
@@ -495,6 +495,13 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
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

