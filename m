Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B38769F948
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 17:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjBVQrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 11:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjBVQrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 11:47:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10123D938
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 08:47:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FCAC6132C
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 16:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5E5C433D2;
        Wed, 22 Feb 2023 16:46:58 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     andreyknvl@gmail.com, Peter Collingbourne <pcc@google.com>
Cc:     Will Deacon <will@kernel.org>,
        Qun-wei Lin <Qun-wei.Lin@mediatek.com>,
        Guangye Yang <guangye.yang@mediatek.com>, linux-mm@kvack.org,
        Chinwen Chang <chinwen.chang@mediatek.com>,
        kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com,
        linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        eugenis@google.com, Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64: Reset KASAN tag in copy_highpage with HW tags only
Date:   Wed, 22 Feb 2023 16:46:56 +0000
Message-Id: <167708438950.477413.8786796815107449095.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215050911.1433132-1-pcc@google.com>
References: <20230215050911.1433132-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Feb 2023 21:09:11 -0800, Peter Collingbourne wrote:
> During page migration, the copy_highpage function is used to copy the
> page data to the target page. If the source page is a userspace page
> with MTE tags, the KASAN tag of the target page must have the match-all
> tag in order to avoid tag check faults during subsequent accesses to the
> page by the kernel. However, the target page may have been allocated in
> a number of ways, some of which will use the KASAN allocator and will
> therefore end up setting the KASAN tag to a non-match-all tag. Therefore,
> update the target page's KASAN tag to match the source page.
> 
> [...]

Applied to arm64 (for-next/core), thanks!

[1/1] arm64: Reset KASAN tag in copy_highpage with HW tags only
      https://git.kernel.org/arm64/c/e74a68468062

-- 
Catalin

