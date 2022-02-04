Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB254A9439
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 08:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbiBDHAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 02:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiBDHAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 02:00:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B2EC061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 23:00:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6747461BE6
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 07:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4FCC004E1;
        Fri,  4 Feb 2022 07:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643958027;
        bh=qpl6QABk45G6hmm43d7xYtFt7hYo/1gNJlnm6FlD5Ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WjWIBjU+g1YNICSIHVckA+OE7IHNmA7JCSGbTSY3Pukr0LOxcPtkIh6RSzfTEFRMh
         Rl/qATkKKoBXdvEKvNW759tthDKR3oDQdpgeXaopyS0fdwYe6yzV9Bud6MPiVRlVMB
         mygSIcFYECERg8gpzjb52VZBKKwhw/EctbnZU1L4=
Date:   Fri, 4 Feb 2022 08:00:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Self <jason@bluehome.net>
Cc:     stable@vger.kernel.org
Subject: Re: Regression/boot failure on 5.16.3
Message-ID: <YfzPAUa2WlxiNLqe@kroah.com>
References: <20220203161959.3edf1d6e@valencia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203161959.3edf1d6e@valencia>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 03, 2022 at 04:19:59PM -0800, Jason Self wrote:
> The computer (amd64) fails to boot. The init was stuck at the
> synchronization of the time through the network. This began between
> 5.16.2 (good) and 5.16.3 (bad.) This continues on 5.16.4 and 5.16.5.
> Git bisect revealed the following. In this case the nonfree firmwre is
> not present on the system. Blacklisting the iwflwifi module works as a
> workaround for now.
> 
> 6b5ad4bd0d78fef6bbe0ecdf96e09237c9c52cc1 is the first bad commit
> commit 6b5ad4bd0d78fef6bbe0ecdf96e09237c9c52cc1
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Fri Dec 10 11:12:42 2021 +0200
> 
>     iwlwifi: fix leaks/bad data after failed firmware load
>     
>     [ Upstream commit ab07506b0454bea606095951e19e72c282bfbb42 ]
>     
>     If firmware load fails after having loaded some parts of the
>     firmware, e.g. the IML image, then this would leak. For the
>     host command list we'd end up running into a WARN on the next
>     attempt to load another firmware image.
>     
>     Fix this by calling iwl_dealloc_ucode() on failures, and make
>     that also clear the data so we start fresh on the next round.
>     
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>     Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>     Link:
>     https://lore.kernel.org/r/iwlwifi.20211210110539.1f742f0eb58a.I1315f22f6aa632d94ae2069f85e1bca5e734dce0@changeid
>     Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Please cc: the authors of this commit, and the upstream wireless
developers so they can help you out here as I think the same issue shows
up in 5.17-rc2, right?

thanks,

greg k-h
