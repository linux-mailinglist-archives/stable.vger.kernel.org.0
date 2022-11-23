Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFCB63694F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 19:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbiKWSy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 13:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239384AbiKWSy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 13:54:27 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48C174AA6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 10:54:26 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w79so370019pfc.2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 10:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38G975FSDRAQ+rI0qzQhpV6vgqCXeEH2mJsFiFPnzh8=;
        b=AHisl14Edj5ajN8DjoaBcYc3GPjrMcPmRmFOE2N53/MoCwhjMckQ7DIajvz+a8Nq07
         XtP8o371Z8UrFu+mOYtGajqp6V0u4cgrpck31v1O91+BqDXzhwY/PfY3TSexpqVWN5bk
         LNtqKIXfc6twyF9ACqxxhI/OWKhbmObGFbztdiRe+NGgdpUq8nTHjCdwg5wnV0vRAlX/
         1Wtqrhe+QJK0ZDeh5prPn6LmCroohy/Sns2/z3VfRLFw4hlQwzX9zTGIiStnZFdfP78a
         RZLx4+fu6uF1FiiymF+/JkggabE5SWfzJy3av5KmxGh936vXMGL60ntUQ5oB3WVqQuHh
         n+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38G975FSDRAQ+rI0qzQhpV6vgqCXeEH2mJsFiFPnzh8=;
        b=IxCiGUC6EKKBS+GPPe9qoItOPs+xjhm0TI7O6nc/Y/m6G1lcQZEBmSJRzhKvFtgC1w
         GfRSE9NuD5ymR24yagtusX0tlybmJMxj3Ssr5QN/fSnZgFyigKf/tRKOikNVvBtcWg8k
         nINisLmoVTgFFP2P5/665fCUikriwIFfFb7Ke+ak2WODGjdUBm+QJjuHZuKmV9glxWAa
         avRg/5LPmHNrhZulz8p/AQq2D+XukeSrecEQEvzjApsPiBXPwVyOoPDZiLkR6svHUl2n
         4TbeHcCdP53EFTiig//4M6dtXmmKDmmFUZwnK6nOvAH9Vrp0YLAz9EyUi0TCydvvu8Z+
         sBGw==
X-Gm-Message-State: ANoB5pnGniv7jIYVlD00a3k0XakoHjZlytk5/fvVEtB3o6JrTu25DggF
        VzJ+X/cHLuAdxf9X/cahHENMiHapjqg+knVKgGQ=
X-Google-Smtp-Source: AA0mqf69rIk0vKoAb+F5bhnQO/71ui9MwQgchqBJITY/Ttf6ZwX4n92IwHFgPWW9o06WfJnRWiljfJFd4JpaOXorbHY=
X-Received: by 2002:a05:6a00:1696:b0:53e:6656:d829 with SMTP id
 k22-20020a056a00169600b0053e6656d829mr32031741pfc.63.1669229666479; Wed, 23
 Nov 2022 10:54:26 -0800 (PST)
MIME-Version: 1.0
References: <20221114131403.GA3807058@u2004> <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004> <Y3LG/+wWSSj6ZYzl@monkey>
 <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp> <Y31xw1DcqXGx86Fz@monkey>
In-Reply-To: <Y31xw1DcqXGx86Fz@monkey>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 23 Nov 2022 10:54:15 -0800
Message-ID: <CAHbLzkqhewJ27Er-nuhm18oSZtFxb0BE4a-SvGoZsc5M6+=yxQ@mail.gmail.com>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        James Houghton <jthoughton@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 22, 2022 at 5:05 PM Mike Kravetz <mike.kravetz@oracle.com> wrot=
e:
>
> On 11/15/22 01:16, HORIGUCHI NAOYA(=E5=A0=80=E5=8F=A3 =E7=9B=B4=E4=B9=9F)=
 wrote:
> > On Mon, Nov 14, 2022 at 02:53:51PM -0800, Mike Kravetz wrote:
> > > On 11/15/22 07:39, Naoya Horiguchi wrote:
> > > > On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> > > > > On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > > > > > Hi,
> > > > > >
> > > > > > I'd like to request the follow commits to be backported to 5.15=
.y.
> > > > > >
> > > > > > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling=
")
> > > > > > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correct=
ly")
> > > > > > - a76054266661 ("mm: shmem: don't truncate page if memory failu=
re happens")
> > > > > >
> > > > > > These patches fixed a data lost issue by preventing shmem pagec=
ache from
> > > > > > being removed by memory error.  These were not tagged for stabl=
e originally,
> > > > > > but that's revisited recently.
> > > > >
> > > > > And have you tested that these all apply properly (and in which o=
rder?)
> > > >
> > > > Yes, I've checked that these cleanly apply (without any change) on
> > > > 5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next=
,
> > > > then a76054).
> > > >
> > > > > and work correctly?
> > > >
> > > > Yes, I ran related testcases in my test suite, and their status cha=
nged
> > > > FAIL to PASS with these patches.
> > >
> > > Hi Naoya,
> > >
> > > Just curious if you have plans to do backports for earlier releases?
> >
> > I didn't have a clear plan.  I just thought that we should backport to
> > earlier kernels if someone want and the patches are applicable easily
> > enough and well-tested.
> >
> > >
> > > If not, I can start that effort.  We have seen data loss/corruption b=
ecause of
> > > this on a 4.14 based release.   So, I would go at least that far back=
.
> >
> > Thank you for raising hand, that's really helpful.
> >
> > Maybe dd0f230a0a80 ("[PATCH] hugetlbfs: don't delete error page from
> > pagecbache") should be considered to backport together, because it's
> > the similar issue and reported (a while ago) to fail to backport.
> > dd0f230a0a80 does not apply cleanly on top of 5.15.78 + the above 3 pat=
ches.
> > So I need check more and will update my current proposal for 5.15.y.
>
> When working with 5.10.y, I noticed that commit eac96c3efdb5 ("mm: filema=
p:
> check if THP has hwpoisoned subpage for PMD page fault") as well as the
> prereq commit c7cb42e94473 ("mm: hwpoison: remove the unnecessary THP che=
ck")
> were not backported to 5.10.y.  Without those patches, THP testing will
> fail.
>
> Naoya and Yang Shi, does that sound right?

Yes, since the hwpoisoned THP will be kept in page cache so the page
fault may happen on it again, without that commit the page fault won't
return -EHWPOISON if I remember correctly.

>
> I have backports for those as well but want to check if you think
> anything else is needed.

Thanks for backporting them. No more fix is needed AFAICT.

> --
> Mike Kravetz
