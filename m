Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C67F08D9AF
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbfHNRLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728169AbfHNRLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:11:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F3EC2084D;
        Wed, 14 Aug 2019 17:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802661;
        bh=J4dSbfCwkT11Ar3nuoF9znqGCtoVQNozFYMuMTM2jMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqyolR44QTWJt6EZp2N4IpBs20tklemsDYBQepJnYFl0FRtiKf6aquYPN/v2m0NBM
         OlsO02DQ3realMafwYhKfNEB/+zR/A/2jvL3A+9V/0dxAFKp0ZwSObzRg0hFtBoiIF
         l8kBgq8paRa0ckqGwewHaYowN4oSaOx5gpThADbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tai Man <taiman.wong@amd.com>,
        Joshua Aberback <Joshua.Aberback@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/91] drm/amd/display: Increase size of audios array
Date:   Wed, 14 Aug 2019 19:01:06 +0200
Message-Id: <20190814165751.443972078@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7352193a33dfc9b69ba3bf6a8caea925b96243b1 ]

[Why]
The audios array defined in "struct resource_pool" is only 6 (MAX_PIPES)
but the max number of audio devices (num_audio) is 7. In some projects,
it will run out of audios array.

[How]
Incraese the audios array size to 7.

Signed-off-by: Tai Man <taiman.wong@amd.com>
Reviewed-by: Joshua Aberback <Joshua.Aberback@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/inc/core_types.h   | 2 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_types.h b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
index c0b9ca13393b6..f4469fa5afb55 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -159,7 +159,7 @@ struct resource_pool {
 	struct clock_source *clock_sources[MAX_CLOCK_SOURCES];
 	unsigned int clk_src_count;
 
-	struct audio *audios[MAX_PIPES];
+	struct audio *audios[MAX_AUDIOS];
 	unsigned int audio_count;
 	struct audio_support audio_support;
 
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h b/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
index cf7433ebf91a0..71901743a9387 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
@@ -34,6 +34,7 @@
  * Data types shared between different Virtual HW blocks
  ******************************************************************************/
 
+#define MAX_AUDIOS 7
 #define MAX_PIPES 6
 
 struct gamma_curve {
-- 
2.20.1



