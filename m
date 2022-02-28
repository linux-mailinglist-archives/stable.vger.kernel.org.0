Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C104C727F
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbiB1R01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiB1R0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:26:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FFF75E6B;
        Mon, 28 Feb 2022 09:25:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD25DB815A5;
        Mon, 28 Feb 2022 17:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11042C340F4;
        Mon, 28 Feb 2022 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069143;
        bh=Vv7wFnUGlLa3rURQC2K9jde3PYf5CPhS7IZInxX0iB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYck5cBhKsgarVNK0pTvm2l+/iT7xQl5uEjfKIuvR/78zCOOtEcL+TzMQKdGCFHhF
         nkScTEPDTtu0uT66ddNWeQq6DQ+4DstVN0DCmnYDj1d0g+HlT7lZ0LW5Dl+fjm6SbJ
         SyE1aW8qd48oMSJopETavQkRTC34SyR/OMgtCxok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, david regan <dregan@mail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.9 01/29] mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status
Date:   Mon, 28 Feb 2022 18:23:28 +0100
Message-Id: <20220228172141.922269337@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
References: <20220228172141.744228435@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: david regan <dregan@mail.com>

commit 36415a7964711822e63695ea67fede63979054d9 upstream.

The brcmnand driver contains a bug in which if a page (example 2k byte)
is read from the parallel/ONFI NAND and within that page a subpage (512
byte) has correctable errors which is followed by a subpage with
uncorrectable errors, the page read will return the wrong status of
correctable (as opposed to the actual status of uncorrectable.)

The bug is in function brcmnand_read_by_pio where there is a check for
uncorrectable bits which will be preempted if a previous status for
correctable bits is detected.

The fix is to stop checking for bad bits only if we already have a bad
bits status.

Fixes: 27c5b17cd1b1 ("mtd: nand: add NAND driver "library" for Broadcom STB NAND controller")
Signed-off-by: david regan <dregan@mail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/trinity-478e0c09-9134-40e8-8f8c-31c371225eda-1643237024774@3c-app-mailcom-lxa02
[florian: make patch apply to 4.14, file was renamed]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/brcmnand/brcmnand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/brcmnand/brcmnand.c
@@ -1637,7 +1637,7 @@ static int brcmnand_read_by_pio(struct m
 					mtd->oobsize / trans,
 					host->hwcfg.sector_size_1k);
 
-		if (!ret) {
+		if (ret != -EBADMSG) {
 			*err_addr = brcmnand_read_reg(ctrl,
 					BRCMNAND_UNCORR_ADDR) |
 				((u64)(brcmnand_read_reg(ctrl,


