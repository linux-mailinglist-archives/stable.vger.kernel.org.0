Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195665214BC
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 14:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiEJMFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 08:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240849AbiEJMFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 08:05:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0389A3A71A
        for <stable@vger.kernel.org>; Tue, 10 May 2022 05:01:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A43CAB81D17
        for <stable@vger.kernel.org>; Tue, 10 May 2022 12:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45449C385A6;
        Tue, 10 May 2022 12:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652184081;
        bh=0hlPlRQbwT4IPNaz3+wbzuKEtv68yR8cekZX2l3O0TY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jIjEqZ21mCQIgaLmUv/BXBOj+w0w8k2X/UAH/upy3t/oaZ7uSQzAtb9L9CPuHS652
         Fad4wt0t9YleEEyFBNNeOOKg4jik5B6vyU/Nri1Fm2Ta4C3YyORicJnLLjDMCx8QK3
         Rge7tVo1u0/JOzhw1D0DbhfRhRS7R6Mc9fse4aKI8izgFsFarLnEO/0iTfb20ke2kq
         IKpENEMAfga9i8w42SoyUP2BgnF/mZKMXDGRn/L8PcMnBK2r/fb9QiVBkdhRrZjRsX
         9EsOlBNmZP5aeuHgn1VGRxHFIkcPID+fN5lNeEaWTnu02ImuX4P53OjlvIBtqowPb4
         H8whgQrBxo/uA==
Received: by pali.im (Postfix)
        id A3E7A1D4B; Tue, 10 May 2022 14:01:18 +0200 (CEST)
Date:   Tue, 10 May 2022 14:01:18 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Josef Schlehofer <josef.schlehofer@nic.cz>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 4.14 1/2] PCI: aardvark: Clear all MSIs at setup
Message-ID: <20220510120118.r4nmzqrxw3mmyryd@pali>
References: <20220503205434.25275-1-kabel@kernel.org>
 <YnpTTkaVKo8hCOHT@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YnpTTkaVKo8hCOHT@kroah.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 10 May 2022 13:58:06 Greg Kroah-Hartman wrote:
> On Tue, May 03, 2022 at 10:54:33PM +0200, Marek Behún wrote:
> > From: Pali Rohár <pali@kernel.org>
> > 
> > [ Upstream commit 7d8dc1f7cd007a7ce94c5b4c20d63a8b8d6d7751 ]
> > 
> > We already clear all the other interrupts (ISR0, ISR1, HOST_CTRL_INT).
> > 
> > Define a new macro PCIE_MSI_ALL_MASK and do the same clearing for MSIs,
> > to ensure that we don't start receiving spurious interrupts.
> > 
> > Use this new mask in advk_pcie_handle_msi();
> > 
> > Link: https://lore.kernel.org/r/20211130172913.9727-5-kabel@kernel.org
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > Signed-off-by: Marek Behún <kabel@kernel.org>
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Signed-off-by: Marek Behún <kabel@kernel.org>
> > ---
> >  drivers/pci/host/pci-aardvark.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> What about 4.19 and 5.4 for this and patch 2/2?  I can't apply this to
> 4.14 without the newer kernels also having it, right?

Do you mean these patches which Marek prepared? Or something else?
https://lore.kernel.org/stable/20220504140719.11066-1-kabel@kernel.org/
https://lore.kernel.org/stable/20220504140826.11094-1-kabel@kernel.org/

> thanks,
> 
> greg k-h
