Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CFC6CC4A5
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbjC1PGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjC1PGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:06:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220EEEC70
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8279B81D7B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E140C4339E;
        Tue, 28 Mar 2023 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015936;
        bh=mb30MmMqLx6wKvtPb0vCuNT6eDvY4Y5bNrls1gbpZJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejkX1w/JvLI7YJZE1sk56M/ythTAVkRd4uPCE7xmy5oKANd9UcSl9TSHrDmWt+jKZ
         CdSYFeQquo+arn5o5tUlmuy3mF5WPFbsLHYrc/z9yDFpcBO57CYTyCNKwzA7NShlHn
         Uq1YzDW3M/WEgAaxOVUBwrsyJ1m/axQee7oQjvjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 221/224] drm/amdkfd: introduce dummy cache info for property asic
Date:   Tue, 28 Mar 2023 16:43:37 +0200
Message-Id: <20230328142626.505133663@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

commit fd72e2cb2f9dd2734e8013b3e185a21f0d605d3e upstream.

This dummy cache info will enable kfd base function support.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c |   53 +++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -891,6 +891,54 @@ static struct kfd_gpu_cache_info gc_10_3
 	},
 };
 
+static struct kfd_gpu_cache_info dummy_cache_info[] = {
+	{
+		/* TCP L1 Cache per CU */
+		.cache_size = 16,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 1,
+	},
+	{
+		/* Scalar L1 Instruction Cache per SQC */
+		.cache_size = 32,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_INST_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* Scalar L1 Data Cache per SQC */
+		.cache_size = 16,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* GL1 Data Cache per SA */
+		.cache_size = 128,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 6,
+	},
+	{
+		/* L2 Data Cache per GPU (Total Tex Cache) */
+		.cache_size = 2048,
+		.cache_level = 2,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 6,
+	},
+};
+
 static void kfd_populated_cu_info_cpu(struct kfd_topology_device *dev,
 		struct crat_subtype_computeunit *cu)
 {
@@ -1630,7 +1678,10 @@ static int kfd_fill_gpu_cache_info(struc
 				kfd_fill_gpu_cache_info_from_gfx_config(kdev, pcache_info);
 			break;
 		default:
-			return -EINVAL;
+			pcache_info = dummy_cache_info;
+			num_of_cache_types = ARRAY_SIZE(dummy_cache_info);
+			pr_warn("dummy cache info is used temporarily and real cache info need update later.\n");
+			break;
 		}
 	}
 


