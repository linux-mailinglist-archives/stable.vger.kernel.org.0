Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5769696C11
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 18:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbjBNRyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 12:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbjBNRyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 12:54:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B242734
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 09:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0206A617D4
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 17:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED906C433EF;
        Tue, 14 Feb 2023 17:54:20 +0000 (UTC)
Date:   Tue, 14 Feb 2023 17:54:17 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     andreyknvl@gmail.com,
        Qun-wei Lin =?utf-8?B?KOael+e+pOW0tCk=?= 
        <Qun-wei.Lin@mediatek.com>,
        Guangye Yang =?utf-8?B?KOadqOWFieS4mik=?= 
        <guangye.yang@mediatek.com>, linux-mm@kvack.org,
        Chinwen Chang =?utf-8?B?KOW8temMpuaWhyk=?= 
        <chinwen.chang@mediatek.com>, kasan-dev@googlegroups.com,
        ryabinin.a.a@gmail.com, linux-arm-kernel@lists.infradead.org,
        vincenzo.frascino@arm.com, will@kernel.org, eugenis@google.com,
        Kuan-Ying Lee =?utf-8?B?KOadjuWGoOepjik=?= 
        <Kuan-Ying.Lee@mediatek.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Reset KASAN tag in copy_highpage with HW tags only
Message-ID: <Y+vKyZQVeofdcX4V@arm.com>
References: <20230214015214.747873-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230214015214.747873-1-pcc@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 13, 2023 at 05:52:14PM -0800, Peter Collingbourne wrote:
> During page migration, the copy_highpage function is used to copy the
> page data to the target page. If the source page is a userspace page
> with MTE tags, the KASAN tag of the target page must have the match-all
> tag in order to avoid tag check faults during subsequent accesses to the
> page by the kernel. However, the target page may have been allocated in
> a number of ways, some of which will use the KASAN allocator and will
> therefore end up setting the KASAN tag to a non-match-all tag. Therefore,
> update the target page's KASAN tag to match the source page.
> 
> We ended up unintentionally fixing this issue as a result of a bad
> merge conflict resolution between commit e059853d14ca ("arm64: mte:
> Fix/clarify the PG_mte_tagged semantics") and commit 20794545c146 ("arm64:
> kasan: Revert "arm64: mte: reset the page tag in page->flags""), which
> preserved a tag reset for PG_mte_tagged pages which was considered to be
> unnecessary at the time. Because SW tags KASAN uses separate tag storage,
> update the code to only reset the tags when HW tags KASAN is enabled.

Does KASAN_SW_TAGS work together with MTE? In theory they should but I
wonder whether we have other places calling page_kasan_tag_reset()
without the kasan_hw_tags_enabled() check.

> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Link: https://linux-review.googlesource.com/id/If303d8a709438d3ff5af5fd85706505830f52e0c
> Reported-by: "Kuan-Ying Lee (李冠穎)" <Kuan-Ying.Lee@mediatek.com>
> Cc: <stable@vger.kernel.org> # 6.1

What are we trying to fix? The removal of page_kasan_tag_reset() in
copy_highpage()? If yes, I think we should use:

Fixes: 20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"")
Cc: <stable@vger.kernel.org> # 6.0.x

-- 
Catalin
