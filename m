Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D084B796FB
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404150AbfG2TzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404141AbfG2Ty7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C036204EC;
        Mon, 29 Jul 2019 19:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430098;
        bh=DdfrbT/h5+IQ5TDhREUJeTkJ1Qo6pc6XqjlIG7Ji4qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faDaPQ6d+kC7FjioofxGSn3kZobwKJzuhZnMsAw6g56IwZa3gabWW2QhrwheCUiJv
         kaSYCsUEwd7cVbYrvsaa0COkQ6iyN865WRcKPBI6s67s67pKpghPKHLmJup33oMkzG
         RtIP5qAvWaW/NfIhbXz8vpGHUx2uJbmuuVoUnTTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Todd Brandt <todd.e.brandt@linux.intel.com>
Subject: [PATCH 5.2 194/215] ALSA: hda - Fix intermittent CORB/RIRB stall on Intel chips
Date:   Mon, 29 Jul 2019 21:23:10 +0200
Message-Id: <20190729190813.533620151@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2756d9143aa517b97961e85412882b8ce31371a6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -313,11 +313,10 @@ enum {
 
 #define AZX_DCAPS_INTEL_SKYLAKE \
 	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME |\
+	 AZX_DCAPS_SYNC_WRITE |\
 	 AZX_DCAPS_SEPARATE_STREAM_TAG | AZX_DCAPS_I915_COMPONENT)
 
-#define AZX_DCAPS_INTEL_BROXTON \
-	(AZX_DCAPS_INTEL_PCH_BASE | AZX_DCAPS_PM_RUNTIME |\
-	 AZX_DCAPS_SEPARATE_STREAM_TAG | AZX_DCAPS_I915_COMPONENT)
+#define AZX_DCAPS_INTEL_BROXTON		AZX_DCAPS_INTEL_SKYLAKE
 
 /* quirks for ATI SB / AMD Hudson */
 #define AZX_DCAPS_PRESET_ATI_SB \


