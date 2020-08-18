Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04CE2486D9
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 16:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgHRONP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 10:13:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgHRONH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 10:13:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3012080C;
        Tue, 18 Aug 2020 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597759987;
        bh=bRrxl2/Yp/S+CoZjQiGLOPkj1b2LdZsA9BzrDwTw73o=;
        h=Subject:To:From:Date:From;
        b=Xo97hEOcgXjI7Ww1Z+pUobUCHpdc5NTQXE0PfCNCMK+9E4EKgrl1axHiuLcdX4KvN
         lmJZKe5rWWFoRPVto4Z2L0In5878HCzEUcn3A525lhciLtvtS9jSrqvMPneCAM+Kiw
         4vSOp7So/VO/0ylGMfHCfEFJ6rMkhwnAUc5OY3Ic=
Subject: patch "staging: greybus: audio: fix uninitialized value issue" added to staging-linus
To:     vaibhav.sr@gmail.com, colin.king@canonical.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 16:13:20 +0200
Message-ID: <15977600004434@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: greybus: audio: fix uninitialized value issue

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1dffeb8b8b4c261c45416d53c75ea51e6ece1770 Mon Sep 17 00:00:00 2001
From: Vaibhav Agarwal <vaibhav.sr@gmail.com>
Date: Fri, 14 Aug 2020 18:03:15 +0530
Subject: staging: greybus: audio: fix uninitialized value issue

The current implementation for gbcodec_mixer_dapm_ctl_put() uses
uninitialized gbvalue for comparison with updated value. This was found
using static analysis with coverity.

Uninitialized scalar variable (UNINIT)
11. uninit_use: Using uninitialized value
gbvalue.value.integer_value[0].
460        if (gbvalue.value.integer_value[0] != val) {

This patch fixes the issue with fetching the gbvalue before using it for
    comparision.

Fixes: 6339d2322c47 ("greybus: audio: Add topology parser for GB codec")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Vaibhav Agarwal <vaibhav.sr@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/bc4f29eb502ccf93cd2ffd98db0e319fa7d0f247.1597408126.git.vaibhav.sr@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/audio_topology.c | 29 ++++++++++++------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/greybus/audio_topology.c b/drivers/staging/greybus/audio_topology.c
index 2f9fdbdcd547..83b38ae8908c 100644
--- a/drivers/staging/greybus/audio_topology.c
+++ b/drivers/staging/greybus/audio_topology.c
@@ -456,6 +456,15 @@ static int gbcodec_mixer_dapm_ctl_put(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.integer.value[0] & mask;
 	connect = !!val;
 
+	ret = gb_pm_runtime_get_sync(bundle);
+	if (ret)
+		return ret;
+
+	ret = gb_audio_gb_get_control(module->mgmt_connection, data->ctl_id,
+				      GB_AUDIO_INVALID_INDEX, &gbvalue);
+	if (ret)
+		goto exit;
+
 	/* update ucontrol */
 	if (gbvalue.value.integer_value[0] != val) {
 		for (wi = 0; wi < wlist->num_widgets; wi++) {
@@ -466,25 +475,17 @@ static int gbcodec_mixer_dapm_ctl_put(struct snd_kcontrol *kcontrol,
 		gbvalue.value.integer_value[0] =
 			cpu_to_le32(ucontrol->value.integer.value[0]);
 
-		ret = gb_pm_runtime_get_sync(bundle);
-		if (ret)
-			return ret;
-
 		ret = gb_audio_gb_set_control(module->mgmt_connection,
 					      data->ctl_id,
 					      GB_AUDIO_INVALID_INDEX, &gbvalue);
-
-		gb_pm_runtime_put_autosuspend(bundle);
-
-		if (ret) {
-			dev_err_ratelimited(codec_dev,
-					    "%d:Error in %s for %s\n", ret,
-					    __func__, kcontrol->id.name);
-			return ret;
-		}
 	}
 
-	return 0;
+exit:
+	gb_pm_runtime_put_autosuspend(bundle);
+	if (ret)
+		dev_err_ratelimited(codec_dev, "%d:Error in %s for %s\n", ret,
+				    __func__, kcontrol->id.name);
+	return ret;
 }
 
 #define SOC_DAPM_MIXER_GB(xname, kcount, data) \
-- 
2.28.0


