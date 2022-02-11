Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0724B24CD
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 12:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349649AbiBKLxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 06:53:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345558AbiBKLxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 06:53:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E4CEAE
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 03:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 804E161A17
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 11:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DFAC340E9;
        Fri, 11 Feb 2022 11:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644580430;
        bh=rJH0kH8uCbyiFJ3FuSzh9Pq3AtoACTz5k8gJGiDJqCo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RyVLvDikdlSihoDYsquE9FqDOopmvek6cE+nasiOy71SH9dfvI/NP2oRnVao4RjWd
         /RxtUQktPqt4zMr4OBoKfLBLJfJktxa+EUWWHGZizAttGUVGS2BGhPrBr9nDF5PfNd
         Is4uJaHAJS6I7B1rSNzef0GLLMXMaLJZW43BgU00=
Date:   Fri, 11 Feb 2022 12:53:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc:     stable@vger.kernel.org, rafael.j.wysocki@intel.com,
        srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH V2 0/4] Backport intel thermal driver patches to
 5.15-stable
Message-ID: <YgZORzlMkvNnOkiX@kroah.com>
References: <20220211110435.3724-1-sumeet.r.pawnikar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211110435.3724-1-sumeet.r.pawnikar@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 11, 2022 at 04:34:31PM +0530, Sumeet Pawnikar wrote:
> We need to apply 2685c77b80a8 ("thermal/drivers/int340x: Fix RFIM mailbox write commands")
> to the 5.15-stable tree but it does not apply. This patch fix the write
> operation for mailbox command for RFIM (cmd = 0x08) which is ignored.
> This results in failing to store RFI restriction.
> 
> To apply this fix, we need to backport below set of three patches on
> 5.15-stable tree because this fix depended on these three patches.
> Without these three dependent patches, we cannot directly apply
> fix (fourth) patch.
> 
> Backport three patches:
>  [1] c4fcf1ada4ae ("thermal/drivers/int340x: Improve the tcc offset saving for suspend/resume")
>  [2] aeb58c860dc5 ("thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM responses")
>  [3] 994a04a20b03 ("thermal: int340x: Limit Kconfig to 64-bit")
> 
> Fix RFIM patch:
>  [4] 2685c77b80a8 ("thermal/drivers/int340x: Fix RFIM mailbox write commands")
> 
> ---
> Changes in V2 from V1:
>  - Added upstream commit id from Linus's tree for all four patches.
> ---
> 
> *** BLURB HERE ***
> 
> Antoine Tenart (1):
>   thermal/drivers/int340x: Improve the tcc offset saving for
>     suspend/resume
> 
> Arnd Bergmann (1):
>   thermal: int340x: Limit Kconfig to 64-bit
> 
> Srinivas Pandruvada (1):
>   thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM
>     responses
> 
> Sumeet Pawnikar (1):
>   thermal/drivers/int340x: Fix RFIM mailbox write commands
> 
>  drivers/thermal/intel/int340x_thermal/Kconfig |   4 +-
>  .../intel/int340x_thermal/int3401_thermal.c   |   8 +-
>  .../processor_thermal_device.c                |  36 ++++--
>  .../processor_thermal_device.h                |   4 +-
>  .../processor_thermal_device_pci.c            |  18 ++-
>  .../processor_thermal_device_pci_legacy.c     |   8 +-
>  .../int340x_thermal/processor_thermal_mbox.c  | 104 +++++++++++-------
>  .../int340x_thermal/processor_thermal_rfim.c  |  23 ++--
>  8 files changed, 139 insertions(+), 66 deletions(-)
> 
> -- 
> 2.17.1
> 

Now queued up, thanks.

greg k-h
