Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24E269D3D0
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 20:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbjBTTHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 14:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbjBTTHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 14:07:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497BF2202A;
        Mon, 20 Feb 2023 11:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C5YeWhFNorjT28L+tVoUQylS6tCKeubrEl80VFo+e94=; b=H8DDGo6COJKoETGNbL0Kmh+2+y
        q0Baq9DoZ4lH5XLyyrGapKZE2KxqY14bMb35TWWJ+B2rs81f2pVKOERo7gNu3NzpEzew6PaTHW9Z1
        1sEoZhULHawzDLLfTLmufixoZcvrZxY71NJX5VFInRQb5FQLQ6GGqN3zwijMwFVHJ2HF274Ynprr3
        jwDVP4/kZ1qB88U1in5I2IwfFfNu+MKxCcxsAQWIomxOrsTptS6PfqPP0NfLt6LLIwa2+QtUyo650
        Prh8uqoSXYciJf/ou0P0qkp0PzRfIjOgY5pM7M9zFbmz24ATyzrfzarDuEQH7gOwduznTX4cxnSyc
        9Egk+BuQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55032)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pUBTO-0004ul-0D; Mon, 20 Feb 2023 19:05:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pUBTN-0001TN-CE; Mon, 20 Feb 2023 19:05:13 +0000
Date:   Mon, 20 Feb 2023 19:05:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] genirq/msi: Take the per-device MSI lock before
 validating the control structure
Message-ID: <Y/PEac0U1uwRT3XG@shell.armlinux.org.uk>
References: <20230220190101.314446-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220190101.314446-1-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 07:01:01PM +0000, Marc Zyngier wrote:
> Calling msi_ctrl_valid() ultimately results in calling
> msi_get_device_domain(), which requires holding the device MSI lock.
> 
> However, we take that lock right after having called msi_ctrl_valid(),
> which is just a tad too late. Taking the lock earlier solves the issue.
> 
> Fixes: 40742716f294 ("genirq/msi: Make msi_add_simple_msi_descs() device domain aware")
> Reported-by: "Russell King (Oracle)" <linux@armlinux.org.uk>

Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
