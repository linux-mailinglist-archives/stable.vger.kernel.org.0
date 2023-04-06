Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFEC6D9243
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 11:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjDFJG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 05:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbjDFJG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 05:06:57 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E350749C3;
        Thu,  6 Apr 2023 02:06:53 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pkLZy-0003aV-S5; Thu, 06 Apr 2023 11:06:50 +0200
Message-ID: <71816e38-f919-11a4-1ac9-71416b54b243@leemhuis.info>
Date:   Thu, 6 Apr 2023 11:06:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 1/3] ARM: dts: meson: Fix the UART compatible strings
Content-Language: en-US, de-DE
To:     =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20211227180026.4068352-1-martin.blumenstingl@googlemail.com>
 <20211227180026.4068352-2-martin.blumenstingl@googlemail.com>
 <20230405132900.ci35xji3xbb3igar@rcn-XPS-13-9305>
 <fdffc009-47cf-e88d-5b9e-d6301f7f73f2@leemhuis.info>
 <44556911-e56e-6171-07dd-05cc0e30c732@collabora.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
In-Reply-To: <44556911-e56e-6171-07dd-05cc0e30c732@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680772014;6c814293;
X-HE-SMSGID: 1pkLZy-0003aV-S5
X-Spam-Status: No, score=-2.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[CCing the stable list as well as Greg and Sasha so they can correct me
if I write something stupid]

On 06.04.23 10:27, Ricardo Cañuelo wrote:
> 
> On 5/4/23 19:14, Thorsten Leemhuis wrote:
>> Wait, what? A patch (5225e1b87432 ("ARM: dts: meson: Fix the UART
>> compatible strings")) that was merged for v5.17-rc4 and is not in the
>> list of patches that were in 4.14.312-rc1
>> (https://lore.kernel.org/all/20230403140351.636471867@linuxfoundation.org/
>> ) is meant to suddenly cause this? How is this possible? Am I totally on
>> the wrong track here and misunderstanding something, or is this a
>> bisection that went horribly sideways?
> 
> I didn't say this was introduced in 4.14.312-rc1, this has been failing
> for a long time and it was merged for 4.14.267:
> https://lwn.net/Articles/884977/
> 
> Sorry I wasn't clear before.

Ahh, no worries and thx for this. But well, in that case let me get back
to something from your report:

>>> KernelCI detected that this patch introduced a regression in
>>> stable-rc/linux-4.14.y on a meson8b-odroidc1.
>>> After this patch was applied the tests running on this platform don't
>>> show any serial output.
>>> 
>>> This doesn't happen in other stable branches nor in mainline, but 4.14
>>> hasn't still reached EOL and it'd be good to find a fix.

Well, the stable maintainers may correct me if I'm wrong, but as far as
I know in that case it's the duty of the stable team (which was not even
CCed on the report afaics) to look into this for two reasons:

* the regression does not happened in mainline (and maybe never has)

* mainline developers never signed up for maintaining their work in
longterm kernels; quite a few nevertheless help in situation like this,
at least for recent series and if they asked for a backport through a
"CC: <stable@" tag – but the latter doesn't seem to be the case here
(not totally sure, but it looks like AUTOSEL picked this up) and it's a
quite old series.

>>> #regzbot introduced: 5225e1b87432dcf0d0fc3440824b91d04c1d6cc1

Thx for getting regzbot involved, but due to your usage it now considers
this a mainline regression, as 5225e1b87432 is a mainline commit. As
this only happens in a particular stable tree, it should use a commit id
from there instead:

#regzbot introduced: 23dfa42a0a2a91d640ef3fce585194b970d8680c

(above line will make regzbot adjust this)

Ciao, Thorsten
