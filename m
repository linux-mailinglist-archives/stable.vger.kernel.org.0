Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70BF60AD69
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiJXOX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiJXOV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:21:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5817E97ECF
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 05:58:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 658F161333
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 12:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76489C433C1;
        Mon, 24 Oct 2022 12:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616201;
        bh=lxoCBSLyhmT6Gg8REGR3z2MvXmnbNml3mkr8H9Bi434=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LJETqWYW5ERB7RglMtPKuEU5FF94EMxrzc4PHaefE4zQeDT6w3N0c4OumMkYOp7jN
         kxaeSYq9Apcc0qjlJHQYlb1urMwveBPqV/WyAE0r9k0gmcmsyc39XQC2Hv0cJHQ5P4
         mpYp1+SWnLIyQBT48hEZrwPW+oNF/8+BKRYIJB/8=
Date:   Mon, 24 Oct 2022 13:38:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Diederik de Haas <didi.debian@cknow.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range()
 into sdma code for vega"
Message-ID: <Y1Z5Km83Rcc3W0PY@kroah.com>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
 <2651645.mvXUDI8C0e@bagend>
 <Y1I4rC37gwl367rt@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1I4rC37gwl367rt@eldamar.lan>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Argh, that caused me to drop both of these from the review queue.

Can someone verify that this really still is needed on the latest
5.10-rc that was just sent out?  And if so, please send me whatever is
really needed?

this got way too confusing...

greg k-h
