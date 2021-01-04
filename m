Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857FE2E9EA1
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 21:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbhADULE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 15:11:04 -0500
Received: from vulcan.natalenko.name ([104.207.131.136]:47304 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbhADULE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 15:11:04 -0500
Received: from localhost (home.natalenko.name [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id DD8F19170DB;
        Mon,  4 Jan 2021 21:10:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1609791017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MLs4lOSwia7VVuKW2mZ/Q32qp8iJH2T1iJGlhcXRlsA=;
        b=PnAE02r6UbSUII6M2v3mryUx4d+bRebvwUfSzi4RnFwd7uHTyz8DwdMHjuN1RJe6+NRDIS
        IdWteI0aUMlI6Uj4aw+nGXCXIQpRe/Rd+lefzIsOgVWY58UXr3YO2vgQm8Cf80/XLfx6Yd
        tUar3yyw+RGkD+LgUE+lLEnBVL8hezY=
Date:   Mon, 4 Jan 2021 21:10:16 +0100
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
Message-ID: <20210104201016.bncnhyq25zz2y76h@spock.localdomain>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125051.444911072@linuxfoundation.org>
 <e5d9703f-42a4-f154-cf13-55a3eba10859@tomt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5d9703f-42a4-f154-cf13-55a3eba10859@tomt.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 08:04:08PM +0100, Andre Tomt wrote:
> On 28.12.2020 13:50, Greg Kroah-Hartman wrote:
> > From: Stylon Wang <stylon.wang@amd.com>
> > 
> > commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362 upstream.
> > 
> > EDID parsing in S3 resume pushes new display modes
> > to probed_modes list but doesn't consolidate to actual
> > mode list. This creates a race condition when
> > amdgpu_dm_connector_ddc_get_modes() re-initializes the
> > list head without walking the list and results in  memory leak.
> 
> This commit is causing me problems on 5.10.4: when I turn off the display (a
> LG TV in this case), and turn it back on again later there is no video
> output and I get the following in the kernel log:
> 
> [ 8245.259628] [drm:dm_restore_drm_connector_state [amdgpu]] *ERROR*
> Restoring old state failed with -12

Uh, it seems you've just saved me a ton of gray hair. I have the very
same issue and I'm going to revert this patch now in order to check
whether it makes any difference.

Thanks!

> 
> I've found another report on this commit as well:
> https://bugzilla.kernel.org/show_bug.cgi?id=211033
> 
> And I suspect this is the same:
> https://bugs.archlinux.org/task/69202
> 
> Reverting it from 5.10.4 makes things behave again.
> 
> Have not tested 5.4.86 or 5.11-rc.
> 
> I'm using a RX570 Polaris based card.

-- 
  Oleksandr Natalenko (post-factum)
