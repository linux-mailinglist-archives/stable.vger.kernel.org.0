Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC4E6BB2CE
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjCOMir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbjCOMi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:38:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CA9A1FF3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB908CE19C2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96C0C433EF;
        Wed, 15 Mar 2023 12:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883829;
        bh=dv2OtK1ke8V4Uf6tfrYnrXsY6NT3RYbU3qpWjOZL2kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2MDAQ0TB7TApp42fVI3qktRtaO4xCbADCQo2XrBITGYLdbNUDknanGnBDlAXyxSU
         5fuqp0HnGCrCfI0ifcf3nwX1hROzqZOYIPbxI1FqdtHNOorwEVNhgzJiS/sb0sB2gB
         4Aarpp8pCIfOUm3X042JkNi0nEir/QHeAQUB4XzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/143] drm/amdgpu/soc21: Add video cap query support for VCN_4_0_4
Date:   Wed, 15 Mar 2023 13:13:23 +0100
Message-Id: <20230315115744.057519371@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>

[ Upstream commit 6ce2ea07c5ff0a8188eab0e5cd1f0e4899b36835 ]

Added the video capability query support for VCN version 4_0_4

Signed-off-by: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 61ee41aa8abb7..9c52af5005253 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -109,6 +109,7 @@ static int soc21_query_video_codecs(struct amdgpu_device *adev, bool encode,
 	switch (adev->ip_versions[UVD_HWIP][0]) {
 	case IP_VERSION(4, 0, 0):
 	case IP_VERSION(4, 0, 2):
+	case IP_VERSION(4, 0, 4):
 		if (adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0) {
 			if (encode)
 				*codecs = &vcn_4_0_0_video_codecs_encode_vcn1;
-- 
2.39.2



