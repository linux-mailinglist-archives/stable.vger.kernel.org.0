Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983D32A5299
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbgKCUvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731947AbgKCUvV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D8182053B;
        Tue,  3 Nov 2020 20:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436680;
        bh=H+tMIB1mVm+VoOgD6+ybEd6qyTtwzC8e6OO9CNngo30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=waeSFoUfrYjEEkmkXg9aAx9KezIFQjv7fCB85cmOwtReKvc36SkCYsjzj2TJq/sRk
         xofEJfBMLtHg7uZObEbGEx/AGGqq9eXezmg1OHDPVExRA0BjuVh8uxn54Xd1oVvM4+
         jcm2BSh8hqk8rReOohIaL536ZhReNc9AtP+Bm2bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 357/391] drm/amd/pm: increase mclk switch threshold to 200 us
Date:   Tue,  3 Nov 2020 21:36:48 +0100
Message-Id: <20201103203411.224239015@linuxfoundation.org>
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

From: Evan Quan <evan.quan@amd.com>

commit 83da6eea3af669ee0b1f1bc05ffd6150af984994 upstream.

To avoid underflow seen on Polaris10 with some 3440x1440
144Hz displays. As the threshold of 190 us cuts too close
to minVBlankTime of 192 us.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -2873,7 +2873,7 @@ static int smu7_vblank_too_short(struct
 		if (hwmgr->is_kicker)
 			switch_limit_us = data->is_memory_gddr5 ? 450 : 150;
 		else
-			switch_limit_us = data->is_memory_gddr5 ? 190 : 150;
+			switch_limit_us = data->is_memory_gddr5 ? 200 : 150;
 		break;
 	case CHIP_VEGAM:
 		switch_limit_us = 30;


