Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCBB1D2174
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 23:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgEMVs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 17:48:59 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55322 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729487AbgEMVs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 17:48:59 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8207E1C0281; Wed, 13 May 2020 23:48:57 +0200 (CEST)
Date:   Wed, 13 May 2020 23:48:56 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 4.19 37/48] x86/entry/64: Fix unwind hints in register
 clearing code
Message-ID: <20200513214856.GA27858@amd>
References: <20200513094351.100352960@linuxfoundation.org>
 <20200513094401.325580400@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20200513094401.325580400@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2020-05-13 11:45:03, Greg Kroah-Hartman wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>
>=20
> commit 06a9750edcffa808494d56da939085c35904e618 upstream.
>=20
> The PUSH_AND_CLEAR_REGS macro zeroes each register immediately after
> pushing it.  If an NMI or exception hits after a register is cleared,
> but before the UNWIND_HINT_REGS annotation, the ORC unwinder will
> wrongly think the previous value of the register was zero.  This can
> confuse the unwinding process and cause it to exit early.
>=20
> Because ORC is simpler than DWARF, there are a limited number of unwind
> annotation states, so it's not possible to add an individual unwind hint
> after each push/clear combination.  Instead, the register clearing
> instructions need to be consolidated and moved to after the
> UNWIND_HINT_REGS annotation.

This actually makes kernel entry/exit slower, due to poor instruction
scheduling. And that is a bit of hot path... Is it strictly
neccessary? Not everyone needs ORC scheduler. Should it be somehow
optional?

Best regards,
								Pavel

> -	 * Interleave XOR with PUSH for better uop scheduling:
> -	 */
>  	.if \save_ret
>  	pushq	%rsi		/* pt_regs->si */
>  	movq	8(%rsp), %rsi	/* temporarily store the return address in %rsi */
> @@ -114,34 +107,43 @@ For 32-bit we have the following convent
>  	pushq   %rsi		/* pt_regs->si */
>  	.endif
>  	pushq	\rdx		/* pt_regs->dx */
> -	xorl	%edx, %edx	/* nospec   dx */
>  	pushq   %rcx		/* pt_regs->cx */
> -	xorl	%ecx, %ecx	/* nospec   cx */
>  	pushq   \rax		/* pt_regs->ax */
>  	pushq   %r8		/* pt_regs->r8 */
> -	xorl	%r8d, %r8d	/* nospec   r8 */
>  	pushq   %r9		/* pt_regs->r9 */
> -	xorl	%r9d, %r9d	/* nospec   r9 */
>  	pushq   %r10		/* pt_regs->r10 */
> -	xorl	%r10d, %r10d	/* nospec   r10 */
>  	pushq   %r11		/* pt_regs->r11 */
> -	xorl	%r11d, %r11d	/* nospec   r11*/
>  	pushq	%rbx		/* pt_regs->rbx */
> -	xorl    %ebx, %ebx	/* nospec   rbx*/
>  	pushq	%rbp		/* pt_regs->rbp */
> -	xorl    %ebp, %ebp	/* nospec   rbp*/
>  	pushq	%r12		/* pt_regs->r12 */
> -	xorl	%r12d, %r12d	/* nospec   r12*/
>  	pushq	%r13		/* pt_regs->r13 */
> -	xorl	%r13d, %r13d	/* nospec   r13*/
>  	pushq	%r14		/* pt_regs->r14 */
> -	xorl	%r14d, %r14d	/* nospec   r14*/
>  	pushq	%r15		/* pt_regs->r15 */
> -	xorl	%r15d, %r15d	/* nospec   r15*/
>  	UNWIND_HINT_REGS
> +
>  	.if \save_ret
>  	pushq	%rsi		/* return address on top of stack */
>  	.endif
> +
> +	/*
> +	 * Sanitize registers of values that a speculation attack might
> +	 * otherwise want to exploit. The lower registers are likely clobbered
> +	 * well before they could be put to use in a speculative execution
> +	 * gadget.
> +	 */
> +	xorl	%edx,  %edx	/* nospec dx  */
> +	xorl	%ecx,  %ecx	/* nospec cx  */
> +	xorl	%r8d,  %r8d	/* nospec r8  */
> +	xorl	%r9d,  %r9d	/* nospec r9  */
> +	xorl	%r10d, %r10d	/* nospec r10 */
> +	xorl	%r11d, %r11d	/* nospec r11 */
> +	xorl	%ebx,  %ebx	/* nospec rbx */
> +	xorl	%ebp,  %ebp	/* nospec rbp */
> +	xorl	%r12d, %r12d	/* nospec r12 */
> +	xorl	%r13d, %r13d	/* nospec r13 */
> +	xorl	%r14d, %r14d	/* nospec r14 */
> +	xorl	%r15d, %r15d	/* nospec r15 */
> +
>  .endm
> =20
>  .macro POP_REGS pop_rdi=3D1 skip_r11rcx=3D0
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl68a0gACgkQMOfwapXb+vIrGgCfUxFYifTpou/d/zLj+TzOUT+N
UvIAn0eMh/YolxsvDJ8kC1h+/gWGhzg2
=3I5W
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
