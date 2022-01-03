Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DAF483308
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbiACOcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:32:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60386 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbiACOax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A9D06112B;
        Mon,  3 Jan 2022 14:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59B3C36AED;
        Mon,  3 Jan 2022 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220252;
        bh=b3Xj1hsvYvx7YeGTfGNEKNSU4PO1BelsYqOh4/01pZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYINBCLbhy9+1mbQb+3IXLq2WfRGyHg81qF8EPpAXC2AL3SFUo0b8qvgcV5/d27JW
         3cQEQKllIvD/Lj/W3U8S4gz65HDAkXAiG7WUTKksKGlLHpEPtX+4/HSf/PmIVxNE/s
         TOyd+TnJX1Y+VqGJbnUJ4eCiUnVQ6NNpHuZzhV2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Libin Yang <libin.yang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/73] ALSA: hda: intel-sdw-acpi: go through HDAS ACPI at max depth of 2
Date:   Mon,  3 Jan 2022 15:23:32 +0100
Message-Id: <20220103142057.281864330@linuxfoundation.org>
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



