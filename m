Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7E96693BD
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 11:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbjAMKII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 05:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240413AbjAMKIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 05:08:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258CB42E1A
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 02:08:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C54D2B820F8
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 10:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03A4C433F0;
        Fri, 13 Jan 2023 10:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673604479;
        bh=NimXkx2dkga5QSV9oj4fXIX0krc22s6njAv95e4sDNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M+X41J3SiTjCJC+s0NTnNwAxOBorQ94eRWvGoAxjq7TDeCIirZNREXBJclKSg3SWh
         DUQIOzkbW19feIgObIzgxsJQmmtEkAF14QzKLry4z1gAVfP7PWzqRJaax8G4+vKNuh
         0RvmdYdjamkgpOa2itCl2Z7RYDwA8jXjJTFJFaeY=
Date:   Fri, 13 Jan 2023 11:07:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rainer Fiebig <jrf@mailbox.org>
Cc:     stable@vger.kernel.org
Subject: Re: Kernel v6.0.18: Resume from hibernate fails, system hangs;
 bisected
Message-ID: <Y8EtfP9CA52Btz7b@kroah.com>
References: <2d59ed2b-ba8f-6695-9764-fd3b109acd4c@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d59ed2b-ba8f-6695-9764-fd3b109acd4c@mailbox.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 10:03:33PM +0100, Rainer Fiebig wrote:
> Hi! Since kernel 6.0.18 resume from hibernate fails, the system hangs
> and a hard reset is necessary.  The CPU is a Ryzen 5600G, the system is
> Linux From Scratch-11.1.
> 
> I found this in the system log:
> 
> [...]
> Jan 12 19:30:03 LUX kernel: [   50.248036] amdgpu 0000:30:00.0: [drm]
> *ERROR* [CRTC:67:crtc-0] flip_done timed out
> Jan 12 19:30:03 LUX kernel: [   50.248040] amdgpu 0000:30:00.0: [drm]
> *ERROR* [CRTC:70:crtc-1] flip_done timed out
> Jan 12 19:30:14 LUX kernel: [   60.488034] amdgpu 0000:30:00.0: [drm]
> *ERROR* flip_done timed out
> Jan 12 19:30:14 LUX kernel: [   60.488040] amdgpu 0000:30:00.0: [drm]
> *ERROR* [CRTC:67:crtc-0] commit wait timed out
> ^@^@^@^@^@^@^@^@^@^[...]@^@^@^@^@^@^@^@^@^@^@^@^@^@Jan 12 19:31:20 LUX
> syslogd 1.5.1: restart.
> [...]
> 
> 
> Bisecting the problem turned up this:
> 
> ~/Downloads/linux-stable-BLFS-11.1> git bisect bad
> 306df163069e78160e7a534b892c5cd6fefdd537 is the first bad commit
> commit 306df163069e78160e7a534b892c5cd6fefdd537
> Author: Alex Deucher <alexander.deucher@amd.com>
> Date:   Wed Dec 7 11:08:53 2022 -0500
> 
>     drm/amdgpu: make display pinning more flexible (v2)
> 
>     commit 81d0bcf9900932633d270d5bc4a54ff599c6ebdb upstream.

Can you resend this and cc: all of the people involved in this commit as
well as the drm mailing list?

Also, does 6.1.y work properly for you?  6.0.y is now end-of-life and
you shouldn't be using it anymore.

thanks,

greg k-h
