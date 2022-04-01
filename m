Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC784EF4C9
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352771AbiDAPHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350286AbiDAO7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:59:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0C25A587;
        Fri,  1 Apr 2022 07:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00FF960AD8;
        Fri,  1 Apr 2022 14:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39229C340EE;
        Fri,  1 Apr 2022 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824417;
        bh=pU/H+u9rFtp4ENuB1Hm1S3gmfaCJ6UJyWiYaxiMbYOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mM01b3VenxyNrvwoTtMVfDtXS53HE/vZEGmLJmsh2KiHKk2ln136Q+dNbY8OrNYZc
         ILukTjIJsFYCS7CISEoCcqC9ayV41b0WLyeVNP652rgBlHaD+Ii6R7j6NQ/It82RWh
         Zw8w/AURoccR9UA1P7WQwBWRVHrfTPBId60eN+KDEF/IgKAfoaPDUXYGe7cLjSeShU
         dJD6drFL043+Ews8+bZeHvUVtEuioI1lA2lOh3tykey3hYL+1aLGobXjCF7fZNXXWK
         iZLgkAEO3w+15klE4VhbcIlzA8NhpqoDWz7Qzyc3wWdGIxDoM+xxFrMYdLVNvOIdmL
         w0poPKKZ5J8fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 16/29] drm/amdkfd: make CRAT table missing message informational only
Date:   Fri,  1 Apr 2022 10:45:59 -0400
Message-Id: <20220401144612.1955177-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144612.1955177-1-sashal@kernel.org>
References: <20220401144612.1955177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 9dff13f9edf755a15f6507874185a3290c1ae8bb ]

The driver has a fallback so make the message informational
rather than a warning. The driver has a fallback if the
Component Resource Association Table (CRAT) is missing, so
make this informational now.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1906
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index ee4996029a86..e2780643f4c3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -733,7 +733,7 @@ int kfd_create_crat_image_acpi(void **crat_image, size_t *size)
 	/* Fetch the CRAT table from ACPI */
 	status = acpi_get_table(CRAT_SIGNATURE, 0, &crat_table);
 	if (status == AE_NOT_FOUND) {
-		pr_warn("CRAT table not found\n");
+		pr_info("CRAT table not found\n");
 		return -ENODATA;
 	} else if (ACPI_FAILURE(status)) {
 		const char *err = acpi_format_exception(status);
-- 
2.34.1

