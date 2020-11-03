Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEBB2A581E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbgKCVsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:48:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731711AbgKCUtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9228C20719;
        Tue,  3 Nov 2020 20:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436592;
        bh=rjcczr0OLYDAKSqe2DMFn5QK29CM71Zq1WwY+8RlS2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdV2lYOqs11kTBPPIuF2IPTHMJlI98mbAs0ziQuk+3uWVTSuUwpFoC/CGaE7LTkLL
         JiaexDVhW6e4IIU2zNkSmMrUY1aOPPTA+BGEKPOsUxFMajPu8fZyJWsc5WFTDv4pzJ
         aEqNm0S3haHSoYosJOm85uWidvinG6514NBAye18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 318/391] drm/amd/display: Increase timeout for DP Disable
Date:   Tue,  3 Nov 2020 21:36:09 +0100
Message-Id: <20201103203408.568136235@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
@@ -896,10 +896,10 @@ void enc1_stream_encoder_dp_blank(
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


