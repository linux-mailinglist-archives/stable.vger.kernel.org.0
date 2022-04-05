Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217314F37A8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359425AbiDELTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349107AbiDEJtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD65AA015;
        Tue,  5 Apr 2022 02:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C781EB81B14;
        Tue,  5 Apr 2022 09:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B72DC385A3;
        Tue,  5 Apr 2022 09:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151656;
        bh=XSoG/BV4wxZLDa+MVNXRC/TkMgI/vWCpsX4YdueLI9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfKZLfeZ2KrUBl6o5JVvE4pKYnWwxY5OJd2nKPj2/wL0vAbmam4U517SKgIwlUigU
         RVETHxcKgibH+wZerJ7XdSf9fef/rfXsDIElbf1d/zN9iNI9f4yRRRscIijykjgF9Q
         5PgeyJMuXcOpLusacHsI9tUEZEbxctTVctwVXaLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yiqing Yao <yiqing.yao@amd.com>,
        Monk Liu <Monk.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 456/913] drm/amd/pm: enable pm sysfs write for one VF mode
Date:   Tue,  5 Apr 2022 09:25:18 +0200
Message-Id: <20220405070353.517909734@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Yiqing Yao <yiqing.yao@amd.com>

[ Upstream commit e610941c45bad75aa839af015c27d236ab6749e5 ]

[why]
pm sysfs should be writable in one VF mode as is in passthrough

[how]
do not remove write access on pm sysfs if device is in one VF mode

Fixes: 11c9cc95f818 ("amdgpu/pm: Make sysfs pm attributes as read-only for VFs")
Signed-off-by: Yiqing Yao <yiqing.yao@amd.com>
Reviewed-by: Monk Liu <Monk.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 640db5020ccc..6aaf1230655f 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2117,8 +2117,8 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
 		}
 	}
 
-	/* setting should not be allowed from VF */
-	if (amdgpu_sriov_vf(adev)) {
+	/* setting should not be allowed from VF if not in one VF mode */
+	if (amdgpu_sriov_vf(adev) && !amdgpu_sriov_is_pp_one_vf(adev)) {
 		dev_attr->attr.mode &= ~S_IWUGO;
 		dev_attr->store = NULL;
 	}
-- 
2.34.1



