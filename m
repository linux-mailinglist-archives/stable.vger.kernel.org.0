Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDE95405F3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346989AbiFGRca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347438AbiFGRao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A66110AFD;
        Tue,  7 Jun 2022 10:26:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 527676127C;
        Tue,  7 Jun 2022 17:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617D8C385A5;
        Tue,  7 Jun 2022 17:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622807;
        bh=EYs9ncx94BaVVOEcgi9lPfmZq5mNYDCe5PE0656+Wsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itx+gUYbQhEnQ4JOmyoqimqcEVjaGBuRx2sIp3JI8rrYaeO2qrJIThaaolsikl+td
         kCaAuyu00rbcMKCuVUqwORCu5sSvYgLWdwMxjsTqsLQ1GtTw65v2KnxLtPPq3vO5dY
         HMnvsz/71gVeCQCJgRvO6jX7OjFgfP1rUqGCTmvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/452] arm64: fix types in copy_highpage()
Date:   Tue,  7 Jun 2022 19:00:46 +0200
Message-Id: <20220607164914.193828624@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit 921d161f15d6b090599f6a8c23f131969edbd1fa ]

In copy_highpage() the `kto` and `kfrom` local variables are pointers to
struct page, but these are used to hold arbitrary pointers to kernel memory
. Each call to page_address() returns a void pointer to memory associated
with the relevant page, and copy_page() expects void pointers to this
memory.

This inconsistency was introduced in commit 2563776b41c3 ("arm64: mte:
Tags-aware copy_{user_,}highpage() implementations") and while this
doesn't appear to be harmful in practice it is clearly wrong.

Correct this by making `kto` and `kfrom` void pointers.

Fixes: 2563776b41c3 ("arm64: mte: Tags-aware copy_{user_,}highpage() implementations")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Link: https://lore.kernel.org/r/20220420030418.3189040-3-tongtiangen@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/copypage.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 70a71f38b6a9..24913271e898 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -16,8 +16,8 @@
 
 void copy_highpage(struct page *to, struct page *from)
 {
-	struct page *kto = page_address(to);
-	struct page *kfrom = page_address(from);
+	void *kto = page_address(to);
+	void *kfrom = page_address(from);
 
 	copy_page(kto, kfrom);
 
-- 
2.35.1



