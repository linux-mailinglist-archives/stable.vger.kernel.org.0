Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC2E4F7D6F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbfKKS4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbfKKS4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:56:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5073E20818;
        Mon, 11 Nov 2019 18:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498599;
        bh=OKGQPToTmHIJ8jurJdl4brdaM0zohBVeFg0cgXCGx0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzrtS5Lfmh6xsh3HATT9tX94N06Gc47k3TLkaWM4u12uaK9DAY2lJxA6HS28Rm65I
         uMwjT4pelTL1z2K9jjXcKvjXZ7dwP+JKj9sXEPcKKZ/TkCXU2fyIax3qngMv/7BpME
         gMV/79eY07A5dYzXrac3pB9zCb874LQJaPgbEC50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Lei <Jun.Lei@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 167/193] drm/amd/display: do not synchronize "drr" displays
Date:   Mon, 11 Nov 2019 19:29:09 +0100
Message-Id: <20191111181513.449469732@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Lei <Jun.Lei@amd.com>

[ Upstream commit 8775e89fa7121535d2da738c95167b8c65aa6e90 ]

[why]
A display that supports DRR can never really be considered
"synchronized" with any other display because we can dynamically
enable DRR (i.e. without modeset).  this will cause their
relative CRTC positions to drift and lose sync.  this will disrupt
features such as MCLK switching that assume and depend on
their permanent alignment (that can only change with modeset)

[how]
check for ignore_msa in stream when considered synchronizability
this ignore_msa is basically actually implemented as "supports drr"

Signed-off-by: Jun Lei <Jun.Lei@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 68db60e4caf32..d1a33e04570f4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -394,6 +394,9 @@ bool resource_are_streams_timing_synchronizable(
 	if (stream1->view_format != stream2->view_format)
 		return false;
 
+	if (stream1->ignore_msa_timing_param || stream2->ignore_msa_timing_param)
+		return false;
+
 	return true;
 }
 static bool is_dp_and_hdmi_sharable(
@@ -1566,6 +1569,9 @@ bool dc_is_stream_unchanged(
 	if (!are_stream_backends_same(old_stream, stream))
 		return false;
 
+	if (old_stream->ignore_msa_timing_param != stream->ignore_msa_timing_param)
+		return false;
+
 	return true;
 }
 
-- 
2.20.1



