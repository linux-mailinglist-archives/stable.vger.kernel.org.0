Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C977E601EC3
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiJRANF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiJRALK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:11:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E4489817;
        Mon, 17 Oct 2022 17:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EE4A61324;
        Tue, 18 Oct 2022 00:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF69C43470;
        Tue, 18 Oct 2022 00:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051747;
        bh=XQU6IxSFDDludMCvBY1NmvN3jKyoAOUTtqBbNtntPgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1hohrrQWUcfcS0ePPSdKGD3wjqqMbnoL5in0x4udRvZSuIoA5MFhZVxnoKXEZ0yJ
         JKoCkwOXWg5SNxL8Cbp5pfr4TJhEuXsI5J8ItA4pZfusMDEnXkX6nN6BW+kNCbi41p
         RunF+qtnAMFBTYMkffsZJ3m6NC5HC2Kp3r4fvsZe3WWfsxLHObqnUUzK4XTh1kXvuv
         rjMf9XU2tj9a5/lQt0nCOqVuHvVsOABcA0jcFWjsW+s1hAx56MgZsBkHX2pawTyZNR
         Wra/5RGZUS+AECu1qe1HQJwe8Jd+SqQvO8SJLoYlJQS/5steEbKyozOMLHdWw1Id4b
         t8HQBbY6VYtbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 15/29] kbuild: take into account DT_SCHEMA_FILES changes while checking dtbs
Date:   Mon, 17 Oct 2022 20:08:24 -0400
Message-Id: <20221018000839.2730954-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000839.2730954-1-sashal@kernel.org>
References: <20221018000839.2730954-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d7c6ea024c08bbdb799768f51ffd9fdd6236d190 ]

It is useful to be able to recheck dtbs files against a limited set of
DT schema files. This can be accomplished by using differnt
DT_SCHEMA_FILES argument values while rerunning make dtbs_check. However
for some reason if_changed_rule doesn't pick up the rule_dtc changes
(and doesn't retrigger the build).

Fix this by changing if_changed_rule to if_changed_dep and squashing DTC
and dt-validate into a single new command. Then if_changed_dep triggers
on DT_SCHEMA_FILES changes and reruns the build/check.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220915114422.79378-1-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.lib | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 3fb6a99e78c4..cec0560f6ac6 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -371,17 +371,15 @@ DT_CHECKER_FLAGS ?= $(if $(DT_SCHEMA_FILES),-l $(DT_SCHEMA_FILES),-m)
 DT_BINDING_DIR := Documentation/devicetree/bindings
 DT_TMP_SCHEMA := $(objtree)/$(DT_BINDING_DIR)/processed-schema.json
 
-quiet_cmd_dtb_check =	CHECK   $@
-      cmd_dtb_check =	$(DT_CHECKER) $(DT_CHECKER_FLAGS) -u $(srctree)/$(DT_BINDING_DIR) -p $(DT_TMP_SCHEMA) $@ || true
+quiet_cmd_dtb =	DTC_CHK $@
+      cmd_dtb =	$(cmd_dtc) ; $(DT_CHECKER) $(DT_CHECKER_FLAGS) -u $(srctree)/$(DT_BINDING_DIR) -p $(DT_TMP_SCHEMA) $@ || true
+else
+quiet_cmd_dtb = $(quiet_cmd_dtc)
+      cmd_dtb = $(cmd_dtc)
 endif
 
-define rule_dtc
-	$(call cmd_and_fixdep,dtc)
-	$(call cmd,dtb_check)
-endef
-
 $(obj)/%.dtb: $(src)/%.dts $(DTC) $(DT_TMP_SCHEMA) FORCE
-	$(call if_changed_rule,dtc)
+	$(call if_changed_dep,dtb)
 
 $(obj)/%.dtbo: $(src)/%.dts $(DTC) FORCE
 	$(call if_changed_dep,dtc)
-- 
2.35.1

