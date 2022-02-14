Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F7B4B4571
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbiBNJSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:18:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiBNJSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:18:10 -0500
X-Greylist: delayed 308 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Feb 2022 01:18:03 PST
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F098606D7;
        Mon, 14 Feb 2022 01:18:03 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4Jxz5Z129sz1sr4Y;
        Mon, 14 Feb 2022 10:12:50 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4Jxz5Y6ThLz1qqkD;
        Mon, 14 Feb 2022 10:12:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id pdJ6wzpt_XJf; Mon, 14 Feb 2022 10:12:48 +0100 (CET)
X-Auth-Info: i81bJA8adEdhuMnwODt1w9ZYPCIJmRzN5xVOLlFPDwvVOgLBggv7jog9GhkXrxg2
Received: from igel.home (ppp-46-244-178-131.dynamic.mnet-online.de [46.244.178.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 14 Feb 2022 10:12:48 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id 375862C39FF; Mon, 14 Feb 2022 10:12:48 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Sunil V L <sunilvl@ventanamicro.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Anup Patel <apatel@ventanamicro.com>, stable@vger.kernel.org
Subject: Re: [PATCH] riscv/efi_stub: Fix get_boot_hartid_from_fdt() return
 value
References: <20220128045004.4843-1-sunilvl@ventanamicro.com>
X-Yow:  .. If I cover this entire WALL with MAZOLA, who I have to give my
 AGENT ten per cent??
Date:   Mon, 14 Feb 2022 10:12:48 +0100
In-Reply-To: <20220128045004.4843-1-sunilvl@ventanamicro.com> (Sunil V. L.'s
        message of "Fri, 28 Jan 2022 10:20:04 +0530")
Message-ID: <877d9xx14f.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Jan 28 2022, Sunil V L wrote:

> diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
> index 380e4e251399..9c460843442f 100644
> --- a/drivers/firmware/efi/libstub/riscv-stub.c
> +++ b/drivers/firmware/efi/libstub/riscv-stub.c
> @@ -25,7 +25,7 @@ typedef void __noreturn (*jump_kernel_func)(unsigned int, unsigned long);
>  
>  static u32 hartid;
>  
> -static u32 get_boot_hartid_from_fdt(void)
> +static int get_boot_hartid_from_fdt(void)

I think the function should be renamed, now that it no longer returns
the hart ID, but initializes a static variable as a side effect.  Thus
it no longer "gets", but "sets".

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
