Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB5134A30
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 19:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbgAHSIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 13:08:23 -0500
Received: from avon.wwwdotorg.org ([104.237.132.123]:39620 "EHLO
        avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgAHSIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 13:08:22 -0500
Received: from [10.20.204.51] (unknown [216.228.112.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by avon.wwwdotorg.org (Postfix) with ESMTPSA id E337E1C0917;
        Wed,  8 Jan 2020 11:08:21 -0700 (MST)
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.101.4 at avon.wwwdotorg.org
Subject: Re: "arm64: alternatives: use tpidr_el2 on VHE hosts" v4.9 backport
 missing edits to proc.S
From:   Stephen Warren <swarren@wwwdotorg.org>
To:     James Morse <james.morse@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ARM kernel mailing list 
        <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
References: <a1cb6ca5-4806-0813-3aad-1246e65162a6@wwwdotorg.org>
Message-ID: <aa09fae4-5b73-22d6-b3e8-91ff8d61d623@wwwdotorg.org>
Date:   Wed, 8 Jan 2020 11:08:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a1cb6ca5-4806-0813-3aad-1246e65162a6@wwwdotorg.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/7/20 6:09 PM, Stephen Warren wrote:
> James,
> 
> I'm looking at commit 6d99b68933fbcf51f84fcbba49246ce1209ec193 ("arm64: 
> alternatives: use tpidr_el2 on VHE hosts"). When it was back-ported to 
> v4.9.x as eea59020a7f2993018ccde317387031c04c62036, the changes to 
> arch/arm64/mm/proc.S weren't included. I assume this was just an 
> accident, or was there some specific reason for this? Either way, I do 
> find that I need those changes for system suspend/resume to work in my 
> downstream vendor fork of v4.9 if I enable KVM support in .config. I'm 
> happy to send a patch for v4.9.x to add those changes back if that's the 
> way to go. v4.14.x and later don't have this issue.

Upon further investigation of git history, here's what happened:

When When 6d99b68933fb was back-ported to upstream v4.9.x as 
eea59020a7f2, proc.S didn't save/restore tpidr_el1 at all, so that's why 
the edits to proc.S were dropped as part of the backport.

Separately, in android-4.9, 0ec37136b90e ("UPSTREAM: arm64: move sp_el0 
and tpidr_el1 into cpu_suspend_ctx") modified proc.S to save/restore 
tpidir_el1. When those two commits were later merged together in 
android-4.9, the modifications to proc.S to alternate between 
tpidr_el1/2 should have been added back in, but weren't.

Since our downstream 4.9 fork is based on android-4.9 after that merge, 
it picked up this issue and needs to be patched for it. Anyone else 
using android-4.9 would need this fix too. However, upstream 4.9.x 
stable doesn't have an issue.
