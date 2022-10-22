Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC440608B3C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiJVKGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJVKGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:06:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677C132CC66
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 02:22:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE055B82E02
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 08:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57136C433D7;
        Sat, 22 Oct 2022 08:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426526;
        bh=1V0XBw1ky9MWeUmmiD4yGlVox2MD6VTGOylruNVtd5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ni5FYsgfDgutRWoAe3HJ+7c6UyJLUN/kMzXc23deCC5OqLlC7RdMSA2BSMBwVFHb0
         uXhLjWqINI4lTIZeKdh44ikdgHq6WmlC9jXxAFByH7z76bBbRrSKrc4G6/ghI7Aopt
         /thuUdW2h15pY8Y7+5/+KDVAMIhiIr8Zt0C3GacI=
Date:   Sat, 22 Oct 2022 09:39:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Diederik de Haas <didi.debian@cknow.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range()
 into sdma code for vega"
Message-ID: <Y1OeLv/OmfR431tL@kroah.com>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
 <2651645.mvXUDI8C0e@bagend>
 <Y1I4rC37gwl367rt@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1I4rC37gwl367rt@eldamar.lan>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 08:14:04AM +0200, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Fri, Oct 21, 2022 at 02:29:22AM +0200, Diederik de Haas wrote:
> > On Thursday, 20 October 2022 17:38:56 CEST Alex Deucher wrote:
> > > This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.
> > > 
> > > This patch was backported incorrectly when Sasha backported it and
> > > the patch that caused the regression that this patch set fixed
> > > was reverted in commit 412b844143e3 ("Revert "PCI/portdrv: Don't disable AER
> > > reporting in get_port_device_capability()""). This isn't necessary and
> > > causes a regression so drop it.
> > > 
> > > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2216
> > > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > > Cc: Sasha Levin <sashal@kernel.org>
> > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > Cc: <stable@vger.kernel.org>    # 5.10
> > > ---
> > 
> > I build a kernel with these 2 patches reverted and can confirm that that fixes 
> > the issue on my machine with a Radeon RX Vega 64 GPU. 
> > # lspci -nn | grep VGA
> > 0b:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/
> > ATI] Vega 10 XL/XT [Radeon RX Vega 56/64] [1002:687f] (rev c1)
> > 
> > So feel free to add
> > 
> > Tested-By: Diederik de Haas <didi.debian@cknow.org>
> 
> Note additionally (probably only relevant for Greg while reviewing),
> that the first of the commits which need to be reverted is already
> queued as revert in queue-5.10.

Yeah, this series does not apply to the current 5.10 queue at all.

And I am totally confused as to what to do here.

Can someone please just send me a set of patches, on top of the current
5.10 stable queue that works?  Or just wait for after the next 5.10.y
release next week and then send me a working set of patches if you don't
like to mess with the queue format?

thanks,

greg k-h
