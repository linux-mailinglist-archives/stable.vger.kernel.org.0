Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6A34ABACE
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384081AbiBGLYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244593AbiBGLJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:09:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BACBC0401C0;
        Mon,  7 Feb 2022 03:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3513B81028;
        Mon,  7 Feb 2022 11:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F17C004E1;
        Mon,  7 Feb 2022 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232168;
        bh=h26siPkwY4qdDG27Hy2p6yoYlHa37dXXGoSZUXxo4xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrKnfzNuoat0sRiKnchMQ2otr1fFTkRvZveY6vttu7cQ2pZa/JQdMtOs31Dp4Yqb3
         1vkuWQ72SNynuxAROO08ZPY4QKOVFVOXb3RXL/z6UjpVAJovuHQyl6uZ75b1SrgUlB
         uB9a8OlQkyIR3K2NdUMaCCBRHmxk4yNazKnp9JhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 38/48] spi: bcm-qspi: check for valid cs before applying chip select
Date:   Mon,  7 Feb 2022 12:06:11 +0100
Message-Id: <20220207103753.577049817@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
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

commit 2cbd27267ffe020af1442b95ec57f59a157ba85c upstream.

Apply only valid chip select value. This change fixes case where chip
select is set to initial value of '-1' during probe and  PM supend and
subsequent resume can try to use the value with undefined behaviour.
Also in case where gpio based chip select, the check in
bcm_qspi_chip_select() shall prevent undefined behaviour on resume.

Fixes: fa236a7ef240 ("spi: bcm-qspi: Add Broadcom MSPI driver")
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220127185359.27322-1-kdasu.kdev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm-qspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -546,7 +546,7 @@ static void bcm_qspi_chip_select(struct
 	u32 rd = 0;
 	u32 wr = 0;
 
-	if (qspi->base[CHIP_SELECT]) {
+	if (cs >= 0 && qspi->base[CHIP_SELECT]) {
 		rd = bcm_qspi_read(qspi, CHIP_SELECT, 0);
 		wr = (rd & ~0xff) | (1 << cs);
 		if (rd == wr)


