Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA8E217185
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgGGPVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729698AbgGGPVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:21:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C9392078A;
        Tue,  7 Jul 2020 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135279;
        bh=QHZHaMRGai+vdVgWa6RY1S8eqxxr2yVw5NNDIaD0tBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cvc//UVNQKgM4+TW3evs/kWeIJZkvHWvlk1SipwCetqt/If9MTCiXRrobDjy1U36T
         dSSrEN7Jzy0tuKLjJLmj0UlKZtwj4otaaXFTgdCmiaJYgWsmgCU8IfnTmXtGH7JuK4
         aqFKH3BEWc1a/o0GjeZan4Ef7cduGMmKiHEQPyaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Michael Shych <michaelsh@mellanox.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/65] i2c: mlxcpld: check correct size of maximum RECV_LEN packet
Date:   Tue,  7 Jul 2020 17:17:24 +0200
Message-Id: <20200707145754.642012872@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 597911287fcd13c3a4b4aa3e0a52b33d431e0a8e ]

I2C_SMBUS_BLOCK_MAX defines already the maximum number as defined in the
SMBus 2.0 specs. I don't see a reason to add 1 here. Also, fix the errno
to what is suggested for this error.

Fixes: c9bfdc7c16cb ("i2c: mlxcpld: Add support for smbus block read transaction")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Michael Shych <michaelsh@mellanox.com>
Tested-by: Michael Shych <michaelsh@mellanox.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxcpld.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mlxcpld.c b/drivers/i2c/busses/i2c-mlxcpld.c
index 2fd717d8dd30e..71d7bae2cbcad 100644
--- a/drivers/i2c/busses/i2c-mlxcpld.c
+++ b/drivers/i2c/busses/i2c-mlxcpld.c
@@ -337,9 +337,9 @@ static int mlxcpld_i2c_wait_for_tc(struct mlxcpld_i2c_priv *priv)
 		if (priv->smbus_block && (val & MLXCPLD_I2C_SMBUS_BLK_BIT)) {
 			mlxcpld_i2c_read_comm(priv, MLXCPLD_LPCI2C_NUM_DAT_REG,
 					      &datalen, 1);
-			if (unlikely(datalen > (I2C_SMBUS_BLOCK_MAX + 1))) {
+			if (unlikely(datalen > I2C_SMBUS_BLOCK_MAX)) {
 				dev_err(priv->dev, "Incorrect smbus block read message len\n");
-				return -E2BIG;
+				return -EPROTO;
 			}
 		} else {
 			datalen = priv->xfer.data_len;
-- 
2.25.1



