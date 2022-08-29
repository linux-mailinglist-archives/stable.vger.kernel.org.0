Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBFC5A4EC5
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 16:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiH2OFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 10:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiH2OFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 10:05:11 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D241117B
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:05:07 -0700 (PDT)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oSfNv-0000rx-CT; Mon, 29 Aug 2022 16:05:03 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oSfNu-002NW5-2Y;
        Mon, 29 Aug 2022 16:05:02 +0200
Message-ID: <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing"
 failed to apply to 5.10-stable tree
From:   Ben Hutchings <ben@decadent.org.uk>
To:     gregkh@linuxfoundation.org, peterz@infradead.org
Cc:     stable@vger.kernel.org
Date:   Mon, 29 Aug 2022 16:04:58 +0200
In-Reply-To: <166176181110563@kroah.com>
References: <166176181110563@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Y7wknpsOPOs7gqYVf7vX"
User-Agent: Evolution 3.44.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-Y7wknpsOPOs7gqYVf7vX
Content-Type: multipart/mixed; boundary="=-iY3IVrEbVuk2VK+eMuCV"

--=-iY3IVrEbVuk2VK+eMuCV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-08-29 at 10:30 +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20

You need commit 4e3aa9238277 "x86/nospec: Unwreck the RSB stuffing"
before this one.  I've attached the backport of that for 5.10.  I
haven't checked the older branches.

Ben.

> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 332924973725e8cdcc783c175f68cf7e162cb9e5 Mon Sep 17 00:00:00 2001
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 19 Aug 2022 13:01:35 +0200
> Subject: [PATCH] x86/nospec: Fix i386 RSB stuffing
>=20
> Turns out that i386 doesn't unconditionally have LFENCE, as such the
> loop in __FILL_RETURN_BUFFER isn't actually speculation safe on such
> chips.
>=20
> Fixes: ba6e31af2be9 ("x86/speculation: Add LFENCE to RSB fill sequence")
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lkml.kernel.org/r/Yv9tj9vbQ9nNlXoY@worktop.programming.kick=
s-ass.net
>=20
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/=
nospec-branch.h
> index 10731ccfed37..c936ce9f0c47 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -50,6 +50,7 @@
>   * the optimal version - two calls, each with their own speculation
>   * trap should their return address end up getting used, in a loop.
>   */
> +#ifdef CONFIG_X86_64
>  #define __FILL_RETURN_BUFFER(reg, nr)			\
>  	mov	$(nr/2), reg;				\
>  771:							\
> @@ -60,6 +61,17 @@
>  	jnz	771b;					\
>  	/* barrier for jnz misprediction */		\
>  	lfence;
> +#else
> +/*
> + * i386 doesn't unconditionally have LFENCE, as such it can't
> + * do a loop.
> + */
> +#define __FILL_RETURN_BUFFER(reg, nr)			\
> +	.rept nr;					\
> +	__FILL_RETURN_SLOT;				\
> +	.endr;						\
> +	add	$(BITS_PER_LONG/8) * nr, %_ASM_SP;
> +#endif
> =20
>  /*
>   * Stuff a single RSB slot.
>=20

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered
an expert.

--=-iY3IVrEbVuk2VK+eMuCV
Content-Disposition: attachment; filename="x86-nospec-unwreck-the-rsb-stuffing.patch"
Content-Type: text/x-patch; name="x86-nospec-unwreck-the-rsb-stuffing.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbTogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPgpEYXRlOiBUdWUsIDE2
IEF1ZyAyMDIyIDE0OjI4OjM2ICswMjAwClN1YmplY3Q6IHg4Ni9ub3NwZWM6IFVud3JlY2sgdGhl
IFJTQiBzdHVmZmluZwoKY29tbWl0IDRlM2FhOTIzODI3NzU5N2M2Yzc2MjRmMzAyZDgxYTdiNTY4
YjZmMmQgdXBzdHJlYW0uCgpDb21taXQgMmIxMjk5MzIyMDE2ICgieDg2L3NwZWN1bGF0aW9uOiBB
ZGQgUlNCIFZNIEV4aXQgcHJvdGVjdGlvbnMiKQptYWRlIGEgcmlnaHQgbWVzcyBvZiB0aGUgUlNC
IHN0dWZmaW5nLCByZXdyaXRlIHRoZSB3aG9sZSB0aGluZyB0byBub3QKc3Vjay4KClRoYW5rcyB0
byBBbmRyZXcgZm9yIHRoZSBlbmxpZ2h0ZW5pbmcgY29tbWVudCBhYm91dCBQb3N0LUJhcnJpZXIg
UlNCCnRoaW5ncyBzbyB3ZSBjYW4gbWFrZSB0aGlzIGNvZGUgbGVzcyBtYWdpY2FsLgoKQ2M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogUGV0ZXIgWmlqbHN0cmEgKEludGVs
KSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+Ckxpbms6IGh0dHBzOi8vbGttbC5rZXJuZWwub3JnL3Iv
WXZ1TmREV29VWlNCalljbUB3b3JrdG9wLnByb2dyYW1taW5nLmtpY2tzLWFzcy5uZXQKW2J3aDog
QmFja3BvcnRlZCB0byA1LjEwOiBhZGp1c3QgY29udGV4dF0KU2lnbmVkLW9mZi1ieTogQmVuIEh1
dGNoaW5ncyA8YmVuaEBkZWJpYW4ub3JnPgotLS0KIGFyY2gveDg2L2luY2x1ZGUvYXNtL25vc3Bl
Yy1icmFuY2guaCB8IDgwICsrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFu
Z2VkLCAzOSBpbnNlcnRpb25zKCspLCA0MSBkZWxldGlvbnMoLSkKCi0tLSBhL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL25vc3BlYy1icmFuY2guaAorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9ub3Nw
ZWMtYnJhbmNoLmgKQEAgLTM1LDMzICszNSw0NCBAQAogI2RlZmluZSBSU0JfQ0xFQVJfTE9PUFMJ
CTMyCS8qIFRvIGZvcmNpYmx5IG92ZXJ3cml0ZSBhbGwgZW50cmllcyAqLwogCiAvKgorICogQ29t
bW9uIGhlbHBlciBmb3IgX19GSUxMX1JFVFVSTl9CVUZGRVIgYW5kIF9fRklMTF9PTkVfUkVUVVJO
LgorICovCisjZGVmaW5lIF9fRklMTF9SRVRVUk5fU0xPVAkJCVwKKwlBTk5PVEFURV9JTlRSQV9G
VU5DVElPTl9DQUxMOwkJXAorCWNhbGwJNzcyZjsJCQkJXAorCWludDM7CQkJCQlcCis3NzI6CisK
Ky8qCisgKiBTdHVmZiB0aGUgZW50aXJlIFJTQi4KKyAqCiAgKiBHb29nbGUgZXhwZXJpbWVudGVk
IHdpdGggbG9vcC11bnJvbGxpbmcgYW5kIHRoaXMgdHVybmVkIG91dCB0byBiZQogICogdGhlIG9w
dGltYWwgdmVyc2lvbiDigJQgdHdvIGNhbGxzLCBlYWNoIHdpdGggdGhlaXIgb3duIHNwZWN1bGF0
aW9uCiAgKiB0cmFwIHNob3VsZCB0aGVpciByZXR1cm4gYWRkcmVzcyBlbmQgdXAgZ2V0dGluZyB1
c2VkLCBpbiBhIGxvb3AuCiAgKi8KLSNkZWZpbmUgX19GSUxMX1JFVFVSTl9CVUZGRVIocmVnLCBu
ciwgc3ApCVwKLQltb3YJJChuci8yKSwgcmVnOwkJCVwKLTc3MToJCQkJCQlcCi0JQU5OT1RBVEVf
SU5UUkFfRlVOQ1RJT05fQ0FMTDsJCVwKLQljYWxsCTc3MmY7CQkJCVwKLTc3MzoJLyogc3BlY3Vs
YXRpb24gdHJhcCAqLwkJCVwKLQlVTldJTkRfSElOVF9FTVBUWTsJCQlcCi0JcGF1c2U7CQkJCQlc
Ci0JbGZlbmNlOwkJCQkJXAotCWptcAk3NzNiOwkJCQlcCi03NzI6CQkJCQkJXAotCUFOTk9UQVRF
X0lOVFJBX0ZVTkNUSU9OX0NBTEw7CQlcCi0JY2FsbAk3NzRmOwkJCQlcCi03NzU6CS8qIHNwZWN1
bGF0aW9uIHRyYXAgKi8JCQlcCi0JVU5XSU5EX0hJTlRfRU1QVFk7CQkJXAotCXBhdXNlOwkJCQkJ
XAotCWxmZW5jZTsJCQkJCVwKLQlqbXAJNzc1YjsJCQkJXAotNzc0OgkJCQkJCVwKLQlhZGQJJChC
SVRTX1BFUl9MT05HLzgpICogMiwgc3A7CVwKLQlkZWMJcmVnOwkJCQlcCi0Jam56CTc3MWI7CQkJ
CVwKLQkvKiBiYXJyaWVyIGZvciBqbnogbWlzcHJlZGljdGlvbiAqLwlcCisjZGVmaW5lIF9fRklM
TF9SRVRVUk5fQlVGRkVSKHJlZywgbnIpCQkJXAorCW1vdgkkKG5yLzIpLCByZWc7CQkJCVwKKzc3
MToJCQkJCQkJXAorCV9fRklMTF9SRVRVUk5fU0xPVAkJCQlcCisJX19GSUxMX1JFVFVSTl9TTE9U
CQkJCVwKKwlhZGQJJChCSVRTX1BFUl9MT05HLzgpICogMiwgJV9BU01fU1A7CVwKKwlkZWMJcmVn
OwkJCQkJXAorCWpuegk3NzFiOwkJCQkJXAorCS8qIGJhcnJpZXIgZm9yIGpueiBtaXNwcmVkaWN0
aW9uICovCQlcCisJbGZlbmNlOworCisvKgorICogU3R1ZmYgYSBzaW5nbGUgUlNCIHNsb3QuCisg
KgorICogVG8gbWl0aWdhdGUgUG9zdC1CYXJyaWVyIFJTQiBzcGVjdWxhdGlvbiwgb25lIENBTEwg
aW5zdHJ1Y3Rpb24gbXVzdCBiZQorICogZm9yY2VkIHRvIHJldGlyZSBiZWZvcmUgbGV0dGluZyBh
IFJFVCBpbnN0cnVjdGlvbiBleGVjdXRlLgorICoKKyAqIE9uIFBCUlNCLXZ1bG5lcmFibGUgQ1BV
cywgaXQgaXMgbm90IHNhZmUgZm9yIGEgUkVUIHRvIGJlIGV4ZWN1dGVkCisgKiBiZWZvcmUgdGhp
cyBwb2ludC4KKyAqLworI2RlZmluZSBfX0ZJTExfT05FX1JFVFVSTgkJCQlcCisJX19GSUxMX1JF
VFVSTl9TTE9UCQkJCVwKKwlhZGQJJChCSVRTX1BFUl9MT05HLzgpLCAlX0FTTV9TUDsJCVwKIAls
ZmVuY2U7CiAKICNpZmRlZiBfX0FTU0VNQkxZX18KQEAgLTEyMCwyOCArMTMxLDE1IEBACiAjZW5k
aWYKIC5lbmRtCiAKLS5tYWNybyBJU1NVRV9VTkJBTEFOQ0VEX1JFVF9HVUFSRAotCUFOTk9UQVRF
X0lOVFJBX0ZVTkNUSU9OX0NBTEwKLQljYWxsIC5MdW5iYWxhbmNlZF9yZXRfZ3VhcmRfXEAKLQlp
bnQzCi0uTHVuYmFsYW5jZWRfcmV0X2d1YXJkX1xAOgotCWFkZCAkKEJJVFNfUEVSX0xPTkcvOCks
ICVfQVNNX1NQCi0JbGZlbmNlCi0uZW5kbQotCiAgLyoKICAgKiBBIHNpbXBsZXIgRklMTF9SRVRV
Uk5fQlVGRkVSIG1hY3JvLiBEb24ndCBtYWtlIHBlb3BsZSB1c2UgdGhlIENQUAogICAqIG1vbnN0
cm9zaXR5IGFib3ZlLCBtYW51YWxseS4KICAgKi8KLS5tYWNybyBGSUxMX1JFVFVSTl9CVUZGRVIg
cmVnOnJlcSBucjpyZXEgZnRyOnJlcSBmdHIyCi0uaWZiIFxmdHIyCi0JQUxURVJOQVRJVkUgImpt
cCAuTHNraXBfcnNiX1xAIiwgIiIsIFxmdHIKLS5lbHNlCi0JQUxURVJOQVRJVkVfMiAiam1wIC5M
c2tpcF9yc2JfXEAiLCAiIiwgXGZ0ciwgImptcCAuTHVuYmFsYW5jZWRfXEAiLCBcZnRyMgotLmVu
ZGlmCi0JX19GSUxMX1JFVFVSTl9CVUZGRVIoXHJlZyxcbnIsJV9BU01fU1ApCi0uTHVuYmFsYW5j
ZWRfXEA6Ci0JSVNTVUVfVU5CQUxBTkNFRF9SRVRfR1VBUkQKKy5tYWNybyBGSUxMX1JFVFVSTl9C
VUZGRVIgcmVnOnJlcSBucjpyZXEgZnRyOnJlcSBmdHIyPUFMVF9OT1QoWDg2X0ZFQVRVUkVfQUxX
QVlTKQorCUFMVEVSTkFUSVZFXzIgImptcCAuTHNraXBfcnNiX1xAIiwgXAorCQlfX3N0cmluZ2lm
eShfX0ZJTExfUkVUVVJOX0JVRkZFUihccmVnLFxucikpLCBcZnRyLCBcCisJCV9fc3RyaW5naWZ5
KF9fRklMTF9PTkVfUkVUVVJOKSwgXGZ0cjIKKwogLkxza2lwX3JzYl9cQDoKIC5lbmRtCiAK


--=-iY3IVrEbVuk2VK+eMuCV--

--=-Y7wknpsOPOs7gqYVf7vX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmMMx4oACgkQ57/I7JWG
EQl5CQ//Zlgu2lwubvVGQ3VEnITWL9iwroWZJO8TbzFwbOHFHQ6cuZz3/NlBP3yH
TGJoD5jFGzp2oEDUaCLO2J2w1U0dzGlTBdAPhtmD0sozWtOJpLFIYvZF7eBJYbqo
A7SWlejRYRz9j6rTCUPmdgi/kwt8x4AFgvUgjr6CwMRF7nPdyMgdodEX1SuX4g6R
XeoZ20xXuuYJ2Jg/5cBdZNE64+MDowXxxtLqnliBnufCeKgD1KpFihZ74u/l6i0j
vKlwSeDnCPImrV01F2VEmUdHKhJ2OOH2Mkf1Dq5NvPMWxU0FQd4XrS+3ByjqknT4
E5DLUaXOJhlrHUqQqgF2r+kUGyWll4pMa76hXDfDrzDJ0GsWQbiDvBqmp3XLYBJy
FYuGGBMicaJCKkaKCO4DqD+vGQj+zUyUy9TODiQY1yM2+oQqxjywDU+LtGhUxCIP
61ScSk0x6VUG/Sh32Kag3a1+fvesBrFvv7tJve24IX7RxBGttYGiTKy5xz5XpPrh
7gXXNrCC87KiUsCeUxsJnUmxopkk64/Kf6OrHGPWl6ZuvXFAst38aB/xDFfQGxvU
gCW9kWkdAJ5EJ6xsjfksJsdRZfjCKxS/YdxzKMwZPAYV+3F8vrocSskiLk5Rxbuu
kq3EAANDVrlpB1x5/p57vD126dYp1OTtNqHJYgG6oKvRx3tE5kY=
=wLCT
-----END PGP SIGNATURE-----

--=-Y7wknpsOPOs7gqYVf7vX--
