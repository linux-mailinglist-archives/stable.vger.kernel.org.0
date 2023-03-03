Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBFF6A9F98
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 19:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjCCSwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 13:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjCCSwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 13:52:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B7555BD;
        Fri,  3 Mar 2023 10:52:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 310DD618CB;
        Fri,  3 Mar 2023 18:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44463C433EF;
        Fri,  3 Mar 2023 18:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677869553;
        bh=o2oLwGsei7l6ysDnMTS07L4p4IZ8OhbojgGXZ1MHCdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zjimd4rVUN8sL2pNtX7D6dtp+R8HwLK7NFZ0SDyADG0Le58eRp1hQdb4UiaELpnmk
         dlO5icxGdDapEBGaeSaqFxDlQiqF9JjtvxXPSGWVUkipU2nuYj4rY5koIt8SHn9MTg
         RwX5iIhJxXMHVZpBvHLWNWu9sCj/DjR8KYxAPoR8=
Date:   Fri, 3 Mar 2023 19:52:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] thermal: int340x: processor_thermal: Fix deadlock
Message-ID: <ZAJB7qTK81T7Zau4@kroah.com>
References: <20230303161910.3195805-1-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303161910.3195805-1-srinivas.pandruvada@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 08:19:09AM -0800, Srinivas Pandruvada wrote:
> From: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
> 
> When user space updates the trip point there is a deadlock, which results
> in caller gets blocked forever.
> 
> Commit 05eeee2b51b4 ("thermal/core: Protect sysfs accesses to thermal
> operations with thermal zone mutex"), added a mutex for tz->lock in the
> function trip_point_temp_store(). Hence, trip set callback() can't
> call any thermal zone API as they are protected with the same mutex lock.
> 
> The callback here calling thermal_zone_device_enable(), which will result
> in deadlock.
> 
> Move the thermal_zone_device_enable() to proc_thermal_pci_probe() to
> avoid this deadlock.
> 
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
> Cc: stable@vger.kernel.org
> ---
> The commit which caused this issue was added during v6.2 cycle.

What commit exactly?  Always list that as a Fixes: tag if you know this.

thanks,

greg k-h
