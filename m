Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E455853F92A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbiFGJOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbiFGJOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:14:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544ACA76D8;
        Tue,  7 Jun 2022 02:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kkP/s+Ji9Wf1wICipktQGL6qQb1FQDhuSBXH1dOnyM4=; b=s9AU0VZ/z1xjcxXhYPf5NG3IDy
        PIFnZTyHNk+dQBKfdXkTzzFBQTowu5AJVSs4jjL0Qbe47dup38If6DKOJLGI60xgYHIpVCjuS9Sua
        prL4RAhPNR6knlLWeraZn1yjBDTzlxy6RWqOFepk0Rk5/CkRMu58ZdAsjzOgZC6vLHScRO8MWMz5m
        ItdlNDFHD5yNG9IOjAvLBdWMphRoIWqygNRZogI5FHLRcU2JSRMtzrPktK+DoP7WQNvjh8a/tdnaB
        7DCreg+Q72E3RH0/Qi+aXK3i4xL/2xaJf5imEmakUh6kNA9NzmUOyqwzjFDX3Mn6C/+maPkpIEOQI
        ZMl+NLTQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60986)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nyVI5-00035X-PQ; Tue, 07 Jun 2022 10:14:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nyVI3-0000fj-Uy; Tue, 07 Jun 2022 10:14:19 +0100
Date:   Tue, 7 Jun 2022 10:14:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Phil Elwell <phil@raspberrypi.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
Message-ID: <Yp8W68o37X6aAD86@shell.armlinux.org.uk>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 10:30:49AM +0200, Jason A. Donenfeld wrote:
> Hi Phil,
> 
> Thanks for testing this. Can you let me know if v1 of this works?
> 
> https://lore.kernel.org/lkml/20220602212234.344394-1-Jason@zx2c4.com/
> 
> (I'll also fashion a revert for this part of stable.)

As the arm32 version hasn't been merged yet, how is it in stable already?
If it is in stable, isn't that a yet another violation of the stable
kernel rules?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
