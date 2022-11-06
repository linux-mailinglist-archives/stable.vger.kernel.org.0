Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3135761E3A1
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiKFRDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiKFRDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:03:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0192FDF51;
        Sun,  6 Nov 2022 09:03:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC899B80BED;
        Sun,  6 Nov 2022 17:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B04BC4347C;
        Sun,  6 Nov 2022 17:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754230;
        bh=L/nM+BqdI8CQ0JsCB003896I7ZgPq+TeFIFtwjcT/VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxd6a0K7YzGm9GRLzSW4LUtnMKJMZejYRde6rTL2Chwk1pUwRwFUUuq/gryiOLO0q
         kkHwebqywOitkqh5Apd82LaKdwkBCj/yzD078grDrThCaU29fGwNDvWWjnhFUivUhQ
         GzVB8yvi3VJbc7g1pFck3/TPzjvCKRqlJ85lXUhNdOEF65PF6nAYHZhnaGW9cvT+WD
         BsWRwXO+EITsoecfGqEwFs5+7ECUgDY0t4LkVTCTgDdENog6QsGkem4jC3CqjSP2ts
         wvWUF3K9ykkIe9hPQkvQgtH16Zx1k217nGz+JYdvIkFsu1JlRw8oo5YAKyELiu43Un
         ZFHvTT8CoLfBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, thierry.reding@gmail.com,
        jonathanh@nvidia.com, skomatineni@nvidia.com, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 02/30] spi: tegra210-quad: Fix combined sequence
Date:   Sun,  6 Nov 2022 12:03:14 -0500
Message-Id: <20221106170345.1579893-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

