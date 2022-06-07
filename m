Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2A353FCDF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 13:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbiFGLGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 07:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242422AbiFGLGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 07:06:21 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D4D1409D
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 04:02:31 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nyWyc-0005Ut-Nb; Tue, 07 Jun 2022 13:02:22 +0200
Message-ID: <789eb485-067c-88fa-e687-4201b37b5dc3@leemhuis.info>
Date:   Tue, 7 Jun 2022 13:02:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Jocelyn Falempe <jfalempe@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, kuohsiang_chou@aspeedtech.com,
        David Airlie <airlied@redhat.com>
Cc:     regressions@lists.linux.dev, stable@vger.kernel.org
References: <d84ba981-d907-f942-6b05-67c836580542@redhat.com>
 <6e9f84f9-dc97-9ff4-57c8-97fbffd3a996@suse.de>
 <66419e2f-8a68-0e0c-334b-96b211a96e50@redhat.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [REGRESSION] VGA output with AST 2600 graphics.
In-Reply-To: <66419e2f-8a68-0e0c-334b-96b211a96e50@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1654599755;ae6f340a;
X-HE-SMSGID: 1nyWyc-0005Ut-Nb
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 01.06.22 14:29, Jocelyn Falempe wrote:
> On 01/06/2022 12:33, Thomas Zimmermann wrote:
>> Am 01.06.22 um 11:33 schrieb Jocelyn Falempe:
>>>
>>> I've found a regression in the ast driver, for AST2600 hardware.
>>>
>>> before the upstream commit f9bd00e0ea9d
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=f9bd00e0ea9d9b04140aa969a9a13ad3597a1e4e
>>>
>>>
>>> The ast driver handled AST 2600 chip like an AST 2500.
>>>
>>> After this commit, it uses some default values, more like the older
>>> AST chip.
>>>
>>> There are a lot of places in the driver like this:
>>> https://elixir.bootlin.com/linux/v5.18.1/source/drivers/gpu/drm/ast/ast_post.c#L82
>>>
>>> where it checks for (AST2300 || AST2400 || AST2500) but not for AST2600.
>>>
>>> This makes the VGA output, to be blurred and flickered with whites
>>> lines on AST2600.
>>>
>>> The issue is present since v5.11
>>>
>>> For v5.11~v5.17 I propose a simple workaround (as there are no other
>>> reference to AST2600 in the driver):
>>> --- a/drivers/gpu/drm/ast/ast_main.c
>>> +++ b/drivers/gpu/drm/ast/ast_main.c
>>> @@ -146,7 +146,8 @@ static int ast_detect_chip(struct drm_device
>>> *dev, bool *need_post)
>>>
>>>       /* Identify chipset */
>>>       if (pdev->revision >= 0x50) {
>>> -        ast->chip = AST2600;
>>> +        /* Workaround to use the same codepath for AST2600 */
>>> +        ast->chip = AST2500;
>>
>> The whole handling of different models in this driver is broken by
>> design and needs to be replaced.  I don't have much of the affected
>> hardware, so such things are going slowly. :(
>>
>> For an intermediate fix, it would be better to change all tests for
>> AST2500 to include AST2600 as well. There aren't too many IIRC.
>
> I feel a bit uncomfortable doing this, because I don't know if this
> settings are good for AST2600 or not. I just know that AST2500 settings
> are better than the "default".

KuoHsiang Chou, you wrote the commit causing this regression. Could you
maybe take care of the idea Thomas outlined to get this fixed relative
quickly? Or do you have a better idea?

> Also it may not apply cleanly up to v5.11

FWIW, 5.11 is EOL anyway.

> I will do a test patch and see what it gives.
> 
> Another solution would be to just revert f9bd00e0ea9d for v5.11 to v5.17 ?

That might cause a regression for users that depend on something
supported thx to this change. :-/

Ciao, Thorsten
