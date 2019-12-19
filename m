Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5C6126B00
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfLSSxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:53:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730323AbfLSSxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:53:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A27B24683;
        Thu, 19 Dec 2019 18:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781586;
        bh=DZTffMPfrJQtkLV5eRy2s0drgVzLds0tyJMKlwS9wv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVwWfwm3jEeKVK7oA76PmqhT+t9xjoXtraVgxGbrppcLjm4tEPxqKK4XthSJjQZCT
         XINCB/G8AIerE9sj9fIfNR84t6KhjTwh2kHhidPQF6SLXlVjCK3wXky4ALP/huHIoo
         3XcThgjTo3zYPwPt1DjATzZ5260njh2aArIzoj7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meelis Roos <mroos@linux.ee>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 46/47] drm/radeon: fix r1xx/r2xx register checker for POT textures
Date:   Thu, 19 Dec 2019 19:35:00 +0100
Message-Id: <20191219182956.768522615@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 008037d4d972c9c47b273e40e52ae34f9d9e33e7 upstream.

Shift and mask were reversed.  Noticed by chance.

Tested-by: Meelis Roos <mroos@linux.ee>
Reviewed-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r100.c |    4 ++--
 drivers/gpu/drm/radeon/r200.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1820,8 +1820,8 @@ static int r100_packet0_check(struct rad
 			track->textures[i].use_pitch = 1;
 		} else {
 			track->textures[i].use_pitch = 0;
-			track->textures[i].width = 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
-			track->textures[i].height = 1 << ((idx_value >> RADEON_TXFORMAT_HEIGHT_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
+			track->textures[i].width = 1 << ((idx_value & RADEON_TXFORMAT_WIDTH_MASK) >> RADEON_TXFORMAT_WIDTH_SHIFT);
+			track->textures[i].height = 1 << ((idx_value & RADEON_TXFORMAT_HEIGHT_MASK) >> RADEON_TXFORMAT_HEIGHT_SHIFT);
 		}
 		if (idx_value & RADEON_TXFORMAT_CUBIC_MAP_ENABLE)
 			track->textures[i].tex_coord_type = 2;
--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -476,8 +476,8 @@ int r200_packet0_check(struct radeon_cs_
 			track->textures[i].use_pitch = 1;
 		} else {
 			track->textures[i].use_pitch = 0;
-			track->textures[i].width = 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
-			track->textures[i].height = 1 << ((idx_value >> RADEON_TXFORMAT_HEIGHT_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
+			track->textures[i].width = 1 << ((idx_value & RADEON_TXFORMAT_WIDTH_MASK) >> RADEON_TXFORMAT_WIDTH_SHIFT);
+			track->textures[i].height = 1 << ((idx_value & RADEON_TXFORMAT_HEIGHT_MASK) >> RADEON_TXFORMAT_HEIGHT_SHIFT);
 		}
 		if (idx_value & R200_TXFORMAT_LOOKUP_DISABLE)
 			track->textures[i].lookup_disable = true;


