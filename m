Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CC513349D
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgAGV0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbgAGU6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 067F7208C4;
        Tue,  7 Jan 2020 20:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430722;
        bh=19JIRivrHLm4BzQ3KT1QJXT/8qrNlXSsGID6WapevY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MR0bY7Vc5NKDf1GdG3Uk1KNQ7XkHB7q4n8nfprQKvJRo0g/RfXWmQTsTlJECfGeIS
         D70a1a72ziRqPR3VCO/Q4mdkaMbO0I57AUHntfbcoZkCkT9IfYXSli5ATZAyhSEooa
         5Xp+2rql+iWz5x7Mt7zIWaubWtK1FvFMIGaqfogk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Klaus Ethgen <Klaus@ethgen.ch>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 069/191] ALSA: hda - Apply sync-write workaround to old Intel platforms, too
Date:   Tue,  7 Jan 2020 21:53:09 +0100
Message-Id: <20200107205336.682332722@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c366b3dbbab14b28d044b94eb9ce77c23482ea35 upstream.

Klaus Ethgen reported occasional high CPU usages in his system that
seem caused by HD-audio driver.  The perf output revealed that it's
in the unsolicited event handling in the workqueue, and the problem
seems triggered by some communication stall between the controller and
the codec at the runtime or system resume.

Actually a similar phenomenon was seen in the past for other Intel
platforms, and we already applied the workaround to enforce sync-write
for CORB/RIRB verbs for Skylake and newer chipsets (commit
2756d9143aa5 "ALSA: hda - Fix intermittent CORB/RIRB stall on Intel
chips").  Fortunately, the same workaround is applicable to the old
chipset, and the experiment showed the positive effect.

Based on the experiment result, this patch enables the sync-write
workaround for all Intel chipsets.  The only reason I hesitated to
apply this workaround was about the possibly slightly higher CPU usage.
But if the lack of sync causes a much severer problem even for quite
old chip, we should think this would be necessary for all Intel chips.

Reported-by: Klaus Ethgen <Klaus@ethgen.ch>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191223171833.GA17053@chua
Link: https://lore.kernel.org/r/20191223221816.32572-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -280,12 +280,13 @@ enum {
 
 /* quirks for old Intel chipsets */
 #define AZX_DCAPS_INTEL_ICH \
-	(AZX_DCAPS_OLD_SSYNC | AZX_DCAPS_NO_ALIGN_BUFSIZE)
+	(AZX_DCAPS_OLD_SSYNC | AZX_DCAPS_NO_ALIGN_BUFSIZE |\
+	 AZX_DCAPS_SYNC_WRITE)
 
 /* quirks for Intel PCH */
 #define AZX_DCAPS_INTEL_PCH_BASE \
 	(AZX_DCAPS_NO_ALIGN_BUFSIZE | AZX_DCAPS_COUNT_LPIB_DELAY |\
-	 AZX_DCAPS_SNOOP_TYPE(SCH))
+	 AZX_DCAPS_SNOOP_TYPE(SCH) | AZX_DCAPS_SYNC_WRITE)
 
 /* PCH up to IVB; no runtime PM; bind with i915 gfx */
 #define AZX_DCAPS_INTEL_PCH_NOPM \
@@ -300,13 +301,13 @@ enum {
 #define AZX_DCAPS_INTEL_HASWELL \
 	(/*AZX_DCAPS_ALIGN_BUFSIZE |*/ AZX_DCAPS_COUNT_LPIB_DELAY |\
 	 AZX_DCAPS_PM_RUNTIME | AZX_DCAPS_I915_COMPONENT |\
-	 AZX_DCAPS_SNOOP_TYPE(SCH))
+	 AZX_DCAPS_SNOOP_TYPE(SCH) | AZX_DCAPS_SYNC_WRITE)
 
 /* Broadwell HDMI can't use position buffer reliably, force to use LPIB */
 #define AZX_DCAPS_INTEL_BROADWELL \
 	(/*AZX_DCAPS_ALIGN_BUFSIZE |*/ AZX_DCAPS_POSFIX_LPIB |\
 	 AZX_DCAPS_PM_RUNTIME | AZX_DCAPS_I915_COMPONENT |\
-	 AZX_DCAPS_SNOOP_TYPE(SCH))
+	 AZX_DCAPS_SNOOP_TYPE(SCH) | AZX_DCAPS_SYNC_WRITE)
 
 #define AZX_DCAPS_INTEL_BAYTRAIL \
 	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_I915_COMPONENT)


