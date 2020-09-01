Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA92259D33
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgIAR3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbgIAR3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 13:29:43 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F933C061245
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 10:29:42 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 17so1187761pfw.9
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 10:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FW5La7opiv4KWG16c7XYpf3DTcgrj7Pdfd83aUNKNrc=;
        b=jAYS2ZZc79qZYnTsWwjv1SadjMN4RsSUm73yL30/GRwcwxgx4b2Nzm1acr8EpXHU9A
         boOwDj4V+fB5mPRPo+Bphq2QhUwtv9CGHRTG0Mst/tBdwp4NX2vO6i7ag2MSCNrd/HIi
         AZQ+fBRYvWGIFiYzyOdjiuLJEwGDoPjfTasrm4iP6Bxhunex1Odsdg877c+L2oeUIjyl
         BvD61dtjU9PXUL0yTB3RKH36Q/pHpRkVTcfkriR5wU0n1ydpyKxsMdyKoKf2KiK0Wrgh
         jFGMvRTtmQI4gSn4b684qUrpZw/MICxUnYbOWXjmbDcERxcrngcctPQze1oDKK2bpbTD
         aFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FW5La7opiv4KWG16c7XYpf3DTcgrj7Pdfd83aUNKNrc=;
        b=bur+RaBF1qSQVfMdtH77fZtDieI+lZl4UWPDRBzp3ikO+cODMbCdQTSFIiZJLPRWtm
         aRYxZgLSY73PgMPEIE09pHZG95vg5cvKYFrrslDgbrL6mHFod8CcSC+C817NVb9mNpzh
         YALbjPyPPiMKNhT5r8OUbPx4jkfSP81pymfrB8qDlvFGA23dbr0Lui/16f7gCG4U94xh
         NyAB+y8OQG4Trb+tIofn8ZNO2TDbk3PfURZw07X4tJpQKLiM+M+KUsTY8chkwJdg/eST
         1QvFam0VEnK32tCIdqyVWpay2S4XNYsai1nwW1IAG/VuvbBjcxFJoSk7wRmoSzRxmqM8
         cQhw==
X-Gm-Message-State: AOAM530KYjtZjxaCIIbVPJq639z63NYIl0Q/SJa8m5gpB65Z9egSFvwA
        q1PZPZ5SMptN4JR49jI/RlV89O7nfK0BXh7rFafgJw==
X-Google-Smtp-Source: ABdhPJy+wnhFDll+mv7LIiKSNfRQ41dAABi9B9GZjw2dwvoiws5enWPEeNCL3N0k/xB5qaMMi/h/yGiXziML8E6Nkz4=
X-Received: by 2002:a63:d62:: with SMTP id 34mr2356233pgn.179.1598981381718;
 Tue, 01 Sep 2020 10:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com> <20200729214607.GA30831@salvia>
 <20200731002611.GA1035680@google.com> <20200731175115.GA16982@salvia>
 <20200731181633.GA1209076@google.com> <20200803183156.GA3084830@google.com>
 <20200804113711.GA20988@salvia> <20200901153607.GC4292@willie-the-truck>
In-Reply-To: <20200901153607.GC4292@willie-the-truck>
From:   William Mcvicker <willmcvicker@google.com>
Date:   Tue, 1 Sep 2020 10:29:25 -0700
Message-ID: <CABYd82ZDVqJo4KUiF0oMX6CW7pC_Y0DB_PdXJMft-yU=c5TCBg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] netfilter: nat: add a range check for l3/l4 protonum
To:     Will Deacon <will@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, security@kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Will,

Pablo is going to add the latest patch to the nf.git tree. Once that
happens, I'm going to propose the patch in nf.git get cherry-picked to
the -stable branches.

Thanks,
Will


On Tue, Sep 1, 2020 at 8:36 AM Will Deacon <will@kernel.org> wrote:
>
> Hi Will, Pablo,
>
> On Tue, Aug 04, 2020 at 01:37:11PM +0200, Pablo Neira Ayuso wrote:
> > This patch is much smaller and if you confirm this is address the
> > issue, then this is awesome.
>
> Did that ever get confirmed? AFAICT, nothing ended up landing in the stable
> trees for this.
>
> Cheers,
>
> Will
>
>
> > On Mon, Aug 03, 2020 at 06:31:56PM +0000, William Mcvicker wrote:
> > [...]
> > > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > > index 31fa94064a62..56d310f8b29a 100644
> > > --- a/net/netfilter/nf_conntrack_netlink.c
> > > +++ b/net/netfilter/nf_conntrack_netlink.c
> > > @@ -1129,6 +1129,8 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
> > >     if (!tb[CTA_TUPLE_IP])
> > >             return -EINVAL;
> > >
> > > +   if (l3num >= NFPROTO_NUMPROTO)
> > > +           return -EINVAL;
> >
> > l3num can only be either NFPROTO_IPV4 or NFPROTO_IPV6.
> >
> > Other than that, bail out with EOPNOTSUPP.
> >
> > Thank you.
