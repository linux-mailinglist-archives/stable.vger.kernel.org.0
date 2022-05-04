Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0C851A5AB
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353277AbiEDQlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbiEDQls (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:41:48 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B83440E51
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:38:11 -0700 (PDT)
Date:   Wed, 04 May 2022 16:38:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail2; t=1651682287;
        bh=yOoxg2N5zJ4F1OoSCgUaKhglPU6NB2rB8SsmeAPDDmM=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=ETrz8E2Ecixoq5zO+zb61vwH1Uhl9f9E5C9NnUQ+f99bjDPcqwqs6debkIxamKJFk
         RbFOcIRODUPl2+fQ0kb14L0r+A0iIUuf5XWvG4n+iDhR/ny9mBHV7OT7zfa3dXYL3C
         JdTuNEFRietq10Rqtj8Fc8Xrk3DYzqlAZGlPVyhBtetZtpNFTi01B5s+XMd+YbeSpZ
         yJNHjjm7FxqAvuuPFwSy/a0zcCp44BDD1xQrTRjdQwA5N8DkYQRwybNnQMscwa3K/x
         yNQFZvydKAb370R8MjRG9DB9T9QE1b+ML4NeUpV27p67zI9+/XlmvOXi2qEU6xfQMF
         VfzR4JQ1FhjoQ==
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Jordan Leppert <jordanleppert@protonmail.com>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "labre@posteo.de" <labre@posteo.de>,
        "davem@davemloft.net" <davem@davemloft.net>
Reply-To: Jordan Leppert <jordanleppert@protonmail.com>
Subject: Re: Crash on resume after suspend (5.17.5 and 5.15.36)
Message-ID: <m2x6JjQLsOKoQvBopqci-aIwjaD4NAjGwR2ifWQ1UiGU4nnC9HzU0TpntBf8hWSIbItvCxm8fDgDnrDQbmGAg1-FRsfUO_rFzF1PAd_Amrw=@protonmail.com>
In-Reply-To: <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com>
References: <refZ3y2HAXztrRkMMmFbBaF7Dz1CctWgjchSdBtcSNlpk-TL0fqLepVVHfw9qXtIQF9uFzBvFdjQiiX9Jv2zW9oaWej952s1IYwu61d1REo=@protonmail.com> <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com>
Feedback-ID: 43610911:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some info I missed out, and some I've discovered:

1. This causes my system to completely freeze such that I need to reboot to=
 recover

2. There are no system logs from the crash, in fact absolutely no logs from=
 the resume at all, the last logs were of the computer going into suspend

3. I've found that I can prevent this crash by unloading the atlantic modul=
e before suspending (modprobe -r atlantic)

4. Also, if I take the v5.17.5 tag of the kernel and revert the commit ment=
ioned in my first email, this also prevents the crash

Regards,
Jordan



------- Original Message -------
On Wednesday, May 4th, 2022 at 16:07, Jordan Leppert <jordanleppert@protonm=
ail.com> wrote:


>
>
> Hi,
>
> A changed was added to both version 5.17.5 and 5.15.36 which causes my co=
mputer to freeze when resuming after a suspend. This happens every time I s=
uspend and then resume.
>
> I've bisected the change to commit: cbe6c3a8f8f4315b96e46e1a1c70393c06d95=
a4c (net: atlantic: invert deep par in pm functions, preventing null derefs=
)
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?=
h=3Dlinux-5.17.y&id=3Dcbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c
>
> My computer details that might be relevant:
> OS: Arch Linux
> CPU: AMD 5950X
> GPU: AMD 6800XT
>
> As expected I have an Aquantia ethernet controller listed in lspci:
>
> 05:00.0 Ethernet controller: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz E=
thernet Controller [AQtion] (rev 02)
>
> Please let me know if there is any more info I can give that will help.
>
> Regards,
> Jordan
