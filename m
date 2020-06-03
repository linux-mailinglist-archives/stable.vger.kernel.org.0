Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48E31ECB45
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 10:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgFCISN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 04:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFCISN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 04:18:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7DEA2077D;
        Wed,  3 Jun 2020 08:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591172292;
        bh=23PcVa7EdhREdYsRG2ukTTJlYmc0V3Ikbi+hEgb/bWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QFNxcSHiCHMwLzPqCvS1CUGNtppbAmB8XmvSh47s1JAUo1bjK8+v87XIkBMLFVjyS
         nh0OzHd510myM9HjXKEu2vHrbKcWYMLHJtISELb/Dfbe3w4GtVtX9e8M3I8esELNL0
         pa/hTRDF5NQCqecaD9d8SwC6tMVXg2My2ajPuy1M=
Date:   Wed, 3 Jun 2020 10:18:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     xiao.zhang@windriver.com, yue.tao@windriver.com,
        lpd-eng-rr@windriver.com, stable@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>
Subject: Re: Review request for LIN1019-4731/LIN1018-6238 Security Advisory -
 linux - CVE-2020-10751
Message-ID: <20200603081808.GA814141@kroah.com>
References: <20200603075701.33568-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603075701.33568-1-ovidiu.panait@windriver.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 10:57:00AM +0300, Ovidiu Panait wrote:
> Summary: Security Advisory - linux - CVE-2020-10751
> Tech Review: Xiao
> Gatekeeper: Yue Tao
> Lockdown Approval (if needed):
> Branch Tag: LTS19, LTS18
> 
> IP Statement (form link or license statement, usually automated):
> Crypto URL(s) (if needed): see http://wiki.wrs.com/PBUeng/LinuxProductDivisionExportProcess
> Parent Template (where applicable):
> 
> 
> -------------------------------------
> Impacted area             Impact y/n
> -------------------       -----------
> docs/tech-pubs                 n
> tests                          n
> build system                   n
> host dependencies              n
> RPM/packaging                  n
> toolchain                      n
> kernel code                    y
> user code                      n
> configuration files            n
> target configuration           n
> Other                          n
> Applicable to Yocto/upstream   n
> New Kernel Warnings            n
> 
> 
> Comments (indicate scope for each "y" above):
> ---------------------------------------------
> >From 11d31c9c777c235630d9a72bf316f48c5036e609 Mon Sep 17 00:00:00 2001
> From: Paul Moore <paul@paul-moore.com>
> Date: Tue, 28 Apr 2020 09:59:02 -0400
> Subject: [PATCH] selinux: properly handle multiple messages in
>  selinux_netlink_send()
> 
> commit fb73974172ffaaf57a7c42f35424d9aece1a5af6 upstream.
> 
> Fix the SELinux netlink_send hook to properly handle multiple netlink
> messages in a single sk_buff; each message is parsed and subject to
> SELinux access control.  Prior to this patch, SELinux only inspected
> the first message in the sk_buff.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [OP: backport of eeef0d9fd40 from branch linux-5.4.y of linux-stable]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> 
> Added Files:
> ------------
> No.
> 
> Removed Files:
> --------------
> No.
> 
> Remaining Changes (diffstat):
> -----------------------------
>  security/selinux/hooks.c | 70 ++++++++++++++++++++++++++--------------
>  1 file changed, 45 insertions(+), 25 deletions(-)
> 
> Testing Applicable to:
> ----------------------
> intel-x86-64
> 
> Testing Commands:
> -----------------
> CONFIG_SECURITY_SELINUX=y
> bitbake virtual/kernel
> 
> Testing, Expected Results:
> --------------------------
> Build OK. No build err/warning caused by this modification.
> 
> Conditions of submission:
> -------------------------
> Build OK. No build err/warning caused by this modification.
> Boot in qemu OK.
> 
> Arch    built      boot     boardname
> -------------------------------------
> MIPS      n         n
> MIPS64    n         n
> MIPS64n32 n         n
> ARM32     n         n
> ARM64     n         n
> x86       n         n
> x86_64    y         n       intel-x86-64
> PPC       n         n
> PPC64     n         n
> SPARC64   n         n

What is this message for?  What are we supposed to do with it?

confused,

greg k-h
