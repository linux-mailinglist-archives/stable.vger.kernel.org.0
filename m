Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9B7C172
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 14:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfGaMhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 08:37:16 -0400
Received: from foss.arm.com ([217.140.110.172]:45792 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfGaMhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 08:37:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A039D344;
        Wed, 31 Jul 2019 05:37:15 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C9FC3F575;
        Wed, 31 Jul 2019 05:37:14 -0700 (PDT)
Date:   Wed, 31 Jul 2019 13:37:12 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 V2 11/43] arm64: uaccess: Mask __user pointers for
 __arch_{clear, copy_*}_user
Message-ID: <20190731123711.GB39768@lakrids.cambridge.arm.com>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <7d56c56af2f883958d5e74fa3178a1f774b9fd94.1562908075.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d56c56af2f883958d5e74fa3178a1f774b9fd94.1562908075.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 10:57:59AM +0530, Viresh Kumar wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> commit f71c2ffcb20dd8626880747557014bb9a61eb90e upstream.
> 
> Like we've done for get_user and put_user, ensure that user pointers
> are masked before invoking the underlying __arch_{clear,copy_*}_user
> operations.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [ v4.4: fixup for v4.4 style uaccess primitives ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

[...]

>  static inline unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n)
>  {
>  	kasan_check_write(to, n);
> -	return  __arch_copy_from_user(to, from, n);
> +	return __arch_copy_from_user(to, __uaccess_mask_ptr(from), n);
> +
>  }
>  
>  static inline unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n)
>  {
>  	kasan_check_read(from, n);
> -	return  __arch_copy_to_user(to, from, n);
> +	return __arch_copy_to_user(__uaccess_mask_ptr(to), from, n);
> +
>  }

Can we please drop the trailing whitespace from each of these? That
wasn't in the upstreadm commit or v4.9.y.

Otherwise, this looks fine.

Thanks,
Mark.
