Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5086357CE
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbiKWJoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238152AbiKWJnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04FF12747
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:41:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E1BA61B3B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F33C433C1;
        Wed, 23 Nov 2022 09:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196481;
        bh=L/nM+BqdI8CQ0JsCB003896I7ZgPq+TeFIFtwjcT/VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xvj2mKInLaEZeINEZSTUNuIlIwkmDpixwrHYy0ZiH82ESkjwSpQ4lFsEbU2M+toz
         eoClD48PbZ9GQ54pl16hZpzFNMzfVyEmA1vo0Yi2AyotBAO57rZcTf6ne2j6FeFImu
         SHL45wjBeyFXtySf0F/yO52wGlovJWReiQk9kekI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 003/314] spi: tegra210-quad: Fix combined sequence
Date:   Wed, 23 Nov 2022 09:47:28 +0100
Message-Id: <20221123084625.639401875@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit 8777dd9dff4020bba66654ec92e4b0ab6367ad30 ]

Return value should be updated to zero in combined sequence routine
if transfer is completed successfully. Currently it holds timeout value
resulting in errors.

Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/20221001122148.9158-1-kyarlagadda@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index c89592b21ffc..904972606bd4 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1157,6 +1157,11 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 		msg->actual_length += xfer->len;
 		transfer_phase++;
 	}
+	if (!xfer->cs_change) {
+		tegra_qspi_transfer_end(spi);
+		spi_transfer_delay_exec(xfer);
+	}
+	ret = 0;
 
 exit:
 	msg->status = ret;
-- 
2.35.1



