Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CC155CD7A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiF1CTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241587AbiF1CSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:18:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428E623169;
        Mon, 27 Jun 2022 19:18:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A047D617C5;
        Tue, 28 Jun 2022 02:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2A9C34115;
        Tue, 28 Jun 2022 02:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382725;
        bh=B4w962AotObPYdAsZWfwMKCogWttxO1vzeHRyt+aHeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHDVzAhjo8QHsPqwlyJE0Hp0zNQKgqvfwjlzPQjMU/8wBucww4DKKD/bQG6pC/z4S
         tWgP506CSWmdobvyGhJkWmG7W/7xwpvsfYQOQSzrnCxqTe554UZHQFsz8BUJqIzF1s
         eRhKZpjchumq035rBm4qnqMPZasQOnEFAtdVgcqjMFrUF8hHgnvLejr2h39YXaZN42
         1n4nZUtUBwu5ibyprxSEuBgDZJz59+Na2G5rTh+wd3VY0g9v8UiJuNSchhkSUNexux
         hgZ721oVDqGzm2P2WbqvBvR5FJWUAj4fpBW7hlKRNXSyAUEqupyJ8LUkFWesBkrw4M
         jUhePNDGIesoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrice Chotard <patrice.chotard@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 03/53] spi: spi-mem: Fix spi_mem_poll_status()
Date:   Mon, 27 Jun 2022 22:17:49 -0400
Message-Id: <20220628021839.594423-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
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
index 0e8dafc62d94..99a76a2dda5a 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -799,7 +799,7 @@ int spi_mem_poll_status(struct spi_mem *mem,
 	    op->data.dir != SPI_MEM_DATA_IN)
 		return -EINVAL;
 
-	if (ctlr->mem_ops && ctlr->mem_ops->poll_status) {
+	if (ctlr->mem_ops && ctlr->mem_ops->poll_status && !mem->spi->cs_gpiod) {
 		ret = spi_mem_access_start(mem);
 		if (ret)
 			return ret;
-- 
2.35.1

