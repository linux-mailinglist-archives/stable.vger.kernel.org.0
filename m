Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6F25981CD
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 12:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241318AbiHRK5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 06:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242917AbiHRK5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 06:57:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A75E8F96E;
        Thu, 18 Aug 2022 03:57:11 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660820224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QwcESLCmW8ulJw28LxzClSHwzOuNQQyl6cJVugvBlps=;
        b=PvT/spCWBQOdm3augbdnEd1SsHd2Cq8bLGAFh+lRxf5dNDv4nC3W0+C4AionWanAuCyLZo
        ZFVGBAxx0/G8H6vuenX5a/CA8+OMJoUHLTSFsq7wl9fzBbUasvh4fU4EF/JKc5ERMKjHnN
        ICSk+i7vmA9fHnaTmb6kI9a13Rv6ZXY86IONlsnoLPeSdSH2Di1nhIKtnE5n5KVlVpfGuY
        wrC5KOyd1VHob6rjM6Ewx3IzCKtctan9cRt7klfSM8V3tSyeZa6Cl3aMAsfLmdFz2LXYYS
        M/Wn0oAKDclgPfDLdUZ2KvM6oE7RmBWn+DmtpPzU3xOBi+mgGDVcjjfzMCS3VQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660820224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QwcESLCmW8ulJw28LxzClSHwzOuNQQyl6cJVugvBlps=;
        b=HKzI6hTHmw6EN0x7oU06xuzrV/0EqzveJFcwGkkIlcqOaCZG12gPEsy922Z4MyvcyjrWPo
        ka6x/zC7WO5xAvCw==
To:     Kyle Huey <me@kylehuey.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Kyle Huey <me@kylehuey.com>, Borislav Petkov <bp@suse.de>,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] x86/fpu: Allow PKRU to be (once again) written
 by ptrace.
In-Reply-To: <20220808141538.102394-1-khuey@kylehuey.com>
References: <20220808141538.102394-1-khuey@kylehuey.com>
Date:   Thu, 18 Aug 2022 12:57:04 +0200
Message-ID: <87ilmpzunz.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kyle!

On Mon, Aug 08 2022 at 07:15, Kyle Huey wrote:
> When management of the PKRU register was moved away from XSTATE, emulation
> of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
> for APIs that write XSTATE. This can be seen by running gdb and executing
> `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
> write to the PKRU register (which gdb performs through ptrace) is ignored.
>
> There are three relevant APIs: PTRACE_SETREGSET with NT_X86_XSTATE,
> sigreturn, and KVM_SET_XSAVE. KVM_SET_XSAVE has its own special handling to
> make PKRU writes take effect (in fpu_copy_uabi_to_guest_fpstate). Push that
> down into copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE
> and sigreturn pass in pointers to the appropriate PKRU value.
>
> This also adds code to initialize the PKRU value to the hardware init value
> (namely 0) if the PKRU bit is not set in the XSTATE header to match XRSTOR.
> This is a change to the current KVM_SET_XSAVE behavior.

You are stating a fact here, but provide 0 justification why this is
correct.

>
> Changelog since v4:

Can you please put the change log past the --- seperator line, so it
gets stripped off when the patch is applied? That spares manual fixups.

>
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: kvm@vger.kernel.org # For edge case behavior of KVM_SET_XSAVE
> Cc: stable@vger.kernel.org # 5.14+
> Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")

Can you please use the documented tag ordering?

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#patch-submission-notes

> @@ -1235,6 +1235,24 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
>  	for (i = 0; i < XFEATURE_MAX; i++) {
>  		mask = BIT_ULL(i);
>  
> +		if (i == XFEATURE_PKRU) {
> +			/*
> +			 * Retrieve PKRU if not in init state, otherwise
> +			 * initialize it.
> +			 */
> +			if (hdr.xfeatures & mask) {
> +				struct pkru_state xpkru = {0};
> +
> +				if (copy_from_buffer(&xpkru, xstate_offsets[i],
> +						     sizeof(xpkru), kbuf, ubuf))
> +					return -EFAULT;
> +
> +				*pkru = xpkru.pkru;
> +			} else {
> +				*pkru = 0;
> +			}
> +		}

That's really horrible and there is no point in copying the stuff from
the buffer twice:

@@ -1246,6 +1246,15 @@ static int copy_uabi_to_xstate(struct fp
 		}
 	}
 
+	/* Update the user protection key storage */
+	*pkru = 0;
+	if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
+		struct pkru_state *xpkru;
+
+		xpkru = get_xsave_addr(xsave, XFEATURE_PKRU);
+		*pkru = xpkru->pkru;
+	}
+

Hmm?

Thanks,

        tglx
