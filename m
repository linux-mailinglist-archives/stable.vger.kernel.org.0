Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0F5657ED9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiL1P6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbiL1P6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:58:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5941183AE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 527D6B81730
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A08C433D2;
        Wed, 28 Dec 2022 15:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243095;
        bh=GL4mJz2xseuJ8mFyrNVjfF7MC9nm8IiQbGRDw+mH5AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uy4SAD1/KLRvjWbVDXuLJ4ATpAd4Hl9qkx7feLKj77l77NrWPoWJI57kQ34jrQ07A
         g2d54WG+r9iVTn3E0oimbdi63GrWEW1i56Tjsp0CDNUl2Jjh9cM+pKjtKtlYEO1M2j
         ZjMaq5LJQQ7bonhEbMNdQECEvSLsEap8io8N/Fpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Karolina Drobnik <karolinadrobnik@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        "Tyler Hicks (Microsoft)" <code@tyhicks.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 683/731] tools/include: Add _RET_IP_ and math definitions to kernel.h
Date:   Wed, 28 Dec 2022 15:43:10 +0100
Message-Id: <20221228144316.268824360@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karolina Drobnik <karolinadrobnik@gmail.com>

commit 5cf67a6051ea2558fd7c3d39c5a808db73073e9d upstream.

Add max_t, min_t and clamp functions, together with _RET_IP_
definition, so they can be used in testing.

Signed-off-by: Karolina Drobnik <karolinadrobnik@gmail.com>
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/r/230fea382cb1e1659cdd52a55201854d38a0a149.1643796665.git.karolinadrobnik@gmail.com
[tyhicks: Backport around contextual differences due to the lack of v5.16 commit
 d6e6a27d960f ("tools: Fix math.h breakage"). That commit fixed a commit
 that was merged in v5.16-rc1 and, therefore, doesn't need to go back to
 the stable branches.]
Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/kernel.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
index a7e54a08fb54..c2e109860fbc 100644
--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -14,6 +14,8 @@
 #define UINT_MAX	(~0U)
 #endif
 
+#define _RET_IP_		((unsigned long)__builtin_return_address(0))
+
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 
 #define PERF_ALIGN(x, a)	__PERF_ALIGN_MASK(x, (typeof(x))(a)-1)
@@ -52,6 +54,10 @@
 	_min1 < _min2 ? _min1 : _min2; })
 #endif
 
+#define max_t(type, x, y)	max((type)x, (type)y)
+#define min_t(type, x, y)	min((type)x, (type)y)
+#define clamp(val, lo, hi)	min((typeof(val))max(val, lo), hi)
+
 #ifndef roundup
 #define roundup(x, y) (                                \
 {                                                      \
-- 
2.35.1



