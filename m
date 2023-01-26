Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E461667C51A
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 08:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjAZHq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 02:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbjAZHqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 02:46:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B0469B04
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 23:45:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 550AD6175F
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 07:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4404CC433EF;
        Thu, 26 Jan 2023 07:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674719147;
        bh=QjhsujuJ9sK/ibe4v7IXmvDSdVXT7XmI7uzbJBgm8Cw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JmJLP/x0gwpaxXzan4sEFcJfkRZWekoH76gWze9WbODBqIuG4Ra5cHvADOpjW4oZG
         QccnN5u7mY+apK4NLE+XSxD5KqUZzGlaTcC5qwuSFRbe+g0H8PxsEKoWV8rc2l9fVZ
         Kn6opjWqN0WapRnNMJRy7DYnVgsCAm9N0MhHPMSA=
Date:   Thu, 26 Jan 2023 08:45:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org, x86@kernel.org,
        kernel@gpiccoli.net, kernel-dev@igalia.com,
        Deepak Sharma <deepak.sharma@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 5.10 / 5.15] x86: ACPI: cstate: Optimize C3 entry on AMD
 CPUs
Message-ID: <Y9IvqbdW+T5IsJH6@kroah.com>
References: <20230125215145.1171151-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125215145.1171151-1-gpiccoli@igalia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 25, 2023 at 06:51:45PM -0300, Guilherme G. Piccoli wrote:
> From: Deepak Sharma <deepak.sharma@amd.com>
> 
> commit a8fb40966f19ff81520d9ccf8f7e2b95201368b8 upstream.
> 
> All Zen or newer CPU which support C3 shares cache. Its not necessary to
> flush the caches in software before entering C3. This will cause drop in
> performance for the cores which share some caches. ARB_DIS is not used
> with current AMD C state implementation. So set related flags correctly.
> 
> Signed-off-by: Deepak Sharma <deepak.sharma@amd.com>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
> 
> 
> Hi folks, this is a very simple optimization that might be read
> as a fix IMO, since it's setting the flags correctly for the Zen CPUs.
> It was built/boot tested in the Steam Deck.
> 
> The backport for stable was a suggestion from Greg [0], so lemme
> know if any of you see an issue with that, or if we should target
> other stable versions (or less versions, maybe only 5.15).
> Cheers,

Looks good, thanks for the backport, now queued up!

greg k-h
