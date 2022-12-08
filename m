Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C0E647755
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 21:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLHUdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 15:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLHUdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 15:33:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B450676818
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 12:32:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68CE3B82610
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 20:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE97C433F0;
        Thu,  8 Dec 2022 20:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670531577;
        bh=IMiU0ybfWpFPkLH7ggIfjt9FWG/CwHkplq4z3S1ZfaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VzW/gHjELyKoWvUgXE4zn4qUHoPG855iFwCkv18qCUszcirlJD1ZCM5bPipFm0Kgc
         YDonyJbP5mbf0iQIGfluYv7bjlrbeIS6bdrN6fC2FVZMnhCpaohrGk4kfiifMh18so
         j1hpwmtCLkM0q1A85DJi6HmimyIzcZeLbDjewYeg=
Date:   Thu, 8 Dec 2022 21:32:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org, vkoul@kernel.org,
        Sjoerd Simons <sjoerd@collabora.com>,
        Chao Song <chao.song@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>
Subject: Re: [PATCH] soundwire: intel: Initialize clock stop timeout
Message-ID: <Y5JJ9ib1mF9p+eNu@kroah.com>
References: <20221205170600.15002-1-pierre-louis.bossart@linux.intel.com>
 <Y445YurEQGO0tQqJ@kroah.com>
 <2f12eb6e-6866-1945-b24b-edceb423e6b3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f12eb6e-6866-1945-b24b-edceb423e6b3@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 01:33:06PM -0600, Pierre-Louis Bossart wrote:
> 
> 
> On 12/5/22 12:33, Greg KH wrote:
> > On Mon, Dec 05, 2022 at 11:06:00AM -0600, Pierre-Louis Bossart wrote:
> >> From: Sjoerd Simons <sjoerd@collabora.com>
> >>
> >> commit 13c30a755847c7e804e1bf755e66e3ff7b7f9367 upstream
> >>
> >> The bus->clk_stop_timeout member is only initialized to a non-zero value
> >> during the codec driver probe. This can lead to corner cases where this
> >> value remains pegged at zero when the bus suspends, which results in an
> >> endless loop in sdw_bus_wait_for_clk_prep_deprep().
> >>
> >> Corner cases include configurations with no codecs described in the
> >> firmware, or delays in probing codec drivers.
> >>
> >> Initializing the default timeout to the smallest non-zero value avoid this
> >> problem and allows for the existing logic to be preserved: the
> >> bus->clk_stop_timeout is set as the maximum required by all codecs
> >> connected on the bus.
> >>
> >> Fixes: 1f2dcf3a154ac ("soundwire: intel: set dev_num_ida_min")
> > 
> > This commit is is only in 6.1-rc1, so why does it need to go to any
> > older kernels?  Is this tag not correct?
> 
> I don't recall why this tag was selected, it's clearly not related
> functionality-wise. I vaguely recall a discussion with Bard Liao on
> this... And yes sure enough here it is [1], it was to indicate a
> conflict but that was confusing in hindsight.
> 
> At any rate, this one-line change is really needed, some distributions
> such as Arch back-ported this change but most did not, and users don't
> have a working setup.

Ok, now queued up, thanks.

greg k-h
