Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E11D5B6F79
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiIMONQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiIMOMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:12:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA3459272;
        Tue, 13 Sep 2022 07:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7209461497;
        Tue, 13 Sep 2022 14:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83628C433C1;
        Tue, 13 Sep 2022 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078198;
        bh=QBsjK9oGm5O9r4YTpxdmvu68qWH0C2oAEG1TyScOEnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/uQh16tnoG8liAYBjMYjFqW+O15U/j+mIOS0l1tWgKWsn+W3yJBxDlDNoNlNr4q7
         g2yGreJuuC4GgrWGgvXIfVNuUm8Bxesci4XrQvLhQzTwr1xxRbO7KxVBpCbmnExIr5
         EzUJ9VywS6p1Bu7skxtKtMcBTHGyPhnLTZEg1gNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YiPeng Chai <YiPeng.Chai@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 014/192] drm/amdgpu: fix hive reference leak when adding xgmi device
Date:   Tue, 13 Sep 2022 16:02:00 +0200
Message-Id: <20220913140410.649837380@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit f5994da72ba124a3d0463672fdfbec073e3bb72f ]

Only amdgpu_get_xgmi_hive but no amdgpu_put_xgmi_hive
which will leak the hive reference.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 3adebb63680e0..ea2b74c0fd229 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2482,12 +2482,14 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 			if (!hive->reset_domain ||
 			    !amdgpu_reset_get_reset_domain(hive->reset_domain)) {
 				r = -ENOENT;
+				amdgpu_put_xgmi_hive(hive);
 				goto init_failed;
 			}
 
 			/* Drop the early temporary reset domain we created for device */
 			amdgpu_reset_put_reset_domain(adev->reset_domain);
 			adev->reset_domain = hive->reset_domain;
+			amdgpu_put_xgmi_hive(hive);
 		}
 	}
 
-- 
2.35.1



