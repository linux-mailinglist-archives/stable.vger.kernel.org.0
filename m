Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4631F5B8FC1
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 22:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiINUti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 16:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiINUtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 16:49:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4011B3C;
        Wed, 14 Sep 2022 13:49:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE60E61D3A;
        Wed, 14 Sep 2022 20:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAFDC433C1;
        Wed, 14 Sep 2022 20:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663188568;
        bh=gxi18X7LFH/rzmBn2mQG5Ml5iaadp1E8KUQNbCcmOCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ak7zE0y0MZXOAPXK0wge44cCiiKzYa9if0LFLhCCq6RsPV5o9oSYnDid2X6mxW2zm
         veNajCDmhp+Y/EBBadU7Y8Ld5EAAMcwA/tf6CwqajNJKOpFh1yPePlgejHkA9j7ntQ
         Z/8Da/hLyefCb18wxNWThBSYjkYkpNT5wp7nQ3r8=
Date:   Wed, 14 Sep 2022 13:49:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Doug Berger <opendmb@gmail.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: correct demote page offset logic
Message-Id: <20220914134927.16c229ccdc1a6b9da5d698c3@linux-foundation.org>
In-Reply-To: <20220914190917.3517663-1-opendmb@gmail.com>
References: <20220914190917.3517663-1-opendmb@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Sep 2022 12:09:17 -0700 Doug Berger <opendmb@gmail.com> wrote:

> With gigantic pages it may not be true that struct page structures
> are contiguous across the entire gigantic page. The nth_page macro
> is used here in place of direct pointer arithmetic to correct for
> this.

What were the user-visible runtime effects of this bug?
