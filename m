Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7B851ADB6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 21:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356352AbiEDT25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 15:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356130AbiEDT2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 15:28:55 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DC926B
        for <stable@vger.kernel.org>; Wed,  4 May 2022 12:25:15 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id A1D07240109
        for <stable@vger.kernel.org>; Wed,  4 May 2022 21:25:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651692313; bh=xQMF+5afuQoxgkF9mHfBopm170bOS0rnq3uzCt9KPYc=;
        h=From:To:Cc:Subject:Date:From;
        b=U9WURfQts9wFPQVyxrVjPg5VaUJYU1mIgVfu6yTrASmG0EbAri3G1ovfYgpda7Z2x
         CipyOQmT27Xuss7XyhgAidHyCHVt8hMG4d33Ih+XPODRUTKyrIO/2tcSPNgQuB/TO8
         DNtOgXryQWqNt5MSum4LfDW+FpLojPzPVX9pDff5I0vJcGAzdBhufklyQWB54HKwwn
         9j5jgJVp6aca7q0hbTUo3smKKWAcYM7qPtpI1/ENbxeKSD2u3sK88fh4xRCD+wCK2l
         6EKZ83CK849lbdaPibcF56aMEZlWNqJ6CnBucgVN44zSUG1HDLq1npkrJ1Qdz1Zyj/
         /7SwDf54xOj4A==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Ktmxh59shz9rxK;
        Wed,  4 May 2022 21:25:12 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Jordan Leppert <jordanleppert@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "labre@posteo.de" <labre@posteo.de>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: Crash on resume after suspend (5.17.5 and 5.15.36)
References: <refZ3y2HAXztrRkMMmFbBaF7Dz1CctWgjchSdBtcSNlpk-TL0fqLepVVHfw9qXtIQF9uFzBvFdjQiiX9Jv2zW9oaWej952s1IYwu61d1REo=@protonmail.com>
        <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com>
Date:   Wed, 04 May 2022 19:25:29 +0000
In-Reply-To: <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com>
        (Jordan Leppert's message of "Wed, 04 May 2022 15:07:46 +0000")
Message-ID: <87levhnlqu.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?=
h=3Dlinux-5.17.y&id=3Dcbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c
Yup, that=E2=80=99s my fault and I reproduced this myself yesterday. I actu=
ally
expected this to happen and attempted to test suspend with the patch,
but must have screwed up by kexec-rebooting into an unpatched kernel
version or something like that. I=E2=80=99ll disable the kexec service in t=
he
future, if I ever need to prepare a patch again.
> 05:00.0 Ethernet controller: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz E=
thernet Controller [AQtion] (rev 02)
Yes, I have the same one.

> Please let me know if there is any more info I can give that will help.
Can you confirm, that hibernation works with the patch, but not without
it? The patch was an attempt to fix it, because I had the same behaviour
with hibernation. I tried to make sense of the deep parameter in
atl_resume_common pm function calls, but apparently it=E2=80=99s always req=
uired
to be true and thus obsolete.

I=E2=80=99ll leave the cleanup of that parameter to the maintainers for mai=
nline
and prepare a patch. Last time I sent it against mainline. If this fixup
of a stable patch regression should be posted differently, it would be
nice, if someone could give me a pointer.

5.10.113 is also affected.
