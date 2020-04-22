Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E241B430A
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgDVLUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726684AbgDVLUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:08 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFD4C03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u127so1907239wmg.1
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MsgQu2s5Ine+vEQU/kp8/4vrgQB3e/69fxJksj4R8LU=;
        b=hU/UImhOgaBPrYxmlbvrhfuY0DVRcChjEjSIxhLm4KSDwBpk8qaM4842oVYTIqnBNe
         QqplL8fDemr0t3MjqYeIYaC9NLlmOy+EoSmDsMBQQE4AIDrD9tBsH7uIiw4QmYbyri6q
         AdzBG2i0JH/3J27IzYano4jVPXhLI9ht28l0yT6T1c7MtTMkQH3+YSddi1y5swXGHVbC
         bbb5QI7ZduhfYTGWsMjg4bnGhnPAMgS3UMR8XEqbiOOe+Kj3mnuvE1ATxOCDwFAyteMc
         hgjas7Wg3beHs4dcvcEGqPlBfrLTmyPjcvMG52/HC/TWs6MR8Di9zZStXPFGTigLw6fU
         /uWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MsgQu2s5Ine+vEQU/kp8/4vrgQB3e/69fxJksj4R8LU=;
        b=oPPUTXiry7mCI1xT5nhLqxIve5RNgcb+qikO4Daf2wLQZpNOmH+hunJWc8g7Wdt8i5
         PcejiFf3wAVVsx71cMVzAyIQxMnOEz4XXwW81ZWv1woXcELYBGQur01Y7ukc//ObuDqN
         3gdSDcXvW+2otXW2FuFb1/hcQYsHvgOz81XPYE3gEqj8hIeev4gtIAOhxMPCtt9u/iY/
         gGtPzFCIfCcRvgNi/KgbTwggZkqCSX/shFgkNtAAPDRKSmWyeEQaVUsmBa2Rnw2bD5j1
         cjzeREJzTi0+3vtEApXPaO2JUAbALLDppQGEAZqmfI0F9eSrIMmDgAZQyljadN8uiu0U
         /qrg==
X-Gm-Message-State: AGi0PuakEBeJJd5zIqYqSWtXY7we5Rznq5kcAEpofcR5qUDf6T0+guAX
        gMj0Iyf15YWPToWQqm0jN1YH2O7ZkiY=
X-Google-Smtp-Source: APiQypJ2TnXV4Sh5/FH1flErjab76R2V2iey4z+plkdp+ISGaPTr4ojnlnXEuOYmsVX02va6RRpcng==
X-Received: by 2002:a05:600c:c5:: with SMTP id u5mr10533544wmm.134.1587554406202;
        Wed, 22 Apr 2020 04:20:06 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Lyude Paul <lyude@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 05/21] drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()
Date:   Wed, 22 Apr 2020 12:19:41 +0100
Message-Id: <20200422111957.569589-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

[ Upstream commit a4c30a4861c54af78c4eb8b7855524c1a96d9f80 ]

When parsing the reply of a DP_REMOTE_DPCD_READ DPCD command the
result is wrong due to a missing idx increment.

This was never noticed since DP_REMOTE_DPCD_READ is currently not
used, but if you enable it, then it is all wrong.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/e72ddac2-1dc0-100a-d816-9ac98ac009dd@xs4all.nl
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 17aedaaf364c1..93f2033b414a2 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -431,6 +431,7 @@ static bool drm_dp_sideband_parse_remote_dpcd_read(struct drm_dp_sideband_msg_rx
 	if (idx > raw->curlen)
 		goto fail_len;
 	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
+	idx++;
 	if (idx > raw->curlen)
 		goto fail_len;
 
-- 
2.25.1

