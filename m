Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807DC2A4B76
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgKCQ3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgKCQ3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:29:15 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E271C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:29:15 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id g17so3527305qts.5
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jz8hWyeLCDU1uCQNL3NNtY0a7zCNewhmalZFotzhmyk=;
        b=NgLt7Ss2A/8L8hrK35v2SbfQxOBMmLDO1Mxmwz7jq+FMszoCOPDsCLtwanTl6KLTiQ
         odx5L+gsUI7hppWSMth1PQbY6qw8UHbSvqYAiZVgvppuCFUlWFiDOOaaDIF4hLyvCJ2q
         lxKQDa9MsAOf5yP/qo60HD4F6r+1DLD0rkz6BZehBS5aZ4RHdzyBOyajBjeN3sJP7qv3
         lsRo3B1J0rYc7eHuEN3SLjeHZcA5evQE2zZog3+Aw4RCysYMPSI6U4kdXcfUh1TMf+e1
         7ypqeL9Bw//dTLYbDjH/7mVzGmCj7A1/GF1Kq2z7Nnc+SaOFnNFdh0zg1m1nKF7cfHWZ
         eH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jz8hWyeLCDU1uCQNL3NNtY0a7zCNewhmalZFotzhmyk=;
        b=OguJNwVc+qGs8Q8/NeOGuJkJZkYNDcufLpcJYCQrvJJH1NnNDV9d+Ze9QSAwYDjeN8
         jqjZ5YBvNCk/6JuHhUUIDlZz1xFG2T39pewE7vDM89TYz+hv4/de64DjapMiXJsstd1i
         1x74VwoqwnxuvMQ/kytKrvWghbLcboD1Fan7vFF0dTW5u9K3S0qs2na0F2B8uPjwVboZ
         lkYqD77fAIoZVDkTC+TIfPokCixp7ZOj9s3eykIkWbbGmR4gwytupP/yiBme0zJwyA7f
         qm5pkODgT9JM63lz0KCJn2iBpSi3fgLA6/u4VDcEBOnH/0X/K5nK9HnkN+xCrhTS03Ty
         j6MA==
X-Gm-Message-State: AOAM530+rGC7PiUWxv8wGeutbovTo4jIskm38RN73vbhNRquzv8EjEIy
        yPUtWO//UDp54nDYvCohDhGG+8HkNAI=
X-Google-Smtp-Source: ABdhPJxDwTB9b9MS8hsEDKeX8rTijXO5Vs9p+UEUlGyjg9M4+YocZzWtPWdnZ95jPOtaLKWdvLHOCA==
X-Received: by 2002:ac8:750a:: with SMTP id u10mr5847515qtq.303.1604420954630;
        Tue, 03 Nov 2020 08:29:14 -0800 (PST)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id d48sm10171434qta.26.2020.11.03.08.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:29:13 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 2/7] drm/amd/pm: increase mclk switch threshold to 200 us
Date:   Tue,  3 Nov 2020 11:28:58 -0500
Message-Id: <20201103162903.687752-4-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103162903.687752-1-alexander.deucher@amd.com>
References: <20201103162903.687752-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

To avoid underflow seen on Polaris10 with some 3440x1440
144Hz displays. As the threshold of 190 us cuts too close
to minVBlankTime of 192 us.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit 83da6eea3af669ee0b1f1bc05ffd6150af984994)
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
index 4a3b64aa21ce..fc63d9e32e1f 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -2873,7 +2873,7 @@ static int smu7_vblank_too_short(struct pp_hwmgr *hwmgr,
 		if (hwmgr->is_kicker)
 			switch_limit_us = data->is_memory_gddr5 ? 450 : 150;
 		else
-			switch_limit_us = data->is_memory_gddr5 ? 190 : 150;
+			switch_limit_us = data->is_memory_gddr5 ? 200 : 150;
 		break;
 	case CHIP_VEGAM:
 		switch_limit_us = 30;
-- 
2.25.4

