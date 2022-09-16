Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400FF5BAA8B
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiIPK1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiIPKZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:25:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583A5B286C;
        Fri, 16 Sep 2022 03:16:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC10C62A30;
        Fri, 16 Sep 2022 10:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97EAC433C1;
        Fri, 16 Sep 2022 10:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323302;
        bh=vz5fOPB/0yc8mAdng/GhOFDcONd3/2mlwH7O9Qh8JFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHha+YmrfRfgHspoPTYFzYTsqpYgU4A/psZxJdXuyxJCiFuwORaDbJOO+LoNVje1K
         OH3HCOIhhvxNLkR9kNTcHBMVjXXgSSm9DRdhoHAqcfJLTsOnSkrQkhtN8mR6n5C6qR
         H/1WKLu1i6aB3PBrWwLhSJl9cv483ms7BxCI62Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 23/38] drm/amdgpu: disable FRU access on special SIENNA CICHLID card
Date:   Fri, 16 Sep 2022 12:08:57 +0200
Message-Id: <20220916100449.440667456@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
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

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit c8fea9273fd1be308668496badfcbd55183e0dd3 ]

Below driver load error will be printed, not friendly to end user.

amdgpu: ATOM BIOS: 113-D603GLXE-077
[drm] FRU: Failed to get size field
[drm:amdgpu_fru_get_product_info [amdgpu]] *ERROR* Failed to read FRU Manufacturer, ret:-5

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
index ecada5eadfe35..e325150879df7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
@@ -66,10 +66,15 @@ static bool is_fru_eeprom_supported(struct amdgpu_device *adev)
 		return true;
 	case CHIP_SIENNA_CICHLID:
 		if (strnstr(atom_ctx->vbios_version, "D603",
+		    sizeof(atom_ctx->vbios_version))) {
+			if (strnstr(atom_ctx->vbios_version, "D603GLXE",
 			    sizeof(atom_ctx->vbios_version)))
-			return true;
-		else
+				return false;
+			else
+				return true;
+		} else {
 			return false;
+		}
 	default:
 		return false;
 	}
-- 
2.35.1



