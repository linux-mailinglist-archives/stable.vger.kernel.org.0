Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485FC606E40
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 05:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiJUDTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 23:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJUDTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 23:19:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD361D93EE;
        Thu, 20 Oct 2022 20:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q2CsU9j35e4opIsKqxE71Di4rOM/M7grRBS9sfeC9eM=; b=VRkt09LE12jN447t+9ZjNlQneq
        TG6kAL+F7qkxWLD8MJG4PD7/q7Q9z7SnToGHAdK6SpkKc0Qx24OqI4qE322xr8HW2IzEF8gBcE54c
        2bExxK3EfSh+l8bNqn6RgaoyDekYLSjw+HM4Og6I13AgL7n8WsUhze1P28t/ZH1gm3eDTA0RV4byz
        4GlsSsRpmpHllBMgf/sOZS3LAyNrmKXGz+7gry6mcOcG428wJ7fqJcRnxamMMn9gp9dICYwGiU2jO
        SdPc/4Hfi6lg4U46AVM9VXAovDohnJYFzWyb6TJiFKg/krY5NZ8Ig0s948CGEKeTry6tbgvlyVh58
        7iDDJciw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oliYs-00Cqfq-Rs; Fri, 21 Oct 2022 03:19:07 +0000
Date:   Fri, 21 Oct 2022 04:19:06 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Maria Yu <quic_aiquny@quicinc.com>
Cc:     akpm@linux-foundation.org, ziy@nvidia.com, david@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mike.kravetz@oracle.com, opendmb@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_isolation: fix clang deadcode warning
Message-ID: <Y1IPqhVpiehRBGNS@casper.infradead.org>
References: <20221021030953.34925-1-quic_aiquny@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021030953.34925-1-quic_aiquny@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 11:09:53AM +0800, Maria Yu wrote:
> When !CONFIG_VM_BUG_ON, there is warning of
> clang-analyzer-deadcode.DeadStores:
> Value stored to 'mt' during its initialization
> is never read.

Honestly, the cure is worse than the disease.  I'd rather not have a
line that's this long.

> -		int mt = get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
> -
> -		VM_BUG_ON(!is_migrate_isolate(mt));
> +		VM_BUG_ON(!is_migrate_isolate(get_pageblock_migratetype(pfn_to_page(isolate_pageblock))));
