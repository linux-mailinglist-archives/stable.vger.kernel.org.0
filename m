Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB74659003D
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbiHKPis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236239AbiHKPiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:38:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1917BA0309;
        Thu, 11 Aug 2022 08:34:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A684D6164A;
        Thu, 11 Aug 2022 15:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A04FC433D6;
        Thu, 11 Aug 2022 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232040;
        bh=puQTGdVI9lZ26uvCd9Wvp8y/49CubBUwDPtLDxsmHko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbrO6AIerA3cCAAv5toSJfuaQKBnGu/NnR/PgPmSoX+3BrTeAZoy2/3ltDljbYlDE
         uPo0y8VwbBOPFqGtrShYOxbo85NqEUcZl4/MekqUD2fpy7gv7NYoOc7HmoAL9cDj4i
         +eECgfl2rDFuu6b6WPKybBUQux5e+G9+CuK3SmkXIQxfKIsSXS5iSbUvuFPp5WyV7z
         qj+sAxM6k3yTqWgEUBoeAFRoIZMHRc+KKvUMWSj+txyS/l7NgxjIPM9+QY/ZFbt2Z9
         na/yAFzDCnaaVFQSTqAlnnd5ImV3Z9JjApQcn+RQ0R00FPXs5Fo54UDoc6FBOckCHr
         GPvuqQDr0CUfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 053/105] libbpf: fix up few libbpf.map problems
Date:   Thu, 11 Aug 2022 11:27:37 -0400
Message-Id: <20220811152851.1520029-53-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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
index 52973cffc20c..b6592c93a9d4 100644
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

