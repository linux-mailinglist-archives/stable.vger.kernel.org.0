Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03212D8FCE
	for <lists+stable@lfdr.de>; Sun, 13 Dec 2020 20:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgLMTNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Dec 2020 14:13:20 -0500
Received: from out28-98.mail.aliyun.com ([115.124.28.98]:45169 "EHLO
        out28-98.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgLMTNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Dec 2020 14:13:13 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07921612|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.180487-0.000463275-0.81905;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047190;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.J6g39E6_1607886743;
Received: from 192.168.10.152(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.J6g39E6_1607886743)
          by smtp.aliyun-inc.com(10.147.40.2);
          Mon, 14 Dec 2020 03:12:24 +0800
Subject: Re: [PATCH] MIPS: Ingenic: Disable HPTLB for D0 XBurst CPUs too
To:     Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Zhou Yanjie <zhouyanjie@zoho.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20201212000354.291665-1-paul@crapouillou.net>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <b5c0677a-fb8c-f5e8-b0f5-5bcaab00d921@wanyeetech.com>
Date:   Mon, 14 Dec 2020 03:12:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20201212000354.291665-1-paul@crapouillou.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On 2020/12/12 上午8:03, Paul Cercueil wrote:
> The JZ4760 has the HPTLB as well, but has a XBurst CPU with a D0 CPUID.
>
> Disable the HPTLB for all XBurst CPUs with a D0 CPUID. In the case where
> there is no HPTLB (e.g. for older SoCs), this won't have any side
> effect.
>
> Fixes: b02efeb05699 ("MIPS: Ingenic: Disable abandoned HPTLB function.")
> Cc: <stable@vger.kernel.org> # 5.4
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>   arch/mips/kernel/cpu-probe.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> index e6853697a056..31cb9199197c 100644
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -1830,16 +1830,17 @@ static inline void cpu_probe_ingenic(struct cpuinfo_mips *c, unsigned int cpu)
>   		 */
>   		case PRID_COMP_INGENIC_D0:
>   			c->isa_level &= ~MIPS_CPU_ISA_M32R2;
> -			break;
> +			fallthrough;
>   
>   		/*
>   		 * The config0 register in the XBurst CPUs with a processor ID of
> -		 * PRID_COMP_INGENIC_D1 has an abandoned huge page tlb mode, this
> -		 * mode is not compatible with the MIPS standard, it will cause
> -		 * tlbmiss and into an infinite loop (line 21 in the tlb-funcs.S)
> -		 * when starting the init process. After chip reset, the default
> -		 * is HPTLB mode, Write 0xa9000000 to cp0 register 5 sel 4 to


I just noticed that I mistakenly wrote a capital 'W' in the original 
version.

with that fixed:

Reviewed-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>


BTW: Are you planning to add support for JZ4760 recently? I am currently 
writing the CGU driver for JZ4775 and X2000. If you plan to add support 
for JZ4760, I can also write the CGU driver for JZ4760 by the way.


Thanks and best regards!


> -		 * switch back to VTLB mode to prevent getting stuck.
> +		 * PRID_COMP_INGENIC_D0 or PRID_COMP_INGENIC_D1 has an abandoned
> +		 * huge page tlb mode, this mode is not compatible with the MIPS
> +		 * standard, it will cause tlbmiss and into an infinite loop
> +		 * (line 21 in the tlb-funcs.S) when starting the init process.
> +		 * After chip reset, the default is HPTLB mode, Write 0xa9000000
> +		 * to cp0 register 5 sel 4 to switch back to VTLB mode to prevent
> +		 * getting stuck.
>   		 */
>   		case PRID_COMP_INGENIC_D1:
>   			write_c0_page_ctrl(XBURST_PAGECTRL_HPTLB_DIS);
