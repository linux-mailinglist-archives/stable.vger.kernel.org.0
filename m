Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B7D521492
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 14:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241026AbiEJMCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 08:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241491AbiEJMCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 08:02:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316425A0B1
        for <stable@vger.kernel.org>; Tue, 10 May 2022 04:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF172B81CBA
        for <stable@vger.kernel.org>; Tue, 10 May 2022 11:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5B3C385C2;
        Tue, 10 May 2022 11:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652183900;
        bh=H2R9iVrf9zsJX4O82ilSVsfc1NAaIopb9YS1d+O0kho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yi0hkacQZ2W6bxxRgX1AnTfw9OnYptNs2tZnJBGGU0sMB9bGvsgb2/uBxJQliiBA3
         5mKmyUxN/PF2aq/AEUg4FeTcTxyXlBTVs8Q5lP++e4KZTwHmu9zn2ehOhOgrfNikCi
         h7Vc8DeCnQ0llvin5s1DtaxuXzF5HPVCH6JX3LEE=
Date:   Tue, 10 May 2022 13:58:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        pali@kernel.org, Josef Schlehofer <josef.schlehofer@nic.cz>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 4.14 1/2] PCI: aardvark: Clear all MSIs at setup
Message-ID: <YnpTTkaVKo8hCOHT@kroah.com>
References: <20220503205434.25275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220503205434.25275-1-kabel@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 03, 2022 at 10:54:33PM +0200, Marek Behún wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> [ Upstream commit 7d8dc1f7cd007a7ce94c5b4c20d63a8b8d6d7751 ]
> 
> We already clear all the other interrupts (ISR0, ISR1, HOST_CTRL_INT).
> 
> Define a new macro PCIE_MSI_ALL_MASK and do the same clearing for MSIs,
> to ensure that we don't start receiving spurious interrupts.
> 
> Use this new mask in advk_pcie_handle_msi();
> 
> Link: https://lore.kernel.org/r/20211130172913.9727-5-kabel@kernel.org
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/pci/host/pci-aardvark.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

What about 4.19 and 5.4 for this and patch 2/2?  I can't apply this to
4.14 without the newer kernels also having it, right?

thanks,

greg k-h
