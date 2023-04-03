Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3058C6D4A40
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbjDCOpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbjDCOpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:45:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660AF16971
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4800BB81D35
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFB2C433D2;
        Mon,  3 Apr 2023 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533098;
        bh=vuW0vUuDsrbF6EdZBmyISlMkpcKD10t+InuXT0eDUMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWsjHtjzPp2si+3l1kmEFy+DgEJobwJl+LUG74SlJ7pUG4d4xbkemt14n6rIecDyD
         QgLLDbB5xTnzEDFYG672hlFYGxxeQuUkOTPlio8R2BS8hFeTz01xwB34b8W+Epi+rC
         ivZ/MtvST6e8JEQMelFgfi1G5LMNzsG+3ASIUr5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Nick Terrell <terrelln@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 023/187] zstd: Fix definition of assert()
Date:   Mon,  3 Apr 2023 16:07:48 +0200
Message-Id: <20230403140416.787278477@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit 6906598f1ce93761716d780b6e3f171e13f0f4ce ]

assert(x) should emit a warning if x is false. WARN_ON(x) emits a
warning if x is true. Thus, assert(x) should be defined as WARN_ON(!x)
rather than WARN_ON(x).

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Nick Terrell <terrelln@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/zstd/common/zstd_deps.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/zstd/common/zstd_deps.h b/lib/zstd/common/zstd_deps.h
index 7a5bf44839c9c..f06df065dec01 100644
--- a/lib/zstd/common/zstd_deps.h
+++ b/lib/zstd/common/zstd_deps.h
@@ -84,7 +84,7 @@ static uint64_t ZSTD_div64(uint64_t dividend, uint32_t divisor) {
 
 #include <linux/kernel.h>
 
-#define assert(x) WARN_ON((x))
+#define assert(x) WARN_ON(!(x))
 
 #endif /* ZSTD_DEPS_ASSERT */
 #endif /* ZSTD_DEPS_NEED_ASSERT */
-- 
2.39.2



