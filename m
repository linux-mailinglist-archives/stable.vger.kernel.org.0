Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FDF65D8D2
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbjADQS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239892AbjADQSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:18:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E881117E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:18:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AAF3B8172B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291F6C433EF;
        Wed,  4 Jan 2023 16:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849110;
        bh=3BGaD82kiYMk6MEGp8L5K/lw5Pyr41ws2r/LCvbbx5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwZLA6dcCjyt3vV+6XcZkfF9TPjCKnRpUpKVW0aU7DMtwM/7yuFTudBQHQPw+a7OE
         ihL9kOhp/J5u6c5zXLmK7e0v7JDAM6Yob9jrJm5JfdDW+YFXftmPKqZ1C0LLGA7VXI
         E39VrS/b9CmE/uEdA1PVpTPA/PVwZ+nAmM/c6WPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rijo-john Thomas <Rijo-john.Thomas@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 134/207] crypto: ccp - Add support for TEE for PCI ID 0x14CA
Date:   Wed,  4 Jan 2023 17:06:32 +0100
Message-Id: <20230104160516.163659408@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 10da230a4df1dfe32a58eb09246f5ffe82346f27 upstream.

SoCs containing 0x14CA are present both in datacenter parts that
support SEV as well as client parts that support TEE.

Cc: stable@vger.kernel.org # 5.15+
Tested-by: Rijo-john Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sp-pci.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -381,6 +381,15 @@ static const struct psp_vdata pspv3 = {
 	.inten_reg		= 0x10690,
 	.intsts_reg		= 0x10694,
 };
+
+static const struct psp_vdata pspv4 = {
+	.sev			= &sevv2,
+	.tee			= &teev1,
+	.feature_reg		= 0x109fc,
+	.inten_reg		= 0x10690,
+	.intsts_reg		= 0x10694,
+};
+
 #endif
 
 static const struct sp_dev_vdata dev_vdata[] = {
@@ -426,7 +435,7 @@ static const struct sp_dev_vdata dev_vda
 	{	/* 5 */
 		.bar = 2,
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
-		.psp_vdata = &pspv2,
+		.psp_vdata = &pspv4,
 #endif
 	},
 	{	/* 6 */


