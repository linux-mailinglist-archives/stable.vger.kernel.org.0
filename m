Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C69F33D344
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 12:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237422AbhCPLlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 07:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhCPLlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 07:41:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E232765018;
        Tue, 16 Mar 2021 11:41:31 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lM84o-001wtA-0a; Tue, 16 Mar 2021 11:41:30 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 16 Mar 2021 11:41:29 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, dbrazdil@google.com
Subject: Re: [PATCH][for-stable-v5.11]] arm64: Unconditionally set virtual cpu
 id registers
In-Reply-To: <YFCXCbKefWH8smpB@kroah.com>
References: <20210316112500.85268-1-vladimir.murzin@arm.com>
 <YFCXCbKefWH8smpB@kroah.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <530a6de97ee4f0d03e10102273f35fd6@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, vladimir.murzin@arm.com, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, dbrazdil@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-16 11:31, Greg KH wrote:
> On Tue, Mar 16, 2021 at 11:25:00AM +0000, Vladimir Murzin wrote:
>> Commit 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
>> reorganized el2 setup in such way that virtual cpu id registers set
>> only in nVHE, yet they used (and need) to be set irrespective VHE
>> support. Lack of setup causes 32-bit guest stop booting due to MIDR
>> stay undefined.
>> 
>> Fixes: 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>> 
>> There is no upstream fix since issue went away due to code there has
>> been reworked in 5.12: nVHE comes first, so virtual cpu id register
>> are always set.
>> 
>> Maintainers, please, Ack.
> 
> Why not just use the "rework" patch instead that fixes this issue?
> 
> 
> that's always preferred instead of one-off patches.

It isn't just a "rework" patch. It's a whole series that turns the
world upside down, and it really isn't suitable for backporting in
the upstream kernel.

My preference would be to fix 5.11. I'll review that patch in a moment.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
