Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1C16370B8
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 04:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiKXDD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 22:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKXDD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 22:03:57 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9188C285F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 19:03:56 -0800 (PST)
Date:   Thu, 24 Nov 2022 12:03:45 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669259034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h4H4uc+fqB74xMpI0j4ke//JC7+Z9czrxb/2KPqCmJs=;
        b=xBQtZ5iCvqYUMO41yIkqupPKCwtg0VqwE62wcGaiszFQMdNzrY4czMLwSVL+aTiDRVA4gz
        95ru1euia8P+R0u8UNC0VWu0eGKe3vKq/rrhQXuYDWWhjPAjNlrLMekey8Y4j6GyCytXrR
        FtLzZk//yzMCajqW6fkF7m1GdhzkVZc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Naoya Horiguchi <naoya.horiguchi@linux.dev>
To:     Yang Shi <shy828301@gmail.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        HORIGUCHI =?utf-8?B?TkFPWUEo5aCA5Y+jIOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>, Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        James Houghton <jthoughton@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <20221124030345.GA1300899@u2004>
References: <20221114131403.GA3807058@u2004>
 <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004>
 <Y3LG/+wWSSj6ZYzl@monkey>
 <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp>
 <Y31xw1DcqXGx86Fz@monkey>
 <CAHbLzkqhewJ27Er-nuhm18oSZtFxb0BE4a-SvGoZsc5M6+=yxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkqhewJ27Er-nuhm18oSZtFxb0BE4a-SvGoZsc5M6+=yxQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 10:54:15AM -0800, Yang Shi wrote:
> On Tue, Nov 22, 2022 at 5:05 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
> >
> > On 11/15/22 01:16, HORIGUCHI NAOYA(堀口 直也) wrote:
> > > On Mon, Nov 14, 2022 at 02:53:51PM -0800, Mike Kravetz wrote:
> > > > On 11/15/22 07:39, Naoya Horiguchi wrote:
> > > > > On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> > > > > > On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > > > > > > Hi,
> > > > > > >
> > > > > > > I'd like to request the follow commits to be backported to 5.15.y.
> > > > > > >
> > > > > > > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > > > > > > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > > > > > > - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > > > > > >
> > > > > > > These patches fixed a data lost issue by preventing shmem pagecache from
> > > > > > > being removed by memory error.  These were not tagged for stable originally,
> > > > > > > but that's revisited recently.
> > > > > >
> > > > > > And have you tested that these all apply properly (and in which order?)
> > > > >
> > > > > Yes, I've checked that these cleanly apply (without any change) on
> > > > > 5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next,
> > > > > then a76054).
> > > > >
> > > > > > and work correctly?
> > > > >
> > > > > Yes, I ran related testcases in my test suite, and their status changed
> > > > > FAIL to PASS with these patches.
> > > >
> > > > Hi Naoya,
> > > >
> > > > Just curious if you have plans to do backports for earlier releases?
> > >
> > > I didn't have a clear plan.  I just thought that we should backport to
> > > earlier kernels if someone want and the patches are applicable easily
> > > enough and well-tested.
> > >
> > > >
> > > > If not, I can start that effort.  We have seen data loss/corruption because of
> > > > this on a 4.14 based release.   So, I would go at least that far back.
> > >
> > > Thank you for raising hand, that's really helpful.
> > >
> > > Maybe dd0f230a0a80 ("[PATCH] hugetlbfs: don't delete error page from
> > > pagecbache") should be considered to backport together, because it's
> > > the similar issue and reported (a while ago) to fail to backport.
> > > dd0f230a0a80 does not apply cleanly on top of 5.15.78 + the above 3 patches.
> > > So I need check more and will update my current proposal for 5.15.y.
> >
> > When working with 5.10.y, I noticed that commit eac96c3efdb5 ("mm: filemap:
> > check if THP has hwpoisoned subpage for PMD page fault") as well as the
> > prereq commit c7cb42e94473 ("mm: hwpoison: remove the unnecessary THP check")
> > were not backported to 5.10.y.  Without those patches, THP testing will
> > fail.
> >
> > Naoya and Yang Shi, does that sound right?
>
> Yes, since the hwpoisoned THP will be kept in page cache so the page
> fault may happen on it again, without that commit the page fault won't
> return -EHWPOISON if I remember correctly.
>
> >
> > I have backports for those as well but want to check if you think
> > anything else is needed.
>
> Thanks for backporting them. No more fix is needed AFAICT.

I agree with Yang.  There seems no other commit related to current
pagecache problem but not backported yet.

Thanks,
Naoya Horiguchi
