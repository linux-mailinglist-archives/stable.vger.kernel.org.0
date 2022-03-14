Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B9F4D8310
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbiCNMMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbiCNMJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:09:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9262715E;
        Mon, 14 Mar 2022 05:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED626130D;
        Mon, 14 Mar 2022 12:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D89FC340E9;
        Mon, 14 Mar 2022 12:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259638;
        bh=2o1LoqJAtWoL5H0rIhGX0s5a1sOKR+z79T2uz71pT8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hf96/YFAnrlnO0EHA8dRH8J/gT5bO21Uw/slO7FHhjcTPa9XbakqM7DG8mJzyfUZf
         1P3Pb4YGCR75twjE8OzNs44dO7Qaju2iODgO0q1mCXYcRhB6BN3BdjwlmmJ7aJWZ/H
         1u3AJ5BGKC36CfK2h5SwPWHKpaitpM9Zu/HmPR9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/110] pinctrl: tigerlake: Revert "Add Alder Lake-M ACPI ID"
Date:   Mon, 14 Mar 2022 12:53:57 +0100
Message-Id: <20220314112744.571590223@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6f66db29e2415cbe8759c48584f9cae19b3c2651 ]

It appears that last minute change moved ACPI ID of Alder Lake-M
to the INTC1055, which is already in the driver.

This ID on the other hand will be used elsewhere.

This reverts commit 258435a1c8187f559549e515d2f77fa0b57bcd27.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-tigerlake.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-tigerlake.c b/drivers/pinctrl/intel/pinctrl-tigerlake.c
index 0bcd19597e4a..3ddaeffc0415 100644
--- a/drivers/pinctrl/intel/pinctrl-tigerlake.c
+++ b/drivers/pinctrl/intel/pinctrl-tigerlake.c
@@ -749,7 +749,6 @@ static const struct acpi_device_id tgl_pinctrl_acpi_match[] = {
 	{ "INT34C5", (kernel_ulong_t)&tgllp_soc_data },
 	{ "INT34C6", (kernel_ulong_t)&tglh_soc_data },
 	{ "INTC1055", (kernel_ulong_t)&tgllp_soc_data },
-	{ "INTC1057", (kernel_ulong_t)&tgllp_soc_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, tgl_pinctrl_acpi_match);
-- 
2.34.1



