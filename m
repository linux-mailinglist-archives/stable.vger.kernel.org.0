Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C731DBDB0
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 21:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgETTN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 15:13:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726548AbgETTN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 15:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590002007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uVj+MsI3l6KMi5hkuPwd7L6S2NyrXRTHPrxS0K9UsOs=;
        b=ZntZSa1aATOrGrEaFf5WIOPm4vh0Z3DSsq8k4b8/fBfwnp0zSK7YWLpO+JKWPxwfUHtkPd
        1xIHlbkAh9beAREc6hhM7GfDT32O9n/kLmB9SOe0jwVoDThmT14LpZsOekw16K7OR9Vk/9
        B86JmXaTWU4fdS9AMToEkfNAmOMHCcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-TUkh5LkHMQm8KIdAbJot0w-1; Wed, 20 May 2020 15:13:23 -0400
X-MC-Unique: TUkh5LkHMQm8KIdAbJot0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCBBB461;
        Wed, 20 May 2020 19:13:21 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-121.rdu2.redhat.com [10.10.114.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 476375C1BE;
        Wed, 20 May 2020 19:13:21 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id C16CD22036E; Wed, 20 May 2020 15:13:20 -0400 (EDT)
Date:   Wed, 20 May 2020 15:13:20 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Subject: Re: [PATCH v3 2/2] x86/copy_mc: Introduce copy_mc_generic()
Message-ID: <20200520191320.GA3255@redhat.com>
References: <158992635164.403910.2616621400995359522.stgit@dwillia2-desk3.amr.corp.intel.com>
 <158992636214.403910.12184670538732959406.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158992636214.403910.12184670538732959406.stgit@dwillia2-desk3.amr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 03:12:42PM -0700, Dan Williams wrote:
> The original copy_mc_fragile() implementation had negative performance
> implications since it did not use the fast-string instruction sequence
> to perform copies. For this reason copy_mc_to_kernel() fell back to
> plain memcpy() to preserve performance on platform that did not indicate
> the capability to recover from machine check exceptions. However, that
> capability detection was not architectural and now that some platforms
> can recover from fast-string consumption of memory errors the memcpy()
> fallback now causes these more capable platforms to fail.
> 
> Introduce copy_mc_generic() as the fast default implementation of
> copy_mc_to_kernel() and finalize the transition of copy_mc_fragile() to
> be a platform quirk to indicate 'fragility'. With this in place
> copy_mc_to_kernel() is fast and recovery-ready by default regardless of
> hardware capability.
> 
> Thanks to Vivek for identifying that copy_user_generic() is not suitable
> as the copy_mc_to_user() backend since the #MC handler explicitly checks
> ex_has_fault_handler().

/me is curious to know why #MC handler mandates use of _ASM_EXTABLE_FAULT().

[..]
> +/*
> + * copy_mc_generic - memory copy with exception handling
> + *
> + * Fast string copy + fault / exception handling. If the CPU does
> + * support machine check exception recovery, but does not support
> + * recovering from fast-string exceptions then this CPU needs to be
> + * added to the copy_mc_fragile_key set of quirks. Otherwise, absent any
> + * machine check recovery support this version should be no slower than
> + * standard memcpy.
> + */
> +SYM_FUNC_START(copy_mc_generic)
> +	ALTERNATIVE "jmp copy_mc_fragile", "", X86_FEATURE_ERMS
> +	movq %rdi, %rax
> +	movq %rdx, %rcx
> +.L_copy:
> +	rep movsb
> +	/* Copy successful. Return zero */
> +	xorl %eax, %eax
> +	ret
> +SYM_FUNC_END(copy_mc_generic)
> +EXPORT_SYMBOL_GPL(copy_mc_generic)
> +
> +	.section .fixup, "ax"
> +.E_copy:
> +	/*
> +	 * On fault %rcx is updated such that the copy instruction could
> +	 * optionally be restarted at the fault position, i.e. it
> +	 * contains 'bytes remaining'. A non-zero return indicates error
> +	 * to copy_safe() users, or indicate short transfers to

copy_safe() is vestige of terminology of previous patches?

> +	 * user-copy routines.
> +	 */
> +	movq %rcx, %rax
> +	ret
> +
> +	.previous
> +
> +	_ASM_EXTABLE_FAULT(.L_copy, .E_copy)

A question for my education purposes.

So copy_mc_generic() can handle MCE both on source and destination
addresses? (Assuming some device can generate MCE on stores too).
On the other hand copy_mc_fragile() handles MCE recovery only on
source and non-MCE recovery on destination.

Thanks
Vivek

