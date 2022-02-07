Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207C04ABD3B
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387168AbiBGLkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386568AbiBGLe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:34:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D975C043181;
        Mon,  7 Feb 2022 03:34:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3C79B8102E;
        Mon,  7 Feb 2022 11:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D71C004E1;
        Mon,  7 Feb 2022 11:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233694;
        bh=kbXvknl46C1yh96qPSzRoU7OAGKJq3nYu1ZxHS+sLKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dADbWCjsWp4AZCsTwDibgrXq5Pnw1uE4PfUmeClOg2k4lk2S/1BCwzlwllkEx7Iq0
         D8nwpdvDSMN8Rn1LGWdZ2pYVmuLj+AFox73N5UYNqp3n8oHFUGMaW4dWkHmFGPKxY+
         xxnjLYYXUg/QUg6O0wG1/hxzBAvaRl6umNYYEi3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 059/126] spi: bcm-qspi: check for valid cs before applying chip select
Date:   Mon,  7 Feb 2022 12:06:30 +0100
Message-Id: <20220207103806.153211332@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
@@ -573,7 +573,7 @@ static void bcm_qspi_chip_select(struct
 	u32 rd = 0;
 	u32 wr = 0;
 
-	if (qspi->base[CHIP_SELECT]) {
+	if (cs >= 0 && qspi->base[CHIP_SELECT]) {
 		rd = bcm_qspi_read(qspi, CHIP_SELECT, 0);
 		wr = (rd & ~0xff) | (1 << cs);
 		if (rd == wr)


