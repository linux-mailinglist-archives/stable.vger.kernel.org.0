Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F86649298
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfFQVVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbfFQVVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:21:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8BF2089E;
        Mon, 17 Jun 2019 21:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806508;
        bh=velIhUKy6AIG4rUQNiehLtNEbg7Pq6v2sXH3kCwIP2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoLN8f+akNIVARTOxQty84ZPd9E4mFPvN8o1iJkBQGXy5KHp4F9fYSHVf06TRkUZz
         J0roBvHqYwND19GbumKhP15KvkPb/4rQi5qrSRh2knttgZuBD4WcDEKEGEFT5zbIFQ
         Pj3vst+bCTrzZbzoav4uz4tOVAOgUXKmHqKlmDSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Flora Cui <flora.cui@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 075/115] drm/amdgpu: keep stolen memory on picasso
Date:   Mon, 17 Jun 2019 23:09:35 +0200
Message-Id: <20190617210803.859605462@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 379109351f4f6f2405cf54e7a296055f589c3ad1 ]

otherwise screen corrupts during modprobe.

Signed-off-by: Flora Cui <flora.cui@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 2fe8397241ea..1611bef19a2c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -715,6 +715,7 @@ static bool gmc_v9_0_keep_stolen_memory(struct amdgpu_device *adev)
 	case CHIP_VEGA10:
 		return true;
 	case CHIP_RAVEN:
+		return (adev->pdev->device == 0x15d8);
 	case CHIP_VEGA12:
 	case CHIP_VEGA20:
 	default:
-- 
2.20.1



