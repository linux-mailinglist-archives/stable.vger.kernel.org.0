Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506D76D2156
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 15:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjCaNRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 09:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjCaNRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 09:17:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415091A47B;
        Fri, 31 Mar 2023 06:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC3BBB82DC1;
        Fri, 31 Mar 2023 13:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E771C433EF;
        Fri, 31 Mar 2023 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680268628;
        bh=GzcVFio4AKLjf3M2ehf5Onz2XStfPLZyBXJzNjDKbCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n1dTHJSMtP+h8o9JZ5ceaqLuJq8JJu4FOd8y7ZsWjRgJd2/b/Zzav6DSejtYk/c2k
         QG4KRYBoP97Dmbed7Q0od/I7oreKHUNVFaYc6IMYiCueDxMeu8F/gKsx1P6TKiWy9Z
         /QonQCe1RgF64HyKh5BI3Pbk6W5f4zI/IfVoFH3U=
Date:   Fri, 31 Mar 2023 15:17:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jianmin Lv <lvjianmin@loongson.cn>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        loongson-kernel@lists.loongnix.cn, stable@vger.kernel.org
Subject: Re: [PATCH V2 1/5] irqchip/loongson-eiointc: Fix returned value on
 parsing MADT
Message-ID: <ZCbdUbVhH7lmh3PI@kroah.com>
References: <20230331113900.9105-1-lvjianmin@loongson.cn>
 <20230331113900.9105-2-lvjianmin@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331113900.9105-2-lvjianmin@loongson.cn>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 31, 2023 at 07:38:56PM +0800, Jianmin Lv wrote:
> In pch_pic_parse_madt(), a NULL parent pointer will be
> returned from acpi_get_vec_parent() for second pch-pic domain
> related to second bridge while calling eiointc_acpi_init() at
> first time, where the parent of it has not been initialized
> yet, and will be initialized during second time calling
> eiointc_acpi_init(). So, it's reasonable to return zero so
> that failure of acpi_table_parse_madt() will be avoided, or else
> acpi_cascade_irqdomain_init() will return and initialization of
> followed pch_msi domain will be skipped.
> 
> Although it does not matter when pch_msi_parse_madt() returns
> -EINVAL if no invalid parent is found, it's also reasonable to
> return zero for that.
> 
> Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
> ---
>  drivers/irqchip/irq-loongson-eiointc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
