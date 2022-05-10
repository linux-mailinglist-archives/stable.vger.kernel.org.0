Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E9A521518
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 14:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241678AbiEJMYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 08:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241670AbiEJMYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 08:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D142CD6
        for <stable@vger.kernel.org>; Tue, 10 May 2022 05:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50E9E60A75
        for <stable@vger.kernel.org>; Tue, 10 May 2022 12:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19524C385C2;
        Tue, 10 May 2022 12:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652185240;
        bh=5rxW07Ihd0t/36ikoFO1qIBVC9ETiKAvr1S8ZGlmyKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YPGVdSU0kFrOemWCjiUkGLacnThZFqV11i8IOK7Y3AvQL2KKMJXkEOGDJtULISiOh
         yv9X7vskJHZsFNFX0OVTBxQ1udUV8Y7yaEghYFgGfeTQBAWTNfQrjTiDB33GoyOjbb
         6ZbPViqmX7JZMqLkaV1KUfZ3e//rfx/h7OQKP9sw=
Date:   Tue, 10 May 2022 14:20:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Josef Schlehofer <josef.schlehofer@nic.cz>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 4.14 1/2] PCI: aardvark: Clear all MSIs at setup
Message-ID: <YnpYkEYMYEP9yo3T@kroah.com>
References: <20220503205434.25275-1-kabel@kernel.org>
 <YnpTTkaVKo8hCOHT@kroah.com>
 <20220510120118.r4nmzqrxw3mmyryd@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510120118.r4nmzqrxw3mmyryd@pali>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 02:01:18PM +0200, Pali Rohár wrote:
> On Tuesday 10 May 2022 13:58:06 Greg Kroah-Hartman wrote:
> > On Tue, May 03, 2022 at 10:54:33PM +0200, Marek Behún wrote:
> > > From: Pali Rohár <pali@kernel.org>
> > > 
> > > [ Upstream commit 7d8dc1f7cd007a7ce94c5b4c20d63a8b8d6d7751 ]
> > > 
> > > We already clear all the other interrupts (ISR0, ISR1, HOST_CTRL_INT).
> > > 
> > > Define a new macro PCIE_MSI_ALL_MASK and do the same clearing for MSIs,
> > > to ensure that we don't start receiving spurious interrupts.
> > > 
> > > Use this new mask in advk_pcie_handle_msi();
> > > 
> > > Link: https://lore.kernel.org/r/20211130172913.9727-5-kabel@kernel.org
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > Signed-off-by: Marek Behún <kabel@kernel.org>
> > > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > Signed-off-by: Marek Behún <kabel@kernel.org>
> > > ---
> > >  drivers/pci/host/pci-aardvark.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > What about 4.19 and 5.4 for this and patch 2/2?  I can't apply this to
> > 4.14 without the newer kernels also having it, right?
> 
> Do you mean these patches which Marek prepared? Or something else?
> https://lore.kernel.org/stable/20220504140719.11066-1-kabel@kernel.org/
> https://lore.kernel.org/stable/20220504140826.11094-1-kabel@kernel.org/

Odd, I missed those somehow.  Thanks for pointing them out, I'll go
apply them now.

greg k-h
