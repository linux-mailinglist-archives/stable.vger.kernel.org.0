Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7D72E9EF3
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 21:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbhADUlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 15:41:06 -0500
Received: from vulcan.natalenko.name ([104.207.131.136]:49628 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbhADUlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 15:41:06 -0500
Received: from localhost (home.natalenko.name [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id A35E19171B5;
        Mon,  4 Jan 2021 21:40:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1609792823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m3kO4/0YnkBsr3+eyXx74q8og9elDAs3U+DeFXahA8A=;
        b=FiJIQEVMIEGPLRLwuTGiz0LgbHiNrwZda/w+m5WNew9UE/smj6ZbT7folHdXgHqguQydum
        pChH4fK/2zTYv6kdpT/RPyhrCv0lEV4MJbh5/hSOuQwAd6HpUd2nQEspDu24KX3iNtRvXo
        pxRLyacsJLJ6upCC2Nx0AVbC43LhTLA=
Date:   Mon, 4 Jan 2021 21:40:23 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Andre Tomt <andre@tomt.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>
Subject: Re: [PATCH 5.10 637/717] drm/amd/display: Fix memory leaks in S3
 resume
Message-ID: <20210104204023.nloe547uwfxgjnl4@spock.localdomain>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125051.444911072@linuxfoundation.org>
 <e5d9703f-42a4-f154-cf13-55a3eba10859@tomt.net>
 <20210104201016.bncnhyq25zz2y76h@spock.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104201016.bncnhyq25zz2y76h@spock.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 09:10:17PM +0100, Oleksandr Natalenko wrote:
> On Mon, Jan 04, 2021 at 08:04:08PM +0100, Andre Tomt wrote:
> > On 28.12.2020 13:50, Greg Kroah-Hartman wrote:
> > > From: Stylon Wang <stylon.wang@amd.com>
> > > 
> > > commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362 upstream.
> > > 
> > > EDID parsing in S3 resume pushes new display modes
> > > to probed_modes list but doesn't consolidate to actual
> > > mode list. This creates a race condition when
> > > amdgpu_dm_connector_ddc_get_modes() re-initializes the
> > > list head without walking the list and results in  memory leak.
> > 
> > This commit is causing me problems on 5.10.4: when I turn off the display (a
> > LG TV in this case), and turn it back on again later there is no video
> > output and I get the following in the kernel log:
> > 
> > [ 8245.259628] [drm:dm_restore_drm_connector_state [amdgpu]] *ERROR*
> > Restoring old state failed with -12
> 
> Uh, it seems you've just saved me a ton of gray hair. I have the very
> same issue and I'm going to revert this patch now in order to check
> whether it makes any difference.

Confirmed, reverting this patch makes my monitor light back after
turning off/on.

Also, during testing, I've noticed that with the stock v5.10.4 kernel
once reboot sequence is initiated and xorg gets killed, the monitor also
lights back and shows the console.

My HW:

0a:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Lexa PRO [Radeon 540/540X/550/550X / RX 540X/550/550X] (rev c7)

> 
> Thanks!
> 
> > 
> > I've found another report on this commit as well:
> > https://bugzilla.kernel.org/show_bug.cgi?id=211033
> > 
> > And I suspect this is the same:
> > https://bugs.archlinux.org/task/69202
> > 
> > Reverting it from 5.10.4 makes things behave again.
> > 
> > Have not tested 5.4.86 or 5.11-rc.
> > 
> > I'm using a RX570 Polaris based card.

-- 
  Oleksandr Natalenko (post-factum)
