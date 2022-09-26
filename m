Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7400B5EA24F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbiIZLFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237504AbiIZLEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:04:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B01D5F7DC;
        Mon, 26 Sep 2022 03:33:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4462760C05;
        Mon, 26 Sep 2022 10:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F00CC433D7;
        Mon, 26 Sep 2022 10:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188391;
        bh=x+L9myrdhMFe+PBMn/mlZoyBLiwv9mp5QQNf8CaZSb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYQnDWUYvB8lfZH/X4rgBuLQWah66L3KpnbpbtLWuoTa64I1j8p8cYJwEouMXSn9n
         x4KQO9HkCuTr8E4TuDB5EtYvmrE84IzKUihnfho+IQQniPR9TbF2yih11NqT8fjDby
         ILzxjVF1ixguttAN4kbdzWCluNvihBEAIUJct6Kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalil Blaiech <kblaiech@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/141] i2c: mlxbf: incorrect base address passed during io write
Date:   Mon, 26 Sep 2022 12:12:41 +0200
Message-Id: <20220926100759.341746397@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asmaa Mnebhi <asmaa@nvidia.com>

[ Upstream commit 2a5be6d1340c0fefcee8a6489cff7fd88a0d5b85 ]

Correct the base address used during io write.
This bug had no impact over the overall functionality of the read and write
transactions. MLXBF_I2C_CAUSE_OR_CLEAR=0x18 so writing to (smbus->io + 0x18)
instead of (mst_cause->ioi + 0x18) actually writes to the sc_low_timeout
register which just sets the timeout value before a read/write aborts.

Fixes: b5b5b32081cd206b (i2c: mlxbf: I2C SMBus driver for Mellanox BlueField SoC)
Reviewed-by: Khalil Blaiech <kblaiech@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxbf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mlxbf.c b/drivers/i2c/busses/i2c-mlxbf.c
index ab261d762dea..042c83b90734 100644
--- a/drivers/i2c/busses/i2c-mlxbf.c
+++ b/drivers/i2c/busses/i2c-mlxbf.c
@@ -675,7 +675,7 @@ static int mlxbf_i2c_smbus_enable(struct mlxbf_i2c_priv *priv, u8 slave,
 	/* Clear status bits. */
 	writel(0x0, priv->smbus->io + MLXBF_I2C_SMBUS_MASTER_STATUS);
 	/* Set the cause data. */
-	writel(~0x0, priv->smbus->io + MLXBF_I2C_CAUSE_OR_CLEAR);
+	writel(~0x0, priv->mst_cause->io + MLXBF_I2C_CAUSE_OR_CLEAR);
 	/* Zero PEC byte. */
 	writel(0x0, priv->smbus->io + MLXBF_I2C_SMBUS_MASTER_PEC);
 	/* Zero byte count. */
-- 
2.35.1



