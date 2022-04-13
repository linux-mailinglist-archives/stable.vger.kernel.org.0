Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF5C500282
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 01:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbiDMXZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 19:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiDMXZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 19:25:55 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D7725283;
        Wed, 13 Apr 2022 16:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649892207;
        bh=UOmsfiUHZxEuNiv0Pgb/nZvDVXfQQUfQzVhysVasWek=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=Q/I88eJFE4/UE7peYUs6NcPHUPYa4V6tztoWnqsiWUEVczNTkIH8QDYC5urL+3RT1
         I5I0OPenL58yKR5w35rOsE5TrNgROzFyyqpLN8KBeiXENJYz+QVm5Sw+L1ewpLpeO+
         iy3ez3ElOvN7BXCGDMrZqs/IpqLQ3oxy0ss8X4NY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M9Fjb-1nYRD747TL-006KX6; Thu, 14
 Apr 2022 01:23:27 +0200
Message-ID: <9b8f45cb-060b-0b32-ff60-b0861eca2a33@gmx.com>
Date:   Thu, 14 Apr 2022 07:23:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 1/3] btrfs: avoid double clean up when submit_one_bio()
 failed
Content-Language: en-US
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1649766550.git.wqu@suse.com>
 <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
 <20220412204104.GA15609@twin.jikos.cz>
 <447a2d76-dfff-9efb-09e8-9778ac4a44f2@gmx.com>
 <20220413134630.GI15609@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220413134630.GI15609@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xCSAXaW5SaudQTKuX8ob6JbdLDbOqjDpE6+Eij9silkcHUb7NJi
 dHo/RmOlzlckRWRfCdEd0k6avRIlF0zNAGY48xXpTO0f7WE8J2fiv3NO66/ek8GwyfD09w+
 S6vOaZGcae3yVrLBzL88SpGS2tQ+tuqBBoFFSuDAapd7Oyszb/tO1hXrmKhatHjfnoRV9LH
 sspbg3ZryaeePAeO9cNWw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JpfwP2CLRGc=:RFwyeGo8A2qTPQ9kQLKRS/
 mT6PWStYgq3W3r0/05AQi4EW/LBWtPerxK1TJ18G6kQo3qGBY262oZap2P9kwMTbGmeWDnu4Y
 sJ6MZWNg663erC1Lf+391o6Kp0vSDAel7y9vINZMgiGMiL4alJgqh6xe1LFO+hpMAlrFZuCDx
 Yzo0vZy1NdhAuGFVxHnvsPfBrTB2JW8MQdS1HPQNlwprLYhN5MVtbJIOT02oImH3WaSzB6SFH
 3+PmsoRfMEGcehLh7l2irBbTMQ1edB5codTRvA9YMUPM7y7vvZ1Ed6hl3n2Cdr+WMGZGJ+T5w
 OmOWiSoOYMMjghu635DDg5Lvf5Q3cc0kU/1fZ7kLx1uxRd976qCuSTk/9A60bcmyoeIowurMD
 JWbBWMOn9xFEeuRnthMPCZC6ix0DlCF4fc1jdDx2TlCBj/JsXgmDqTZChwStxeM4+K1TFJI8G
 kH86ZcAyN0GqTY7IOrmt87tQ5vP3MH670gjXYDuE3Xs+rXf6JKoQPxN0AXsR62e6XToFmQ6xa
 b46FDDMMLhAEJ8sw4eFvcxxNKJUqRGriR60UqOV2DDSaKX5HJ57mvu+P5wFC68I5Nj149w4fD
 z/0RaHeC+Pja7joi/dCtyBUfsH5cvYD1VQdw8VdZ/zPs0coroQHM+mfQMVnhocgE4A5I2gV9d
 gg+DGboxxmgf1UGh661OSkkTeQPpbIK2I2JJ6PclAXngETZ0aI1huZUkrCS3b1i5kpnF17r0D
 maH5KdmRW/NxHKd36ONC1wdrXMfUButrsRacHHQ8kXnHUsJdCjWKkLQNTqxrHIw84dvyUNSZ8
 AKWWuDNIrNkMicRfYnhSd1lWXb2vRuIAii2sZe5QEXVKW0EK51sUeP8zWPfM63LWIJ0E+6D1m
 9+AVHXxubABESv2YCWALMgp/TZBb3R0pl32eiXfr7x7+zSIFwOuggvGIV0Oh6rmp+qneMzwNn
 UVHXkvXsN0giNCieu6tpmiS/yTykUBEP+FggG8JB6Av1Q96VIY6f6uql7H2Hyvg46cJtsCz7a
 gas4plOaYQpJulmIHf11+b75y2KB7iR1XjlPSXHAQuOmQkEwly36K6I83lq20nyMLCgkjtdIi
 8mE7kjPqk8PBKg=
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/4/13 21:46, David Sterba wrote:
> On Wed, Apr 13, 2022 at 07:32:41AM +0800, Qu Wenruo wrote:
>> On 2022/4/13 04:41, David Sterba wrote:
>>> On Tue, Apr 12, 2022 at 08:30:13PM +0800, Qu Wenruo wrote:
>>>> The commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly o=
n
>>>> reads") itself is completely fine, it's our existing code not properl=
y
>>>> handling the error from bio submission hook properly.
>>>>
>>>> This patch will make submit_one_bio() to return void so that the call=
ers
>>>> will never be able to do cleanup when bio submission hook fails.
>>>>
>>>> CC: stable@vger.kernel.org # 5.18+
>>>
>>> BTW stable tags are only for released kernels, if it's still in some r=
c
>>> then Fixes: is appropriate.
>>
>> The problem is I don't have a good idea on which commit to be fixed.
>>
>> Commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
>> reads") is completely fine by itself.
>>
>> The problem is there for a long long time, but can only be triggered
>> with IO errors with that newer commit.
>>
>> Should we really use that commit? It looks like a scapegoat to me...
>
> I see, so it does not make sense to put Fixes: if it's not clearly
> caused by the patch, the text description of the problem and references
> to patches that could affect is OK.
>
> Still the stable tag should reflect where the fix applies but 5.18
> hasn't been released so either it's a typo or you know roughly which
> stable kernels should get the fix (5.15, 5.10, etc).

Then I guess we can drop the stable tag.

Before that mentioned commit, btrfs_lookup_bio_csum() will never return
error, thus submit_one_bio() will not really fail (due to IO error).

Although the error path is there for a long long time, we don't have
easy way to trigger the problem.

Thanks,
Qu
