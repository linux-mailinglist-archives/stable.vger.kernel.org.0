Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35FE29A6F0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 09:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509478AbgJ0IvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 04:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509468AbgJ0IvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 04:51:18 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC80B207DE;
        Tue, 27 Oct 2020 08:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603788678;
        bh=8dUViDF5AY6tlMc5Zv1B0uvXiJWKjdjrfSA2hyJnu28=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=waBWXHTqt80D98RIveVBsQt6EJGt9YZqLHtwaRK9rAclMOx08LZIK9YMmqSaqOtvH
         YjA/f8lhEIZG3jfMjd74abkaEl4Cp49JUn/1zfsGXdBVEpABFHKaAI/ukFV+EM6TGk
         omphyMaLuYEjNhCsXtta74oQ9l+Z7bSCz4RQ9MnY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kXKhH-004cXA-IH; Tue, 27 Oct 2020 08:51:15 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 08:51:15 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: Re: [PATCH AUTOSEL 5.9 087/147] genirq: Add stub for set_handle_irq()
 when !GENERIC_IRQ_MULTI_HANDLER
In-Reply-To: <20201026234905.1022767-87-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
 <20201026234905.1022767-87-sashal@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <afd454bc23c458d4561378907f95a0aa@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sashal@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, thunder.leizhen@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-10-26 23:48, Sasha Levin wrote:
> From: Zhen Lei <thunder.leizhen@huawei.com>
> 
> [ Upstream commit ea0c80d1764449acf2f70fdb25aec33800cd0348 ]
> 
> In order to avoid compilation errors when a driver references 
> set_handle_irq(),
> but that the architecture doesn't select GENERIC_IRQ_MULTI_HANDLER,
> add a stub function that will just WARN_ON_ONCE() if ever used.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> [maz: commit message]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: 
> https://lore.kernel.org/r/20200924071754.4509-2-thunder.leizhen@huawei.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/irq.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 1b7f4dfee35b3..b167baef88c0b 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -1252,6 +1252,12 @@ int __init set_handle_irq(void
> (*handle_irq)(struct pt_regs *));
>   * top-level IRQ handler.
>   */
>  extern void (*handle_arch_irq)(struct pt_regs *) __ro_after_init;
> +#else
> +#define set_handle_irq(handle_irq)		\
> +	do {					\
> +		(void)handle_irq;		\
> +		WARN_ON(1);			\
> +	} while (0)
>  #endif
> 
>  #endif /* _LINUX_IRQ_H */

What is the reason for this backport? The only user is a driver that
isn't getting backported (d59f7d159891 and following patches).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
