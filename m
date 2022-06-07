Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBC15413A0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353812AbiFGUDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357948AbiFGUCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FDF1C14F1;
        Tue,  7 Jun 2022 11:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F344161326;
        Tue,  7 Jun 2022 18:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1DCC3411C;
        Tue,  7 Jun 2022 18:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626323;
        bh=n7mdJGl0agHnUCSyXIFfvAF7u5JxOgJlNavYdXtgUdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynB6FOoIt/vo8SphvRLwxpCE9dioLdXPf8tvRJo9uPbTaLiYe9M8nFEwZTrzsHFND
         +uraW/9jJHCgqzQAc7dWgp20x0+/SZdF0K5LydRD/4rT2G9mRUI1DcMqe7IcZHtAMZ
         pP+mADUBkAgZhK3ASZhXYiug5uaVWINVU6pgHtIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 335/772] arm64: fix types in copy_highpage()
Date:   Tue,  7 Jun 2022 18:58:47 +0200
Message-Id: <20220607164958.895738878@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index b5447e53cd73..0dea80bf6de4 100644
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



