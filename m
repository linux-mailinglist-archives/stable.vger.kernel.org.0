Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C2F4B4626
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238292AbiBNJ2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:28:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243021AbiBNJ2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B49B60D83;
        Mon, 14 Feb 2022 01:28:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 284EC60F88;
        Mon, 14 Feb 2022 09:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0978CC340E9;
        Mon, 14 Feb 2022 09:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830914;
        bh=r4loICwC/Ra3vZUKUUxcneuvZ23lklqWBJUiGClVREg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDj/knm8TDrAM2IOPoLHG3/8h5PpDhTl586Otb+TUvgn1IJb2S/gqxuqyBtmtSNuM
         /bVQP3lstFm1HKTIJpzrKepbr8JkcFDCAlgdlyAm1aDJsTqiDjnfR8Hu7PUtC021YE
         YG1TD43OyUtTOgRvKdnUhFwFP/cHzGU0VJkZj/OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH 4.9 05/34] Input: i8042 - Fix misplaced backport of "add ASUS Zenbook Flip to noselftest list"
Date:   Mon, 14 Feb 2022 10:25:31 +0100
Message-Id: <20220214092446.126910108@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Bertholon <guillaume.bertholon@ens.fr>

The upstream commit b5d6e7ab7fe7 ("Input: i8042 - add ASUS Zenbook Flip to
noselftest list") inserted a new entry in the `i8042_dmi_noselftest_table`
table, further patched by commit daa58c8eec0a ("Input: i8042 - fix Pegatron
C15B ID entry") to insert a missing separator.

However, their backported version in stable (commit e9e8b3769099
("Input: i8042 - add ASUS Zenbook Flip to noselftest list") and
commit c551d20d487a ("Input: i8042 - fix Pegatron C15B ID entry"))
inserted this entry in `i8042_dmi_forcemux_table` instead.

This patch moves the entry back into `i8042_dmi_noselftest_table`.

Fixes: e9e8b3769099 ("Input: i8042 - add ASUS Zenbook Flip to noselftest list")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-x86ia64io.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -586,11 +586,6 @@ static const struct dmi_system_id i8042_
 			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-CS"),
 		},
-	}, {
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_CHASSIS_TYPE, "31"), /* Convertible Notebook */
-		},
 	},
 	{ }
 };
@@ -677,6 +672,12 @@ static const struct dmi_system_id i8042_
 			DMI_MATCH(DMI_PRODUCT_NAME, "Z450LA"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "31"), /* Convertible Notebook */
+		},
+	},
 	{ }
 };
 static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {


