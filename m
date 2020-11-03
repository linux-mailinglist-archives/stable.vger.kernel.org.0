Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3B42A5679
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbgKCU7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733137AbgKCU7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3C882053B;
        Tue,  3 Nov 2020 20:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437179;
        bh=++ju2fKRxiCQv1EbNy1d6SkepNYAyD/77pNvAKt6BFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIxh2zFnvGh5WSdVZFYGqPmYjZ9uXT/JWhf9VqLVYkiGkdMvTYEffun2zqcnJnYRa
         62ovWtVAIKoGlneDZ86cpz7hLkcsBaVQ33FgkG/8YcOPETWpk6J9+0TmuzBI1kEm75
         LapoGMwtZwobGkVdTB1F+UySrsbOW0t95Z0kVfXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 180/214] drm/amd/display: Increase timeout for DP Disable
Date:   Tue,  3 Nov 2020 21:37:08 +0100
Message-Id: <20201103203307.580064817@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

commit 37b7cb10f07c1174522faafc1d51c6591b1501d4 upstream.

[WHY]
When disabling DP video, the current REG_WAIT timeout
of 50ms is too low for certain cases with very high
VSYNC intervals.

[HOW]
Increase the timeout to 102ms, so that
refresh rates as low as 10Hz can be handled properly.

Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
@@ -898,10 +898,10 @@ void enc1_stream_encoder_dp_blank(
 	 */
 	REG_UPDATE(DP_VID_STREAM_CNTL, DP_VID_STREAM_DIS_DEFER, 2);
 	/* Larger delay to wait until VBLANK - use max retry of
-	 * 10us*5000=50ms. This covers 41.7ms of minimum 24 Hz mode +
+	 * 10us*10200=102ms. This covers 100.0ms of minimum 10 Hz mode +
 	 * a little more because we may not trust delay accuracy.
 	 */
-	max_retries = DP_BLANK_MAX_RETRY * 250;
+	max_retries = DP_BLANK_MAX_RETRY * 501;
 
 	/* disable DP stream */
 	REG_UPDATE(DP_VID_STREAM_CNTL, DP_VID_STREAM_ENABLE, 0);


