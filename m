Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B8C6E5561
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 01:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjDQXsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 19:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjDQXsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 19:48:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C67272A;
        Mon, 17 Apr 2023 16:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF74D6209F;
        Mon, 17 Apr 2023 23:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD1C433EF;
        Mon, 17 Apr 2023 23:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681775303;
        bh=5Zdo30UwbY/ugu5/xvKsTrl3c9ZrDjjdWYxF5rzZT84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sVSf3VXBkTRXrirTwU3FG2FBV7kU4yfoxfiWm7KupFJBq0aLURnd6HUp/GZlsbc+3
         AFA6HPhkZkm7DvYCkWOct6xO3S1WXD0jZ00eeJ32RV6LKYYYy5sHDNLNFe3wk4yRuR
         NXNS1wOJHqds6ummn+iJkFYaHoKPuy7smosu3Bic=
Date:   Mon, 17 Apr 2023 16:48:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mika =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] mm/hugetlb: Fix uffd-wp bit lost when unsharing
 happens
Message-Id: <20230417164822.d1f5d162115c53aab4c85e85@linux-foundation.org>
In-Reply-To: <20230417195317.898696-3-peterx@redhat.com>
References: <20230417195317.898696-1-peterx@redhat.com>
        <20230417195317.898696-3-peterx@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Apr 2023 15:53:13 -0400 Peter Xu <peterx@redhat.com> wrote:

> When we try to unshare a pinned page for a private hugetlb, uffd-wp bit can
> get lost during unsharing.  Fix it by carrying it over.
> 
> This should be very rare, only if an unsharing happened on a private
> hugetlb page with uffd-wp protected (e.g. in a child which shares the same
> page with parent with UFFD_FEATURE_EVENT_FORK enabled).

What are the user-visible consequences of the bug?

> Cc: linux-stable <stable@vger.kernel.org>

When proposing a backport, it's better to present the patch as a
standalone thing, against current -linus.  I'll then queue it in
mm-hotfixes and shall send it upstream during this -rc cycle.

As presented, this patch won't go upstream until after 6.3 is released,
and as it comes later in time, more backporting effort might be needed.

I can rework things if this fix is reasonably urgent (the "user-visible
consequences" info is the guide).  If not urgent, we can leave things
as they are.
