Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14A9492501
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 12:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbiARLfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 06:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbiARLfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 06:35:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4479C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 03:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wq16ARThkkzqOHE2RX7AL/zGNvzaVQplga00bV+mA9Y=; b=BpvoH/q9nwh2OepOE97z/QnkK4
        8noWv/AsTGQhENiVZti/EorahKQWvp1H14WlXJJgvPU4eNKhp183aT8acFYwi7BPy1e0jxNjFwkGk
        HetzQ5yHHdgWp3+F8ow0BWmU8tMoAzjnv4dZ9uTi68M9i2JZllW/AFUWy7GnRckmzaLys8kKRWqbu
        Xdc8/l5GqOhXZLYWtksEQRMNSUktEzj2uAge2xkaZgh5UL8qYHsxUM3quO+tUNUaeKk059fZeMgjU
        QT4dblM/lVzNYaIb58lDd8AQon9AbX6q6gLkOVVgkQBdEeTHMlGFhQZ/5TVyhrhiBqpX/OD+j/6aM
        3CbJoZpg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56754)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9mln-0003hC-Rx; Tue, 18 Jan 2022 11:35:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9mlm-0004FN-U5; Tue, 18 Jan 2022 11:35:22 +0000
Date:   Tue, 18 Jan 2022 11:35:22 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: Thumb2: align ALT_UP() sections sufficiently
Message-ID: <Yeal+oNFCvj911nt@shell.armlinux.org.uk>
References: <20220118102756.1259149-1-ardb@kernel.org>
 <YeaisFN1ru7suF1Y@shell.armlinux.org.uk>
 <CAMj1kXHTXeLPWbnQpkEen2uy6ameVL27QfeN2MZpdBB21Wj14w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHTXeLPWbnQpkEen2uy6ameVL27QfeN2MZpdBB21Wj14w@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 12:32:55PM +0100, Ard Biesheuvel wrote:
> On Tue, 18 Jan 2022 at 12:21, Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
> >
> > On Tue, Jan 18, 2022 at 11:27:56AM +0100, Ard Biesheuvel wrote:
> > > When building for Thumb2, the .alt.smp.init sections that are emitted by
> > > the ALT_UP() patching code may not be 32-bit aligned, even though the
> > > fixup_smp_on_up() routine expects that. This results in alignment faults
> > > at module load time, which need to be fixed up by the fault handler.
> > >
> > > So let's align those sections explicitly, and avoid this from occurring.
> >
> > Are you seeing a problem that this patch fixes?
> >
> > This really should not matter. .alt.smp.init contents are always a whole
> > number of 32-bit words. These are gathered by the linker into the
> > .init.smpalt section, so the contents should always be a whole number
> > of 32-bit words.
> >
> > This follows the .init.tagtable section, which is also a 32-bit word
> > aligned structure built by the linker... which follows the
> > .init.arch.info section and .init.proc.info sections which all have
> > 32-bit alignment requirements.
> >
> 
> This only affects modules, not the core kernel. The .alt.smp.init
> section in a module is visible to the module loader, which means the
> module loader will make no attempt to position it at a 32-bit aligned
> address if the ELF alignment is only 16 bits, which appears to be the
> default in my Thumb2 build [gcc version 10.3.1 20211117 (Debian
> 10.3.0-13)]
> 
> I only spotted this because do_fixup_smp_on_up() was shown as the most
> recent in-kernel fixup location in /proc/cpu/alignment.

Ok, thanks for the explanation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
