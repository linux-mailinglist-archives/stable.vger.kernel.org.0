Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D35D4803C4
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhL0TFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbhL0TEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859B3C06175B;
        Mon, 27 Dec 2021 11:04:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50D3FB8113E;
        Mon, 27 Dec 2021 19:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EAEC36AE7;
        Mon, 27 Dec 2021 19:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631888;
        bh=b3Xj1hsvYvx7YeGTfGNEKNSU4PO1BelsYqOh4/01pZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd99dl9y/mHOQxXbZtAU8jL9fQw6ZgDVcKVUc1594+sN6cNGCg4Zwtsxxsfd5kcsl
         o3zIzTHlZ2qIDzhCCfsrekrbgTfO5BhDQKFWTV5MAOSN+WiWaWYEacDN5/tzXmrJ4h
         U0o7La2i4wOdIrx1OyjPFKEQooZeuO7M/cgtv03BY/q2yu7I1rHAw7cGnCuekq0E0A
         nO2jgIhyzJqlbA5AM6JEz7f4SmBYDrtijH4qpzNxcWHfG9zZrfXCfP7DgKP5zUZhjS
         lz8neUa1LGRTNdZNgJnRESTyGBJAvPV8dLKn7ceHlRd13fTKWSRunrfSYnYzgNNHfo
         xVScgewZk3jXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Libin Yang <libin.yang@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, vkoul@kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 25/26] ALSA: hda: intel-sdw-acpi: go through HDAS ACPI at max depth of 2
Date:   Mon, 27 Dec 2021 14:03:26 -0500
Message-Id: <20211227190327.1042326-25-sashal@kernel.org>
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

[ Upstream commit 78ea40efb48e978756db2ce45fcfa55bac056b91 ]

In the HDAS ACPI scope, the SoundWire may not be the direct child of HDAS.
It needs to go through the ACPI table at max depth of 2 to find the
SoundWire device from HDAS.

Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211221010817.23636-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-sdw-acpi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/hda/intel-sdw-acpi.c b/sound/hda/intel-sdw-acpi.c
index ba8a872a29010..b7758dbe23714 100644
--- a/sound/hda/intel-sdw-acpi.c
+++ b/sound/hda/intel-sdw-acpi.c
@@ -165,8 +165,14 @@ int sdw_intel_acpi_scan(acpi_handle *parent_handle,
 	acpi_status status;
 
 	info->handle = NULL;
+	/*
+	 * In the HDAS ACPI scope, 'SNDW' may be either the child of
+	 * 'HDAS' or the grandchild of 'HDAS'. So let's go through
+	 * the ACPI from 'HDAS' at max depth of 2 to find the 'SNDW'
+	 * device.
+	 */
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE,
-				     parent_handle, 1,
+				     parent_handle, 2,
 				     sdw_intel_acpi_cb,
 				     NULL, info, NULL);
 	if (ACPI_FAILURE(status) || info->handle == NULL)
-- 
2.34.1

