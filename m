Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D249567938
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 23:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiGEVSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 17:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiGEVSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 17:18:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D5FB95;
        Tue,  5 Jul 2022 14:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FDBE61CB1;
        Tue,  5 Jul 2022 21:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0628BC341C7;
        Tue,  5 Jul 2022 21:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657055900;
        bh=fVMogeJmga7ig2AqAptnQCM6iwfe/+yH29ZcV4O2RYQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QWun8u4MHhoyUSkwZohNmRQwRv7GVlpNYY4UFDCOICjc5tU5TthBsgHZagQmAbVD1
         wiE67Q6NMkkaAqzWiUVvGH7ntoTYz1e7WXwoh+M8lHBN8tf/6A+o2eUAi6Cb/J8oDT
         YHuoio/B5MHzUnlBSZWENzYaWv+N3wQDwVEJ1Atc=
Date:   Tue, 5 Jul 2022 14:18:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     willy@infradead.org, jgg@ziepe.ca, jhubbard@nvidia.com,
        william.kucharski@oracle.com, dan.j.williams@intel.com,
        jack@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: fix missing wake-up event for FSDAX pages
Message-Id: <20220705141819.804eb972d43be3434dc70192@linux-foundation.org>
In-Reply-To: <20220705123532.283-1-songmuchun@bytedance.com>
References: <20220705123532.283-1-songmuchun@bytedance.com>
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

On Tue,  5 Jul 2022 20:35:32 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
> 1, then the page is freed.  The FSDAX pages can be pinned through GUP,
> then they will be unpinned via unpin_user_page() using a folio variant
> to put the page, however, folio variants did not consider this special
> case, the result will be to miss a wakeup event (like the user of
> __fuse_dax_break_layouts()).  Since FSDAX pages are only possible get
> by GUP users, so fix GUP instead of folio_put() to lower overhead.
> 

What are the user visible runtime effects of this bug?
