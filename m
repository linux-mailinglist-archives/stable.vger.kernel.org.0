Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2096AE910
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjCGRUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjCGRUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F159547D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:15:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3169614E1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7736C433EF;
        Tue,  7 Mar 2023 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209337;
        bh=0Ygr5Q+4JTuHWytzLIR9ppCJ9rwgirIIcE9/ohIHY/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyjaXFMIsbMNte75KAHzkZgmVrIugN6To60S6F+PL4r9/DZyf74PcVB0r9vG7EYvB
         QnPkvwYIa2tWZ9J6ibOmmpeTMlTSiKlaQPsVHzS1LHyIsu9VeBeKIgqfqhW/KeAEar
         jFMYVoktwWESuM5vnUendWs5DX2tQV8g6sB1qjY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ludovic LHours <ludovic.lhours@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0185/1001] libbpf: Fix map creation flags sanitization
Date:   Tue,  7 Mar 2023 17:49:17 +0100
Message-Id: <20230307170029.925699892@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic L'Hours <ludovic.lhours@gmail.com>

[ Upstream commit 6920b08661e3ad829206078b5c9879b24aea8dfc ]

As BPF_F_MMAPABLE flag is now conditionnaly set (by map_is_mmapable),
it should not be toggled but disabled if not supported by kernel.

Fixes: 4fcac46c7e10 ("libbpf: only add BPF_F_MMAPABLE flag for data maps with global vars")
Signed-off-by: Ludovic L'Hours <ludovic.lhours@gmail.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20230108182018.24433-1-ludovic.lhours@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2a82f49ce16f3..adf818da35dda 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7355,7 +7355,7 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
 		if (!bpf_map__is_internal(m))
 			continue;
 		if (!kernel_supports(obj, FEAT_ARRAY_MMAP))
-			m->def.map_flags ^= BPF_F_MMAPABLE;
+			m->def.map_flags &= ~BPF_F_MMAPABLE;
 	}
 
 	return 0;
-- 
2.39.2



