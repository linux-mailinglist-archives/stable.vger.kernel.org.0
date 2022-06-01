Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8461853A822
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354323AbiFAOGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354881AbiFAOFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:05:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CF0AE44B;
        Wed,  1 Jun 2022 06:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39F856163D;
        Wed,  1 Jun 2022 13:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D55EC385B8;
        Wed,  1 Jun 2022 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091956;
        bh=KJhUKllErRJpBntBCZwKFWW3K3q4jqc9MvCVLYA5Vgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMyy3HzkUA3LNCZfh2catNm3ksielIkc7CsIDPT0BJrPjkf8+uhpMBvUGiXDiZHxf
         +UfY71B5xnELiKiNXGRVxlxiCEGo+rOobAEizwkAlJbhFhO7grEGKqiuSWL7zZKqvO
         QZ/Rpy9PvWyURXUa1kZF7hRpYyZ4TqjDAF48JYOV7Kek73KZkwJ1eFAUAyiom1GkUX
         yAYM/sELA+SHHa1fEzqtfPOTnofqr2oKtDH1M61t+iUXq77nS01wwsu2i7pviZZAg4
         MzgJ85bTbLhrAVK4rxXNyD+IRxeHIJ/OSvdmrHEJvUwL9cXwh9k9QQvex3mvGPaALo
         YsdDp6qCmSRIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/20] selftests/resctrl: Change the default limited time to 120 seconds
Date:   Wed,  1 Jun 2022 09:58:49 -0400
Message-Id: <20220601135902.2004823-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135902.2004823-1-sashal@kernel.org>
References: <20220601135902.2004823-1-sashal@kernel.org>
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

