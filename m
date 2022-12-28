Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28ED657B3F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiL1PTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiL1PT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:19:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE0C13F9D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:19:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BE4B6154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F8BC433EF;
        Wed, 28 Dec 2022 15:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240764;
        bh=qzGdcX6DZmcrpreGIyBAinRiqOxSYUzrw+zsS6QIe7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7Ecv8+VRq0JpwpxW5ZvTypuhk38gyl+q4tgQjmwLiryE2gncnrRN7EFE7wk9O2e1
         cS2NxT8aiheHzele4t9pdSH86CbqZUBzs20OJ39OjXVkp7DHdGum1MywqJUoZxbmhO
         RvPFKWlwQtFUUfsnUoG7fHDcCAaomIWPR7hfU99Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Kuohai <xukuohai@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0200/1073] libbpf: Fix memory leak in parse_usdt_arg()
Date:   Wed, 28 Dec 2022 15:29:48 +0100
Message-Id: <20221228144333.449465142@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 0dc9254e03704c75f2ebc9cbef2ce4de83fba603 ]

In the arm64 version of parse_usdt_arg(), when sscanf returns 2, reg_name
is allocated but not freed. Fix it.

Fixes: 0f8619929c57 ("libbpf: Usdt aarch64 arg parsing support")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20221011120108.782373-3-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/usdt.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index d18e37982344..2ade9c7969d7 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -1348,25 +1348,23 @@ static int calc_pt_regs_off(const char *reg_name)
 
 static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
 {
-	char *reg_name = NULL;
+	char reg_name[16];
 	int arg_sz, len, reg_off;
 	long off;
 
-	if (sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3) {
+	if (sscanf(arg_str, " %d @ \[ %15[a-z0-9], %ld ] %n", &arg_sz, reg_name, &off, &len) == 3) {
 		/* Memory dereference case, e.g., -4@[sp, 96] */
 		arg->arg_type = USDT_ARG_REG_DEREF;
 		arg->val_off = off;
 		reg_off = calc_pt_regs_off(reg_name);
-		free(reg_name);
 		if (reg_off < 0)
 			return reg_off;
 		arg->reg_off = reg_off;
-	} else if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
+	} else if (sscanf(arg_str, " %d @ \[ %15[a-z0-9] ] %n", &arg_sz, reg_name, &len) == 2) {
 		/* Memory dereference case, e.g., -4@[sp] */
 		arg->arg_type = USDT_ARG_REG_DEREF;
 		arg->val_off = 0;
 		reg_off = calc_pt_regs_off(reg_name);
-		free(reg_name);
 		if (reg_off < 0)
 			return reg_off;
 		arg->reg_off = reg_off;
@@ -1375,12 +1373,11 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
 		arg->arg_type = USDT_ARG_CONST;
 		arg->val_off = off;
 		arg->reg_off = 0;
-	} else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
+	} else if (sscanf(arg_str, " %d @ %15[a-z0-9] %n", &arg_sz, reg_name, &len) == 2) {
 		/* Register read case, e.g., -8@x4 */
 		arg->arg_type = USDT_ARG_REG;
 		arg->val_off = 0;
 		reg_off = calc_pt_regs_off(reg_name);
-		free(reg_name);
 		if (reg_off < 0)
 			return reg_off;
 		arg->reg_off = reg_off;
-- 
2.35.1



