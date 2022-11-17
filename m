Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E9D62E02D
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 16:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiKQPm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 10:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiKQPm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 10:42:28 -0500
Received: from xry111.site (xry111.site [89.208.246.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A99CDA
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 07:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1668699742;
        bh=aJ3Su7Id8fFh36dDnfD7Im9eQ/HKaolYvEEtMS4T6wA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gcnqWlsJVFIti3S36UCLPp6LZWk61Yum6VxXfUEEo4xF3bzMGzkJwph+NBHUoWZFQ
         +1XyIzoo2E9NcQI+br42vmJf0KXrTfNAGUhS2wgJl36idviXeRB4RUxnxHUh5GWZI1
         E5Jxa6DoZmf1A2F3e6ZkZKKVJLO93ciY9CMFCDSc=
Received: from localhost.localdomain (xry111.site [IPv6:2001:470:683e::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 61F7565DD0;
        Thu, 17 Nov 2022 10:42:19 -0500 (EST)
Message-ID: <b402098421927699db853e5e05fbb9d48fa24886.camel@xry111.site>
Subject: Re: [PATCH 04/47] LoongArch: Set _PAGE_DIRTY only if _PAGE_WRITE is
 set in {pmd,pte}_mkdirty()
From:   Xi Ruoyao <xry111@xry111.site>
To:     Huacai Chen <chenhuacai@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     loongarch@lists.linux.dev, Xuefeng Li <lixuefeng@loongson.cn>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "David S . Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>
Date:   Thu, 17 Nov 2022 23:42:17 +0800
In-Reply-To: <b1707e1c04a6a9b91fd5f70ea012b5bcc764516e.camel@xry111.site>
References: <20221117042532.4064448-1-chenhuacai@loongson.cn>
         <b1707e1c04a6a9b91fd5f70ea012b5bcc764516e.camel@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.0 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-11-17 at 21:59 +0800, Xi Ruoyao wrote:
> Hi Huacai,
>=20
> On Thu, 2022-11-17 at 12:25 +0800, Huacai Chen wrote:
> > Now {pmd,pte}_mkdirty() set _PAGE_DIRTY bit unconditionally, this cause=
s
> > random segmentation fault after commit 0ccf7f168e17bb7e ("mm/thp: carry
> > over dirty bit when thp splits on pmd").
>=20
> Hmm, the pte_mkdirty call is already removed in commit 624a2c94f5b7a081
> ("Partly revert \"mm/thp: carry over dirty bit when thp splits on
> pmd\"").
>=20
> Not sure if this issue is related to some random segfaults I've observed
> recently though.=C2=A0 My last kernel build contains 0ccf7f168e17bb7e but
> does not contain 624a2c94f5b7a081.

I can confirm this patch alone (without 624a2c94f5b7a081) fixes the
random segfaults I've recently encountered running GCC testsuite.

Link: https://gcc.gnu.org/pipermail/gcc/2022-November/239857.html
Tested-by: Xi Ruoyao <xry111@xry111.site>

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
