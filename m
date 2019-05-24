Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C823C29B22
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 17:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389654AbfEXPeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 11:34:21 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:43290 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389646AbfEXPeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 11:34:21 -0400
Received: by mail-vs1-f66.google.com with SMTP id d128so6058405vsc.10
        for <stable@vger.kernel.org>; Fri, 24 May 2019 08:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O64QUlJZvY6edZzNsDoXZFt70BByWxmPmSeDdp5OTr0=;
        b=E299hfcAeoekUCJdVk+6uA7NCrFIRyxeJiZu1+OWckqOx2l1zuZIYwySNzN7QO7Z16
         4Xz5Xl6l851U2C5ntqmueHixTeTPrMtXnfSFbp11PzsYh55fpC1snt3kwOXQtM6IzUpX
         eIhB6EV/89bs3/ei17s+n+oSW+/uXLXQIlQrG6Vdrwq2zFdrRiK0we12ejud6WMFCfU7
         890OrooUPcphWqjfFXi6/6k7zSGA6bCdSqATZbVwWatXNTqbJiR1jhoHKfhNnTPwUX9D
         iw1bxdH9ORStP/3cdT1tS8jrcLFmweexVsg5OD4XQCUimO/dbrw7eAw1FYlbG9n19m3C
         l0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O64QUlJZvY6edZzNsDoXZFt70BByWxmPmSeDdp5OTr0=;
        b=eYaYWRDXri73uAEcs6wogp+2VkuqR2hiPrZNFZqKgO9IfZ+FKgi+ZS7g8x8S3rft18
         HlOIJUaxyyYjhoXqe6/NVzIGD6jO6+/ZGij4NkGXbQnpfbHWkWg9AKJ1MsNdULsjd7dv
         HDddnIhlgkbN1rPtO3uOOqB3skhAkg6enTE0RSdxu83DBKjWHum9MfIS/MhIYRmb6eV5
         AOUayTMlMkTQIvZhooGYFPNaW5z/dJcyLVd1GiveS7hV8T/flEQ78+b5ZwlC9MrnfVGv
         fdxn3hvCSRG43fcganjz9tGH0FOveEe0jlyKrK44YgFKQAnO6WN9pkQqDa0B37zeQiaw
         teAw==
X-Gm-Message-State: APjAAAX75xv4B03mjl3UPenwrpfBBC7a3X+gpFcPQ5Nieo62bSTYQKnz
        1tCXNZy/fjWaA1UaW2l00ec=
X-Google-Smtp-Source: APXvYqxNNmqjh4yg1lJ8CHCe0WrUD/8INNbp4XH+ILRxW8b0DOIhOxVIXQGa0cVk32L9ExOocUCY4g==
X-Received: by 2002:a67:770f:: with SMTP id s15mr42499850vsc.11.1558712059855;
        Fri, 24 May 2019 08:34:19 -0700 (PDT)
Received: from localhost.localdomain ([71.219.72.228])
        by smtp.gmail.com with ESMTPSA id s65sm2858523vkd.36.2019.05.24.08.34.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 08:34:18 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/amd/display: Don't load DMCU for Raven 1 (v2)
Date:   Fri, 24 May 2019 10:34:10 -0500
Message-Id: <20190524153410.19402-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Wentland <harry.wentland@amd.com>

[WHY]
Some early Raven boards had a bad SBIOS that doesn't play nicely with
the DMCU FW. We thought the issues were fixed by ignoring errors on DMCU
load but that doesn't seem to be the case. We've still seen reports of
users unable to boot their systems at all.

[HOW]
Disable DMCU load on Raven 1. Only load it for Raven 2 and Picasso.

v2: Fix ifdef (Alex)

Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 995f9df66142..bcb1a93c0b4c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -29,6 +29,7 @@
 #include "dm_services_types.h"
 #include "dc.h"
 #include "dc/inc/core_types.h"
+#include "dal_asic_id.h"
 
 #include "vid.h"
 #include "amdgpu.h"
@@ -640,7 +641,7 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 
 static int load_dmcu_fw(struct amdgpu_device *adev)
 {
-	const char *fw_name_dmcu;
+	const char *fw_name_dmcu = NULL;
 	int r;
 	const struct dmcu_firmware_header_v1_0 *hdr;
 
@@ -663,7 +664,14 @@ static int load_dmcu_fw(struct amdgpu_device *adev)
 	case CHIP_VEGA20:
 		return 0;
 	case CHIP_RAVEN:
-		fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
+#if defined(CONFIG_DRM_AMD_DC_DCN1_01)
+		if (ASICREV_IS_PICASSO(adev->external_rev_id))
+			fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
+		else if (ASICREV_IS_RAVEN2(adev->external_rev_id))
+			fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
+		else
+#endif
+			return 0;
 		break;
 	default:
 		DRM_ERROR("Unsupported ASIC type: 0x%X\n", adev->asic_type);
-- 
2.20.1

