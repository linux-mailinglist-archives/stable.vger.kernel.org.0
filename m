Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59F76D2C7D
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjDABgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjDABgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:36:24 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 001501C1FE;
        Fri, 31 Mar 2023 18:36:21 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.153])
        by gateway (Coremail) with SMTP id _____8DxEzSUiidkhh4VAA--.32573S3;
        Sat, 01 Apr 2023 09:36:20 +0800 (CST)
Received: from [10.20.42.153] (unknown [10.20.42.153])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxLL6SiidkP30SAA--.15525S3;
        Sat, 01 Apr 2023 09:36:18 +0800 (CST)
Subject: Re: [PATCH V2 1/5] irqchip/loongson-eiointc: Fix returned value on
 parsing MADT
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        loongson-kernel@lists.loongnix.cn, stable@vger.kernel.org
References: <20230331113900.9105-1-lvjianmin@loongson.cn>
 <20230331113900.9105-2-lvjianmin@loongson.cn> <ZCbdUbVhH7lmh3PI@kroah.com>
From:   Jianmin Lv <lvjianmin@loongson.cn>
Message-ID: <f00383ba-6f2a-3111-9a55-c412f9a50e7f@loongson.cn>
Date:   Sat, 1 Apr 2023 09:36:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ZCbdUbVhH7lmh3PI@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxLL6SiidkP30SAA--.15525S3
X-CM-SenderInfo: 5oymxthqpl0qxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7tFWUCF1DZr47urW5Xry3CFg_yoW8JF4fpa
        y7X398tr4Yy34fCw4ftw1rXFyrXa93Ca4ftr45WwsYkr1DurnrW3WIvw4I9F93CFW3Ka12
        vF4aqan5Aw45A3DanT9S1TB71UUUUj7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bDkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwA2z4
        x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8JVW8Jr1ln4kS
        14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
        1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
        67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
        AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE
        7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I
        0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAI
        cVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcV
        CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8h0ePUUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ok, thanks, got it.

On 2023/3/31 下午9:17, Greg KH wrote:
> On Fri, Mar 31, 2023 at 07:38:56PM +0800, Jianmin Lv wrote:
>> In pch_pic_parse_madt(), a NULL parent pointer will be
>> returned from acpi_get_vec_parent() for second pch-pic domain
>> related to second bridge while calling eiointc_acpi_init() at
>> first time, where the parent of it has not been initialized
>> yet, and will be initialized during second time calling
>> eiointc_acpi_init(). So, it's reasonable to return zero so
>> that failure of acpi_table_parse_madt() will be avoided, or else
>> acpi_cascade_irqdomain_init() will return and initialization of
>> followed pch_msi domain will be skipped.
>>
>> Although it does not matter when pch_msi_parse_madt() returns
>> -EINVAL if no invalid parent is found, it's also reasonable to
>> return zero for that.
>>
>> Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
>> ---
>>   drivers/irqchip/irq-loongson-eiointc.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
> 

