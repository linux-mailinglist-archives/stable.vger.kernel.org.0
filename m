Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC51A6DA5B7
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 00:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbjDFWZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 18:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238521AbjDFWZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 18:25:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5476AA5EA;
        Thu,  6 Apr 2023 15:25:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E58DC60B4A;
        Thu,  6 Apr 2023 22:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7B5C4339C;
        Thu,  6 Apr 2023 22:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819921;
        bh=POcrBfS5KWYTL3150CQlbiuXIeiUWyNtp77r2d/bEKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z9GcPeDky5bXJIS5FPZvkZRQLwPX1vosICtCydDasYwnvWQAHXcgHSRK94G7k3PyW
         HCI+J1rY2pqaZR9VS+XlL7EuXxjy53E3Gg0xsLg+hNRHLWr7FeHfb5GHkFiKaQEVyb
         3aR95I7JT6+jddfjG4EZUQKBvbOGbwAw95KQD6hY=
Date:   Thu, 6 Apr 2023 15:25:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] mm: vmscan: ignore non-LRU-based reclaim in
 memcg reclaim
Message-Id: <20230406152519.b57c4fb4da75e0b5142de2b0@linux-foundation.org>
In-Reply-To: <a8cb406a-70cd-aa47-fdda-50cd0eb8c941@redhat.com>
References: <20230405185427.1246289-1-yosryahmed@google.com>
        <20230405185427.1246289-2-yosryahmed@google.com>
        <a8cb406a-70cd-aa47-fdda-50cd0eb8c941@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Apr 2023 12:30:56 +0200 David Hildenbrand <david@redhat.com> wrote:

> Otherwise it's hard to judge how far to backport this.

The case for backporting sounded rather unconvincing to me, which is
why I'm still sitting on the v4 series.

What are your thoughts on the desirability of a backport?

It makes sense to design the forthcoming v6 series for backportability,
so that even if we decide "no", others can still take it easily if they
wish to.

