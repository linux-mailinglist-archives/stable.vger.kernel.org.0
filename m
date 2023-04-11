Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026DE6DDD17
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjDKOA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjDKOA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:00:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A8E19F
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 323A3617D2
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 14:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E2FC433EF;
        Tue, 11 Apr 2023 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681221623;
        bh=RbvMk2Y7sT52ZV72hUDL03h02CG/evHN6LuVyGXsj28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HyQbisRs2xtE2rHYgDRQf7RPBAkkJbbRqFYh7mPvYWlCoJA/4tNwPrL4jUIYMQ2Y0
         Z7qk75UGiQy44Koy9+WlCyO1HD+P+zlZoAjgy7O05u4RdC90PSXyhHu5ntgunIzXKI
         yz+R3xnpgf1I2/9gUjcA8tHeO50zIEjwKxqVjmR0=
Date:   Tue, 11 Apr 2023 16:00:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 6.1.y 0/2] MST Fixups in 6.1.y
Message-ID: <2023041101-unspoken-snowman-7ec4@gregkh>
References: <20230405193707.8184-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405193707.8184-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 02:37:05PM -0500, Mario Limonciello wrote:
> Hi,
> 
> Some MST fixups that landed in 6.3-rc1 were CC to stable and successfully
> applied to 6.2.y, but failed to apply to 6.1.y even though they are needed
> there as well.
> 
> They fail to apply due to this commit missing in 6.1.y:
> commit 8c7d980da9ba ("drm/nouveau/disp: move DP MST payload config method")
> 
> Backporting that is a rabbit hole of other work and makes this no longer
> viable for stable, so instead hand modify
> commit e761cc20946a ("drm/display/dp_mst: Handle old/new payload states in drm_dp_remove_payload()")
> 
> for the missing contextual changes in 6.1.y in nouveau.
> 
> I've tested that these work on a Rembrandt laptop connected to WD19TB
> with two monitors connected.
> 
> Imre Deak (2):
>   drm/display/dp_mst: Handle old/new payload states in
>     drm_dp_remove_payload()
>   drm/i915/dp_mst: Fix payload removal during output disabling
> 
>  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c |  2 +-
>  drivers/gpu/drm/display/drm_dp_mst_topology.c | 26 ++++++++++---------
>  drivers/gpu/drm/i915/display/intel_dp_mst.c   | 14 +++++++---
>  drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 +-
>  include/drm/display/drm_dp_mst_helper.h       |  3 ++-
>  5 files changed, 28 insertions(+), 19 deletions(-)
> 
> -- 
> 2.34.1
> 

Both now queued up, thanks.

greg k-h
