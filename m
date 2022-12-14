Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035C864CB76
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 14:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbiLNNmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 08:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiLNNmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 08:42:10 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D6426AC3;
        Wed, 14 Dec 2022 05:42:06 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4NXGkN0yH9z9snF;
        Wed, 14 Dec 2022 14:42:04 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hfhTWXB50so6; Wed, 14 Dec 2022 14:42:04 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4NXGkN05yxz9sn7;
        Wed, 14 Dec 2022 14:42:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E7C018B773;
        Wed, 14 Dec 2022 14:42:03 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id yYyqfqsYJ_Hn; Wed, 14 Dec 2022 14:42:03 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.7.109])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A4C018B766;
        Wed, 14 Dec 2022 14:42:03 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 2BEDfs3H890976
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 14:41:54 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 2BEDfqfY890971;
        Wed, 14 Dec 2022 14:41:52 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Mark Brown <broonie@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-spi@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH] spi: fsl_spi: Don't change speed while chipselect is active
Date:   Wed, 14 Dec 2022 14:41:33 +0100
Message-Id: <8aab84c51aa330cf91f4b43782a1c483e150a4e3.1671025244.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671025291; l=2546; s=20211009; h=from:subject:message-id; bh=8/jPqVq6+i4ZTuwdyPTYisS3aYHreLAZCFf6R55Qckc=; b=qC4a0ccjJlEsJPlSdNoPiAK0OdPp36lryj0XAXdRWkYMSkTpCRSKsHcmDwFHDrSe4T7embn0AI06 R/d0B4vFB3QmoUTj3Dpc7VRNc76rQnest+fh3CBywicoYi5Lwg4K
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.38.1

