Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EC25901BE
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbiHKP5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237596AbiHKP45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:56:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D1EA8CC0;
        Thu, 11 Aug 2022 08:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9315B82166;
        Thu, 11 Aug 2022 15:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE0FC433C1;
        Thu, 11 Aug 2022 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232848;
        bh=yBJ2y8HCNBKPJMYF4B5gcb9bH4TcIwSHkzdudjGSQPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abBzRSFB+ieSu9X/v4jkihXd9vEPAd28hIFpeMiZpRj7SEmNvCdj3UC9Zu8JbYTQ9
         qgNKnO4646skhiEFtUQPJo1gdPw+wuUBgPTOAiR9qoDsHclRnX78BhvxShr5HlOek+
         U1ZwRPInyHrsf1i9u/OPmBF1yIu3Z/KER7+d0k+g34CDjl0vmlHhzlRPECvlwCzk27
         N/XlWbDcmNHVJ2bzp5yqo+ZSp410zMWKi3E3xLViCgDiTa2aPnFoGrDN0D9orbhK/i
         Jc8+X3piTlhEjnMEDFBvEsmsvohtHHcVNzy1BnQlnr2BAD3g1UL6asBQ8frRli14k/
         DM/cD2P8UkydA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 48/93] libbpf: fix up few libbpf.map problems
Date:   Thu, 11 Aug 2022 11:41:42 -0400
Message-Id: <20220811154237.1531313-48-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit ab9a5a05dc480f8994eddd31093a8920b08ee71d ]

Seems like we missed to add 2 APIs to libbpf.map and another API was
misspelled. Fix it in libbpf.map.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20220627211527.2245459-16-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.map      | 3 ++-
 tools/lib/bpf/libbpf_legacy.h | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index dd35ee58bfaa..d2476c1aee8c 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -434,10 +434,11 @@ LIBBPF_0.7.0 {
 		bpf_xdp_detach;
 		bpf_xdp_query;
 		bpf_xdp_query_id;
+		btf_ext__raw_data;
 		libbpf_probe_bpf_helper;
 		libbpf_probe_bpf_map_type;
 		libbpf_probe_bpf_prog_type;
-		libbpf_set_memlock_rlim_max;
+		libbpf_set_memlock_rlim;
 } LIBBPF_0.6.0;
 
 LIBBPF_0.8.0 {
diff --git a/tools/lib/bpf/libbpf_legacy.h b/tools/lib/bpf/libbpf_legacy.h
index d7bcbd01f66f..a3503c02e4a9 100644
--- a/tools/lib/bpf/libbpf_legacy.h
+++ b/tools/lib/bpf/libbpf_legacy.h
@@ -71,8 +71,8 @@ enum libbpf_strict_mode {
 	 * first BPF program or map creation operation. This is done only if
 	 * kernel is too old to support memcg-based memory accounting for BPF
 	 * subsystem. By default, RLIMIT_MEMLOCK limit is set to RLIM_INFINITY,
-	 * but it can be overriden with libbpf_set_memlock_rlim_max() API.
-	 * Note that libbpf_set_memlock_rlim_max() needs to be called before
+	 * but it can be overriden with libbpf_set_memlock_rlim() API.
+	 * Note that libbpf_set_memlock_rlim() needs to be called before
 	 * the very first bpf_prog_load(), bpf_map_create() or bpf_object__load()
 	 * operation.
 	 */
-- 
2.35.1

