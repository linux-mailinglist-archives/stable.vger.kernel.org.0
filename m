Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7AE1FAE80
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgFPKtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgFPKtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 06:49:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A90E920734;
        Tue, 16 Jun 2020 10:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592304553;
        bh=ulWb4LxavZ/8PfP+CaZ5BGeZjJdMYCTeWQ5Ymqi4SYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bbrkst39G4oSZphfvS5Ej/QEAfCXDVX31UAidES7ABCdjlFHF1pouJeEQj6TVY4xD
         klvfC4imYz4cYtnvEDtkZCD/zrhZgOXkrIUY+vc7OG814Mv+cEsd2YlRirxihyYiYy
         s45p7e4wzDzaReqp+/u/3vJm0TzuNbQh8Ha0lA+E=
Date:   Tue, 16 Jun 2020 12:49:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     asteinhauser@google.com, tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/speculation: Avoid force-disabling
 IBPB based on STIBP" failed to apply to 4.19-stable tree
Message-ID: <20200616104907.GB2653240@kroah.com>
References: <159222800515682@kroah.com>
 <20200615180318.GG5492@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615180318.GG5492@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 02:03:18PM -0400, Sasha Levin wrote:
> On Mon, Jun 15, 2020 at 03:33:25PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 21998a351512eba4ed5969006f0c55882d995ada Mon Sep 17 00:00:00 2001
> > From: Anthony Steinhauser <asteinhauser@google.com>
> > Date: Tue, 19 May 2020 06:40:42 -0700
> > Subject: [PATCH] x86/speculation: Avoid force-disabling IBPB based on STIBP
> > and enhanced IBRS.
> > 
> > When STIBP is unavailable or enhanced IBRS is available, Linux
> > force-disables the IBPB mitigation of Spectre-BTB even when simultaneous
> > multithreading is disabled. While attempts to enable IBPB using
> > prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, ...) fail with
> > EPERM, the seccomp syscall (or its prctl(PR_SET_SECCOMP, ...) equivalent)
> > which are used e.g. by Chromium or OpenSSH succeed with no errors but the
> > application remains silently vulnerable to cross-process Spectre v2 attacks
> > (classical BTB poisoning). At the same time the SYSFS reporting
> > (/sys/devices/system/cpu/vulnerabilities/spectre_v2) displays that IBPB is
> > conditionally enabled when in fact it is unconditionally disabled.
> > 
> > STIBP is useful only when SMT is enabled. When SMT is disabled and STIBP is
> > unavailable, it makes no sense to force-disable also IBPB, because IBPB
> > protects against cross-process Spectre-BTB attacks regardless of the SMT
> > state. At the same time since missing STIBP was only observed on AMD CPUs,
> > AMD does not recommend using STIBP, but recommends using IBPB, so disabling
> > IBPB because of missing STIBP goes directly against AMD's advice:
> > https://developer.amd.com/wp-content/resources/Architecture_Guidelines_Update_Indirect_Branch_Control.pdf
> > 
> > Similarly, enhanced IBRS is designed to protect cross-core BTB poisoning
> > and BTB-poisoning attacks from user space against kernel (and
> > BTB-poisoning attacks from guest against hypervisor), it is not designed
> > to prevent cross-process (or cross-VM) BTB poisoning between processes (or
> > VMs) running on the same core. Therefore, even with enhanced IBRS it is
> > necessary to flush the BTB during context-switches, so there is no reason
> > to force disable IBPB when enhanced IBRS is available.
> > 
> > Enable the prctl control of IBPB even when STIBP is unavailable or enhanced
> > IBRS is available.
> > 
> > Fixes: 7cc765a67d8e ("x86/speculation: Enable prctl mode for spectre_v2_user")
> > Signed-off-by: Anthony Steinhauser <asteinhauser@google.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: stable@vger.kernel.org
> 
> I took these two additional patches for 4.19-4.4:
> 
> aa77bfb354c4 ("x86/speculation: Change misspelled STIPB to STIBP")
> 20c3a2c33e9f ("x86/speculation: Add support for STIBP always-on preferred mode")
> 
> With tiny massaging on 4.9 and 4.4.

Thanks for doing this, and the other FAILED fixups.

greg k-h
