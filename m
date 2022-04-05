Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D164F25EB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiDEHxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiDEHwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:52:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3E79A98F;
        Tue,  5 Apr 2022 00:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02591B81B18;
        Tue,  5 Apr 2022 07:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64611C340EE;
        Tue,  5 Apr 2022 07:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144893;
        bh=tvO/3D6CFdPDaHRXYaUegP0jGzL9pB/dr5JAGUtgmak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PqQ+2HC16ceEL1kgQL08M/L7V+36Q/Bm/fiH4MY9mTZy72TWYSm+FjwOCiJbcewR
         R4l8f97txnyyqp5vxcFVPj/CK9aqi5VAGAftJgmO8xMQ9s20EXPa4Kt8dEM8jsPdEg
         p2277MCj5bjZxEFyZ9xf5NLqOX23T4H6lfduF1UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shijith Thotton <sthotton@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0208/1126] crypto: octeontx2 - select CONFIG_NET_DEVLINK
Date:   Tue,  5 Apr 2022 09:15:55 +0200
Message-Id: <20220405070413.714881700@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Shijith Thotton <sthotton@marvell.com>

[ Upstream commit 85872d1a6f38d133133784c8027d25d1c5328f4f ]

OcteonTX2 CPT driver will fail to link without devlink support.

aarch64-linux-gnu-ld: otx2_cpt_devlink.o: in function `otx2_cpt_dl_egrp_delete':
otx2_cpt_devlink.c:18: undefined reference to `devlink_priv'
aarch64-linux-gnu-ld: otx2_cpt_devlink.o: in function `otx2_cpt_dl_egrp_create':
otx2_cpt_devlink.c:9: undefined reference to `devlink_priv'
aarch64-linux-gnu-ld: otx2_cpt_devlink.o: in function `otx2_cpt_dl_uc_info':
otx2_cpt_devlink.c:27: undefined reference to `devlink_priv'

Fixes: fed8f4d5f946 ("crypto: octeontx2 - parameters for custom engine groups")

Signed-off-by: Shijith Thotton <sthotton@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 9125199f1702..a48591af12d0 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -47,6 +47,7 @@ config CRYPTO_DEV_OCTEONTX2_CPT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
+	select NET_DEVLINK
 	help
 		This driver allows you to utilize the Marvell Cryptographic
 		Accelerator Unit(CPT) found in OcteonTX2 series of processors.
-- 
2.34.1



