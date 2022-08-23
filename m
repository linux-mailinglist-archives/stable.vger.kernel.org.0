Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBDE59DE6C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352466AbiHWMG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359515AbiHWMGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:06:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAB7DF4D8;
        Tue, 23 Aug 2022 02:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BE236149B;
        Tue, 23 Aug 2022 09:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC2DC433D6;
        Tue, 23 Aug 2022 09:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247445;
        bh=XXnsT8YnvLr5n07bfMayojz6yEaBHQq9iwO02OlXMVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8cc5pQgl3sotyCE+y5+5XbdmnM4gCkS3UOGqQqM2EoT1OLUZ1ZXpgP1iNGSPFeUM
         YODD5bV3bLKXMiw16BStTE1/+ZZe35oGpUdSXDtEG2+rO1nkgVPH7TFGv5NfFj87Ks
         f2k1OlQazbPH/YloT3Gx/EvW30z4j5TKDxM46pHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 007/158] mmc: pxamci: Fix an error handling path in pxamci_probe()
Date:   Tue, 23 Aug 2022 10:25:39 +0200
Message-Id: <20220823080046.359281137@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 98d7c5e5792b8ce3e1352196dac7f404bb1b46ec upstream.

The commit in Fixes: has moved some code around without updating gotos to
the error handling path.

Update it now and release some resources if pxamci_of_init() fails.

Fixes: fa3a5115469c ("mmc: pxamci: call mmc_of_parse()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/6d75855ad4e2470e9ed99e0df21bc30f0c925a29.1658862932.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/pxamci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -648,7 +648,7 @@ static int pxamci_probe(struct platform_
 
 	ret = pxamci_of_init(pdev, mmc);
 	if (ret)
-		return ret;
+		goto out;
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;


