Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FE1694E09
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 18:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjBMRca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 12:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBMRcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 12:32:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03B9193FB
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 09:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 269EC61219
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 17:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA90C433D2;
        Mon, 13 Feb 2023 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676309541;
        bh=M3kOciXEED3P01s/DIimClElVOiXiryB7sJpct7LmUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OkymwqciWOgiPVg3WJ1vmm1UoRslZ3g9MqdT1/eBKpvsKEOIBfLgMfPNLD9U+Iq1E
         IN/z2tLgjq3iUzBp9VaPCMBiCUuJooTJ883jwdBPy3Gc5zqNNZvDIByBglgEA61Zfx
         ntMgBMXSyqhVwrWxLG9jLhh38QnEjMyzyDjbrUVI=
Date:   Mon, 13 Feb 2023 16:23:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Xaver Hugl <xaver.hugl@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [5.15.y backport 1/1] platform/x86/amd: pmc: Disable IRQ1 wakeup
 for RN/CZN
Message-ID: <Y+pV/CuA/SMeqXen@kroah.com>
References: <20230213151543.176-1-mario.limonciello@amd.com>
 <20230213151543.176-2-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213151543.176-2-mario.limonciello@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 13, 2023 at 09:15:43AM -0600, Mario Limonciello wrote:
> By default when the system is configured for low power idle in the FADT
> the keyboard is set up as a wake source.  This matches the behavior that
> Windows uses for Modern Standby as well.
> 
> It has been reported that a variety of AMD based designs there are
> spurious wakeups are happening where two IRQ sources are active.
> 
> For example:
> ```
> PM: Triggering wakeup from IRQ 9
> PM: Triggering wakeup from IRQ 1
> ```
> 
> In these designs IRQ 9 is the ACPI SCI and IRQ 1 is the keyboard.
> One way to trigger this problem is to suspend the laptop and then unplug
> the AC adapter.  The SOC will be in a hardware sleep state and plugging
> in the AC adapter returns control to the kernel's s2idle loop.
> 
> Normally if just IRQ 9 was active the s2idle loop would advance any EC
> transactions and no other IRQ being active would cause the s2idle loop
> to put the SOC back into hardware sleep state.
> 
> When this bug occurred IRQ 1 is also active even if no keyboard activity
> occurred. This causes the s2idle loop to break and the system to wake.
> 
> This is a platform firmware bug triggering IRQ1 without keyboard activity.
> This occurs in Windows as well, but Windows will enter "SW DRIPS" and
> then with no activity enters back into "HW DRIPS" (hardware sleep state).
> 
> This issue affects Renoir, Lucienne, Cezanne, and Barcelo platforms. It
> does not happen on newer systems such as Mendocino or Rembrandt.
> 
> It's been fixed in newer platform firmware.  To avoid triggering the bug
> on older systems check the SMU F/W version and adjust the policy at suspend
> time for s2idle wakeup from keyboard on these systems. A lot of thought
> and experimentation has been given around the timing of disabling IRQ1,
> and to make it work the "suspend" PM callback is restored.
> 
> Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2115
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1951
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Link: https://lore.kernel.org/r/20230120191519.15926-1-mario.limonciello@amd.com
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> (cherry picked from commit 8e60615e8932167057b363c11a7835da7f007106)
> (cherry picked from commit f6045de1f53268131ea75a99b210b869dcc150b2)
> These have been hand modified for missing dependency commits.

Can you split this up into the 2 different commits and submit this as a
patch series so that we can track this over time easier?

thanks,

greg k-h
