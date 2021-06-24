Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCE53B32C6
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 17:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFXPsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 11:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhFXPsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 11:48:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6DB613CE;
        Thu, 24 Jun 2021 15:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624549552;
        bh=RrCmE3/Sa5h2TcH5LkIE1d5SFIhyeBiWXrCbsGgl5DM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WzGrDovytRbaYmonTAz6FxdZ6REQkmMeEP4j6aQlMlapxO2T1APmEJzBeWOTilIwN
         rs71Lv4FeytoBeIbY3aVrpecz71KpjlCHH+KJKVYZJtIAU/dVP1eQMAQY7870NGBRr
         RPV6InVbuCAvwAkdUVD9bOKptT0bkB2RP+qZKtkdHpkR+rfctHHuymiWhf8963Y3ZR
         FN/qOgzSdzlBotaGdTkh9ZRrSjtgpQlkpdd4zOW5/TzHyLcjozO67YctamF3XOrHVK
         arIiSWIMAl2YciY/5QsG4zUF1NfGkRFntqkF7Ddp8iN7oGOH5UpAO1sKUeUScehDbO
         HZHG1tSKN7lgg==
Subject: Re: [PATCHv3 1/4] clk: agilex/stratix10: remove noc_clk
To:     linux-clk@vger.kernel.org
Cc:     sboyd@kernel.org, mturquette@baylibre.com, stable@vger.kernel.org
References: <20210611025201.118799-1-dinguyen@kernel.org>
From:   Dinh Nguyen <dinguyen@kernel.org>
Message-ID: <5932304d-53fe-ae64-b4e7-246216b5d6f6@kernel.org>
Date:   Thu, 24 Jun 2021 10:45:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210611025201.118799-1-dinguyen@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ping?

On 6/10/21 9:51 PM, Dinh Nguyen wrote:
> Early documentation had a noc_clk, but in reality, it's just the
> noc_free_clk. Remove the noc_clk clock and just use the noc_free_clk.
> 
> Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---
> v3: no change
> v2: add linux-stable to cc
> ---
>   drivers/clk/socfpga/clk-agilex.c | 32 +++++++++++++++-----------------
>   drivers/clk/socfpga/clk-s10.c    | 32 +++++++++++++++-----------------
>   2 files changed, 30 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
> index 92a6d740a799..5b8131542218 100644
> --- a/drivers/clk/socfpga/clk-agilex.c
> +++ b/drivers/clk/socfpga/clk-agilex.c
> @@ -222,11 +222,9 @@ static const struct stratix10_perip_cnt_clock agilex_main_perip_cnt_clks[] = {
>   	{ AGILEX_MPU_FREE_CLK, "mpu_free_clk", NULL, mpu_free_mux, ARRAY_SIZE(mpu_free_mux),
>   	   0, 0x3C, 0, 0, 0},
>   	{ AGILEX_NOC_FREE_CLK, "noc_free_clk", NULL, noc_free_mux, ARRAY_SIZE(noc_free_mux),
> -	  0, 0x40, 0, 0, 1},
> -	{ AGILEX_L4_SYS_FREE_CLK, "l4_sys_free_clk", "noc_free_clk", NULL, 1, 0,
> -	  0, 4, 0, 0},
> -	{ AGILEX_NOC_CLK, "noc_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux),
> -	  0, 0, 0, 0x30, 1},
> +	  0, 0x40, 0, 0, 0},
> +	{ AGILEX_L4_SYS_FREE_CLK, "l4_sys_free_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0,
> +	  0, 4, 0x30, 1},
>   	{ AGILEX_EMAC_A_FREE_CLK, "emaca_free_clk", NULL, emaca_free_mux, ARRAY_SIZE(emaca_free_mux),
>   	  0, 0xD4, 0, 0x88, 0},
>   	{ AGILEX_EMAC_B_FREE_CLK, "emacb_free_clk", NULL, emacb_free_mux, ARRAY_SIZE(emacb_free_mux),
> @@ -252,24 +250,24 @@ static const struct stratix10_gate_clock agilex_gate_clks[] = {
>   	  0, 0, 0, 0, 0, 0, 4},
>   	{ AGILEX_MPU_CCU_CLK, "mpu_ccu_clk", "mpu_clk", NULL, 1, 0, 0x24,
>   	  0, 0, 0, 0, 0, 0, 2},
> -	{ AGILEX_L4_MAIN_CLK, "l4_main_clk", "noc_clk", NULL, 1, 0, 0x24,
> -	  1, 0x44, 0, 2, 0, 0, 0},
> -	{ AGILEX_L4_MP_CLK, "l4_mp_clk", "noc_clk", NULL, 1, 0, 0x24,
> -	  2, 0x44, 8, 2, 0, 0, 0},
> +	{ AGILEX_L4_MAIN_CLK, "l4_main_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x24,
> +	  1, 0x44, 0, 2, 0x30, 1, 0},
> +	{ AGILEX_L4_MP_CLK, "l4_mp_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x24,
> +	  2, 0x44, 8, 2, 0x30, 1, 0},
>   	/*
>   	 * The l4_sp_clk feeds a 100 MHz clock to various peripherals, one of them
>   	 * being the SP timers, thus cannot get gated.
>   	 */
> -	{ AGILEX_L4_SP_CLK, "l4_sp_clk", "noc_clk", NULL, 1, CLK_IS_CRITICAL, 0x24,
> -	  3, 0x44, 16, 2, 0, 0, 0},
> -	{ AGILEX_CS_AT_CLK, "cs_at_clk", "noc_clk", NULL, 1, 0, 0x24,
> -	  4, 0x44, 24, 2, 0, 0, 0},
> -	{ AGILEX_CS_TRACE_CLK, "cs_trace_clk", "noc_clk", NULL, 1, 0, 0x24,
> -	  4, 0x44, 26, 2, 0, 0, 0},
> +	{ AGILEX_L4_SP_CLK, "l4_sp_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), CLK_IS_CRITICAL, 0x24,
> +	  3, 0x44, 16, 2, 0x30, 1, 0},
> +	{ AGILEX_CS_AT_CLK, "cs_at_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x24,
> +	  4, 0x44, 24, 2, 0x30, 1, 0},
> +	{ AGILEX_CS_TRACE_CLK, "cs_trace_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x24,
> +	  4, 0x44, 26, 2, 0x30, 1, 0},
>   	{ AGILEX_CS_PDBG_CLK, "cs_pdbg_clk", "cs_at_clk", NULL, 1, 0, 0x24,
>   	  4, 0x44, 28, 1, 0, 0, 0},
> -	{ AGILEX_CS_TIMER_CLK, "cs_timer_clk", "noc_clk", NULL, 1, 0, 0x24,
> -	  5, 0, 0, 0, 0, 0, 0},
> +	{ AGILEX_CS_TIMER_CLK, "cs_timer_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x24,
> +	  5, 0, 0, 0, 0x30, 1, 0},
>   	{ AGILEX_S2F_USER0_CLK, "s2f_user0_clk", NULL, s2f_usr0_mux, ARRAY_SIZE(s2f_usr0_mux), 0, 0x24,
>   	  6, 0, 0, 0, 0, 0, 0},
>   	{ AGILEX_EMAC0_CLK, "emac0_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0x7C,
> diff --git a/drivers/clk/socfpga/clk-s10.c b/drivers/clk/socfpga/clk-s10.c
> index f0bd77138ecb..0199cffe4d77 100644
> --- a/drivers/clk/socfpga/clk-s10.c
> +++ b/drivers/clk/socfpga/clk-s10.c
> @@ -167,7 +167,7 @@ static const struct stratix10_perip_cnt_clock s10_main_perip_cnt_clks[] = {
>   	{ STRATIX10_MPU_FREE_CLK, "mpu_free_clk", NULL, mpu_free_mux, ARRAY_SIZE(mpu_free_mux),
>   	   0, 0x48, 0, 0, 0},
>   	{ STRATIX10_NOC_FREE_CLK, "noc_free_clk", NULL, noc_free_mux, ARRAY_SIZE(noc_free_mux),
> -	  0, 0x4C, 0, 0, 0},
> +	  0, 0x4C, 0, 0x3C, 1},
>   	{ STRATIX10_MAIN_EMACA_CLK, "main_emaca_clk", "main_noc_base_clk", NULL, 1, 0,
>   	  0x50, 0, 0, 0},
>   	{ STRATIX10_MAIN_EMACB_CLK, "main_emacb_clk", "main_noc_base_clk", NULL, 1, 0,
> @@ -200,10 +200,8 @@ static const struct stratix10_perip_cnt_clock s10_main_perip_cnt_clks[] = {
>   	  0, 0xD4, 0, 0, 0},
>   	{ STRATIX10_PERI_PSI_REF_CLK, "peri_psi_ref_clk", "peri_noc_base_clk", NULL, 1, 0,
>   	  0xD8, 0, 0, 0},
> -	{ STRATIX10_L4_SYS_FREE_CLK, "l4_sys_free_clk", "noc_free_clk", NULL, 1, 0,
> -	  0, 4, 0, 0},
> -	{ STRATIX10_NOC_CLK, "noc_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux),
> -	  0, 0, 0, 0x3C, 1},
> +	{ STRATIX10_L4_SYS_FREE_CLK, "l4_sys_free_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0,
> +	  0, 4, 0x3C, 1},
>   	{ STRATIX10_EMAC_A_FREE_CLK, "emaca_free_clk", NULL, emaca_free_mux, ARRAY_SIZE(emaca_free_mux),
>   	  0, 0, 2, 0xB0, 0},
>   	{ STRATIX10_EMAC_B_FREE_CLK, "emacb_free_clk", NULL, emacb_free_mux, ARRAY_SIZE(emacb_free_mux),
> @@ -227,20 +225,20 @@ static const struct stratix10_gate_clock s10_gate_clks[] = {
>   	  0, 0, 0, 0, 0, 0, 4},
>   	{ STRATIX10_MPU_L2RAM_CLK, "mpu_l2ram_clk", "mpu_clk", NULL, 1, 0, 0x30,
>   	  0, 0, 0, 0, 0, 0, 2},
> -	{ STRATIX10_L4_MAIN_CLK, "l4_main_clk", "noc_clk", NULL, 1, 0, 0x30,
> -	  1, 0x70, 0, 2, 0, 0, 0},
> -	{ STRATIX10_L4_MP_CLK, "l4_mp_clk", "noc_clk", NULL, 1, 0, 0x30,
> -	  2, 0x70, 8, 2, 0, 0, 0},
> -	{ STRATIX10_L4_SP_CLK, "l4_sp_clk", "noc_clk", NULL, 1, CLK_IS_CRITICAL, 0x30,
> -	  3, 0x70, 16, 2, 0, 0, 0},
> -	{ STRATIX10_CS_AT_CLK, "cs_at_clk", "noc_clk", NULL, 1, 0, 0x30,
> -	  4, 0x70, 24, 2, 0, 0, 0},
> -	{ STRATIX10_CS_TRACE_CLK, "cs_trace_clk", "noc_clk", NULL, 1, 0, 0x30,
> -	  4, 0x70, 26, 2, 0, 0, 0},
> +	{ STRATIX10_L4_MAIN_CLK, "l4_main_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x30,
> +	  1, 0x70, 0, 2, 0x3C, 1, 0},
> +	{ STRATIX10_L4_MP_CLK, "l4_mp_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x30,
> +	  2, 0x70, 8, 2, 0x3C, 1, 0},
> +	{ STRATIX10_L4_SP_CLK, "l4_sp_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), CLK_IS_CRITICAL, 0x30,
> +	  3, 0x70, 16, 2, 0x3C, 1, 0},
> +	{ STRATIX10_CS_AT_CLK, "cs_at_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x30,
> +	  4, 0x70, 24, 2, 0x3C, 1, 0},
> +	{ STRATIX10_CS_TRACE_CLK, "cs_trace_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x30,
> +	  4, 0x70, 26, 2, 0x3C, 1, 0},
>   	{ STRATIX10_CS_PDBG_CLK, "cs_pdbg_clk", "cs_at_clk", NULL, 1, 0, 0x30,
>   	  4, 0x70, 28, 1, 0, 0, 0},
> -	{ STRATIX10_CS_TIMER_CLK, "cs_timer_clk", "noc_clk", NULL, 1, 0, 0x30,
> -	  5, 0, 0, 0, 0, 0, 0},
> +	{ STRATIX10_CS_TIMER_CLK, "cs_timer_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x30,
> +	  5, 0, 0, 0, 0x3C, 1, 0},
>   	{ STRATIX10_S2F_USER0_CLK, "s2f_user0_clk", NULL, s2f_usr0_mux, ARRAY_SIZE(s2f_usr0_mux), 0, 0x30,
>   	  6, 0, 0, 0, 0, 0, 0},
>   	{ STRATIX10_EMAC0_CLK, "emac0_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0xA4,
> 
