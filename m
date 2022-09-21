Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEFA5C04D7
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiIUQ5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiIUQ5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:57:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9A0222;
        Wed, 21 Sep 2022 09:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36E866321F;
        Wed, 21 Sep 2022 16:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0D8C433C1;
        Wed, 21 Sep 2022 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663779452;
        bh=LeK5JLTbFJzs1hR1169CAEELd2s0T4NEbTDkGk4Qc78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hMwpdt1IY3z7GH5nlskxk3QBoXR7H/soWjBbsLnMGh7thd+WpGZvhB/EGa49p57qd
         Odsp1gZRPTma06dVip7Pj1Tcpn+yXEiyIWdIiF5aRYvuQ4Dj4Ybz4h4TIpnZsdkSrw
         Bn1t8q0F1aXLM3MpCMRXHwPNNPfGqSar3kjCU1DX/m/+C889aHp9QLOwgv5pPlN5T5
         EL3/YYWwNXTDH4A8sC2LIHKsbxGL6rgj9J7xc5UeKBZecoAQBDeYK97MOOv8/781VC
         hAAdJyWL6tEBMRfGgG5Q5RULdFzA3x/eRxH7piUsz/W4xMvMwaDuZxi25n1K65AU6u
         +YRiP7pw75M+g==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ob32Q-00BizR-D0;
        Wed, 21 Sep 2022 17:57:30 +0100
MIME-Version: 1.0
Date:   Wed, 21 Sep 2022 17:57:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, linusw@kernel.org,
        kaloz@openwrt.org, khalasa@piap.pl,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 2/5] gpio: ixp4xx: Make irqchip immutable
In-Reply-To: <20220921155436.235371-2-sashal@kernel.org>
References: <20220921155436.235371-1-sashal@kernel.org>
 <20220921155436.235371-2-sashal@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <fec2e2e2e74d680d5f9de6d68fb5fe18@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sashal@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linus.walleij@linaro.org, brgl@bgdev.pl, linusw@kernel.org, kaloz@openwrt.org, khalasa@piap.pl, linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-09-21 16:54, Sasha Levin wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> [ Upstream commit 94e9bc73d85aa6ecfe249e985ff57abe0ab35f34 ]
> 
> This turns the IXP4xx GPIO irqchip into an immutable
> irqchip, a bit different from the standard template due
> to being hierarchical.
> 
> Tested on the IXP4xx which uses drivers/ata/pata_ixp4xx_cf.c
> for a rootfs on compact flash with IRQs from this GPIO
> block to the CF ATA controller.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Why? The required dependencies are only in 5,19, and are
definitely NOT a stable candidate...

This isn't a fix by any stretch of the imagination.

         M.
-- 
Jazz is not dead. It just smells funny...
