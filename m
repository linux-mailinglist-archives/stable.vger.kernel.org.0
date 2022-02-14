Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3A24B4715
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244346AbiBNJhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244265AbiBNJft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:35:49 -0500
X-Greylist: delayed 1234 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Feb 2022 01:33:27 PST
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A17654AD;
        Mon, 14 Feb 2022 01:33:27 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4JxzYC2nmmz1sb42;
        Mon, 14 Feb 2022 10:33:19 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4JxzYC1Pw7z1qqkB;
        Mon, 14 Feb 2022 10:33:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 4A6rFkojWdYt; Mon, 14 Feb 2022 10:33:13 +0100 (CET)
X-Auth-Info: 3pXtXEblWigUp5dC0ALx0wnK0waqMMj3wTwQrNh+E7nq00Dn+vM/9Ec1zbIoMOOV
Received: from igel.home (ppp-46-244-178-131.dynamic.mnet-online.de [46.244.178.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 14 Feb 2022 10:33:13 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id 07A512C39FF; Mon, 14 Feb 2022 10:33:13 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>, stable@vger.kernel.org,
        Sunil V L <sunilvl@ventanamicro.com>
Subject: Re: [PATCH] riscv/efi_stub: Fix get_boot_hartid_from_fdt() return
 value
References: <20220128045004.4843-1-sunilvl@ventanamicro.com>
        <877d9xx14f.fsf@igel.home>
        <9cd9f149-d2ea-eb55-b774-8d817b9b6cc9@gmx.de>
X-Yow:  LOU GRANT froze my ASSETS!!
Date:   Mon, 14 Feb 2022 10:33:12 +0100
In-Reply-To: <9cd9f149-d2ea-eb55-b774-8d817b9b6cc9@gmx.de> (Heinrich
        Schuchardt's message of "Mon, 14 Feb 2022 10:24:22 +0100")
Message-ID: <87y22dvllz.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Feb 14 2022, Heinrich Schuchardt wrote:

> On 2/14/22 10:12, Andreas Schwab wrote:
>> On Jan 28 2022, Sunil V L wrote:
>>
>>> diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
>>> index 380e4e251399..9c460843442f 100644
>>> --- a/drivers/firmware/efi/libstub/riscv-stub.c
>>> +++ b/drivers/firmware/efi/libstub/riscv-stub.c
>>> @@ -25,7 +25,7 @@ typedef void __noreturn (*jump_kernel_func)(unsigned int, unsigned long);
>>>
>>>   static u32 hartid;
>>>
>>> -static u32 get_boot_hartid_from_fdt(void)
>>> +static int get_boot_hartid_from_fdt(void)
>>
>> I think the function should be renamed, now that it no longer returns
>> the hart ID, but initializes a static variable as a side effect.  Thus
>> it no longer "gets", but "sets".
>>
>
> set_boot_hartid() implies that the caller can change the boot hart ID.
> As this is not a case this name obviously would be a misnomer.

Then I guess a different, more fitting name needs to be found.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
