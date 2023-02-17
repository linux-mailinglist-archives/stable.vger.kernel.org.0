Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1602B69AD56
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBQOHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBQOG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:06:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6296747B
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 06:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32244B82AFD
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 14:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D776C433EF;
        Fri, 17 Feb 2023 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676642815;
        bh=yGZ51zNNg+QhQlatK8Cs9B59Jr1gR9KEEJtUwROZzlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XQjtCLVNlxipKXSX4pmFjBq6tguHW0M2x3hnzhM700vvzK7eJPhk18185k/81x8gY
         5n2Zx8xeqUKSAB3/+0a1Iz6xYV3bpgFebRpX2fk68qitM6QAkcFP2IchF6MAm8sbvJ
         u9Him1A2BhtOCjfCS9BD4b4UOxzsRwt1PwFyLHs0=
Date:   Fri, 17 Feb 2023 15:06:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15.y v2 0/4] Disable IRQ1 wakeup on CZN systems for
 s2idle
Message-ID: <Y++J/a8g3jt3S/3+@kroah.com>
References: <20230213220537.6534-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213220537.6534-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 13, 2023 at 04:05:33PM -0600, Mario Limonciello wrote:
> A number of Cezanne systems report IRQ1 as a wakeup source when it's not actually
> a wakeup. This can cause problems for certain ACPI events. The following fix
> went upstream that fixed it:
> 
> commit 8e60615e8932 ("platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN")
> 
> It was reported that this fix actually helped here with older kernels too:
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1921#note_1770257
> 
> So backport this fix to 5.15.y as well.
> This backport is dependent upon being able to read the SMU version which
> happened in a different commit. So backport that commit and follow up fixes
> as well.
> 
> v1->v2:
>  * Split into multiple commits
>  * Catch some fixes for reading SMU version too
> 
> Hans de Goede (1):
>   platform/x86: amd-pmc: Fix compilation when CONFIG_DEBUGFS is disabled
> 
> Mario Limonciello (2):
>   platform/x86: amd-pmc: Correct usage of SMU version
>   platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN
> 
> Sanket Goswami (1):
>   platform/x86: amd-pmc: Export Idlemask values based on the APU
> 
>  drivers/platform/x86/amd-pmc.c | 116 +++++++++++++++++++++++++++++++++
>  1 file changed, 116 insertions(+)
> 
> -- 
> 2.34.1
> 

All now queued up, thanks.

greg k-h
