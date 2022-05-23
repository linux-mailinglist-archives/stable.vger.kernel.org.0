Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97AC53131E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbiEWOvr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 23 May 2022 10:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbiEWOvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 10:51:45 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B413211A2F
        for <stable@vger.kernel.org>; Mon, 23 May 2022 07:51:44 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-32-eDnsE147PLCRz1ef_auwew-1; Mon, 23 May 2022 15:51:41 +0100
X-MC-Unique: eDnsE147PLCRz1ef_auwew-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 23 May 2022 15:51:41 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 23 May 2022 15:51:41 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Petr Malat' <oss@malat.biz>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC:     Joern Engel <joern@lazybastard.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] mtd: phram: Map RAM using memremap instead of ioremap
Thread-Topic: [PATCH] mtd: phram: Map RAM using memremap instead of ioremap
Thread-Index: AQHYbrHUf5tSa7gm6kqFegI33HIF660si3RA
Date:   Mon, 23 May 2022 14:51:41 +0000
Message-ID: <3cab9a7f4ed34ca0b742a62c2bdc3bce@AcuMS.aculab.com>
References: <20220523142825.3144904-1-oss@malat.biz>
In-Reply-To: <20220523142825.3144904-1-oss@malat.biz>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Malat
> Sent: 23 May 2022 15:28
> 
> One can't use memcpy on memory obtained by ioremap, because IO memory
> may have different alignment and size access restriction than the system
> memory. Use memremap as phram driver operates on RAM.

Does that actually help?
The memcpy() is still likely to issue unaligned accesses
that the hardware can't handle.

	David


> 
> This fixes an unaligned access on ARM64, which could be triggered with
> e.g. dd if=/dev/phram/by-name/testdev bs=8190 count=1
> 
>    Unable to handle kernel paging request at virtual address ffffffc01208bfbf
>    Mem abort info:
>      ESR = 0x96000021
>      EC = 0x25: DABT (current EL), IL = 32 bits
>      SET = 0, FnV = 0
>      EA = 0, S1PTW = 0
>    Data abort info:
>      ISV = 0, ISS = 0x00000021
>      CM = 0, WnR = 0
>    swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000000cd5000
>    [ffffffc01208bfbf] pgd=00000002fffff003, p4d=00000002fffff003, pud=00000002fffff003,
> pmd=0000000100b43003, pte=0068000022221717
>    Internal error: Oops: 96000021 [#1] PREEMPT SMP
>    CPU: 2 PID: 14768 Comm: dd Tainted: G           O      5.10.116-f13ddced70 #1
>    Hardware name: AXM56xx Victoria (DT)
>    pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
>    pc : __memcpy+0x168/0x230
>    lr : phram_read+0x68/0xb0 [phram]
>    sp : ffffffc0138f3bd0
>    x29: ffffffc0138f3bd0 x28: 0000000034a50090
>    x27: 0000000000000000 x26: ffffff81176ce000
>    x25: 0000000000000000 x24: 0000000000000000
>    x23: ffffffc0138f3cb8 x22: ffffff8109475000
>    x21: 0000000000000000 x20: ffffff81176ce000
>    x19: 0000000000001fff x18: 0000000000000020
>    x17: 0000000000000000 x16: 0000000000000000
>    x15: ffffff8125861410 x14: 0000000000000000
>    x13: 0000000000000000 x12: 0000000000000000
>    x11: 0000000000000000 x10: 0000000000000000
>    x9 : 0000000000000000 x8 : 0000000000000000
>    x7 : 0000000000000000 x6 : 0000000000000000
>    x5 : ffffff81176cffff x4 : ffffffc01208bfff
>    x3 : ffffff81176cff80 x2 : ffffffffffffffef
>    x1 : ffffffc01208bfc0 x0 : ffffff81176ce000
>    Call trace:
>     __memcpy+0x168/0x230
>     mtd_read_oob_std+0x80/0x90
>     mtd_read_oob+0x8c/0x150
>     mtd_read+0x54/0x80
>     mtdchar_read+0xdc/0x2c0
>     vfs_read+0xb8/0x1e4
>     ksys_read+0x78/0x10c
>     __arm64_sys_read+0x28/0x34
>     do_el0_svc+0x94/0x1f0
>     el0_svc+0x20/0x30
>     el0_sync_handler+0x1a4/0x1c0
>     el0_sync+0x180/0x1c0
>    Code: a984346c a9c4342c f1010042 54fffee8 (a97c3c8e)
>    ---[ end trace 5707221d643416b6 ]---
> 
> Signed-off-by: Petr Malat <oss@malat.biz>
> ---
>  drivers/mtd/devices/phram.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
> index d503821a3e60..25d3674b4e51 100644
> --- a/drivers/mtd/devices/phram.c
> +++ b/drivers/mtd/devices/phram.c
> @@ -83,7 +83,7 @@ static void unregister_devices(void)
> 
>  	list_for_each_entry_safe(this, safe, &phram_list, list) {
>  		mtd_device_unregister(&this->mtd);
> -		iounmap(this->mtd.priv);
> +		memunmap(this->mtd.priv);
>  		kfree(this->mtd.name);
>  		kfree(this);
>  	}
> @@ -99,9 +99,9 @@ static int register_device(char *name, phys_addr_t start, size_t len, uint32_t e
>  		goto out0;
> 
>  	ret = -EIO;
> -	new->mtd.priv = ioremap(start, len);
> +	new->mtd.priv = memremap(start, len, MEMREMAP_WB);
>  	if (!new->mtd.priv) {
> -		pr_err("ioremap failed\n");
> +		pr_err("memremap failed\n");
>  		goto out1;
>  	}
> 
> @@ -129,7 +129,7 @@ static int register_device(char *name, phys_addr_t start, size_t len, uint32_t e
>  	return 0;
> 
>  out2:
> -	iounmap(new->mtd.priv);
> +	memunmap(new->mtd.priv);
>  out1:
>  	kfree(new);
>  out0:
> --
> 2.30.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

