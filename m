Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EA740E898
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356058AbhIPRpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355625AbhIPRlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03C6861A8A;
        Thu, 16 Sep 2021 16:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811203;
        bh=XD2EfWVY1jQfNBXsgWZfi3Zkz9SpbfHHHXOiHvi5Osw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhG+fewI8qresC4sjh2wxv8f7YcYJnivZ86zCNn1OyYXR5IV3uue1O0o6ULBGkhnS
         B1+Dwb9IFxIScdmdklUNmwZFyTnrywuNlQkaD+4lmN5ClK12K9oh/KeQr1VmILRCx1
         ZkL9lzZkhh+MjZC+14oQ/XQyelhpn6phHulpPuTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Liu <aaron.liu@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 421/432] drm/amdgpu: Enable S/G for Yellow Carp
Date:   Thu, 16 Sep 2021 18:02:50 +0200
Message-Id: <20210916155825.097832664@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit c5d3c9a093d353e7f38183a70df425f92e3c329d upstream.

Missing code for Yellow Carp to enable scatter gather - follows how
DCN21 support was added.

Tested that 8k framebuffer allocation and display can now succeed after
applying the patch.

v2: Add hookup in DM

Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -522,6 +522,7 @@ uint32_t amdgpu_display_supported_domain
 			break;
 		case CHIP_RENOIR:
 		case CHIP_VANGOGH:
+		case CHIP_YELLOW_CARP:
 			domain |= AMDGPU_GEM_DOMAIN_GTT;
 			break;
 


