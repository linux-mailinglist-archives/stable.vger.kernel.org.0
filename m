Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB8A6A30C2
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjBZOxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjBZOwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:52:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5BB1A494;
        Sun, 26 Feb 2023 06:49:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A653860C58;
        Sun, 26 Feb 2023 14:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657E5C433D2;
        Sun, 26 Feb 2023 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422880;
        bh=w+h52hvnhQo5lNcm23tac3TAxBW43PYXPti+xpjvico=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rT8tVsT8IA1vMT64UGi93J6I/Uunf639N2McyXNkUtUXTLPYH3Chj0j/nn2o5a9hK
         cszpx1JXuN1N1oD6XmGTZTQuTxdVJgiIVZfS82sdbI/fJE/aei3ZH5aILG7EqvPnRv
         W5jf5QCZf9w9isccDZVnheBE8ll1NBWSsQ9N8ZOr3RampP4sYA+99plYvwNPjy6iQJ
         l+3tVm+zON8vFKmrMqKmywvcNAtcp81K+1k+769arQHUxnlt412ONHWi8KecjJpOKy
         NP+lzL9CY8bkH9iUTL04NHLoQI3gXofQyPuoYRBKB5YKtmRHHo7OpUaNJeAQNWwzb5
         BG/Eioca6Ic3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 31/49] tools/power/x86/intel-speed-select: Add Emerald Rapid quirk
Date:   Sun, 26 Feb 2023 09:46:31 -0500
Message-Id: <20230226144650.826470-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 61f9fdcdcd01f9a996b6db4e7092fcdfe8414ad5 ]

Need memory frequency quirk as Sapphire Rapids in Emerald Rapids.
So add Emerald Rapids CPU model check in is_spr_platform().

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
[srinivas.pandruvada@linux.intel.com: Subject, changelog and code edits]
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index a160bad291eb7..be3668d37d654 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -110,7 +110,7 @@ int is_skx_based_platform(void)
 
 int is_spr_platform(void)
 {
-	if (cpu_model == 0x8F)
+	if (cpu_model == 0x8F || cpu_model == 0xCF)
 		return 1;
 
 	return 0;
-- 
2.39.0

