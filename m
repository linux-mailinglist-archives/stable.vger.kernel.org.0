Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440BC4121A7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358755AbhITSHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358065AbhITSFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:05:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D338C61A05;
        Mon, 20 Sep 2021 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158256;
        bh=12siGeLuNRMNegAARWNe0txf5wjF4ptGz5s0ho4zFTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRQBt++f7eSwm5qsUJD9j+oGqvvtZ7MKMKlMOFBEP+3bpmnvpyPqmd86PlWc38d57
         mRqofPqwgIOKXvg1ie7towv04M7JLNPRwqIAHnsHrYUv9yxUYoB27lXhBHxYXah5W8
         c4Vi3B6Syf0Yo3VNTgbmKPYJreT8lUrwAJX7OpM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/260] drm/amdgpu: Fix amdgpu_ras_eeprom_init()
Date:   Mon, 20 Sep 2021 18:41:30 +0200
Message-Id: <20210920163933.579121842@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit dce4400e6516d18313d23de45b5be8a18980b00e ]

No need to account for the 2 bytes of EEPROM
address--this is now well abstracted away by
the fixes the the lower layers.

Cc: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Cc: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Acked-by: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 8a32b5c93778..bd7ae3e130b6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -138,7 +138,7 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control)
 		return ret;
 	}
 
-	__decode_table_header_from_buff(hdr, &buff[2]);
+	__decode_table_header_from_buff(hdr, buff);
 
 	if (hdr->header == EEPROM_TABLE_HDR_VAL) {
 		control->num_recs = (hdr->tbl_size - EEPROM_TABLE_HEADER_SIZE) /
-- 
2.30.2



