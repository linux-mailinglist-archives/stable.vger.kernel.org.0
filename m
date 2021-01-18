Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE352FA973
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407346AbhARS6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393760AbhARS6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 13:58:01 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387AFC061573;
        Mon, 18 Jan 2021 10:57:19 -0800 (PST)
Received: from zn.tnic (p200300ec2f069f001e13c6b7481d9a7b.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:9f00:1e13:c6b7:481d:9a7b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 83A3E1EC04F0;
        Mon, 18 Jan 2021 19:57:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610996237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=krn0pyExBt6Uw03HX1RQFL05svD1tIpItYoSX8WSQY4=;
        b=sOhinDlfoB1Cdx/tMppOuoE8j/lsVolvNdZCXhjPGybIWQ1I2VAGQ8WOTqBmzS/QwnmHmE
        okIfh+K2SnoJJ/DbHNZfNagYbOATOdcVhQfJFKAvTNpAwz9mEvQVhotLAfE68yNy0TdZTF
        cOOPiujUjw1inhn0NlIu1ckOtd3YO2Y=
Date:   Mon, 18 Jan 2021 19:57:12 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        kai.huang@intel.com, haitao.huang@intel.com, seanjc@google.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <20210118185712.GE30090@zn.tnic>
References: <20210115014638.15037-1-jarkko@kernel.org>
 <20210115071809.GA9138@zn.tnic>
 <YAJ11v5tuS2uMuNm@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YAJ11v5tuS2uMuNm@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 16, 2021 at 07:12:54AM +0200, Jarkko Sakkinen wrote:
> > https://lkml.kernel.org/r/X/zoarV7gd/LNo4A@kernel.org
> 
> OK, I could recall the race that from but that must be partly because I've
> been proactively working on it, i.e. getting your point.
> 
> So let's say I add this after the sequence:
> 
> "The sequence demonstrates a scenario where CPU B starts a new
> grace period, which goes unnoticed by CPU A in sgx_release(),
> because it did not remove the final entry from the enclave's
> mm list."
> 
> Would this be sufficient or not?

Not sure.

That link above says:

"Now, let's imagine that there is exactly one entry in the encl->mm_list.
and sgx_release() execution gets scheduled right after returning from
synchronize_srcu().

With some bad luck, some process comes and removes that last entry befoe
sgx_release() acquires mm_lock."

So, the last entry gets removed by some other process before
sgx_release() acquires mm_lock. When it does acquire that lock, the test

	if (list_empty(&encl->mm_list))

will be true because "some other process" has removed that last entry.

So why do you need the synchronize_srcu() call when this process sees an
empty mm_list already?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
