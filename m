Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F94A5AA73D
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 07:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiIBF3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 01:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIBF3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 01:29:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7CDB69F0
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 22:29:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDEA3B829DD
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 05:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E3AC433D6;
        Fri,  2 Sep 2022 05:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662096543;
        bh=OLDVN7mSvjW5xGH0+pVMsmiu/y679ZGtVil1ZnUiJm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MYx2OOcTDwTXJW22ZSEWjI7uTMCHxdDv3aS+Bfz/4nyLYfhdwYuNaxBDHm/FHpu18
         cvxrrI1Vqt8wVjI8ZwEB+Zz/eDvuncNzyfcRjnlZKbU1XctLWUNmbmbDmUqwsbGUCD
         S+Maa6/XMYWNrCDeAd5uvG1jO74cGo1ifI6p/SD0=
Date:   Fri, 2 Sep 2022 07:29:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Properly reflect IOMMU DMA Protection in 5.15.y+
Message-ID: <YxGUnAjojULtdhfL@kroah.com>
References: <MN0PR12MB6101D6CA042DB26E76179482E27A9@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101D6CA042DB26E76179482E27A9@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 03:00:26AM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> A sysfs file /sys/bus/thunderbolt/devices/domainX/iommu_dma_protection is exported from the kernel and used by userspace to make judgments on whether to automatically authorize PCIe tunnels for USB4 devices.
> Before kernel 5.19 this file was only populated on Intel USB4 and TBT3 controllers, but starting with 5.19 it also populates for non-Intel as well.

So that's a new kernel feature?

> This is accomplished by an assertion from the IOMMU subsystem that it's safe to do so by a combination of firmware and hardware.
> 
> Here is the patch series on top of 5.15.64:
> 
> 3f6634d997dba8140b3a7cba01776b9638d70dff
> ed36d04e8f8d7b00db451b0fa56a54e8e02ec43e
> d0be55fbeb6ac694d15af5d1aad19cdec8cd64e5
> f316ba0a8814f4c91e80a435da3421baf0ddd24c
> f1ca70717bcb4525e29da422f3d280acbddb36fe
> bfb3ba32061da1a9217ef6d02fbcffb528e4c8df
> 418e0a3551bbef5b221705b0e5b8412cdc0afd39
> acdb89b6c87a2d7b5c48a82756e6f5c6f599f60a
> ea4692c75e1c63926e4fb0728f5775ef0d733888
> 86eaf4a5b4312bea8676fb79399d9e08b53d8e71
> 
> Can you please consider backporting them to 5.15.y+?

I don't understand why all of the string helpers are needed just for the
last commit, are you sure this is all necessary?

And again, this feels like new features are being added that are much
more than just a "new device id added".  Why not just use 5.19 for this
hardware?

thanks,

greg k-h
