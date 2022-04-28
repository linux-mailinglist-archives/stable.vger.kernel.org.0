Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC494512B9C
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 08:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243860AbiD1GgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 02:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiD1GgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 02:36:14 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0961821E0F
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 23:32:59 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23S6Wdqn115702;
        Thu, 28 Apr 2022 01:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1651127559;
        bh=AuCn46SOHizXCif9euMaGC+fc3ayXPHXv/N04x/Z+Lg=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=hOAufCDdTKPVxcbQVRLW3ejTQaZTPsrKUNLeOUGgmxstevT/karR5A4Re31oiJvW+
         RWUn36VBBjPJFcamRkqAQYMHgarPBcmgz0svSXW6TN0cCXBL2JL9LH+ZskzF6HLoZB
         ClKyeFtSQeOVm4b4oasc0i9QBS1Xt2OamzFW8Rxg=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23S6WdPo049938
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 28 Apr 2022 01:32:39 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 28
 Apr 2022 01:32:39 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 28 Apr 2022 01:32:39 -0500
Received: from [172.24.145.176] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23S6Wa6s010886;
        Thu, 28 Apr 2022 01:32:37 -0500
Message-ID: <b1f196f2-04ec-fa3c-557f-85ec9e6472f3@ti.com>
Date:   Thu, 28 Apr 2022 12:02:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v7 0/4] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
CC:     Tokunori Ikegami <ikegami.t@gmail.com>, <richard@nod.at>,
        <linux-mtd@lists.infradead.org>, <stable@vger.kernel.org>
References: <20220323170458.5608-1-ikegami.t@gmail.com>
 <6b09d10e-2098-9fb7-be4c-ae67d802cd2d@leemhuis.info>
 <20220411094047.06556ee1@xps13> <20220427113709.01f460c8@xps13>
From:   Vignesh Raghavendra <vigneshr@ti.com>
In-Reply-To: <20220427113709.01f460c8@xps13>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 27/04/22 15:07, Miquel Raynal wrote:
> Hi Vignesh,
> 
> miquel.raynal@bootlin.com wrote on Mon, 11 Apr 2022 09:40:47 +0200:
> 
>> Hello,
>>
>> regressions@leemhuis.info wrote on Sun, 10 Apr 2022 10:51:17 +0200:
>>
>>> Hi, this is your Linux kernel regression tracker. Top-posting for once,
>>> to make this easily accessible to everyone.
>>>
>>> Miquel, Richard, Vignesh: what's up here? This patchset fixes a
>>> regression. It's quite old, so it's not that urgent, but it looked like
>>> nothing happened for two and a half week now. Or was progress made
>>> somewhere?  
>>
>> Vignesh, I'm waiting for your review/ack ;)
> 

Sorry for the delay, I was able to test this series and to see no
regression on CFI an HyperFlashes that I have access to

I think series is in good shape now.

So

Acked-by: Vignesh Raghavendra <vigneshr@ti.com>


[...]
