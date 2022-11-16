Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF3062B63A
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 10:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiKPJRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 04:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiKPJQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 04:16:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AD3636E
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 01:16:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 145CD61B20
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 09:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D14DC433C1;
        Wed, 16 Nov 2022 09:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668590198;
        bh=mN/GYXPUK/cgG2rFY58a57XnliiG0/yQN4/WhO8m/8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RUraSMAEK7XQFcDPMJRXdItdpjQ1l1PvPa95BhlfI5+DDS1tS+t2lb4W1h1+uj3++
         lQIYHm/mFJo0hdKPhRyegB0RSTjPr4aYDSbspb2pnyFIQWyBROKHnSL1y/+KHd6/PF
         mYHnx8EsxJZNRA1kCnEJmHlBzwqsxTffXIKQJpoY=
Date:   Wed, 16 Nov 2022 10:16:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc:     stable@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <Y3SqdCSdvJGz35ku@kroah.com>
References: <20221114131403.GA3807058@u2004>
 <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114223900.GA3883066@u2004>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 07:39:00AM +0900, Naoya Horiguchi wrote:
> On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> > On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > > Hi,
> > > 
> > > I'd like to request the follow commits to be backported to 5.15.y.
> > > 
> > > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > > - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > > 
> > > These patches fixed a data lost issue by preventing shmem pagecache from
> > > being removed by memory error.  These were not tagged for stable originally,
> > > but that's revisited recently.
> > 
> > And have you tested that these all apply properly (and in which order?)
> 
> Yes, I've checked that these cleanly apply (without any change) on
> 5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next,
> then a76054).
> 
> > and work correctly?
> 
> Yes, I ran related testcases in my test suite, and their status changed
> FAIL to PASS with these patches.

Great, all now queued up, thanks.

greg k-h
