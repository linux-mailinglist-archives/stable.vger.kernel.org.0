Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683AB64F1B2
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 20:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbiLPTXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 14:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiLPTXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 14:23:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13E269AAA;
        Fri, 16 Dec 2022 11:23:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25E4BB81D39;
        Fri, 16 Dec 2022 19:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF656C433F0;
        Fri, 16 Dec 2022 19:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671218618;
        bh=RPZWOujzbVli+s2nnJG3PDWi5GirhZ9Tw3d2IZ7eLoE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QkHJzd0IsYNmHWeuBGtkI1PkTMHrqzI7rRjkeDPHOhL/boNqResRwHT9klKqKVh93
         Glr9LC1z/zR7RayrZg1zUGRhfGZmfjz+/ph+2PxDgSArxEkh1LK90yEpl/yRHmrnBO
         5qspcefNGfp7N/6RvX5Sunzq/tNsAdbgdUJf/8rBd8GtRqL5/om39yjPued8M+lUfn
         zpfx4enWByJBPxUnYscIva+JvVODNiu6e7lMyhHG5Kwq4AAtJOkDKCtOU8BH7zRd+M
         bu9t6FaAW6DN6Vvp+6yXGQjPbXq2nYY9RubBo72rN81uvjFlWKjJQ4MYVp+4uPdA5n
         uM14NnUoVv0VA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1p6GIy-00D998-Kf;
        Fri, 16 Dec 2022 19:23:36 +0000
MIME-Version: 1.0
Date:   Fri, 16 Dec 2022 19:23:36 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [irqchip: irq/irqchip-next] irqchip/ls-extirq: Fix endianness
 detection
In-Reply-To: <3c8c4cf8-9987-31d6-a19c-c18d9f41c7c1@seco.com>
References: <20221201212807.616191-1-sean.anderson@seco.com>
 <167023926482.4906.17012979311813913704.tip-bot2@tip-bot2>
 <8e8bfa5e-f713-4590-95db-66ed6454881b@seco.com>
 <9a7ef68d94e7d0ca879b9f55f7634df5@kernel.org>
 <3c8c4cf8-9987-31d6-a19c-c18d9f41c7c1@seco.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1fd422cf6f379e03949362721ad623f2@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sean.anderson@seco.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, tglx@linutronix.de
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-16 19:11, Sean Anderson wrote:
> On 12/16/22 13:22, Marc Zyngier wrote:
>> On 2022-12-16 16:37, Sean Anderson wrote:
>>> Hi Stable maintainers,
>>> 
>>> On 12/5/22 06:21, irqchip-bot for Sean Anderson wrote:
>>>> The following commit has been merged into the irq/irqchip-next 
>>>> branch of irqchip:
>>>> 
>>>> Commit-ID:     3ae977d0e4e3a2a2ccc912ca2d20c9430508ecdd
>>>> Gitweb:        
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/3ae977d0e4e3a2a2ccc912ca2d20c9430508ecdd
>>>> Author:        Sean Anderson <sean.anderson@seco.com>
>>>> AuthorDate:    Thu, 01 Dec 2022 16:28:07 -05:00
>>>> Committer:     Marc Zyngier <maz@kernel.org>
>>>> CommitterDate: Mon, 05 Dec 2022 10:39:52
>>>> 
>>>> irqchip/ls-extirq: Fix endianness detection
>>>> 
>>>> parent is the interrupt parent, not the parent of node. Use
>>>> node->parent. This fixes endianness detection on big-endian 
>>>> platforms.
>>>> 
>>>> Fixes: 1b00adce8afd ("irqchip/ls-extirq: Fix invalid wait context by 
>>>> avoiding to use regmap")
>>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>> Link: 
>>>> https://lore.kernel.org/r/20221201212807.616191-1-sean.anderson@seco.com
>>>> ---
>>>>  drivers/irqchip/irq-ls-extirq.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>> 
>>>> diff --git a/drivers/irqchip/irq-ls-extirq.c 
>>>> b/drivers/irqchip/irq-ls-extirq.c
>>>> index d8d48b1..139f26b 100644
>>>> --- a/drivers/irqchip/irq-ls-extirq.c
>>>> +++ b/drivers/irqchip/irq-ls-extirq.c
>>>> @@ -203,7 +203,7 @@ ls_extirq_of_init(struct device_node *node, 
>>>> struct device_node *parent)
>>>>         if (ret)
>>>>                 goto err_parse_map;
>>>> 
>>>> -       priv->big_endian = of_device_is_big_endian(parent);
>>>> +       priv->big_endian = of_device_is_big_endian(node->parent);
>>>>         priv->is_ls1021a_or_ls1043a = of_device_is_compatible(node, 
>>>> "fsl,ls1021a-extirq") ||
>>>>                                       of_device_is_compatible(node, 
>>>> "fsl,ls1043a-extirq");
>>>>         raw_spin_lock_init(&priv->lock);
>>> 
>>> This patch has made it into linux/master, but it should also get
>>> backported to 6.1. Just want to make sure this doesn't fall through 
>>> the
>>> cracks, since this was a really annoying bug to deal with (causes an 
>>> IRQ
>>> storm).
>> 
>> If you wanted it backported, why didn't it have a Cc: stable
>> the first place? In any case, if you want a backport to happen,
>> you'll have to post that backport.
> 
> Usually, anything with a Fixes: tag gets picked up.

And I actively object to this for the subsystems I maintain,
so no, this isn't automatic.

> Actually, I was
> expecting you to submit a PR for 6.1, since this was submitted before
> that release came out.

Expectations are better stated rather than being implicit.

> That said, this email is "option 2" of
> Documentation/process/stable-kernel-rules.rst, so I don't think I need
> to do "option 3".

Here's to hope!

         M.
-- 
Jazz is not dead. It just smells funny...
