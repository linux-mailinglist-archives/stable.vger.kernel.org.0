Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98824A6F95
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbfICQda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730823AbfICQbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:31:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AE2523789;
        Tue,  3 Sep 2019 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528309;
        bh=zYpf6LcmcPRXNyxdZ9NouTwFkdG53ktbHALUub252VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLt0mdXf0/xRqbpvZfMxXNOXAUNwXe5lSgAyuYzkg+uAXt3cTU7eFrTT4dF67FruS
         wMrj70xhmsNXpeFz4b1Tb2Sbqp6VdNTSl87BSgXIOVcTMrBega2gOqvtYf2Jl6HK3r
         RQMvb4flWiwRQPm7YwIPvcl8O//onX0Xw1QrB6vA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 148/167] ALSA: hda - Fix intermittent CORB/RIRB stall on Intel chips
Date:   Tue,  3 Sep 2019 12:25:00 -0400
Message-Id: <20190903162519.7136-148-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 2756d9143aa517b97961e85412882b8ce31371a6 ]

It turned out that the recent Intel HD-audio controller chips show a
significant stall during the system PM resume intermittently.  It
doesn't happen so often and usually it may read back successfully
after one or more seconds, but in some rare worst cases the driver
went into fallback mode.

After trial-and-error, we found out that the communication stall seems
covered by issuing the sync after each verb write, as already done for
AMD and other chipsets.  So this patch enables the write-sync flag for
the recent Intel chips, Skylake and onward, as a workaround.

Also, since Broxton and co have the very same driver flags as Skylake,
refer to the Skylake driver flags instead of defining the same
contents again for simplification.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=201901
Reported-and-tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 7a3e34b120b33..c3e3d80ff7203 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -329,13 +329,11 @@ enum {
 
 #define AZX_DCAPS_INTEL_SKYLAKE \
 	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME |\
+	 AZX_DCAPS_SYNC_WRITE |\
 	 AZX_DCAPS_SEPARATE_STREAM_TAG | AZX_DCAPS_I915_COMPONENT |\
 	 AZX_DCAPS_I915_POWERWELL)
 
-#define AZX_DCAPS_INTEL_BROXTON \
-	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME |\
-	 AZX_DCAPS_SEPARATE_STREAM_TAG | AZX_DCAPS_I915_COMPONENT |\
-	 AZX_DCAPS_I915_POWERWELL)
+#define AZX_DCAPS_INTEL_BROXTON			AZX_DCAPS_INTEL_SKYLAKE
 
 /* quirks for ATI SB / AMD Hudson */
 #define AZX_DCAPS_PRESET_ATI_SB \
-- 
2.20.1

