Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B3B4924A8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 12:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiARLV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 06:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiARLV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 06:21:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C5BC061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 03:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0YIdVKtdFmfG5n3uavuj6tkK42RYTf7CKBl8Kthf/50=; b=NRDhc81iKhblxcuPAVUy5T3xdg
        /e+GTGe3VO61jAlAbymAE7azb9l24JZj/lHApv2qKuY+zeMxknnPjnTGi5lPnjLpwXanceKonQ7H+
        t99pafBVS6/Ru5BzDOTPqUUCJzPvvuJBG2aFcezJTE7xbYH57E8LYkBK/66Iq8VBrnkrevnWg/IJZ
        LF024wbwwqFTUzIfm23q1XA9g3dB3DAY6iPx0D1cIKYYhaQg3gpb43Jhj0dEvwX61LzqhLE0oc62Q
        d8moJClGS5she8pf+ZE7HcEjc6MoMghVxKccME51VsyvAjElM5c6byWcYMYyUC9Iz2xOagFgnY+Le
        dnqL/ZiQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56752)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9mYD-0003gB-Tx; Tue, 18 Jan 2022 11:21:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9mYC-0004FC-KL; Tue, 18 Jan 2022 11:21:20 +0000
Date:   Tue, 18 Jan 2022 11:21:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: Thumb2: align ALT_UP() sections sufficiently
Message-ID: <YeaisFN1ru7suF1Y@shell.armlinux.org.uk>
References: <20220118102756.1259149-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118102756.1259149-1-ardb@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 11:27:56AM +0100, Ard Biesheuvel wrote:
> When building for Thumb2, the .alt.smp.init sections that are emitted by
> the ALT_UP() patching code may not be 32-bit aligned, even though the
> fixup_smp_on_up() routine expects that. This results in alignment faults
> at module load time, which need to be fixed up by the fault handler.
> 
> So let's align those sections explicitly, and avoid this from occurring.

Are you seeing a problem that this patch fixes?

This really should not matter. .alt.smp.init contents are always a whole
number of 32-bit words. These are gathered by the linker into the
.init.smpalt section, so the contents should always be a whole number
of 32-bit words.

This follows the .init.tagtable section, which is also a 32-bit word
aligned structure built by the linker... which follows the
.init.arch.info section and .init.proc.info sections which all have
32-bit alignment requirements.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
