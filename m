Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973D651A334
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 17:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351796AbiEDPLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 11:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351606AbiEDPLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 11:11:33 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE391D0FE
        for <stable@vger.kernel.org>; Wed,  4 May 2022 08:07:55 -0700 (PDT)
Date:   Wed, 04 May 2022 15:07:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail2; t=1651676871;
        bh=o10sw0tBjGYFqmRrH+fVUfT4lfywBEMkHYlcUAVI/y8=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=kwN8druepZBT8H5u0V5ZB9bLgMb8VlorSd5rf3dcu6oO/rfFJCcRpWy69Q5Uz7DxL
         MWJa6S7mIZ/1XnB1fNubnfhMnXoBDT0IFhYB1WaFbX9NulkkDLB9j8nsk8z9yHcVOo
         lgWK1XbR3qjux36H+jMES5cS+u+LxFUI/bX3lEZfQ9ibzOezVQv7c+2fGXXFi49Nr2
         GIB5BHt1b747lJVcrsH19lnAJImLzUYEO/97n8Pidp+PquDn4C9YwagmWRvQy5Am2P
         mG4L7w7wNT0YIBftTz0bDoWwzX8NDUppVsv5STdmXYxq1OBXtqgUm1+d2yTw/8P65N
         2SaOUAoJnfOCA==
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Jordan Leppert <jordanleppert@protonmail.com>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "labre@posteo.de" <labre@posteo.de>,
        "davem@davemloft.net" <davem@davemloft.net>
Reply-To: Jordan Leppert <jordanleppert@protonmail.com>
Subject: Crash on resume after suspend (5.17.5 and 5.15.36)
Message-ID: <9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com>
In-Reply-To: <refZ3y2HAXztrRkMMmFbBaF7Dz1CctWgjchSdBtcSNlpk-TL0fqLepVVHfw9qXtIQF9uFzBvFdjQiiX9Jv2zW9oaWej952s1IYwu61d1REo=@protonmail.com>
References: <refZ3y2HAXztrRkMMmFbBaF7Dz1CctWgjchSdBtcSNlpk-TL0fqLepVVHfw9qXtIQF9uFzBvFdjQiiX9Jv2zW9oaWej952s1IYwu61d1REo=@protonmail.com>
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

Hi,

A changed was added to both version 5.17.5 and 5.15.36 which causes my comp=
uter to freeze when resuming after a suspend. This happens every time I sus=
pend and then resume.

I've bisected the change to commit: cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4=
c (net: atlantic: invert deep par in pm functions, preventing null derefs)
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-5.17.y&id=3Dcbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c

My computer details that might be relevant:
OS: Arch Linux
CPU: AMD 5950X
GPU: AMD 6800XT

As expected I have an Aquantia ethernet controller listed in lspci:

05:00.0 Ethernet controller: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz Eth=
ernet Controller [AQtion] (rev 02)

Please let me know if there is any more info I can give that will help.

Regards,
Jordan
