Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B01628C2E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbiKNWjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiKNWjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:39:12 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D6A167F1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 14:39:11 -0800 (PST)
Date:   Tue, 15 Nov 2022 07:39:00 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668465549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U4ISDoDUFZL6kUsJTzpMHgkewp9hDvaTzzAjTmu+C/4=;
        b=p1v4QZa6cDzlDqEPFygtE+AldqsKxb0P2MUqUxE4Q27bNdNtB52wlfOFzyRABBOPFn3mNQ
        NMeCDJ75kw9UBItuH+jZlkzhMTQXDKUVmoUdaXz601V26RUTslCsuWDqKcRCQQUYxPcywY
        S6JHtjxx4rg5FM3KrUuVJElyHV+zbok=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Naoya Horiguchi <naoya.horiguchi@linux.dev>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <20221114223900.GA3883066@u2004>
References: <20221114131403.GA3807058@u2004>
 <Y3JotyM0Flj5ijVW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3JotyM0Flj5ijVW@kroah.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > Hi,
> > 
> > I'd like to request the follow commits to be backported to 5.15.y.
> > 
> > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > 
> > These patches fixed a data lost issue by preventing shmem pagecache from
> > being removed by memory error.  These were not tagged for stable originally,
> > but that's revisited recently.
> 
> And have you tested that these all apply properly (and in which order?)

Yes, I've checked that these cleanly apply (without any change) on
5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next,
then a76054).

> and work correctly?

Yes, I ran related testcases in my test suite, and their status changed
FAIL to PASS with these patches.

Thanks,
Naoya Horiguchi
