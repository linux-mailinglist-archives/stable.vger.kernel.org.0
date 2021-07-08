Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1996D3C1A76
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 22:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhGHUVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 16:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhGHUVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 16:21:40 -0400
X-Greylist: delayed 82512 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Jul 2021 13:18:57 PDT
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B127CC061574;
        Thu,  8 Jul 2021 13:18:57 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 0526F92009C; Thu,  8 Jul 2021 22:18:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id EAD1292009B;
        Thu,  8 Jul 2021 22:18:55 +0200 (CEST)
Date:   Thu, 8 Jul 2021 22:18:55 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <bhelgaas@google.com>
cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Do not restore firmware BAR assignments behind a
 PCI-PCI bridge
In-Reply-To: <alpine.DEB.2.21.2104211620400.44318@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2107082210480.6599@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104211620400.44318@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 7 Jul 2021, Maciej W. Rozycki wrote:

> This may work for a device directly on the root bus decoded by the host 
> bridge only, but for a device behind one or more PCI-to-PCI (or CardBus) 
> bridges those bridges' forwarding windows have been standardised and 
> need to be respected, or leaving whatever has been there in a downstream 
> device's BAR will have no effect as cycles for the addresses recorded 
> there will have no chance to appear on the bus the device has been 
> immediately attached to.
> 
> Do not restore the firmware assignment for a device behind a PCI-to-PCI 
> bridge then, fixing the system concerned as follows:

 Scrap it.

 Something kept bothering me about this fix and I have double-checked with 
PR 16263, and the problematic device there also was behind a PCI-to-PCI 
bridge, which I have somehow missed previously, though within the bridge's 
forwarding window.  So a more stringent rule will be required to keep both 
cases happy and I'll make v2 shortly that only refrains from restoring the 
original assignment when it is outside the relevant upstream bridge's 
forwarding window.

  Maciej
