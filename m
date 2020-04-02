Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B3619C978
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389074AbgDBTLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54734 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731689AbgDBTLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id c81so4614464wmd.4
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gmGOQvsAVrNac3r2fPvk9ny0MoHOFf1e/7ikoc940pY=;
        b=OVsIbulFLUVp4jqk8I2YD7QsOXPyFpUdzNay867Z4Qb3UvNLu4b9tE+Ui8/foKPRIq
         fCUWqD28TqQ2lGB0cyXhIaoM2nikFdnSv6ayW3CUXaIqdym5Fc8GCna1ZbuRTLTljqOi
         UXGkLKzvC+3BxoqDf8+s1E2DhsC5aDEEls5yZaK68dBgftNWgURo4FhZ3QFLOboE3eKC
         H8W20XbUcTYUW2B23qOEOF+afBD8jJerg+iMrztb4eJqgVwLJbbZ3T46+KuIcDLqLAgs
         HHiqHQhmA6ucyZm6pKYlT/dzFCJ8YbSSn4vvzUmUSMpKYFmTw8DNLQ1C8H2pIqTsj/Hh
         hFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gmGOQvsAVrNac3r2fPvk9ny0MoHOFf1e/7ikoc940pY=;
        b=hm+dKHm7tCxFSfN3OatBIOyChS9nmDUsYOJiq5FIAxUDh90h+F7PnXUprw+0Py4ww/
         IJUhBH79rJps6MkP5P8sww0h34nDma2o1laZLlfLIGBiTwd3bSi5JmpIueDYl+tzofIk
         KmfMW7RAnDSHeS7yB18KtozgasQ2Wdw2Zg5vWdQjOxyVHFM9YYnnDcHSJ0f1YvYsdY0/
         +IDCdMW9dDrPE4OhaKrbZELpIaqIb3uhqC7cX0shjsfoKIyQfTcTWnqR6QV6Y1RiLKtP
         JmIhpb5HVZTWlZqfi5rau1zix4sF1Mop02BuzYpLFjsImgEg9cViX69wj195Op15FqgU
         OErg==
X-Gm-Message-State: AGi0PubmLdL4oa45x2pf6t9+edBHdivmrhk8/F6SC59nWODl+an3ZzKE
        xoi7RWnfL0GkavquVg2QmaQ2xWFsDd7nrQ==
X-Google-Smtp-Source: APiQypIQyuPOyPp3awgvJJt7JTECO4o+jUsnbIasJd0BSWQ8Ve0qVSnVHguvpzx+WU0kTDTRWu/vpg==
X-Received: by 2002:a05:600c:2f17:: with SMTP id r23mr1677606wmn.20.1585854690509;
        Thu, 02 Apr 2020 12:11:30 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:29 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 04/14] drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()
Date:   Thu,  2 Apr 2020 20:12:10 +0100
Message-Id: <20200402191220.787381-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
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
index bf4eed5f6a7ee..a7c7f522fe1c4 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -439,6 +439,7 @@ static bool drm_dp_sideband_parse_remote_dpcd_read(struct drm_dp_sideband_msg_rx
 	if (idx > raw->curlen)
 		goto fail_len;
 	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
+	idx++;
 	if (idx > raw->curlen)
 		goto fail_len;
 
-- 
2.25.1

