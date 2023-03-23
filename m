Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A056C5C1B
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 02:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjCWBc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 21:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCWBc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 21:32:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB7D30EB0;
        Wed, 22 Mar 2023 18:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 760C0B81B97;
        Thu, 23 Mar 2023 01:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30584C4339C;
        Thu, 23 Mar 2023 01:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679535063;
        bh=Ot5hvcQeLnVZ+qQdLf6laKQ2NtMhh4KUe2xmfxdFmpA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wh/4SRvy1oGFHxG1F3VeFwKlwlrfEqd8MXR+i/5CJAn7DvNqjbMUQDRjYxt/vSUaR
         u1gQA0y8Bx5lbAzUt70i4QfVzstMFPya3XxrK3uwQHynbGE/ZaUx5Pk4d+n9bGXV0v
         YBLgv2l3STg3fzIepLNbzsNxkUdXJ8kqNKzJDcO+ByNK4bvJPNp8kL0ICi4JIlzFr8
         +6J+qGIXyXJx67NXGzo1XBz6GNjt2GetV6GRDMqZHznxDAg4Ox+YVzn9trfUjeZIBL
         slbneUV0Oa6TV0wXvzjcz0hX+LMKGnLsW1FLbyARSDuBjjF0Jk5twGUCzubP802quE
         ZSpbwHGH06h3g==
Received: by mail-ed1-f52.google.com with SMTP id i5so33498038eda.0;
        Wed, 22 Mar 2023 18:31:03 -0700 (PDT)
X-Gm-Message-State: AO0yUKVnDAuXeIg0fgmg2E3le5W/OUjhCwzyfY9dvWd7PfHsSgbITeBn
        bkQA+ouRcccHpZXmrySaNHHzPD85WnG+Wo9bfFM=
X-Google-Smtp-Source: AK7set8JSq4K/B6pM2JnVQ3yUOzDZeZHRnLuujLTMBPSNeW8Qumnt/x9Wvc+9CRPKkwiG3kPO3ZtUyeAD1jI32gzCDM=
X-Received: by 2002:a17:907:784:b0:92f:b348:8f93 with SMTP id
 xd4-20020a170907078400b0092fb3488f93mr4409449ejb.10.1679535061387; Wed, 22
 Mar 2023 18:31:01 -0700 (PDT)
MIME-Version: 1.0
References: <1679380154-20308-1-git-send-email-yangtiezhu@loongson.cn>
 <253a5dfcb7e41e44d15232e1891e7ea9d39dc953.camel@xry111.site>
 <f61ac027-0068-40f0-87bd-17f916141884@roeck-us.net> <CAAhV-H5kFRt9z0U_TqSQeqX9WuUJ2cg0LOboUXHp-fLR0PoTJg@mail.gmail.com>
 <b4592fa4-35ec-4062-b965-962fc1ea12f6@roeck-us.net>
In-Reply-To: <b4592fa4-35ec-4062-b965-962fc1ea12f6@roeck-us.net>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Thu, 23 Mar 2023 09:30:49 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6DieadTzUqdCMeALhcmRyT9Da_QkzyG_RoO-S0PikfFw@mail.gmail.com>
Message-ID: <CAAhV-H6DieadTzUqdCMeALhcmRyT9Da_QkzyG_RoO-S0PikfFw@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: Check unwind_error() in arch_stack_walk()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Xi Ruoyao <xry111@xry111.site>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, loongson-kernel@lists.loongnix.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

OK, thanks.

Huacai

On Wed, Mar 22, 2023 at 10:20=E2=80=AFAM Guenter Roeck <linux@roeck-us.net>=
 wrote:
>
> On Wed, Mar 22, 2023 at 08:50:07AM +0800, Huacai Chen wrote:
> > On Tue, Mar 21, 2023 at 10:25=E2=80=AFPM Guenter Roeck <linux@roeck-us.=
net> wrote:
> > >
> > > On Tue, Mar 21, 2023 at 08:35:34PM +0800, Xi Ruoyao wrote:
> > > > On Tue, 2023-03-21 at 14:29 +0800, Tiezhu Yang wrote:
> > > > > We can see the following messages with CONFIG_PROVE_LOCKING=3Dy o=
n
> > > > > LoongArch:
> > > > >
> > > > >   BUG: MAX_STACK_TRACE_ENTRIES too low!
> > > > >   turning off the locking correctness validator.
> > > > >
> > > > > This is because stack_trace_save() returns a big value after call
> > > > > arch_stack_walk(), here is the call trace:
> > > > >
> > > > >   save_trace()
> > > > >     stack_trace_save()
> > > > >       arch_stack_walk()
> > > > >         stack_trace_consume_entry()
> > > > >
> > > > > arch_stack_walk() should return immediately if unwind_next_frame(=
)
> > > > > failed, no need to do the useless loops to increase the value of
> > > > > c->len in stack_trace_consume_entry(), then we can fix the above
> > > > > problem.
> > > > >
> > > > > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > > > > Link: https://lore.kernel.org/all/8a44ad71-68d2-4926-892f-72bfc7a=
67e2a@roeck-us.net/
> > > > > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > > >
> > > > The fix makes sense, but I'm asking the same question again (sorry =
if
> > > > it's noisy): should we Cc stable@vger.kernel.org and/or make a PR f=
or
> > > > 6.3?
> > > >
> > > > To me a bug fixes should be backported into all stable branches aff=
ected
> > > > by the bug, unless there is some serious difficulty.  As 6.3 releas=
e
> > > > will work on launched 3A5000 boards out-of-box, people may want to =
stop
> > > > staying on the leading edge and use a LTS/stable release series. We
> > > > can't just say (or behave like) "we don't backport, please use late=
st
> > > > mainline" IMO :).
> > >
> > > It is a bug fix, isn't it ? It should be backported to v6.1+. Otherwi=
se,
> > > if your policy is to not backport bug fixes, I might as well stop tes=
ting
> > > loongarch on all but the most recent kernel branch. Let me know if th=
is is
> > > what you want. If so, I think you should let all other regression tes=
ters
> > > know that they should only test loongarch on mainline and possibly on
> > > linux-next.
> > This is of course a bug fix, but should Tiezhu resend this patch? Or
> > just replying to this message with CC stable@vger.kernel.org is
> > enough?
> >
>
> Normally the maintainer, before sending a pull request to Linus, would ad=
d
> "Cc: stable@vger.kernel.org" to the patch. Actually sending the patch to
> the stable@ mailing list is only necessary if it was applied to the
> upstream kernel without Cc: stable@ in the commit message.
>
> Guenter
