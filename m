Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8CC65850A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbiL1RFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiL1REk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B2B2036A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:59:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C93D61568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2003CC433D2;
        Wed, 28 Dec 2022 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246747;
        bh=0Z1WykKJ+4YJpdOfdslu/bsFMASDIA3vEl0636o0UtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMWunACgLlzClFDNuoLLAYOy6zJ8m6mlCDIeY+8z3WRMVMQgRjY6EszfegxKrpGo8
         5zEvQ/2/rGBU0eJMxSm0m/Z9/4R8oD06Hek50uHX5xl2ZxFXeQiq97avcjzZo5GONp
         9XzWV5ojFL5Mhx0LjdF/bkXZhp4OsEnIwHmurT0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Herve Codina <herve.codina@bootlin.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 1124/1146] spi: fsl_spi: Dont change speed while chipselect is active
Date:   Wed, 28 Dec 2022 15:44:23 +0100
Message-Id: <20221228144400.676730888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 3b553e0041a65e499fa4e25ee146f01f4ec4e617 upstream.

Commit c9bfcb315104 ("spi_mpc83xx: much improved driver") made
modifications to the driver to not perform speed changes while
chipselect is active. But those changes where lost with the
convertion to tranfer_one.

Previous implementation was allowing speed changes during
message transfer when cs_change flag was set.
At the time being, core SPI does not provide any feature to change
speed while chipselect is off, so do not allow any speed change during
message transfer, and perform the transfer setup in prepare_message
in order to set correct speed while chipselect is still off.

Reported-by: Herve Codina <herve.codina@bootlin.com>
Fixes: 64ca1a034f00 ("spi: fsl_spi: Convert to transfer_one")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/8aab84c51aa330cf91f4b43782a1c483e150a4e3.1671025244.git.christophe.leroy@csgroup.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-spi.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 731624f157fc..93152144fd2e 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -333,13 +333,26 @@ static int fsl_spi_prepare_message(struct spi_controller *ctlr,
 {
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(ctlr);
 	struct spi_transfer *t;
+	struct spi_transfer *first;
+
+	first = list_first_entry(&m->transfers, struct spi_transfer,
+				 transfer_list);
 
 	/*
 	 * In CPU mode, optimize large byte transfers to use larger
 	 * bits_per_word values to reduce number of interrupts taken.
+	 *
+	 * Some glitches can appear on the SPI clock when the mode changes.
+	 * Check that there is no speed change during the transfer and set it up
+	 * now to change the mode without having a chip-select asserted.
 	 */
-	if (!(mpc8xxx_spi->flags & SPI_CPM_MODE)) {
-		list_for_each_entry(t, &m->transfers, transfer_list) {
+	list_for_each_entry(t, &m->transfers, transfer_list) {
+		if (t->speed_hz != first->speed_hz) {
+			dev_err(&m->spi->dev,
+				"speed_hz cannot change during message.\n");
+			return -EINVAL;
+		}
+		if (!(mpc8xxx_spi->flags & SPI_CPM_MODE)) {
 			if (t->len < 256 || t->bits_per_word != 8)
 				continue;
 			if ((t->len & 3) == 0)
@@ -348,7 +361,7 @@ static int fsl_spi_prepare_message(struct spi_controller *ctlr,
 				t->bits_per_word = 16;
 		}
 	}
-	return 0;
+	return fsl_spi_setup_transfer(m->spi, first);
 }
 
 static int fsl_spi_transfer_one(struct spi_controller *controller,
-- 
2.39.0



