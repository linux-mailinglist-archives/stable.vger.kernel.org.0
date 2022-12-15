Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770D664E078
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiLOSON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiLOSNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:13:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3714731F
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:13:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CA5961EA7
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63370C433D2;
        Thu, 15 Dec 2022 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671128014;
        bh=LmXO+w8lxg4PxS27ws8bcX65p0aXeu40GsDw4SIwn1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKF6FfJykBLch45SuRusnlEIIf0xeGM+ZGpsl5lP+taurRWR4mtTG0fQbwUsyy4xU
         jOlK39pYYXWfNE94jt852b0+hZrjADQ357/hfsjjulNMoZJgG/dKodlIHjzONPqm+E
         F2bdZNI11DcaDyh4ekXuvuNG/RrGlJMyzEhAGBPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hou Tao <houtao1@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 09/16] libbpf: Use page size as max_entries when probing ring buffer map
Date:   Thu, 15 Dec 2022 19:10:53 +0100
Message-Id: <20221215172908.561768558@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
References: <20221215172908.162858817@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 689eb2f1ba46b4b02195ac2a71c55b96d619ebf8 ]

Using page size as max_entries when probing ring buffer map, else the
probe may fail on host with 64KB page size (e.g., an ARM64 host).

After the fix, the output of "bpftool feature" on above host will be
correct.

Before :
    eBPF map_type ringbuf is NOT available
    eBPF map_type user_ringbuf is NOT available

After :
    eBPF map_type ringbuf is available
    eBPF map_type user_ringbuf is available

Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221116072351.1168938-2-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf_probes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 6d495656f554..29f7cde10741 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -233,7 +233,7 @@ static int probe_map_create(enum bpf_map_type map_type)
 	case BPF_MAP_TYPE_RINGBUF:
 		key_size = 0;
 		value_size = 0;
-		max_entries = 4096;
+		max_entries = sysconf(_SC_PAGE_SIZE);
 		break;
 	case BPF_MAP_TYPE_STRUCT_OPS:
 		/* we'll get -ENOTSUPP for invalid BTF type ID for struct_ops */
-- 
2.35.1



