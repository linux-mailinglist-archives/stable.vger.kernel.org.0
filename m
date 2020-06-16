Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BC81FB1E5
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 15:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgFPNVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 09:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgFPNVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 09:21:14 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A9A4206F1;
        Tue, 16 Jun 2020 13:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592313673;
        bh=cwpxN6HmpOwPqhRIHV7oO/gd2uBmaosQx1+nlTdyI/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E0tNBW4RUXKVVABZgqoWw6ejm93qW1cr+YdJjDJW8+aSmlF8dhFuiDkPDw8rIUff1
         rehkqLM5CEbmh+EoIx8JLhlO1eeJDnQx/fgB1SR4kaT/1kXkGXRsrYuq/thTEuzg+j
         2GOAV99sFoqgP9ypK55tP156tnerWFmNgJB1Dklw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jlBWZ-003QYC-Sz; Tue, 16 Jun 2020 14:21:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 16 Jun 2020 14:21:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH stable-5.7] KVM: arm64: Synchronize sysreg state on
 injecting an AArch32 exception
In-Reply-To: <4380fcb75d3c486919dd6fe65ce9a6c1@kernel.org>
References: <20200616125200.2024340-1-maz@kernel.org>
 <20200616130916.GB3932158@kroah.com>
 <4380fcb75d3c486919dd6fe65ce9a6c1@kernel.org>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <c8941df9ac547d845c8f248b139908bf@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: greg@kroah.com, stable@vger.kernel.org, kernel-team@android.com, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-16 14:19, Marc Zyngier wrote:
> Hi Greg,
> 
> On 2020-06-16 14:09, Greg KH wrote:
>> On Tue, Jun 16, 2020 at 01:52:00PM +0100, Marc Zyngier wrote:
>>> commit 0370964dd3ff7d3d406f292cb443a927952cbd05 upstream
>>> 
>>> On a VHE system, the EL1 state is left in the CPU most of the time,
>>> and only syncronized back to memory when vcpu_put() is called (most
>>> of the time on preemption).
>>> 
>>> Which means that when injecting an exception, we'd better have a way
>>> to either:
>>> (1) write directly to the EL1 sysregs
>>> (2) synchronize the state back to memory, and do the changes there
>>> 
>>> For an AArch64, we already do (1), so we are safe. Unfortunately,
>>> doing the same thing for AArch32 would be pretty invasive. Instead,
>>> we can easily implement (2) by calling the put/load architectural
>>> backends, and keep preemption disabled. We can then reload the
>>> state back into EL1.
>>> 
>>> Cc: stable@vger.kernel.org
>>> Reported-by: James Morse <james.morse@arm.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  virt/kvm/arm/aarch32.c | 28 ++++++++++++++++++++++++++++
>>>  1 file changed, 28 insertions(+)
>> 
>> Thanks for this, and the other backport.  Queued up.
> 
> You seem to have queued the same patches for 5.4 and 5.6.

Huh, and 4.19 as well. Gahh...

> This will break 32bit ARM (the patch applies nicely, but it will blow
> up at compile time).
> 
> I'll have the corresponding backports later today, once I've finished
> testing them.
> 
> Thanks,
> 
>         M.

-- 
Jazz is not dead. It just smells funny...
