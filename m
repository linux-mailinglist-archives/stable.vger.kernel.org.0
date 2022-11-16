Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B2462CF3E
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 00:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiKPX65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 18:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiKPX6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 18:58:55 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6244D5C2
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 15:58:54 -0800 (PST)
Date:   Thu, 17 Nov 2022 08:58:42 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668643132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gjK5EzpHE+rDdWbI4MHlxAzITuMlzelLH4x2GZwCazc=;
        b=o3Qb3toyB6Nqyb4VmO9IHkoEhhvvGcmFH5Ggw9mC6iJ86KzyNhk92miGAXm2FtDDSLpLd4
        L3pM43dHhaR8aT3M3+a0wdKWT3YcKykF5IjFzzq5gp6hB6z9IVZsJXQ77ebRE4ocEtKfzk
        hePckGY4WWGGOguek6ZB6VYq+Xz3eeA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Naoya Horiguchi <naoya.horiguchi@linux.dev>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     HORIGUCHI =?utf-8?B?TkFPWUEo5aCA5Y+j44CA55u05LmfKQ==?= 
        <naoya.horiguchi@nec.com>, Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <20221116235842.GA62826@u2004>
References: <20221114131403.GA3807058@u2004>
 <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004>
 <Y3LG/+wWSSj6ZYzl@monkey>
 <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp>
 <Y3LrtTmLdBU7atso@monkey>
 <20221115063912.GA3928893@u2004>
 <Y3RdmvpUq3XzYqq+@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3RdmvpUq3XzYqq+@monkey>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 07:48:42PM -0800, Mike Kravetz wrote:
> On 11/15/22 15:39, Naoya Horiguchi wrote:
> > On Mon, Nov 14, 2022 at 05:30:29PM -0800, Mike Kravetz wrote:
> > > On 11/15/22 01:16, HORIGUCHI NAOYA(堀口 直也) wrote:
> > > > On Mon, Nov 14, 2022 at 02:53:51PM -0800, Mike Kravetz wrote:
> > > > > On 11/15/22 07:39, Naoya Horiguchi wrote:
> > > > > > On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> > > > > > > On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > I'd like to request the follow commits to be backported to 5.15.y.
> > > > > > > > 
> > > > > > > > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > > > > > > > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > > > > > > > - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > > > > > > > 
> > > > > > > > These patches fixed a data lost issue by preventing shmem pagecache from
> > > > > > > > being removed by memory error.  These were not tagged for stable originally,
> > > > > > > > but that's revisited recently.
> > > > > > > 
> > > > > > > And have you tested that these all apply properly (and in which order?)
> > > > > > 
> > > > > > Yes, I've checked that these cleanly apply (without any change) on
> > > > > > 5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next,
> > > > > > then a76054).
> > > > > > 
> > > > > > > and work correctly?
> > > > > > 
> > > > > > Yes, I ran related testcases in my test suite, and their status changed
> > > > > > FAIL to PASS with these patches.
> > > > > 
> > > > > Hi Naoya,
> > > > > 
> > > > > Just curious if you have plans to do backports for earlier releases?
> > > > 
> > > > I didn't have a clear plan.  I just thought that we should backport to
> > > > earlier kernels if someone want and the patches are applicable easily
> > > > enough and well-tested.
> > > > 
> > > > > 
> > > > > If not, I can start that effort.  We have seen data loss/corruption because of
> > > > > this on a 4.14 based release.   So, I would go at least that far back.
> > > > 
> > > > Thank you for raising hand, that's really helpful.
> > > > 
> > > > Maybe dd0f230a0a80 ("[PATCH] hugetlbfs: don't delete error page from
> > 
> > # I meant 8625147cafaa, sorry if the wrong commit ID confused you.
> > 
> > I tested with 8625147cafaa too, and it made hugetlb-related testcases
> > passed.
> <snip>
> > We need to slightly modify 8625147cafaa to apply to 5.15.y.  So in summary,
> > my updated suggestion for 5.15.y is like below:
> > 
> > - [1/4] cherry-pick dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > - [2/4] cherry-pick 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > - [3/4] cherry-pick a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > - [4/4] apply the following patch (as a modified version of 8625147cafaa)
> 
> Hi Naoya,
> 
> Just curious, do you have automated tests for this?  I wanted test backports
> to each stable release.  I could manually test, but that would be a bit
> involved and was hoping you had something automated.

Yes, related testcases are available on https://github.com/nhoriguchi/mm_regression.
You can run them by the following steps:

  $ git clone https://github.com/nhoriguchi/mm_regression.
  $ cd mm_regression

  # Check that your testing server meets the prerequisite
  # https://github.com/nhoriguchi/mm_regression#prerequisite    

  $ make
  ...
  # Compiler might show errors but that's OK because all
  # files are not needed to run relevant testcases.

  $ bash run.sh prepare debug

  # List the testcases in work/debug/recipelist like below:

  $ cat work/debug/recipelist
  mm/hwpoison/shmem_link/link-hard.auto3
  mm/hwpoison/shmem_link/link-sym.auto3
  mm/hwpoison/shmem_rw/thp-always.auto3
  mm/hwpoison/shmem_rw/thp-never.auto3

  $ bash run.sh project run

Thanks,
Naoya Horiguchi
