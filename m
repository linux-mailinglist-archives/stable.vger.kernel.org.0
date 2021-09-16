Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8DA40DDF0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 17:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhIPPZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 11:25:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44912 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhIPPZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 11:25:49 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B4C8820242;
        Thu, 16 Sep 2021 15:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631805867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6pwZFuwqADG+vDLGEr18yXqwER5eG6emxPHMsZpMqKo=;
        b=aI56q5Ry5YjBRMbCMrLosUVT2wdEJVt4rjWC7dEP+Xb38YgX7idCDFlweawceUTr3v934L
        d7NRt4ZciNCAfuY8VB+E+hUQYpVaF4YYnTOecjDJ3TLIjlPZxF+GJtkumBrLrB1GN/CpsD
        KqxIAFhM0mkkJNOpx2p3rNcnF0v6LQk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631805867;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6pwZFuwqADG+vDLGEr18yXqwER5eG6emxPHMsZpMqKo=;
        b=SqxS6PAOAZNGNPyHvYzcFyualRRLagxUo6u/24h9gV53GukNz5dpi26t4FZGIEs5VlQwzs
        IB7WpjQxxFkaJqDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A537713D16;
        Thu, 16 Sep 2021 15:24:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Z2tzKKthQ2EPKQAAMHmgww
        (envelope-from <bp@suse.de>); Thu, 16 Sep 2021 15:24:27 +0000
Date:   Thu, 16 Sep 2021 17:24:22 +0200
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     alexander.deucher@amd.com, lijo.lazar@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Fix build with missing
 pm_suspend_target_state" failed to apply to 5.14-stable tree
Message-ID: <YUNhpvXi6NTCi31q@zn.tnic>
References: <163179759115270@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <163179759115270@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 03:06:31PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From a47f6a5806da4f24fbb66148a1519bf72fe060db Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bp@suse.de>
> Date: Tue, 24 Aug 2021 11:42:47 +0200
> Subject: [PATCH] drm/amdgpu: Fix build with missing pm_suspend_target_state
>  module export
> 
> Building a randconfig here triggered:
> 
>   ERROR: modpost: "pm_suspend_target_state" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
> 
> because the module export of that symbol happens in
> kernel/power/suspend.c which is enabled with CONFIG_SUSPEND.
> 
> The ifdef guards in amdgpu_acpi_is_s0ix_supported(), however, test for
> CONFIG_PM_SLEEP which is defined like this:
> 
>   config PM_SLEEP
>           def_bool y
>           depends on SUSPEND || HIBERNATE_CALLBACKS
> 
> and that randconfig has:
> 
>   # CONFIG_SUSPEND is not set
>   CONFIG_HIBERNATE_CALLBACKS=y
> 
> leading to the module export missing.
> 
> Change the ifdeffery to depend directly on CONFIG_SUSPEND.
> 
> Fixes: 5706cb3c910c ("drm/amdgpu: fix checking pmops when PM_SLEEP is not enabled")

Right, that Fixes tag points to a patch which is in:

$ git describe 5706cb3c910c
v5.14-rc3-28-g5706cb3c910c

and this here patch is in 5.14 (and trivially in 5.14-stable) already
too.

So I'm guessing that is a noop here.

Looking at lkml, you've queued that one for 5.13

Subject: [PATCH 5.13 027/113] drm/amdgpu: Fix build with missing pm_suspend_target_state module export

probably because the commit in Fixes was backported there too.

/me goes and checks...

Yap, it is:

commit 8330879408e590b0d576e2e65a0ced4d9ae804bb
Author: Randy Dunlap <rdunlap@infradead.org>
Date:   Thu Jul 29 20:03:47 2021 -0700

    drm/amdgpu: fix checking pmops when PM_SLEEP is not enabled
    
    commit 5706cb3c910cc8283f344bc37a889a8d523a2c6d upstream.


Ok, all clear.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
