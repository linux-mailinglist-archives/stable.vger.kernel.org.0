Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331704CE504
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiCENjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:39:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359E73A1AE
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:38:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9CA6B80B9E
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC7AC004E1;
        Sat,  5 Mar 2022 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646487488;
        bh=VZmtnjUiYBiOweinTqKjlzZ/YkvqWldc9rZKUZI5bAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qmnZqdWQnO7/fD2hhvQGrzE891vjR0/mUWBJSFtzv0QC3AIlaQrhicV+KbdlBc+4c
         WqncgEgdwy8cQEP4G3vVra64+xgm1r1UXC3oV/70KYbAFkv/NBi511ZOF6hktzmr99
         kgy0Ol3z+jZft9lUrhUpbW2d/MSRp2QktwcIMfKQ=
Date:   Sat, 5 Mar 2022 14:38:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] platform/x86: amd-pmc: Set QOS during suspend on CZN w/
 timer wakeup
Message-ID: <YiNnvAScPPtHC/d9@kroah.com>
References: <20220301041510.1122030-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301041510.1122030-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 10:15:10PM -0600, Mario Limonciello wrote:
> commit 59348401ebed ("platform/x86: amd-pmc: Add special handling for
> timer based S0i3 wakeup") adds support for using another platform timer
> in lieu of the RTC which doesn't work properly on some systems. This path
> was validated and worked well before submission. During the 5.16-rc1 merge
> window other patches were merged that caused this to stop working properly.
> 
> When this feature was used with 5.16-rc1 or later some OEM laptops with the
> matching firmware requirements from that commit would shutdown instead of
> program a timer based wakeup.
> 
> This was bisected to commit 8d89835b0467 ("PM: suspend: Do not pause
> cpuidle in the suspend-to-idle path").  This wasn't supposed to cause any
> negative impacts and also tested well on both Intel and ARM platforms.
> However this changed the semantics of when CPUs are allowed to be in the
> deepest state. For the AMD systems in question it appears this causes a
> firmware crash for timer based wakeup.
> 
> It's hypothesized to be caused by the `amd-pmc` driver sending `OS_HINT`
> and all the CPUs going into a deep state while the timer is still being
> programmed. It's likely a firmware bug, but to avoid it don't allow setting
> CPUs into the deepest state while using CZN timer wakeup path.
> 
> If later it's discovered that this also occurs from "regular" suspends
> without a timer as well or on other silicon, this may be later expanded to
> run in the suspend path for more scenarios.
> 
> Cc: stable@vger.kernel.org # 5.16+
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Link: https://lore.kernel.org/linux-acpi/BL1PR12MB51570F5BD05980A0DCA1F3F4E23A9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#mee35f39c41a04b624700ab2621c795367f19c90e
> Fixes: 8d89835b0467 ("PM: suspend: Do not pause cpuidle in the suspend-to-idle path")
> Fixes: 23f62d7ab25b ("PM: sleep: Pause cpuidle later and resume it earlier during system transitions")
> Fixes: 59348401ebed ("platform/x86: amd-pmc: Add special handling for timer based S0i3 wakeup"
> Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Link: https://lore.kernel.org/r/20220223175237.6209-1-mario.limonciello@amd.com
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> (cherry picked from commit 68af28426b3ca1bf9ba21c7d8bdd0ff639e5134c)
> ---
> This didn't apply cleanly to 5.16.y because 5.16.y doesn't contain the STB
> feature.  Manually fixed up the commit for this.
> This is *only* intended for 5.16.

Now queued up, thanks.

greg k-h
