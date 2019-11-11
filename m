Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F64FF7B15
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfKKScV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:32:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbfKKScU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:32:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC0C9222C9;
        Mon, 11 Nov 2019 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497140;
        bh=cIA2Er4jQ/jeqXZOLNDmggGDCTaLVlwFasMubnHygrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1+HH2JAp9UMmFo/Tp0of0xdFcxKHHHuirkBUe67SRxCslRPreFguhDmVmV/Tt2wB
         Pksiazu+LRubbdFhEjVwfkaCvFrAKzawsIN8grRjhFoT90kufzzfEVKcF2XblduGk0
         yPepmWcfC4Eli6atTfDVrixRLrV5UZJ0r/I0U8fI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Zhao <yong.zhao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.9 17/65] drm/radeon: fix si_enable_smc_cac() failed issue
Date:   Mon, 11 Nov 2019 19:28:17 +0100
Message-Id: <20191111181344.326123799@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 2c409ba81be25516afe05ae27a4a15da01740b01 upstream.

Need to set the dte flag on this asic.

Port the fix from amdgpu:
5cb818b861be114 ("drm/amd/amdgpu: fix si_enable_smc_cac() failed issue")

Reviewed-by: Yong Zhao <yong.zhao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si_dpm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -1956,6 +1956,7 @@ static void si_initialize_powertune_defa
 		case 0x682C:
 			si_pi->cac_weights = cac_weights_cape_verde_pro;
 			si_pi->dte_data = dte_data_sun_xt;
+			update_dte_from_pl2 = true;
 			break;
 		case 0x6825:
 		case 0x6827:


