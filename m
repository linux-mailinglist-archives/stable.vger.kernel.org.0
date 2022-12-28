Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE3D657CB2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiL1PfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiL1PfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:35:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F23E16498
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:35:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82CEB81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4C2C433EF;
        Wed, 28 Dec 2022 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241708;
        bh=Z8IlqknPx/sa6wj/y1s6KEd1TUYEWPZi3PG+vRcPg/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gx4q4FQtj9jgIoERsJhPchOIYgBm2ctJ1Az9fxwE6tez8I2sgEwIFGCsPfFeYesf8
         Qule+Ls7oQxljIAAYFmVkOMk2jjsR7AA9kfJeVRv2LdvGMVk2qqRGLs0+5szfRs1j5
         j320bxFJjAuAN0rLmvB38y03BuRWGG+wdwJctWA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Jihong <yangjihong1@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0318/1073] selftests/bpf: Fix xdp_synproxy compilation failure in 32-bit arch
Date:   Wed, 28 Dec 2022 15:31:46 +0100
Message-Id: <20221228144336.646439338@linuxfoundation.org>
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

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit e4c9cf0ce8c413c2030e8fb215551d7e0582ee7b ]

xdp_synproxy fails to be compiled in the 32-bit arch, log is as follows:

  xdp_synproxy.c: In function 'parse_options':
  xdp_synproxy.c:175:36: error: left shift count >= width of type [-Werror=shift-count-overflow]
    175 |                 *tcpipopts = (mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
        |                                    ^~
  xdp_synproxy.c: In function 'syncookie_open_bpf_maps':
  xdp_synproxy.c:289:28: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
    289 |                 .map_ids = (__u64)map_ids,
        |                            ^

Fix it.

Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie helpers")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20221111030836.37632-1-yangjihong1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xdp_synproxy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdp_synproxy.c b/tools/testing/selftests/bpf/xdp_synproxy.c
index d874ddfb39c4..8432836f3be2 100644
--- a/tools/testing/selftests/bpf/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/xdp_synproxy.c
@@ -104,7 +104,8 @@ static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *
 		{ "tc", no_argument, NULL, 'c' },
 		{ NULL, 0, NULL, 0 },
 	};
-	unsigned long mss4, mss6, wscale, ttl;
+	unsigned long mss4, wscale, ttl;
+	unsigned long long mss6;
 	unsigned int tcpipopts_mask = 0;
 
 	if (argc < 2)
@@ -286,7 +287,7 @@ static int syncookie_open_bpf_maps(__u32 prog_id, int *values_map_fd, int *ports
 
 	prog_info = (struct bpf_prog_info) {
 		.nr_map_ids = 8,
-		.map_ids = (__u64)map_ids,
+		.map_ids = (__u64)(unsigned long)map_ids,
 	};
 	info_len = sizeof(prog_info);
 
-- 
2.35.1



