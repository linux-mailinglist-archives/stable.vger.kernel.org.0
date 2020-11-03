Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB3B2A5803
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgKCVrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731952AbgKCUvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B04912236F;
        Tue,  3 Nov 2020 20:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436683;
        bh=S+UFl7fqQwDKvCUJ1NqoAB2Dht1IekaE/sy4E/yC8LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlMfxoIzl5YTtFXaTE+ZfMUvXT9D6ZBq/R8mnwTIZKX6jj9j60Q2IZM93b07MUX32
         bTY7RL424BQPrcENNcGnrjvEhWtql3THjVqHBZkTFeKdndZyQijf+8ibK/kXaHU4CR
         i3vko1gKRLVZRLlYS4DEHZIBK884mDQ3F8S1I/n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Feng <kenneth.feng@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 358/391] drm/amd/pm: fix pp_dpm_fclk
Date:   Tue,  3 Nov 2020 21:36:49 +0100
Message-Id: <20201103203411.291772362@linuxfoundation.org>
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

From: Kenneth Feng <kenneth.feng@amd.com>

commit 392d256fa26d943fb0a019fea4be80382780d3b1 upstream.

fclk value is missing in pp_dpm_fclk. add this to correctly show the current value.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
@@ -447,6 +447,9 @@ static int sienna_cichlid_get_smu_metric
 	case METRICS_CURR_DCEFCLK:
 		*value = metrics->CurrClock[PPCLK_DCEFCLK];
 		break;
+	case METRICS_CURR_FCLK:
+		*value = metrics->CurrClock[PPCLK_FCLK];
+		break;
 	case METRICS_AVERAGE_GFXCLK:
 		if (metrics->AverageGfxActivity <= SMU_11_0_7_GFX_BUSY_THRESHOLD)
 			*value = metrics->AverageGfxclkFrequencyPostDs;


