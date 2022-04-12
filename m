Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837374FD7F2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353412AbiDLHdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353649AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3531727162;
        Tue, 12 Apr 2022 00:03:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5DE760B2E;
        Tue, 12 Apr 2022 07:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB882C385A8;
        Tue, 12 Apr 2022 07:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746981;
        bh=EzKK/Wn9jXP0+oUNcaHf3bXCVHSYf6lG7D5rxxhgLLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOmzg9oRBpdTS8U/YmOb5D+SmxFQL/6OuIX29jBYqzV7RH2HMxKfPqXhiwOy7cBao
         9dx1tAmCkD9FNXjgjNTPC+BlzSvy5lRs1H8dROB5x/PVPpN4SEvyVX3hDFOSyMt3Vw
         ObVHZIKGNEes16lfM7C6GsWaKLwOdA1TrGz7n8FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 198/285] spi: bcm-qspi: fix MSPI only access with bcm_qspi_exec_mem_op()
Date:   Tue, 12 Apr 2022 08:30:55 +0200
Message-Id: <20220412062949.376401450@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Dasu <kdasu.kdev@gmail.com>

[ Upstream commit 2c7d1b281286c46049cd22b43435cecba560edde ]

This fixes case where MSPI controller is used to access spi-nor
flash and BSPI block is not present.

Fixes: 5f195ee7d830 ("spi: bcm-qspi: Implement the spi_mem interface")
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220328142442.7553-1-kdasu.kdev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 44744c55304e..c943908e5281 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1173,7 +1173,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	addr = op->addr.val;
 	len = op->data.nbytes;
 
-	if (bcm_qspi_bspi_ver_three(qspi) == true) {
+	if (has_bspi(qspi) && bcm_qspi_bspi_ver_three(qspi) == true) {
 		/*
 		 * The address coming into this function is a raw flash offset.
 		 * But for BSPI <= V3, we need to convert it to a remapped BSPI
@@ -1192,7 +1192,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	    len < 4)
 		mspi_read = true;
 
-	if (mspi_read)
+	if (!has_bspi(qspi) || mspi_read)
 		return bcm_qspi_mspi_exec_mem_op(spi, op);
 
 	ret = bcm_qspi_bspi_set_mode(qspi, op, 0);
-- 
2.35.1



