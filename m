Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A887A429070
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbhJKOJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239545AbhJKOGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:06:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7951361213;
        Mon, 11 Oct 2021 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960815;
        bh=bagx2nx3wKOH0nF8fIb2G5ZwBEltcy86rwjCAz0DixI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUPu+93YsBbG1JkRqfOnj8bcop7t11eSmgTsC1a87fS59Pm3fkGoDeqGgrgBsyDO1
         FsqNRrCx7K58wRKopB5ZHae3o3jN/fcE7FEXpchYyyoetqbH/Y2Mg+G7JIccJNpaKy
         INW1t/Ird5uml47ia0ww6MBRtgm7cOEJP/ahKqLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 082/151] drm/i915/audio: Use BIOS provided value for RKL HDA link
Date:   Mon, 11 Oct 2021 15:45:54 +0200
Message-Id: <20211011134520.496267065@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit ffac30be2a06b2516b2ce2afa2dcb2cf8af65a52 ]

Commit 989634fb49ad ("drm/i915/audio: set HDA link parameters in
driver") makes HDMI audio on Lenovo P350 disappear.

So in addition to TGL, extend the logic to RKL to use BIOS provided
value to fix the regression.

Fixes: 989634fb49ad ("drm/i915/audio: set HDA link parameters in driver")
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210906041300.508458-1-kai.heng.feng@canonical.com
(cherry picked from commit c6b40ee330fe09b332715bb7ec1467e4fcbe2e65)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_audio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_audio.c b/drivers/gpu/drm/i915/display/intel_audio.c
index 5f4f316b3ab5..4e4429535f9e 100644
--- a/drivers/gpu/drm/i915/display/intel_audio.c
+++ b/drivers/gpu/drm/i915/display/intel_audio.c
@@ -1308,8 +1308,9 @@ static void i915_audio_component_init(struct drm_i915_private *dev_priv)
 		else
 			aud_freq = aud_freq_init;
 
-		/* use BIOS provided value for TGL unless it is a known bad value */
-		if (IS_TIGERLAKE(dev_priv) && aud_freq_init != AUD_FREQ_TGL_BROKEN)
+		/* use BIOS provided value for TGL and RKL unless it is a known bad value */
+		if ((IS_TIGERLAKE(dev_priv) || IS_ROCKETLAKE(dev_priv)) &&
+		    aud_freq_init != AUD_FREQ_TGL_BROKEN)
 			aud_freq = aud_freq_init;
 
 		drm_dbg_kms(&dev_priv->drm, "use AUD_FREQ_CNTRL of 0x%x (init value 0x%x)\n",
-- 
2.33.0



