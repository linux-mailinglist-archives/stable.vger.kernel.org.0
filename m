Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8FC52C34A
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 21:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241903AbiERTZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 15:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241829AbiERTZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 15:25:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F87B30F77
        for <stable@vger.kernel.org>; Wed, 18 May 2022 12:25:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F3A6B821A6
        for <stable@vger.kernel.org>; Wed, 18 May 2022 19:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A71C385A9;
        Wed, 18 May 2022 19:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652901927;
        bh=tQ9wfU1nYYT3jQrFfzPxCMEYx/WsrMVfRUJwUAX61yk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZAfjr4SCMiLfB3YeyAsIm2VOPRPYeNPK+ZsiafRIjQCRi/QPMtDTz0e/zj01q+2g
         ml9zLW9QorfJ2BDHNAZeXwLmxlUelt3eX7X0D1OAyEFiT/rfnS9VMCPiyF8ilBaDEo
         gSuNMIX4BUkdiWqbaxdJpyTc57HLnaTsmcyicTz4=
Date:   Wed, 18 May 2022 21:25:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: MMIO support for I2C-PIIX4 and SP5100-TCO
Message-ID: <YoVIJB/d8Ei3iJiE@kroah.com>
References: <MN0PR12MB610150AC5F1E15D6A67AC352E2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB610150AC5F1E15D6A67AC352E2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 06:49:59PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> Some users have complained that i2c the controller doesn't work on newer designs.  This is because the system can be configured by an OEM to not allow access to the I2C controller registers via legacy methods and instead requires MMIO.
> 
> Some bug reports collecting this problem (which have had duplicates brought in)
> https://gitlab.com/CalcProgrammer1/OpenRGB/-/issues/1984
> https://bugs.launchpad.net/amd/+bug/1950062
> 
> These commits that have landed into 5.18 fix this issue both for i2c-piix4 and for sp5100-tco (which suffers the same fate).
> 
> Would you take them back to stable 5.15.y and 5.17.y?  The series comes back cleanly to both.
> 
> 27c196c7b73c kernel/resource: Introduce request_mem_region_muxed()
> 93102cb44978 i2c: piix4: Replace hardcoded memory map size with a #define
> a3325d225b00 i2c: piix4: Move port I/O region request/release code into functions
> 0a59a24e14e9 i2c: piix4: Move SMBus controller base address detect into function
> fbafbd51bff5 i2c: piix4: Move SMBus port selection into function
> 7c148722d074 i2c: piix4: Add EFCH MMIO support to region request and release
> 46967bc1ee93 i2c: piix4: Add EFCH MMIO support to SMBus base address detect
> 381a3083c674 i2c: piix4: Add EFCH MMIO support for SMBus port select
> 6cf72f41808a i2c: piix4: Enable EFCH MMIO for Family 17h+
> abd71a948f7a Watchdog: sp5100_tco: Move timer initialization into function
> 1f182aca2300 Watchdog: sp5100_tco: Refactor MMIO base address initialization
> 0578fff4aae5 Watchdog: sp5100_tco: Add initialization using EFCH MMIO
> 826270373f17 Watchdog: sp5100_tco: Enable Family 17h+ CPUs

What is the overall diffstat of all of these commits applied?  And why
can't people with newer hardware just use 5.18 and newer releases like
they do for other more complex hardware additions?

thanks,

greg k-h
