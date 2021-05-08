Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC8A3773B0
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 20:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhEHSv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 14:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhEHSv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 14:51:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005B3C061574;
        Sat,  8 May 2021 11:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SpBJgfkftqpvFAtdSzeZJgPR2YQYjUv2usZi8QDov8I=; b=SeN4U+rIUEbJrEn5zmxmH/vfd
        gHhZq25MI4850RNUJ9glt3vOlTJIUm4Dw1PWQCxutZXhNXJ4h2PxnjP0lLht/pDECD9oTAtESUJCa
        yl+1x4kJD/m5WHJ5uaYgC1uRyVgDsSFBqUVUORatl0HT9YCOLRoS7kjyjH1qbjq6HycEPQvO48lWO
        b+A3D8MuCE6kbg9s3ydrK4Ayj6V6PMIQtt4UK9yyyDInWzkKtXej74V+VNNp5NfqVvd3ucacWExNX
        H8l+gzXfixou2x2WQGnFiJf0ao3vyMqA9L4K2rvZwWgI1nLXATzMX9YWCb+dH2xoNIXFxTGImzv8q
        AqjUszFyw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43792)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lfS2H-0006Gv-6v; Sat, 08 May 2021 19:50:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lfS2G-0006u2-A9; Sat, 08 May 2021 19:50:44 +0100
Date:   Sat, 8 May 2021 19:50:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] arm: Enlarge IO_SPACE_LIMIT needed for some SoC
Message-ID: <20210508185043.GF1336@shell.armlinux.org.uk>
References: <20210508175537.202-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508175537.202-1-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 08, 2021 at 07:55:35PM +0200, Ansuel Smith wrote:
> Ipq8064 SoC requires larger IO_SPACE_LIMIT or second and third pci port
> fails to register the IO addresses and connected device doesn't work.
> 
> Cc: <stable@vger.kernel.org> # 4.9+
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

I don't see any consideration of whether this increase results in any
clashes with any other related areas. Also, there is no update of the
memory layout documentation.

The memory layout documentation says:

=============== =============== ===============================================
Start           End             Use
=============== =============== ===============================================
fee00000        feffffff        Mapping of PCI I/O space. This is a static
                                mapping within the vmalloc space.

which means there's a maximum of 0x001fffff available. You are
increasing it's size from 0x000fffff to 0x00ffffff. This means it
expands from 0xfee00000 through to 0xffdfffff.

This conflicts with these entries:

ffc80000        ffefffff        Fixmap mapping region.  Addresses provided
                                by fix_to_virt() will be located here.

ffc00000        ffc7ffff        Guard region

ff800000        ffbfffff        Permanent, fixed read-only mapping of the
                                firmware provided DT blob

So, I have no option but to NAK this change. Sorry.

You can find this documentation in the "Documentation" subdirectory.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
