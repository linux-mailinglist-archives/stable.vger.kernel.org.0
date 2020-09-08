Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65718261C00
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbgIHTNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731090AbgIHQFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3FA8229C7;
        Tue,  8 Sep 2020 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579327;
        bh=pGPGvz4isoVU6Q1OPF74SRiL0p/6cTxaeGQRmI3go7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVNL4R+LGVKVgwoJ8RAqAwl3/+wVW2Ru76+64jKNMaOVvADHqEpF0U4mJE8sgk/m+
         TsJeFGRP+f2sXng3+3NIH/xTRu4ooH4wovQaW8KubrDiBOjLH2Vqx5V2q2CWlVZw8n
         BuzQId7ScVE5Zi6B4hLH3Y0u22juhpmhoAhFzaCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Furquan Shaikh <furquan@google.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 031/186] drivers: gpu: amd: Initialize amdgpu_dm_backlight_caps object to 0 in amdgpu_dm_update_backlight_caps
Date:   Tue,  8 Sep 2020 17:22:53 +0200
Message-Id: <20200908152243.164605314@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Furquan Shaikh <furquan@google.com>

[ Upstream commit 5896585512e5156482335e902f7c7393b940da51 ]

In `amdgpu_dm_update_backlight_caps()`, there is a local
`amdgpu_dm_backlight_caps` object that is filled in by
`amdgpu_acpi_get_backlight_caps()`. However, this object is
uninitialized before the call and hence the subsequent check for
aux_support can fail since it is not initialized by
`amdgpu_acpi_get_backlight_caps()` as well. This change initializes
this local `amdgpu_dm_backlight_caps` object to 0.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Furquan Shaikh <furquan@google.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 666ebe04837af..7ec810ebf4ce4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2844,6 +2844,8 @@ static void amdgpu_dm_update_backlight_caps(struct amdgpu_display_manager *dm)
 #if defined(CONFIG_ACPI)
 	struct amdgpu_dm_backlight_caps caps;
 
+	memset(&caps, 0, sizeof(caps));
+
 	if (dm->backlight_caps.caps_valid)
 		return;
 
-- 
2.25.1



