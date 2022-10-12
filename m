Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2B45FC95F
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 18:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJLQg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 12:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiJLQg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 12:36:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0FEA2864
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 09:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 595C1B81B7B
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 16:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC21C433D6;
        Wed, 12 Oct 2022 16:36:53 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>, Steven Price <steven.price@arm.com>,
        stable@vger.kernel.org,
        syzbot+c2c79c6d6eddc5262b77@syzkaller.appspotmail.com,
        Andrey Konovalov <andreyknvl@gmail.com>, james.morse@arm.com,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        dvyukov@google.com
Subject: Re: [PATCH] arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or restored
Date:   Wed, 12 Oct 2022 17:36:50 +0100
Message-Id: <166559260711.1183596.702987381991575705.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221006163354.3194102-1-catalin.marinas@arm.com>
References: <20221006163354.3194102-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Oct 2022 17:33:54 +0100, Catalin Marinas wrote:
> Prior to commit 69e3b846d8a7 ("arm64: mte: Sync tags for pages where PTE
> is untagged"), mte_sync_tags() was only called for pte_tagged() entries
> (those mapped with PROT_MTE). Therefore mte_sync_tags() could safely use
> test_and_set_bit(PG_mte_tagged, &page->flags) without inadvertently
> setting PG_mte_tagged on an untagged page.
> 
> The above commit was required as guests may enable MTE without any
> control at the stage 2 mapping, nor a PROT_MTE mapping in the VMM.
> However, the side-effect was that any page with a PTE that looked like
> swap (or migration) was getting PG_mte_tagged set automatically. A
> subsequent page copy (e.g. migration) copied the tags to the destination
> page even if the tags were owned by KASAN.
> 
> [...]

Applied to arm64 (for-next/core), thanks!

[1/1] arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or restored
      https://git.kernel.org/arm64/c/a8e5e5146ad0

-- 
Catalin

