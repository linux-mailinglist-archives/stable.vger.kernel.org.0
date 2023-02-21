Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEE469DC9D
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 10:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbjBUJNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 04:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbjBUJNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 04:13:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EE423858
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 01:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676970743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZAvHiPQ19TdYhLIdZGTOSEcgY7DzCG2H/QK92XwZ0l8=;
        b=EFcDomUnxk/72HlqisvHKikDRMP2F4Sq2rPrtK+iQU0PqdoqEQc3t56lMEDpuopO1LGFqy
        kBE1OazfKAxkJmtqRfwhhuDNc5d3xMcRHx8nOuoc3NX6Qnj53+56iMkWcYYi7pUK0mOACy
        lrEMI5F4LWwYvOhD3AqMvBm71HEACcE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-IsxT7RyXOVSdXjthv3bPQg-1; Tue, 21 Feb 2023 04:12:21 -0500
X-MC-Unique: IsxT7RyXOVSdXjthv3bPQg-1
Received: by mail-qt1-f197.google.com with SMTP id n22-20020ac86756000000b003be57054a3bso1873431qtp.1
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 01:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZAvHiPQ19TdYhLIdZGTOSEcgY7DzCG2H/QK92XwZ0l8=;
        b=nAiIYfVuXK6Hp0LuqKkkHzfLBGvmErT+tP5+to4dPGfgYuIQ6uxi5Fj1e+bfZEiona
         1c26gnWgeN76iUfzpZhwOfUOvwzr48rkDY0rFxQ22tL+Nr7NmyPGiOBMpDsshUXvwA2a
         Cs7Yf1eRfeUDd7zBDx9h4NedWC5IBc97v1oExKxh8/8G7t4MeZkdl6SW+eRl0qYhj7S/
         BaLzZCZlRXGoNKRkeRLDEX8JMCA2My+egb5pE/J7gyXiOAPLKqfuziLpc+jNlPgiOhHj
         Az8hFFIsVH0vEEEVx3/n1wLGE//dRF/XyNpvT6fLYrlSZz+HxsoeUNQpoA6TkbLIJFnv
         3Gaw==
X-Gm-Message-State: AO0yUKVeWp3wX1nuHFnjgVss+Y4sbNItL1hhDNz6wMDfb3W7zGgXNEjd
        mHt/Bnbod/MMFmHvm44UnRd/88N66id2/YGktyURsYbYk4LiH563FrhsAtE5SvFSHtRAiLUtxl8
        rdzqHk4RRXFRDm39q
X-Received: by 2002:ac8:4e95:0:b0:3bd:142d:64dd with SMTP id 21-20020ac84e95000000b003bd142d64ddmr8526050qtp.3.1676970741025;
        Tue, 21 Feb 2023 01:12:21 -0800 (PST)
X-Google-Smtp-Source: AK7set83qv+2Mv0RH24mzPx8V9CvzDxA2eI0jnOhrHL7ToCbR/vkhX51kVrQ5bKHy82UfSXuqT0A8g==
X-Received: by 2002:ac8:4e95:0:b0:3bd:142d:64dd with SMTP id 21-20020ac84e95000000b003bd142d64ddmr8526022qtp.3.1676970740740;
        Tue, 21 Feb 2023 01:12:20 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id d4-20020ac81184000000b003b62bc6cd1csm10509603qtj.82.2023.02.21.01.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 01:12:20 -0800 (PST)
Message-ID: <00383a3d782a35173b0638ec1d4289a19cc326e7.camel@redhat.com>
Subject: Re: [PATCH 5.4 096/156] net: sched: sch: Bounds check priority
From:   Paolo Abeni <pabeni@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Simon Horman <simon.horman@corigine.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Tue, 21 Feb 2023 10:12:16 +0100
In-Reply-To: <Y/SDvySpXrsemVpH@kroah.com>
References: <20230220133602.515342638@linuxfoundation.org>
         <20230220133606.471631231@linuxfoundation.org>
         <1bfe95ba03a58d773f50a628b9fb5e007dd124ad.camel@redhat.com>
         <Y/SDvySpXrsemVpH@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-02-21 at 09:41 +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 21, 2023 at 08:45:18AM +0100, Paolo Abeni wrote:
> > Hello,
> >=20
> > On Mon, 2023-02-20 at 14:35 +0100, Greg Kroah-Hartman wrote:
> > > From: Kees Cook <keescook@chromium.org>
> > >=20
> > > [ Upstream commit de5ca4c3852f896cacac2bf259597aab5e17d9e3 ]
> > >=20
> > > Nothing was explicitly bounds checking the priority index used to acc=
ess
> > > clpriop[]. WARN and bail out early if it's pathological. Seen with GC=
C 13:
> > >=20
> > > ../net/sched/sch_htb.c: In function 'htb_activate_prios':
> > > ../net/sched/sch_htb.c:437:44: warning: array subscript [0, 31] is ou=
tside array bounds of 'struct htb_prio[8]' [-Warray-bounds=3D]
> > >   437 |                         if (p->inner.clprio[prio].feed.rb_nod=
e)
> > >       |                             ~~~~~~~~~~~~~~~^~~~~~
> > > ../net/sched/sch_htb.c:131:41: note: while referencing 'clprio'
> > >   131 |                         struct htb_prio clprio[TC_HTB_NUMPRIO=
];
> > >       |                                         ^~~~~~
> > >=20
> > > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > > Cc: Cong Wang <xiyou.wangcong@gmail.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > > Link: https://lore.kernel.org/r/20230127224036.never.561-kees@kernel.=
org
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> >=20
> > This one has a follow-up which I don't see among the patches reaching
> > the netdev ML:
> >=20
> > commit 9cec2aaffe969f2a3e18b5ec105fc20bb908e475
> > Author: Dan Carpenter <error27@gmail.com>
> > Date:   Mon Feb 6 16:18:32 2023 +0300
> >=20
> >     net: sched: sch: Fix off by one in htb_activate_prios()
>=20
> This too is in the queue for 5.4 and newer kernels, are you sure you
> didn't miss that in this series?

I missed it, sorry. I checked only my inbox and netdev, and it was not
there, but I see it in the stable queue.

Sorry for the noise,

Paolo

