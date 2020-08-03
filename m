Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E65239FBF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 08:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgHCGq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 02:46:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55201 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgHCGq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 02:46:56 -0400
Received: from [114.252.213.24] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1k2UFJ-0002pN-0H; Mon, 03 Aug 2020 06:46:53 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH] Revert "ALSA: hda: call runtime_allow() for all hda controllers"
Date:   Mon,  3 Aug 2020 14:46:38 +0800
Message-Id: <20200803064638.6139-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9a6418487b56 ("ALSA: hda: call runtime_allow()
for all hda controllers").

The reverted patch already introduced some regressions on some
machines:
 - on gemini-lake machines, the error of "azx_get_response timeout"
   happens in the hda driver.
 - on the machines with alc662 codec, the audio jack detection doesn't
   work anymore.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208511
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/hda_intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index e699873c8293..e34a4d5d047c 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2352,7 +2352,6 @@ static int azx_probe_continue(struct azx *chip)
 
 	if (azx_has_pm_runtime(chip)) {
 		pm_runtime_use_autosuspend(&pci->dev);
-		pm_runtime_allow(&pci->dev);
 		pm_runtime_put_autosuspend(&pci->dev);
 	}
 
-- 
2.17.1

