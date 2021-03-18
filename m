Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFC3340A6D
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 17:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhCRQnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 12:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232069AbhCRQmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 12:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7255D64E20;
        Thu, 18 Mar 2021 16:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616085771;
        bh=6gXB2FWqFCIJGxnEQusd1j2r934ubPSgjAWKKMgxyGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JKeDwqoVTZ4oHT4WTN7DgZ9cPLeanqv2IHDDpA3PuXByeB1i93SHENdeSpoV0DIRy
         +DQIz5heGAZ2Eu3TKbNcXpaf8VHxM964pVCwdFGY1rcdrwkyhZVfcB7b/78Ocy2h4A
         4tVRQuF7rhYnqN7g+YhDsGmdiYYWG9FSIZCpvMX6os4bcx6UT4nRUSAg7npTW5kTAu
         7q66x8+Vl0yjMewf2Yej2l3TQAb3yKl7JqFbttn5N4d46fXyFeQhJBN+mGjZZhRZvf
         hDLTUGOqy2V+8wI3r9FlcWhzxUTtb68aLPSZNDwFvLIr9c/ADNM6kcUO04+13SjwsB
         +fp40dX/SPb2Q==
Date:   Thu, 18 Mar 2021 12:42:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Thomas Backlund <tmb@tmb.nu>, "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: stable request
Message-ID: <YFODCo5hbvO+Vp5x@sashalap>
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu>
 <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
 <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu>
 <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu>
 <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com>
 <YFNPiHAvEwDpGLrv@sashalap>
 <CAMj1kXG_D_Aw+kyrz7ShMuPaMhpnMhTRZ8tsqKUf0koq_UPSnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMj1kXG_D_Aw+kyrz7ShMuPaMhpnMhTRZ8tsqKUf0koq_UPSnw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 03:15:35PM +0100, Ard Biesheuvel wrote:
>On Thu, 18 Mar 2021 at 14:03, Sasha Levin <sashal@kernel.org> wrote:
>> What about anything older than 5.10? Looks like it's needed there too?
>>
>
>Yes, 4.19 and 5.4 should probably get this too. They should apply with
>minimal effort, afaict. The only conflicting change is
>34fdce6981b96920ced4e0ee56e9db3fb03a33f0, which changed
>
>--- a/arch/x86/crypto/aesni-intel_asm.S
>+++ b/arch/x86/crypto/aesni-intel_asm.S
>@@ -2758,7 +2758,7 @@ SYM_FUNC_START(aesni_xts_crypt8)
>        pxor INC, STATE4
>        movdqu IV, 0x30(OUTP)
>
>-       CALL_NOSPEC %r11
>+       CALL_NOSPEC r11
>
>        movdqu 0x00(OUTP), INC
>        pxor INC, STATE1
>@@ -2803,7 +2803,7 @@ SYM_FUNC_START(aesni_xts_crypt8)
>        _aesni_gf128mul_x_ble()
>        movups IV, (IVP)
>
>-       CALL_NOSPEC %r11
>+       CALL_NOSPEC r11
>
>        movdqu 0x40(OUTP), INC
>        pxor INC, STATE1
>
>but those CALL_NOSPEC calls are being removed by this patch anyway, so
>that shouldn't matter.

Hm, I'm seeing a lot more conflicts on 5.4 that I'm not too comfortable
with resolving.

I should be taking just these two, right?

	032d049ea0f4 ("crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg")
	86ad60a65f29 ("crypto: x86/aes-ni-xts - use direct calls to and 4-way stride")

-- 
Thanks,
Sasha
