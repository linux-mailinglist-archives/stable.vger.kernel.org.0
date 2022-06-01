Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40FD53A791
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354189AbiFAOCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354911AbiFAOBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:01:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427FA4DF58;
        Wed,  1 Jun 2022 06:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46B6CB81B43;
        Wed,  1 Jun 2022 13:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A1EC34119;
        Wed,  1 Jun 2022 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091817;
        bh=KJhUKllErRJpBntBCZwKFWW3K3q4jqc9MvCVLYA5Vgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEnUK8AwaH6iAITMckIM/XCWLCJoOn3f+gBGY4TuUdJ6LApSL+ZGGN1gGWqVMMQi4
         ajHh5ErWnAwSXrhKD1UG1bOBkFBMvR+Q2yfJqRgq9/FTCkzwVmR6+RGnGgPFv/nJeL
         nJtmGRPnlqMWhThHsCJkJUMMAOuLkr7eX0qeDuKoY/QuqUU6+lCTRg3SuOsOGh3jVA
         Uz+n9vkR7NF3Kp/LvOYcPHj/CkUydAwFfoFKmnLZRjl1kpSenQsizkeV1qtwuWbrU4
         DlsktEn9Y3ksVbQWy8Y2100IVSywPuUOwiI7u7TQm6sSqcbBQQV9RusGKGDMW/xFDA
         nwbgm3b6Z5qLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/37] selftests/resctrl: Change the default limited time to 120 seconds
Date:   Wed,  1 Jun 2022 09:56:01 -0400
Message-Id: <20220601135622.2003939-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>

[ Upstream commit e2e3fb6ef0d6548defbe0be6e092397aaa92f3a1 ]

When testing on a Intel(R) Xeon(R) Gold 6254 CPU @ 3.10GHz the resctrl
selftests fail due to timeout after exceeding the default time limit of
45 seconds. On this system the test takes about 68 seconds.
Since the failing test by default accesses a fixed size of memory, the
execution time should not vary significantly between different environment.
A new default of 120 seconds should be sufficient yet easy to customize
with the introduction of the "settings" file for reference.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/settings | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/resctrl/settings

diff --git a/tools/testing/selftests/resctrl/settings b/tools/testing/selftests/resctrl/settings
new file mode 100644
index 000000000000..a383f3d4565b
--- /dev/null
+++ b/tools/testing/selftests/resctrl/settings
@@ -0,0 +1,3 @@
+# If running time is longer than 120 seconds when new tests are added in
+# the future, increase timeout here.
+timeout=120
-- 
2.35.1

