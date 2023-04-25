Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4D66EDB09
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 07:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjDYFIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 01:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDYFIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 01:08:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C3183EC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 22:08:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE76362162
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 05:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26FAC433D2;
        Tue, 25 Apr 2023 05:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682399308;
        bh=dpj1nYk2Bp7BUPtmuwjB5CWpzDqpP8MQ/mlGDMqD3tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eAndy201HXMR0ZPvlWjJTzg2wE6sC7gBC7Cr1lduLiOzSCjYwCOZnrt2XmEdupPy7
         JABSafTLKhOwOZ5s3c7ifJ1yFqITpTzKWRpZz/BsF2W1WH4xfMq3xbXnCW3rJQAyIR
         o/9oTCcLQA0JyMvhQOt4C1bv3HTpMbvSby+lDRl4=
Date:   Tue, 25 Apr 2023 07:08:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Hasemeyer <markhas@chromium.org>
Cc:     bhelgaas@google.com, kai.heng.feng@canonical.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI:ASPM: Remove pcie_aspm_pm_state_change()
Message-ID: <ZEdgSbX3AsaTNBLr@kroah.com>
References: <2023042354-enjoyment-promoter-9d54@gregkh>
 <20230424183536.808003-1-markhas@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424183536.808003-1-markhas@chromium.org>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 24, 2023 at 12:35:36PM -0600, Mark Hasemeyer wrote:
> > Odd, it does not apply cleanly, so how was this tested?  Can you please
> > send the tested backport that you have so we know to get it correct?
> 
> Sorry about that. I had to apply a trivial backport as
> `pci_set_low_power_state` does not exist in v5.15.  It was tested by using an
> RTC wake in combination with using the sysfs to trigger a suspend:
> ```
> echo +5 > /sys/class/rtc/rtc0/wakealarm && echo freeze > /sys/power/state
> ```
> 
> Patch below.
> ------------------------------------
> >From 5ca368f6918710bf491feee54e09a060de835d3f Mon Sep 17 00:00:00 2001
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Date: Mon, 11 Jul 2022 18:07:01 -0500
> Subject: [PATCH] PCI/ASPM: Remove pcie_aspm_pm_state_change()
> 
> pcie_aspm_pm_state_change() was introduced at the inception of PCIe ASPM
> code, but it can cause some issues. For instance, when ASPM config is
> changed via sysfs, those changes won't persist across power state change
> because pcie_aspm_pm_state_change() overwrites them.
> 
> Also, if the driver restores L1SS [1] after system resume, the restored
> state will also be overwritten by pcie_aspm_pm_state_change().
> 
> Remove pcie_aspm_pm_state_change().  If there's any hardware that really
> needs it to function, a quirk can be used instead.
> 
> [1] https://lore.kernel.org/linux-pci/20220201123536.12962-1-vidyas@nvidia.com/
> Link: https://lore.kernel.org/r/20220509073639.2048236-1-kai.heng.feng@canonical.com
> [bhelgaas: remove additional pcie_aspm_pm_state_change() call in
> pci_set_low_power_state(), added by
> 10aa5377fc8a ("PCI/PM: Split pci_raw_set_power_state()") and moved by
> 7957d201456f ("PCI/PM: Relocate pci_set_low_power_state()")]
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Mark Hasemeyer <markhas@chromium.org>
> ---
>  drivers/pci/pci.c       |  3 ---
>  drivers/pci/pci.h       |  2 --
>  drivers/pci/pcie/aspm.c | 19 -------------------
>  3 files changed, 24 deletions(-)

What is the git commit id of this change in Linus's tree?

And can you send it as a stand-alone patch, not one that I have to
hand-edit out of an email to use?  Doing that does not scale at the rate
of change we currently deal with at all.

thanks,

greg k-h
