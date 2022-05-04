Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A5551ACFC
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 20:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355154AbiEDSjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 14:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377421AbiEDSi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 14:38:59 -0400
Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B315D13CED
        for <stable@vger.kernel.org>; Wed,  4 May 2022 11:31:27 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id DFDF0124EC0;
        Wed,  4 May 2022 20:31:25 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 8CEA2F01600;
        Wed,  4 May 2022 20:31:25 +0200 (CEST)
Subject: Re: Crash on resume after suspend (5.17.5 and 5.15.36)
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To:     Jordan Leppert <jordanleppert@protonmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "labre@posteo.de" <labre@posteo.de>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <refZ3y2HAXztrRkMMmFbBaF7Dz1CctWgjchSdBtcSNlpk-TL0fqLepVVHfw9qXtIQF9uFzBvFdjQiiX9Jv2zW9oaWej952s1IYwu61d1REo=@protonmail.com>
 <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com>
 <0e53891e-418f-ce94-2204-060c35b32a2d@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <888dd07b-89b3-6620-820a-74f497ddc223@applied-asynchrony.com>
Date:   Wed, 4 May 2022 20:31:25 +0200
MIME-Version: 1.0
In-Reply-To: <0e53891e-418f-ce94-2204-060c35b32a2d@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-05-04 19:50, Holger Hoffstätte wrote:
> On 2022-05-04 17:07, Jordan Leppert wrote:
>> Hi,
>>
>> A changed was added to both version 5.17.5 and 5.15.36 which causes my computer to freeze when resuming after a suspend. This happens every time I suspend and then resume.
>>
>> I've bisected the change to commit: cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c (net: atlantic: invert deep par in pm functions, preventing null derefs)
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.17.y&id=cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c
>>
>> My computer details that might be relevant:
>> OS: Arch Linux
>> CPU: AMD 5950X
>> GPU: AMD 6800XT
>>
>> As expected I have an Aquantia ethernet controller listed in lspci:
>>
>> 05:00.0 Ethernet controller: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz Ethernet Controller [AQtion] (rev 02)
>>
>> Please let me know if there is any more info I can give that will help.
>>
>> Regards,
>> Jordan
>>
> 
> Just a quick note that I have the same issue (same card model); since recently
> (5.15.36) the hang after resume is 100% reliable. IIRC it used to be hit-and-miss
> before that. I'm currently building .38 with the mentioned commit reverted and
> will report back. Thanks for bringing this up.

With said commit reverted and 5.15.38 I got 1 successful resume and 1 lockup.
Difference is that with the patch reverted, the locked-up system can be pinged
(unlike with the patch applied), though resume still does not finish properly and
now probably runs into the problem that the patch was trying to fix.
Any network services like ssh are still dead though.
This used to work every time, all the time..looks like I'll try removing the
module before suspend.

-h
