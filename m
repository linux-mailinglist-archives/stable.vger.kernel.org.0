Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE685AEB7D
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241529AbiIFOQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241194AbiIFOOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:14:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4002D258;
        Tue,  6 Sep 2022 06:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF781B818E0;
        Tue,  6 Sep 2022 13:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C769C433D6;
        Tue,  6 Sep 2022 13:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472076;
        bh=1UMg89GVgRfbCYyUL8mLu9H04/btJVZaNEypyFBJdzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e749Hn1+Qj3SIlauVGFzQoezr8vGeohrKhY5IhMFvE1cT/qwQDdYfGt6n3X7J41ZN
         Ta2ZE0uLDxO9m3F8SpRbzHBDJs4uNo0Gjphh44qtCo5SkHf8hIh5TL/OG6T7TIPy4v
         gXvPbRpym2wtAI0hwdwJ4tWG/Byw/MqfATyeLlYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 099/155] powerpc/papr_scm: Ensure rc is always initialized in papr_scm_pmu_register()
Date:   Tue,  6 Sep 2022 15:30:47 +0200
Message-Id: <20220906132833.654568002@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 6cf07810e9ef8535d60160d13bf0fd05f2af38e7 ]

Clang warns:

  arch/powerpc/platforms/pseries/papr_scm.c:492:6: warning: variable 'rc' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
          if (!p->stat_buffer_len)
              ^~~~~~~~~~~~~~~~~~~
  arch/powerpc/platforms/pseries/papr_scm.c:523:64: note: uninitialized use occurs here
          dev_info(&p->pdev->dev, "nvdimm pmu didn't register rc=%d\n", rc);
                                                                        ^~
  include/linux/dev_printk.h:150:67: note: expanded from macro 'dev_info'
          dev_printk_index_wrap(_dev_info, KERN_INFO, dev, dev_fmt(fmt), ##__VA_ARGS__)
                                                                          ^~~~~~~~~~~
  include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
                  _p_func(dev, fmt, ##__VA_ARGS__);                       \
                                      ^~~~~~~~~~~
  arch/powerpc/platforms/pseries/papr_scm.c:492:2: note: remove the 'if' if its condition is always false
          if (!p->stat_buffer_len)
          ^~~~~~~~~~~~~~~~~~~~~~~~
  arch/powerpc/platforms/pseries/papr_scm.c:484:8: note: initialize the variable 'rc' to silence this warning
          int rc, nodeid;
                ^
                = 0
  1 warning generated.

The call to papr_scm_pmu_check_events() was eliminated but a return code
was not added to the if statement. Add the same return code from
papr_scm_pmu_check_events() for this condition so there is no more
warning.

Fixes: 9b1ac04698a4 ("powerpc/papr_scm: Fix nvdimm event mappings")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/ClangBuiltLinux/linux/issues/1701
Link: https://lore.kernel.org/r/20220830151256.1473169-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 16bac4e0d7a21..92074a6c49d43 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -489,8 +489,10 @@ static void papr_scm_pmu_register(struct papr_scm_priv *p)
 		goto pmu_err_print;
 	}
 
-	if (!p->stat_buffer_len)
+	if (!p->stat_buffer_len) {
+		rc = -ENOENT;
 		goto pmu_check_events_err;
+	}
 
 	nd_pmu->pmu.task_ctx_nr = perf_invalid_context;
 	nd_pmu->pmu.name = nvdimm_name(p->nvdimm);
-- 
2.35.1



