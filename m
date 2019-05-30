Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6402FDBC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 16:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfE3O2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 10:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfE3O2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 10:28:41 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D975F25ADC;
        Thu, 30 May 2019 14:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559226520;
        bh=+Q7jRzI+M/anX5LfvaXilWi6p15ICQ6el/ITqMpdKrA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BGm48iFnmwhxeaM/klXZnK0kvBFvDAflnLLDE8+siDjc+eCOQ5yoF2A3OpJGGkSt1
         V0nqsK1v0DNXUd3RSsccjAOKEu20d4zoOIaTmGU+ENNxjq3L+QOKZifTxVcwACq6ma
         fqvekD33Ih3PjTLl2iQGW74EqLPR28S/B3jEcsHs=
Subject: Re: [PATCH v5 1/3] powerpc: Fix vDSO clock_getres()
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        shuah <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
References: <20190528120446.48911-1-vincenzo.frascino@arm.com>
 <20190528120446.48911-2-vincenzo.frascino@arm.com>
From:   shuah <shuah@kernel.org>
Message-ID: <d4c2380d-1811-18f3-51a3-10bd3782b9de@kernel.org>
Date:   Thu, 30 May 2019 08:28:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190528120446.48911-2-vincenzo.frascino@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/28/19 6:04 AM, Vincenzo Frascino wrote:
> clock_getres in the vDSO library has to preserve the same behaviour
> of posix_get_hrtimer_res().
> 
> In particular, posix_get_hrtimer_res() does:
>      sec = 0;
>      ns = hrtimer_resolution;
> and hrtimer_resolution depends on the enablement of the high
> resolution timers that can happen either at compile or at run time.
> 
> Fix the powerpc vdso implementation of clock_getres keeping a copy of
> hrtimer_resolution in vdso data and using that directly.
> 
> Fixes: a7f290dad32e ("[PATCH] powerpc: Merge vdso's and add vdso support
> to 32 bits kernel")
> Cc: stable@vger.kernel.org
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
> 
> Note: This patch is independent from the others in this series, hence it
> can be merged singularly by the powerpc maintainers.
> 

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

