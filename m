Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DDF19C98A
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389181AbgDBTNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40594 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388499AbgDBTNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id s8so3446188wrt.7
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CZoKztIEsmgAvabu7dcStmDLo2kd4ifdwugaw9w08qo=;
        b=zfb7pZWWsH8Di4oGsgySbWS3+2HySqQ807Hz1SsnFmKocCS/v3Ms6HcM0jdpS6bzVd
         e21TCewGWFrijLPJPEpZqU6lSoDX33/T/BhMk7JTXFkLUYc6I53lX9+veudHzXxyPlGr
         XVAXqj1yosawFrKMHKMzLhjNP8E4W8UVL9zAUYfIUTzWlVycZbGpEiAK5d8ViUBYrc3C
         f/Xe4bt3bFFWiMuk/SxjVuD3xHjkuYFQM5wlP1+gIPuResJ00BtZCx+gDv/XcHSVVPaf
         kB6TglPAZUG2rAvK5k6SEgAS2Jv0F4qEiGnOvPhLphuxJrBWudd4ADRP0k5H03/bDxm3
         f6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CZoKztIEsmgAvabu7dcStmDLo2kd4ifdwugaw9w08qo=;
        b=lzCaHplhLTKh8qZIz/dPchfKiWF3g4BtVk51bLovBcbeEjeN5ygAKGffEWK2YyuH1L
         72uDdRQkCcpuH7S2kEXjLjOyAATCJDXCm6swVsFSFSjsXVemZlQmAL4FHV5sEj9V/TUm
         dB30Fr49gsXwOMrHwyy9jKW1iciy/k4SPCDe3gcfMAMeuEcWnSIcb8aI7PWkWV/ZrwPf
         bgSFrer8PYMHbYYusb1DdHzf2UQn361WhpaUoGAFDk7uxBBRygf4sw5h+pzc3/9BxdaS
         NfJ3CIz5j9oJK8Tt0mnMQ49lCCU3wypdSL5SoRH53D+/XX/a605twFmngH1TNuy1zbSB
         ToOA==
X-Gm-Message-State: AGi0PuYLklOauXqnuqSUvvQHLwkQFTx8LmAzxAw5+XNEsaGFIdGxR34s
        gNh19Sq+Vf6W5Jv1ZjMErMNvS/ta0KKO0A==
X-Google-Smtp-Source: APiQypLjBa7Wwh0eXLiGm9V1E6UjNIe4XUs/hIq7YMEX6/0/VOJIJZw1UMRXYkvzW76mapVkxZ76qw==
X-Received: by 2002:a5d:4648:: with SMTP id j8mr5016308wrs.202.1585854783288;
        Thu, 02 Apr 2020 12:13:03 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:02 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 04/33] drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()
Date:   Thu,  2 Apr 2020 20:13:24 +0100
Message-Id: <20200402191353.787836-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index 9d94c306c8ca1..a4bf98e6af57d 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -433,6 +433,7 @@ static bool drm_dp_sideband_parse_remote_dpcd_read(struct drm_dp_sideband_msg_rx
 	if (idx > raw->curlen)
 		goto fail_len;
 	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
+	idx++;
 	if (idx > raw->curlen)
 		goto fail_len;
 
-- 
2.25.1

