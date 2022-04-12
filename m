Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710404FD07A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350532AbiDLGrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351566AbiDLGpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:45:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67693B027;
        Mon, 11 Apr 2022 23:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DC26618D5;
        Tue, 12 Apr 2022 06:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8174BC385A1;
        Tue, 12 Apr 2022 06:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745516;
        bh=BWlwAcV+CpjAy6y/GZGHiXsQ0mr0Px66qLqgTx6d8SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhHKUT/c2qwX7wUbHIHtmyJ2EEwCHOIvHmzgT5cLcVgZCsZrdworRGVBl1/FeH7bS
         gtGT3jH4yf5r36qgP1dMP9hLFjuL/rmnPXoYNwfU97sJP4r1w+5UiTMFHkXdNmx0kV
         lDUjK/bHCX+1QGzn36ZCd7uXAuGhiGJ0FXxXv404=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/171] spi: bcm-qspi: fix MSPI only access with bcm_qspi_exec_mem_op()
Date:   Tue, 12 Apr 2022 08:30:14 +0200
Message-Id: <20220412062931.444994490@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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
index 4a80f043b7b1..766b00350e39 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1032,7 +1032,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	addr = op->addr.val;
 	len = op->data.nbytes;
 
-	if (bcm_qspi_bspi_ver_three(qspi) == true) {
+	if (has_bspi(qspi) && bcm_qspi_bspi_ver_three(qspi) == true) {
 		/*
 		 * The address coming into this function is a raw flash offset.
 		 * But for BSPI <= V3, we need to convert it to a remapped BSPI
@@ -1051,7 +1051,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	    len < 4)
 		mspi_read = true;
 
-	if (mspi_read)
+	if (!has_bspi(qspi) || mspi_read)
 		return bcm_qspi_mspi_exec_mem_op(spi, op);
 
 	ret = bcm_qspi_bspi_set_mode(qspi, op, 0);
-- 
2.35.1



