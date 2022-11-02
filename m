Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E08C6157BB
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiKBChy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiKBChx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8071A805
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66EDC617C8
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B72DC433D6;
        Wed,  2 Nov 2022 02:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356659;
        bh=VETqd/5F8XEHDagoaqcVuEzhl7+XurcS5g0ILeS5oOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfTfPbTlFZSLyohi9KM94KN/t9DeLV3uCdNTf71lLs//s5T2Ni6ZagiRRPOtZxMUw
         ILofyNbYJb/6TvEE7vUMN0gSZF41gX5Tp9J9erEq+WujTLluHHjYiRi1tdb2kZU5d8
         VxscSVtA2uL+XyGYP0PkEPB9DOp3TQE+eupKYQpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tony OBrien <tony.obrien@alliedtelesis.co.nz>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.0 038/240] mtd: rawnand: marvell: Use correct logic for nand-keep-config
Date:   Wed,  2 Nov 2022 03:30:13 +0100
Message-Id: <20221102022112.264713102@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony O'Brien <tony.obrien@alliedtelesis.co.nz>

commit ce107713b722af57c4b7f2477594d445b496420e upstream.

Originally the absence of the marvell,nand-keep-config property caused
the setup_data_interface function to be provided. However when
setup_data_interface was moved into nand_controller_ops the logic was
unintentionally inverted. Update the logic so that only if the
marvell,nand-keep-config property is present the bootloader NAND config
kept.

Cc: stable@vger.kernel.org
Fixes: 7a08dbaedd36 ("mtd: rawnand: Move ->setup_data_interface() to nand_controller_ops")
Signed-off-by: Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220927024728.28447-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/marvell_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2672,7 +2672,7 @@ static int marvell_nand_chip_init(struct
 	chip->controller = &nfc->controller;
 	nand_set_flash_node(chip, np);
 
-	if (!of_property_read_bool(np, "marvell,nand-keep-config"))
+	if (of_property_read_bool(np, "marvell,nand-keep-config"))
 		chip->options |= NAND_KEEP_TIMINGS;
 
 	mtd = nand_to_mtd(chip);


