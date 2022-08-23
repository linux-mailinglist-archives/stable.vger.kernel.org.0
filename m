Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F4059D8CE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351115AbiHWJgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351627AbiHWJfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:35:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F7397D68;
        Tue, 23 Aug 2022 01:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBF18B81C53;
        Tue, 23 Aug 2022 08:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F55C433D6;
        Tue, 23 Aug 2022 08:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243942;
        bh=XXnsT8YnvLr5n07bfMayojz6yEaBHQq9iwO02OlXMVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A33b7MDvfMlaL213tYjRk45mOGSPRu10aqT6gOC5d2ObWUgCRoYI6CETdVgd0LC8h
         YiXio5Es4m+Fxz/FAIknywRyb5YOq/MWVGg6x188Mp6GfhIvqe8JDdHvI/7y/r1WML
         aStylsF5wM3c3/k41VhGzDY6aYtphHQB0PTpL0ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 012/244] mmc: pxamci: Fix an error handling path in pxamci_probe()
Date:   Tue, 23 Aug 2022 10:22:51 +0200
Message-Id: <20220823080059.492779138@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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


