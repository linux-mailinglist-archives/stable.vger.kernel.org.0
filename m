Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAB52EA59B
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 07:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbhAEGyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 01:54:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbhAEGyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 01:54:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9609622482;
        Tue,  5 Jan 2021 06:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609829646;
        bh=3QGjJ+c7OISO2HWA6+TOFeLlK1G4pSZMoaTyNzDtunM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SOx4lAdwDB08JCW+czYwOp8LEBjBQrc0U0rbItCl0VpgfXqqG3G0bOu8XMUw1QDTq
         PeOQyDHx+6sCF64wf5bsIgrmOtUJnefZ38mFJTmf+xzL1IozwNC57oUfuFQyZat1tj
         z+2WVTmx8FS/W2WwTd9jamEEteP1c07GBddPzCGk=
Date:   Tue, 5 Jan 2021 07:54:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andre Tomt <andre@tomt.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>
Subject: Re: [PATCH 5.10 637/717] drm/amd/display: Fix memory leaks in S3
 resume
Message-ID: <X/QNCtpIiU5qzRp+@kroah.com>
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

Can you test 5.11-rc to see if this issue is there as well?

thanks,

greg k-h
