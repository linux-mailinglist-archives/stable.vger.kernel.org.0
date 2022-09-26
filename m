Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277835EA391
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbiIZL1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbiIZL0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:26:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCE869F7A;
        Mon, 26 Sep 2022 03:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70EEBB8091E;
        Mon, 26 Sep 2022 10:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778B4C433C1;
        Mon, 26 Sep 2022 10:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188838;
        bh=wTrXeuY4sF/nmZ4OEG26edgOn2fk8co8QKNhySMR+Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5mom1AHlOz/6RxHi4EkG0+XWQ3fapfjeI2subEHqqDQark7BbCJWDtyzEss5P5pt
         95h79eZk8SUe5uQflA5m8WWRgzL8OirE6rVMOQx3gOq15jjXaDD8q5yr/TEEnkEE8E
         yaNYYDh9abr3VdYnAAiGRMdyVIqjCupuzi0i+Y8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalil Blaiech <kblaiech@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/148] i2c: mlxbf: incorrect base address passed during io write
Date:   Mon, 26 Sep 2022 12:12:51 +0200
Message-Id: <20220926100801.356816506@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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
index 8716032f030a..612736906440 100644
--- a/drivers/i2c/busses/i2c-mlxbf.c
+++ b/drivers/i2c/busses/i2c-mlxbf.c
@@ -669,7 +669,7 @@ static int mlxbf_i2c_smbus_enable(struct mlxbf_i2c_priv *priv, u8 slave,
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



