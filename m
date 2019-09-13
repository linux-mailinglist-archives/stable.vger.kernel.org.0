Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0E0B1F8B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390569AbfIMNUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390026AbfIMNUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:20:25 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E905420717;
        Fri, 13 Sep 2019 13:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380824;
        bh=8TkD0+W9zck4fhl47AiNSE+1H/b1ME/YVFvULp6mZWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGZ89glM2j6CEsqhtzc6pmAV4PgzZSFDQGr4X8fjqq4eG9EhQOFsui6Hc2DmUEoBx
         omXUN9lF3tcNEROUo8kZRJEYLXLmI6QzFgF+28VAgQH0AKj2joz+8hjADascv4T0N2
         5+04Mr2PzKnp+023IjzcVA+wlhaBVjonWBV3zPI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        Todd Brandt <todd.e.brandt@linux.intel.com>
Subject: [PATCH 4.19 168/190] ALSA: hda - Fix intermittent CORB/RIRB stall on Intel chips
Date:   Fri, 13 Sep 2019 14:07:03 +0100
Message-Id: <20190913130613.265417784@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



