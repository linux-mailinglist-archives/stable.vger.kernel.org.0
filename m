Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37664803B8
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhL0TFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbhL0TEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C499EC061763;
        Mon, 27 Dec 2021 11:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56C8F61166;
        Mon, 27 Dec 2021 19:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7625AC36AE7;
        Mon, 27 Dec 2021 19:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631882;
        bh=oxhUhvFTWeK3mUGF9MafxpL16GDYsAKol6H7Dor33hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGPJvkslbC5oKAN3b28T93mLhCmgH0YSp699nNkwvyZ97sJFGwpXtV27u4gtqnAfT
         R9OVsYCcw9TkbOV4jnUwKErWpLndbCeruGBlEb1+OJIYPH2o1i9wLcgGuCyIgP0Mld
         ZoKIuuCoZ21HBmCHiiFHG8n/wmYurC0SDPNXL3EdGP044Mh5nY55OUmosSlRjU5DaL
         WgeJOu0AFVOyLRQ3++r2fwa/d/1JTVkQPqYkYO7mNKyhSzb02G+rTCPCanrXOfKgUR
         GpIqeGVdaPiTPfM05v/NRfLC3/ecs7YbIEQ5+UPj3TpqiMMC4OFgEqAPO7Qp46JC4P
         i9H2PIzIKLVXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Libin Yang <libin.yang@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com,
        guennadi.liakhovetski@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 24/26] ALSA: hda: intel-sdw-acpi: harden detection of controller
Date:   Mon, 27 Dec 2021 14:03:25 -0500
Message-Id: <20211227190327.1042326-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Libin Yang <libin.yang@intel.com>

[ Upstream commit 385f287f9853da402d94278e59f594501c1d1dad ]

The existing code currently sets a pointer to an ACPI handle before
checking that it's actually a SoundWire controller. This can lead to
issues where the graph walk continues and eventually fails, but the
pointer was set already.

This patch changes the logic so that the information provided to
the caller is set when a controller is found.

Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211221010817.23636-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-sdw-acpi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/hda/intel-sdw-acpi.c b/sound/hda/intel-sdw-acpi.c
index c0123bc31c0dd..ba8a872a29010 100644
--- a/sound/hda/intel-sdw-acpi.c
+++ b/sound/hda/intel-sdw-acpi.c
@@ -132,8 +132,6 @@ static acpi_status sdw_intel_acpi_cb(acpi_handle handle, u32 level,
 		return AE_NOT_FOUND;
 	}
 
-	info->handle = handle;
-
 	/*
 	 * On some Intel platforms, multiple children of the HDAS
 	 * device can be found, but only one of them is the SoundWire
@@ -144,6 +142,9 @@ static acpi_status sdw_intel_acpi_cb(acpi_handle handle, u32 level,
 	if (FIELD_GET(GENMASK(31, 28), adr) != SDW_LINK_TYPE)
 		return AE_OK; /* keep going */
 
+	/* found the correct SoundWire controller */
+	info->handle = handle;
+
 	/* device found, stop namespace walk */
 	return AE_CTRL_TERMINATE;
 }
-- 
2.34.1

