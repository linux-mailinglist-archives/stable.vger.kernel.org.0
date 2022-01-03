Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEA2483306
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiACOcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:32:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33812 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiACOaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7A53B80EFF;
        Mon,  3 Jan 2022 14:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0B5C36AEB;
        Mon,  3 Jan 2022 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220249;
        bh=oxhUhvFTWeK3mUGF9MafxpL16GDYsAKol6H7Dor33hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBFJD/NSAE78T04hEWcKEEd2ZA1gCgeAtEWFiRB2xYR37TB+dcaiS8CMWLo0dla4L
         3MGS62nJK2ROTeraxg2n7WbcLBJchUgO3sQ8VZDlD8sc/LODzbHOzsqvxgndj3ZOHa
         EHyq3VC9yQtAZdrqcAtKRqgebfrdPzwXLFGKzCYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Libin Yang <libin.yang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/73] ALSA: hda: intel-sdw-acpi: harden detection of controller
Date:   Mon,  3 Jan 2022 15:23:31 +0100
Message-Id: <20220103142057.251741078@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



