Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE2855DFF4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243841AbiF1CWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243562AbiF1CVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B38024966;
        Mon, 27 Jun 2022 19:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22EF1617DA;
        Tue, 28 Jun 2022 02:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E14C341CD;
        Tue, 28 Jun 2022 02:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382865;
        bh=i7qPYKlcHR9LVVGfJAgeQaBb7i3L4ZcOS/QYCEtPbco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fB+/svy/kByOEVCqI6eLqsHQIdyo7pqr0bJhwJKPcie3Em85RbQ91h9GXZBRf+bKl
         JBNDVSrKEnYGKtq9f2NrMgpIq6hIpnHn+2SfiRdlMXD/U0JEQJ07yQggKIoekr1Jjd
         NxN+14AizJctlXvK9bxYx/W4ddj2HTcVLFv3w9S0cIJeNHyB0roB8D+AvS3rVsQsz9
         4F91CgSujxI0vkmhTH4q1IEBqajCbd1Z6zrQ8p9qDWcHAQ/nlqFYEAJaqDUTUSVxQ8
         r/LPBqYwzLLRNCp+KRfbJuUxdeuRWLxIE/3KUFVtu1IW5d+aufkkUd6MA/YGX/SSay
         9YiUz5ePKdrLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrice Chotard <patrice.chotard@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/41] spi: spi-mem: Fix spi_mem_poll_status()
Date:   Mon, 27 Jun 2022 22:20:22 -0400
Message-Id: <20220628022100.595243-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrice Chotard <patrice.chotard@foss.st.com>

[ Upstream commit 2283679f4c468df367830b7eb8f22d48a6940e19 ]

In spi_mem_exec_op(), in case cs_gpiod descriptor is set, exec_op()
callback can't be used.
The same must be applied in spi_mem_poll_status(), poll_status()
callback can't be used, we must use the legacy path using
read_poll_timeout().

Tested on STM32mp257c-ev1 specific evaluation board on which a
spi-nand was mounted instead of a spi-nor.

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Tested-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://lore.kernel.org/r/20220602091022.358127-1-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index 37f4443ce9a0..96f718634ac7 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -795,7 +795,7 @@ int spi_mem_poll_status(struct spi_mem *mem,
 	    op->data.dir != SPI_MEM_DATA_IN)
 		return -EINVAL;
 
-	if (ctlr->mem_ops && ctlr->mem_ops->poll_status) {
+	if (ctlr->mem_ops && ctlr->mem_ops->poll_status && !mem->spi->cs_gpiod) {
 		ret = spi_mem_access_start(mem);
 		if (ret)
 			return ret;
-- 
2.35.1

