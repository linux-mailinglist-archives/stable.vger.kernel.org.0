Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E77E4B459A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiBNJZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:25:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbiBNJZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:25:05 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAEE60A89;
        Mon, 14 Feb 2022 01:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644830679;
        bh=bPwqzMydBgKUCCPAcnpWEevOwrjSEKacihSgwMc0jc4=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=iostq3mEM/MOJNzagGc2y1i3Y05rII7z/NhlaQiyUbyXunuVAbarmNO/rWdo9xJIG
         Vdh5Ow8y1U5FZNOdkaBid272QPDu/tzE6mcnrrSE++hoHwixxHA08Uytf0DAqdq/np
         WOpyi2gw7rg+RBCA7ZXGPairX8MzSBabv/qkfsF0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.123.55] ([88.152.144.107]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MIdif-1nY7vO2GKj-00Edn1; Mon, 14
 Feb 2022 10:24:39 +0100
Message-ID: <9cd9f149-d2ea-eb55-b774-8d817b9b6cc9@gmx.de>
Date:   Mon, 14 Feb 2022 10:24:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] riscv/efi_stub: Fix get_boot_hartid_from_fdt() return
 value
Content-Language: en-US
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>, stable@vger.kernel.org,
        Sunil V L <sunilvl@ventanamicro.com>
References: <20220128045004.4843-1-sunilvl@ventanamicro.com>
 <877d9xx14f.fsf@igel.home>
From:   Heinrich Schuchardt <xypron.glpk@gmx.de>
In-Reply-To: <877d9xx14f.fsf@igel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Au/e3vMlDZkTXGdYorj9+mhhI0kX2Yew6mxWnv2QGwXtTeAfS/B
 GC0CYZsekBZfnzXD4vQVL/bx8xJHpAaGKrFLun/Ih7miykJsovZHN4EABrb6DE/aB82u+CT
 k5c1fbeV8pG17cyAa13L6Z8lVVvBfrq/uV8UwY2JaLXw2tPkV05PLZhFL6PL5/XCgt2mzv1
 QptnAnKEGT+5Wc5+r0pyA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2xdUZkLP5D8=:FOcUVX4+xapxGqnhuR0t5M
 6FjdiVIZ4HOFCmWD7niXzb2QMPmbL5iWiX/XLvvHmuAKoQ21tsqVKJGLichsdaKOjHNjAkrTF
 An37zog0g1a5ZsXqmQpszkOgIpbdUMjsB8RhA3H6PfjxjJqiCuSCHpRuEQHn2lRUZJzWk6qAI
 iLZurQ/PEpqBL5lDwmr14XOmLjXK0xrMeu+Q1IVT8gABOdZNx9S8UT/soc7K3YquXvHbJNFjg
 E8dNS24EEiPvPFGakMihSYE2V48uAKYYApxh+hqTze3kr/LY1nHHBeE4O1+dctXhF+eOp+/nn
 Socw+JcuHf0c7mPCjtc/FKpekkTFRkbbo7L2CCl1UhBX03c4GkdDYmSuUY/f5pWZV4C2QJcQe
 y18FpIOAgTdacaWI7tGuq37kffw8eqwFFSLjHrJOlhUb1Nmdku/DIkVnwmgwQB/x5Y5MEjAjR
 wog4U8Ypt9h50VOKDJTa2tV1pGlqTHZoenPX5khDmG+XG8lb0H633AO9VZ5sUZnH4R9Xh0rS2
 zVO71lzwAJ4WH3zVMN9ksZQzZh0JQkDsppnlPT3GjqQiJXclup+9FigJZatTWZVWKTZ1v1HN6
 C6X355YcfqlYN4hx3qURb85suzcQtMNMOPrqGoZgml4d+PuWg4RpjTCRz5HoIfGXQjqrLC/uG
 /U8OglNbddKjyBuQT4mgX4Gvuaie99pGrxBa68PSHmIMEoo6vfwCHv7Wq2MBflYGAYqF4X9c8
 lgmgbaLfCcW+8hg0SufRgXgG+4N5vZMT2/smamEJRbdaW5qsrvXTaDyEbizDtj6tUiQecgGX6
 WxeiesARhS9k8k0rPt//zIR/Ods6qL111AzecSoNzuu0JpMOy2cfsYinb/ElE0ehIDiV3Bq86
 0VlREP/0vmEG7FlVYi1/xTiD6qoGsRUY/8xP7GMPzocmQI9gyxiwz1dwqOyPMFZLOi8H14moq
 YRsoYoRwlnvad55b5zoADbj694to8+24iVs/JWY7lommLPg6fogVgoGk7v3Fs631qyW9kboe0
 2UHKqP4mtqsKepGO/XjMBlOoKewGj+fYySTjde+bMKWZfGAuPIZ5ljSpiKmVCDfa20uokMbQQ
 JNVEpb4tJlugaM=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 10:12, Andreas Schwab wrote:
> On Jan 28 2022, Sunil V L wrote:
>
>> diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmwa=
re/efi/libstub/riscv-stub.c
>> index 380e4e251399..9c460843442f 100644
>> --- a/drivers/firmware/efi/libstub/riscv-stub.c
>> +++ b/drivers/firmware/efi/libstub/riscv-stub.c
>> @@ -25,7 +25,7 @@ typedef void __noreturn (*jump_kernel_func)(unsigned =
int, unsigned long);
>>
>>   static u32 hartid;
>>
>> -static u32 get_boot_hartid_from_fdt(void)
>> +static int get_boot_hartid_from_fdt(void)
>
> I think the function should be renamed, now that it no longer returns
> the hart ID, but initializes a static variable as a side effect.  Thus
> it no longer "gets", but "sets".
>

set_boot_hartid() implies that the caller can change the boot hart ID.
As this is not a case this name obviously would be a misnomer.

Best regards

Heinrich
