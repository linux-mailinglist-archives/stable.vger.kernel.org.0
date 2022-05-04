Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A8451AFEC
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 22:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiEDVCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 17:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238823AbiEDVCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 17:02:09 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1E218387
        for <stable@vger.kernel.org>; Wed,  4 May 2022 13:58:31 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id B74BB124EC0;
        Wed,  4 May 2022 22:58:29 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 6D5D8F01600;
        Wed,  4 May 2022 22:58:29 +0200 (CEST)
Subject: Re: Crash on resume after suspend (5.17.5 and 5.15.36)
To:     Manuel Ullmann <labre@posteo.de>,
        Jordan Leppert <jordanleppert@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <refZ3y2HAXztrRkMMmFbBaF7Dz1CctWgjchSdBtcSNlpk-TL0fqLepVVHfw9qXtIQF9uFzBvFdjQiiX9Jv2zW9oaWej952s1IYwu61d1REo=@protonmail.com>
 <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com>
 <87levhnlqu.fsf@posteo.de>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <18466b6a-b040-c72c-e33d-fe37c5ff6a9d@applied-asynchrony.com>
Date:   Wed, 4 May 2022 22:58:29 +0200
MIME-Version: 1.0
In-Reply-To: <87levhnlqu.fsf@posteo.de>
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

On 2022-05-04 21:25, Manuel Ullmann wrote:
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.17.y&id=cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c
> Yup, that’s my fault and I reproduced this myself yesterday. I actually
> expected this to happen and attempted to test suspend with the patch,
> but must have screwed up by kexec-rebooting into an unpatched kernel
> version or something like that. I’ll disable the kexec service in the
> future, if I ever need to prepare a patch again.
>> 05:00.0 Ethernet controller: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz Ethernet Controller [AQtion] (rev 02)
> Yes, I have the same one.
> 
>> Please let me know if there is any more info I can give that will help.
> Can you confirm, that hibernation works with the patch, but not without
> it? The patch was an attempt to fix it, because I had the same behaviour

Cannot test hibernation, but..

> with hibernation. I tried to make sense of the deep parameter in
> atl_resume_common pm function calls, but apparently it’s always required
> to be true and thus obsolete.

..I patched 5.15.38 to pass true as deep arg everywhere, and now resume
seems to work again reliably, 5 out of 5. \o/

> I’ll leave the cleanup of that parameter to the maintainers for mainline
> and prepare a patch. Last time I sent it against mainline. If this fixup
> of a stable patch regression should be posted differently, it would be
> nice, if someone could give me a pointer.

Send fix to mainline first, with Fixes: <mainline commit id> tag and
Cc: stable mentioning the affected versions.

cheers
Holger
