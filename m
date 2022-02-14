Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE054B4D06
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350112AbiBNLFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:05:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349672AbiBNLFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 06:05:24 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACDC2DEF;
        Mon, 14 Feb 2022 02:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644834803;
        bh=C52L81Zv6DgbMZ32Hm9sPxd7zXF+yQ2jiwL8dR4ieg4=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=KnJwe0LutHn9sbuIrMoUZoJGhki7eiG5xu5f3Vz1L83YUvdFWghUTrdbvMfphWHUh
         pBx1t0QFUOqTqZyeSuOJshjA1LcH7/IqpYrvBBnsq+5wxRBUwCPgvvPDy3lBSHmTv9
         +FpSytip4vWTQpH0tEW2q/fGAPBSuG6FEuiLShEM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.123.94] ([88.152.144.107]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MFsYx-1nVLkT3WO7-00HNq3; Mon, 14
 Feb 2022 11:28:02 +0100
Message-ID: <49d3aeab-1fe6-8d17-bc83-78f3555109c7@gmx.de>
Date:   Mon, 14 Feb 2022 11:27:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] riscv/efi_stub: Fix get_boot_hartid_from_fdt() return
 value
Content-Language: en-US
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>, stable@vger.kernel.org,
        Sunil V L <sunilvl@ventanamicro.com>
References: <20220128045004.4843-1-sunilvl@ventanamicro.com>
 <877d9xx14f.fsf@igel.home> <9cd9f149-d2ea-eb55-b774-8d817b9b6cc9@gmx.de>
 <87tud1vjn4.fsf@igel.home>
From:   Heinrich Schuchardt <xypron.glpk@gmx.de>
In-Reply-To: <87tud1vjn4.fsf@igel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kWX1RyymCzZi3HShz7TOEYlEEIuEzCNmVUcoaTDwlboEDX5KwFu
 T11R6pzWrra/U18O4BDT+sVEhjcz8mGruHI8KlMlxezPRwjHQjP7BDC7kB7HE7wSbWk5dG9
 A2yqlqau3mBKveqkKrrIjPWTC6WpDX8zIYF0Ip/e/9ud3RGLLFFsmhrML5JLwj88Mx458FZ
 mehheaVewk32SY9MHOJ3Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gW86zBi/V3o=:IslAMeGKcQDNVWpsEcUkOU
 757RAkn0+7tCs9VFCWiekFHWUmgamtMaUmqZwNPl49h7pLOqMHyU8fWz4HPHVVtLwew94i6TG
 7J0A5G5GqDOABx5xmDWoaf2iGtPeFVJnrjKVKLi2eBnb0kxeiTsQqQzUQm9nL5vesxdhxppi9
 TLQhUQrWTmKYOPY64VupXAVyyxx01glCx69Wkqr01auVEq41YDuZgBbArXhTVCi/k+f2fag2o
 /8Q3LVl5WHhJ8dULXOLizrXgl8qL5tWyiB/uADVaj37BZp6yTdjjVsLoA4Pz9NmuMi6vWcJFb
 chAjjguQ7QWkStS42cIruUWoJO5j0svY28NY4c89MLh2NHNgtTJgYbuPPiyqHEtxo5wU8fl7o
 U8MHhrRs7NK345HKhNJQ4WzQdARRdNA7PwnmK2+3Mb4VPtEha5Zj3BGN4W7A+8HfwX4bTZIzX
 1MWYWM8YAeVeSduNKLn+01tnZOwsvGhrAAA9+w+S0TeBYSDQoXQJQA0D6Eyiv79DELk111oHG
 g8+aMcdzYI0fnzspJTJKAiNUmit0BzY75Vav7AEoRdTD60CjTLQhK1KXZbpbN+9KJ2ygfzdrJ
 6QwD1KrZTHFTvcPRtG+BebwYCmwlPNhesWjwiMxt5Uu1Eh6j097PrLUbU2sVjCSn1myDaVIOA
 gUJXgJk4/FGRvL5i1WcSM8WLxD+FDXPqwL21uJc8RZxJEdxbw5+4+MC0HHHz9Vs7q3inenF9g
 p5edhbvHqd+54Pz26fJSaP7bz0mGP1AdB8DdPGVtRx9kI9h05KPGELYQsHEZUmUGKRMQjjPn8
 rFEbVBUZbGmiX+N+ypdjYlIPaQGeeAkEQWKfD/yUe38VuGTUMyb2y/qOdGTmDb9miJ4IcWV5x
 MQ3vFXWw6F4Ug7sTjRaML3OL56ODYiJiqRdrpRRyNsRq7KzD40MvvbCkQE1xtmG/B9+jOXHvI
 dEr8rnyOmrYsNFaubgQJ4vHDxnUEEjUPlornLA0INKVHomW1qvzAmRbzvdAUv7ansGAnecRZ8
 tWUPfQlIar5MYQeLE6QF/PE3EsjVFDSNH5D3BrfN+rEdwUIqupiC4OxA3JMuOj4zZ2ozSVCF+
 tlB/l0M+/zjzok=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 11:15, Andreas Schwab wrote:
> On Feb 14 2022, Heinrich Schuchardt wrote:
>
>> set_boot_hartid() implies that the caller can change the boot hart ID.
>> As this is not a case this name obviously would be a misnomer.
>
> initialize_boot_hartid would fit better.
>

Another misnomer.

