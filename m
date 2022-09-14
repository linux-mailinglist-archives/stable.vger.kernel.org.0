Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5835B9088
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 00:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiINWmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 18:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiINWm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 18:42:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D168052E;
        Wed, 14 Sep 2022 15:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82ADFB81CFD;
        Wed, 14 Sep 2022 22:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59CDC433C1;
        Wed, 14 Sep 2022 22:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663195346;
        bh=OO9cwt5k8sVnjLdqSV7ImgJVM7V/9Yp3/23q+Xzx5dg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tcXAs+RecZt/TPAEon0Wwu0AJli3XGZ87E8Zl+Er+fCzCctuZRpg5a6MX3gl6Kkzr
         To9yjEWYSZoWntASAe2seUmwu2yCbQQOn3d48Pc86ecVVXrx1JX1re+pNGiWQN1/nL
         RahhHaN6JUuQP+oNMzMUWAzSZ4QkuHs4zhlqeDEM=
Date:   Wed, 14 Sep 2022 15:42:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Zi Yan <ziy@nvidia.com>
Cc:     Zi Yan <zi.yan@sent.com>, Doug Berger <opendmb@gmail.com>,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_isolation: fix isolate_single_pageblock()
 isolation behavior
Message-Id: <20220914154225.e3f8ad4b076236c75705b0f9@linux-foundation.org>
In-Reply-To: <20220914023913.1855924-1-zi.yan@sent.com>
References: <20220914023913.1855924-1-zi.yan@sent.com>
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

On Tue, 13 Sep 2022 22:39:13 -0400 Zi Yan <zi.yan@sent.com> wrote:

> set_migratetype_isolate() does not allow isolating MIGRATE_CMA pageblocks
> unless it is used for CMA allocation. isolate_single_pageblock() did not
> have the same behavior when it is used together with
> set_migratetype_isolate() in start_isolate_page_range(). This allows
> alloc_contig_range() with migratetype other than MIGRATE_CMA, like
> MIGRATE_MOVABLE (used by alloc_contig_pages()), to isolate first and last
> pageblock but fail the rest. The failure leads to changing migratetype
> of the first and last pageblock to MIGRATE_MOVABLE from MIGRATE_CMA,
> corrupting the CMA region. This can happen during gigantic page
> allocations.

How does this bug manifest itself as far as the user is concerned?

> Fix it by passing migratetype into isolate_single_pageblock(), so that
> set_migratetype_isolate() used by isolate_single_pageblock() will prevent
> the isolation happening.
