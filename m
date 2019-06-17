Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4BF47D74
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 10:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfFQIqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 04:46:01 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:40124 "EHLO smtp3-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfFQIqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 04:46:01 -0400
Received: from anisse-station (unknown [213.36.7.13])
        by smtp3-g21.free.fr (Postfix) with ESMTPS id 32D1513F8C2;
        Mon, 17 Jun 2019 10:45:46 +0200 (CEST)
Date:   Mon, 17 Jun 2019 10:45:45 +0200
From:   Anisse Astier <aastier@freebox.fr>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org, Dave Martin <dave.martin@arm.com>
Subject: Re: [PATCH v2] arm64/sve: <uapi/asm/ptrace.h> should not depend on
 <uapi/linux/prctl.h>
Message-ID: <20190617084545.GA38959@anisse-station>
References: <20190614164600.36966-1-aastier@freebox.fr>
 <20190615221601.61FFC2184D@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190615221601.61FFC2184D@mail.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 15, 2019 at 10:16:00PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 43d4da2c45b2 arm64/sve: ptrace and ELF coredump support.
> 
> The bot has tested the following trees: v5.1.9, v4.19.50.
> 
> v5.1.9: Build failed! Errors:
>     arch/arm64/kernel/ssbd.c:44:8: error: ‘PR_SPEC_ENABLE’ undeclared (first use in this function); did you mean ‘NR_PAGETABLE’?
>     arch/arm64/kernel/ssbd.c:46:8: error: ‘PR_SPEC_DISABLE’ undeclared (first use in this function); did you mean ‘PFA_SPEC_IB_DISABLE’?
>     arch/arm64/kernel/ssbd.c:47:8: error: ‘PR_SPEC_FORCE_DISABLE’ undeclared (first use in this function); did you mean ‘PFA_SPEC_IB_FORCE_DISABLE’?
>     arch/arm64/kernel/ssbd.c:93:7: error: ‘PR_SPEC_STORE_BYPASS’ undeclared (first use in this function)
>     arch/arm64/kernel/ssbd.c:106:10: error: ‘PR_SPEC_DISABLE’ undeclared (first use in this function); did you mean ‘PFA_SPEC_IB_DISABLE’?
>     arch/arm64/kernel/ssbd.c:109:11: error: ‘PR_SPEC_PRCTL’ undeclared (first use in this function); did you mean ‘PF_SECURITY’?
>     arch/arm64/kernel/ssbd.c:109:27: error: ‘PR_SPEC_FORCE_DISABLE’ undeclared (first use in this function); did you mean ‘PFA_SPEC_IB_FORCE_DISABLE’?
>     arch/arm64/kernel/ssbd.c:112:26: error: ‘PR_SPEC_ENABLE’ undeclared (first use in this function); did you mean ‘NR_PAGETABLE’?
>     arch/arm64/kernel/ssbd.c:116:10: error: ‘PR_SPEC_NOT_AFFECTED’ undeclared (first use in this function)
>     arch/arm64/kernel/ssbd.c:123:7: error: ‘PR_SPEC_STORE_BYPASS’ undeclared (first use in this function)
> 
> v4.19.50: Build OK!
> 
> How should we proceed with this patch?
> 

Looks like I was building without ARM64_SSBD. Although even enabling it
on Linus master does not trigger this build failure (I can reproduce on
5.1.y though).

I'll prepare a v3 anyway to make this linux/prctl.h dependency of ssbd.c
more explicit for 5.1.y backport.

Regards,

Anisse

