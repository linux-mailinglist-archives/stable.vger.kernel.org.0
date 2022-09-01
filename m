Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685075AA32B
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 00:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbiIAWfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 18:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiIAWfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 18:35:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5545A1DA4A;
        Thu,  1 Sep 2022 15:35:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 649E26202A;
        Thu,  1 Sep 2022 22:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2CEC433D7;
        Thu,  1 Sep 2022 22:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662071713;
        bh=7lqxqTpaMBwlZW0DSt1oaG7L/tirGOWXezyya6SssGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L8P4/+OWOF8vcXLf28d5JYnqkdP+h60aSW1hWyuT35xqluQ2xyMH8/Y9XF+m1xCwP
         GSwZ79909apGLOvVmpwhgfWdqVgbtL7n8qFx+tRrOIN8/sLwtL9drhhbVQhGHYB7uO
         Yi2wmOxfbogqjMu3T723bgBw12MFT/tGrs+G6W2s=
Date:   Thu, 1 Sep 2022 15:35:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Nadav Amit <namit@vmware.com>, Yang Shi <shy828301@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Christoph von Recklinghausen <crecklin@redhat.com>,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH v1] mm: fix PageAnonExclusive clearing racing with
 concurrent RCU GUP-fast
Message-Id: <20220901153512.a59e9e584fb00a350788f56e@linux-foundation.org>
In-Reply-To: <20220901083559.67446-1-david@redhat.com>
References: <20220901083559.67446-1-david@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  1 Sep 2022 10:35:59 +0200 David Hildenbrand <david@redhat.com> wrote:

> The possible issues due to reordering are of theoretical nature so far
> and attempts to reproduce the race failed.
> 
> Especially the "no PTE change" case isn't the common case, because we'd
> need an exclusive anonymous page that's mapped R/O and the PTE is clean
> in KSM code -- and using KSM with page pinning isn't extremely common.
> Further, the clear+TLB flush we used for now implies a memory barrier.
> So the problematic missing part should be the missing memory barrier
> after pinning but before checking if the PTE changed.

Obscure bug, large and tricky patch.  Is a -stable backport really
justifiable?

