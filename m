Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E590B6CF95D
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 04:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjC3C7v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 Mar 2023 22:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjC3C7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 22:59:50 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903A92111;
        Wed, 29 Mar 2023 19:59:49 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id j13so15994286pjd.1;
        Wed, 29 Mar 2023 19:59:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680145189;
        h=content-transfer-encoding:fcc:content-language:user-agent
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MyiOuYElhRICJI3D0PJA148VTpJc2bGE9WKOTKleOq8=;
        b=OVqtWI41LKNKz5FSVNstBD0IxoM8cwcpLYVlO7Bhz68z8pcEMnPDcw7GliVSMQLuEl
         fCx5DHrJ60wVpW0G9OBMsxfCqugg36JbRwy79SUwN+3wDh8WGWRruUF/eYAS+wS4IP/B
         L3T+yvDuxn8HtAbP10u5UUzWPl5oUNE/F9UNxV5pjHxJ0/qGBQjLv2ay+yLkNpP6ARxc
         fBk8DWS2eP1X92+2bxpQJTolo752L9N7yNEM74Y4XXY/U17LG00W/VKwvVPVzgMjNvOY
         2DmskcVMepXyrNSzd9V1kNGS9RM7AMRbHUvfpLZmDXQIkzH6nokIv5vm++8yLMg1x91u
         GARg==
X-Gm-Message-State: AAQBX9fygfhJdCquhYFZ6RFB2iPk3IoopDpzJCF9k31vOCnlkTfbNQ65
        xoF7gmSk4unCXoMl+XRmFgw3MMv+0oVGjg==
X-Google-Smtp-Source: AKy350boGkhs/gbvGNKtpPaSEc4HaVUwU+oVgIsS+OdhxK/JAla3ArdI9wUsFz4DT4mMXrbnRKTqyg==
X-Received: by 2002:a17:90a:190f:b0:237:50b6:9838 with SMTP id 15-20020a17090a190f00b0023750b69838mr25440663pjg.45.1680145188929;
        Wed, 29 Mar 2023 19:59:48 -0700 (PDT)
Received: from localhost ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id g4-20020a655804000000b0050bd71ed66fsm2014953pgr.92.2023.03.29.19.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 19:59:48 -0700 (PDT)
From:   Hongyu Xie <xiehongyu1@kylinos.cn>
To:     mathias.nyman@linux.intel.com, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, sunke <sunke@kylinos.cn>,
        Hongyu Xie <xiehongyu1@kylinos.cn>
Subject: Re: [PATCH -next v2] usb: xhci: do not free an empty cmd ring
Date:   Thu, 30 Mar 2023 10:58:57 +0800
Message-Id: <eff504ed-d5b0-171a-8eb8-f073f2ee9271@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <086a7af9-0a33-1a37-2bf3-1338adf96b12@linux.intel.com>
References: <20230327011117.33953-1-xiehongyu1@kylinos.cn> <086a7af9-0a33-1a37-2bf3-1338adf96b12@linux.intel.com>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Thunderbird/102.8.0
Content-Language: en-US
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; DSN=0; uuencode=0; attachmentreminder=0; deliveryformat=1
X-Identity-Key: id1
Fcc:    imap://xiehongyu1%40kylinos.cn@imap.kylinos.cn/Sent
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

在 2023/3/27 22:58, Mathias Nyman 写道:
> On 27.3.2023 4.11, Hongyu Xie wrote:
>> It was first found on HUAWEI Kirin 9006C platform with a builtin xhci
>> controller during stress cycle test(stress-ng, glmark2, x11perf, S4...).
>>
>> phase one:
>> [26788.706878] PM: dpm_run_callback(): platform_pm_thaw+0x0/0x68 returns -12
>> [26788.706878] PM: Device xhci-hcd.1.auto failed to thaw async: error -12
>> ...
>> phase two:
>> [28650.583496] [2023:01:19 04:43:29]Unable to handle kernel NULL pointer dereference at virtual address 0000000000000028
>> ...
>> [28650.583526] user pgtable: 4k pages, 39-bit VAs, pgdp=000000027862a000
>> [28650.583557] [0000000000000028] pgd=0000000000000000
>> ...
>> [28650.583587] pc : xhci_suspend+0x154/0x5b0
>> [28650.583618] lr : xhci_suspend+0x148/0x5b0
>> [28650.583618] sp : ffffffc01c7ebbd0
>> [28650.583618] x29: ffffffc01c7ebbd0 x28: ffffffec834d0000
>> [28650.583618] x27: ffffffc0106a3cc8 x26: ffffffb2c540c848
>> [28650.583618] x25: 0000000000000000 x24: ffffffec82ee30b0
>> [28650.583618] x23: ffffffb43b31c2f8 x22: 0000000000000000
>> [28650.583618] x21: 0000000000000000 x20: ffffffb43b31c000
>> [28650.583648] x19: ffffffb43b31c2a8 x18: 0000000000000001
>> [28650.583648] x17: 0000000000000803 x16: 00000000fffffffe
>> [28650.583648] x15: 0000000000001000 x14: ffffffb150b67e00
>> [28650.583648] x13: 00000000f0000000 x12: 0000000000000001
>> [28650.583648] x11: 0000000000000000 x10: 0000000000000a80
>> [28650.583648] x9 : ffffffc01c7eba00 x8 : ffffffb43ad10ae0
>> [28650.583648] x7 : ffffffb84cd98dc0 x6 : 0000000cceb6a101
>> [28650.583679] x5 : 00ffffffffffffff x4 : 0000000000000001
>> [28650.583679] x3 : 0000000000000011 x2 : 0000000000e2cfa8
>> [28650.583679] x1 : 00000000823535e1 x0 : 0000000000000000
>>
>> gdb:
>> (gdb) l *(xhci_suspend+0x154)
>> 0xffffffc010b6cd44 is in xhci_suspend (/.../drivers/usb/host/xhci.c:854).
>> 849	{
>> 850		struct xhci_ring *ring;
>> 851		struct xhci_segment *seg;
>> 852
>> 853		ring = xhci->cmd_ring;
>> 854		seg = ring->deq_seg;
>> (gdb) disassemble 0xffffffc010b6cd44
>> ...
>> 0xffffffc010b6cd40 <+336>:	ldr	x22, [x19, #160]
>> 0xffffffc010b6cd44 <+340>:	ldr	x20, [x22, #40]
>> 0xffffffc010b6cd48 <+344>:	mov	w1, #0x0                   	// #0
>>
>> During phase one, platform_pm_thaw called xhci_plat_resume which called
>> xhci_resume. The rest possible calling routine might be
>> xhci_resume->xhci_init->xhci_mem_init, and xhci->cmd_ring was cleaned in
>> xhci_mem_cleanup before xhci_mem_init returned -ENOMEM.
>>
>> During phase two, systemd was tring to hibernate again and called
>> xhci_suspend, then xhci_clear_command_ring dereferenced xhci->cmd_ring
>> which was already NULL.
>>
> 
> Any comments on the questions I had on the first version of the patch?
Sorry, didn't notice your reply in the first version.
> 
> xhci_mem_init() failing with -ENOMEM looks like the real problem here.
> 
> Are we really running out of memory? does kmemleak say anything?
It looks like running out of memory, since it was running a stress test. 
But can't go any further without more details. Didn't run with kmemleak 
open.
> Any chance you could look into where exactly xhci_mem_init() fails as
> xhci_mem_init() always returns -ENOMEM on failure?
Can't reproduce the problem for a very long time. Still don't know where 
did it fail in xhci_mem_init. But I think you can't blame xhci driver 
for memory shortage, and you can't fix that.
> 
>> So if xhci->cmd_ring is NULL, xhci_clear_command_ring just return.
> 
> This hides the problem more than solves it. Root cause is still unknown
You were saying "If xhci_mem_init() failed then...it shouldn't be...", 
and I agree with it. Further more, I think functions that calling 
xhci_mem_init needs to check xhci_mem_init's return value, but it needs 
another patch to do this. This patch is saying that 
xhci_clear_command_ring should check a pointer before using it, because 
somewhere else might clear cmd_ring, that's all.
> 
> Thanks
> Mathias
> 
> 
Thanks

Hongyu Xie
