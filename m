Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9421219C9B4
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388571AbgDBTRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39526 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388668AbgDBTRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id p10so5591542wrt.6
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MsgQu2s5Ine+vEQU/kp8/4vrgQB3e/69fxJksj4R8LU=;
        b=O7/5GI48MxA+FT3i0PbzJRsTTHjysb3rIX9ZtfieGrJ8Qp7MaTPl7rG82xr/KMnTEP
         QdcGaIvQlcwb+neCN0gW5PaAgiT65sEyUfEU6tHAkXuWx5X/OZkxLpirjDYv5+QJ1VZz
         AY4noQ+WeNqOm8jwwqRabRBK/HYK3oIRzmX5Gv5/3gOh+PrHj0qVVBD9YmICVPFBBrR/
         QO4WLhBPOEVqr2drMdm7KeHSk7pwDJ/AO43M819nuNn0+22Vmlq3z0t+8YrPvueZwBEP
         fI4H73Tk9BS642H1YHMgaWL7jEs/ig4YxONMEZSGBMXHl8V8omdVRmRYxhoEWn47yGvx
         2TBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MsgQu2s5Ine+vEQU/kp8/4vrgQB3e/69fxJksj4R8LU=;
        b=YzRHpuPIYVUaiZPLkyRbGRcXYrPnnIai9TC11u3ZvuFZCcEpEJJ8QtBhe+LgLeF04W
         PmPb8+2JajpvvpA4d5vYxSKLyRavIAej43lyLDMQ1dUbuvoy+IYKHSdc1716IKknUvdc
         /XlVLD8wTWiNMUYPsgFeDNPItBzHQEd0ck/9j2dkaxhY8Do4T5ZO+ighEU3ZKQlWsngK
         w3t7Tk9bpIp/Iy1OrD9d+ca9VjxjP0h0nE+RKCW9iQmojaiIH7Dc2FL3Oxu1ARn+o5LH
         NK4h2/usRm604sMkpvptVjuyXMQf6nPc2VwmavdK6tmTsvxJggtEpuu8ycjDE+WFt1sZ
         Dz6Q==
X-Gm-Message-State: AGi0PuYNCHXTf8xTeZiBlxFpjbtyeDaAMDGgIm6U1v5CgtgYPLerD1cw
        SL16Scw6ONkPKlv2shZBeRqnykONyjgKIQ==
X-Google-Smtp-Source: APiQypL401ZQY47DLEAbSOs16/DAStlA4lmnuqykhVz8LO/cYBpsUCBVsudur2X14rX6hbEi833OfA==
X-Received: by 2002:a05:6000:4:: with SMTP id h4mr4874935wrx.236.1585855019226;
        Thu, 02 Apr 2020 12:16:59 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:16:58 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 05/24] drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()
Date:   Thu,  2 Apr 2020 20:17:28 +0100
Message-Id: <20200402191747.789097-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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

