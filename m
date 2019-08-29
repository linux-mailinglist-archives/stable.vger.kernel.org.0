Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E588AA2171
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfH2Qw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 12:52:26 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:32938 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbfH2QwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 12:52:25 -0400
Received: by mail-yb1-f193.google.com with SMTP id a17so1438530ybc.0
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 09:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IWHGTbjCnJwyiyI9Ca3d5eKUwHiljjpclYfL/wFTtyU=;
        b=HnHdjDcSHvDje8oZPzGSbFwk5vBbRKynW8WE1qn9oYUAqXENEds0d/fluwd/RR1fpd
         VsF0HoxjBgf8UuEip4jHNCbW3nUVpvhPDOvjWVqiV5h5cv30PVWJ17FsTK6VQlAkC8e3
         TkEpDUUUYD+Q06WbisqP5f/wWlm42KRYuNWBaGOwWFd+/dw3rXHgux4PXoR7LugRHzlE
         zF+qDnLDx46k1mc/KN6y9Kv17ZFg/Bn07HmFYAABP6akdker9Tiqtb3JDAr3uB7cPYTk
         Oa/+Ul3GZBXscNHuYROHQCRKaSmBwT09rubf/0RmcJ+XQE+LTsEbLn27grG9ukx+RO+Z
         FNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IWHGTbjCnJwyiyI9Ca3d5eKUwHiljjpclYfL/wFTtyU=;
        b=jLt61pRFbnSgO9Esoo6dmWyFGVexjpltxyZKpDVzxLDeGbEBHpVUhbWRtMRxaExY3g
         EoGAPY45XfHXCNShPBuQZL6BKEHrKqGCdmMNnMW/y/tIY6/g/7muPw5AGNqpAh1g18+X
         uWZXWknH7DhxKKwq2K6Sg4ylRqfRwX3IDRrxhW5VaaPKqgY7g9BsR6mk7NBQIC76iSeb
         84reJBWgVgO8qd3KHiSUswEQ/BHnCj4nF3d33jpX6ktOTGZdioelYSPLiBCwcW0ch29f
         XgD2LRW9Y/04gOoGnilBMFE/hEN+dYWbFcdBmK39JgfhT8Lc4eIaFdvVPkfgoQ39rAWu
         FeUQ==
X-Gm-Message-State: APjAAAX6UeoFywMFWTItiUmDTzxWwLxyR/f7WhLFVMLBvpSmHvf/T769
        JrIR/fjpesf+TuPrRqyimyub8w==
X-Google-Smtp-Source: APXvYqwNz943O/0Sm7Mch5qv38P9Uj6/qzSYIsI+XhYIjhV0Kbf6nhbnvWbCRbzRopUXgwjXE6n/uw==
X-Received: by 2002:a25:37c7:: with SMTP id e190mr7698196yba.117.1567097544968;
        Thu, 29 Aug 2019 09:52:24 -0700 (PDT)
Received: from rosewood.cam.corp.google.com ([2620:0:1013:11:89c6:2139:5435:371d])
        by smtp.gmail.com with ESMTPSA id d9sm620595ywd.55.2019.08.29.09.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 09:52:24 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org
Cc:     Sean Paul <seanpaul@chromium.org>, Lyude Paul <lyude@redhat.com>,
        Todd Previte <tprevite@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH] drm: mst: Fix query_payload ack reply struct
Date:   Thu, 29 Aug 2019 12:52:19 -0400
Message-Id: <20190829165223.129662-1-sean@poorly.run>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

Spec says[1] Allocated_PBN is 16 bits

[1]- DisplayPort 1.2 Spec, Section 2.11.9.8, Table 2-98

Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Todd Previte <tprevite@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Sean Paul <sean@poorly.run>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 include/drm/drm_dp_mst_helper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_dp_mst_helper.h b/include/drm/drm_dp_mst_helper.h
index 2ba6253ea6d3..fc349204a71b 100644
--- a/include/drm/drm_dp_mst_helper.h
+++ b/include/drm/drm_dp_mst_helper.h
@@ -334,7 +334,7 @@ struct drm_dp_resource_status_notify {
 
 struct drm_dp_query_payload_ack_reply {
 	u8 port_number;
-	u8 allocated_pbn;
+	u16 allocated_pbn;
 };
 
 struct drm_dp_sideband_msg_req_body {
-- 
Sean Paul, Software Engineer, Google / Chromium OS

