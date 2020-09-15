Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD95526B5EE
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgIOXyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbgIOObc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C7822275;
        Tue, 15 Sep 2020 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179798;
        bh=3DeDof8zH8ebgLROJLAJWdreYRB88ogNi4I2Oja4Bdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7lUD0aZElTtF64B7EZ2HIUL9IyREXe46V+zJH9GjvnlqtSuNWoHfNgfBPjJoMvZm
         cbxW6C2pW9zLR/+sNHVaUkG4bc+NdqUZD173GE/8Fr8Y7F/azSCzQudsWuufY8mv0l
         YGfnO8LYHovVXdEhxnznHWiogWPK1xX/4xzZ5XOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Vaibhav Agarwal <vaibhav.sr@gmail.com>
Subject: [PATCH 5.4 121/132] staging: greybus: audio: fix uninitialized value issue
Date:   Tue, 15 Sep 2020 16:13:43 +0200
Message-Id: <20200915140650.172030849@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Agarwal <vaibhav.sr@gmail.com>

commit 1dffeb8b8b4c261c45416d53c75ea51e6ece1770 upstream.

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
 drivers/staging/greybus/audio_topology.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/staging/greybus/audio_topology.c
+++ b/drivers/staging/greybus/audio_topology.c
@@ -460,6 +460,15 @@ static int gbcodec_mixer_dapm_ctl_put(st
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
@@ -473,25 +482,17 @@ static int gbcodec_mixer_dapm_ctl_put(st
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
-			dev_err_ratelimited(codec->dev,
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


