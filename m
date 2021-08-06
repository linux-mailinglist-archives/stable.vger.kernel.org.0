Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BFA3E25DA
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243664AbhHFIXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243671AbhHFIV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545A16103B;
        Fri,  6 Aug 2021 08:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238076;
        bh=m8l14w+egSfT/C7aH9DafRMc1X0hp5Wqj0hV362fQMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiH08+RXqMix3gJkS1DH7k5I7/9LjoMVXCxWfdO/rFkhCLFzmKEUoA5aJ04kYsTma
         ozl3AAPLVCvOTDkUgLnUuX+ynvfu/ZgCrM4L/qu6D6RA2AXiwZl0/d2zZQ61AXwxBr
         uIQ25QEXoN1ESSZRMPNyB1lsjFqKy2zuXLw/de28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Stylon Wang <stylon.wang@amd.com>
Subject: [PATCH 5.13 35/35] drm/amd/display: Fix ASSR regression on embedded panels
Date:   Fri,  6 Aug 2021 10:17:18 +0200
Message-Id: <20210806081114.880179631@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

commit 6be50f5d83adc9541de3d5be26e968182b5ac150 upstream.

[Why]
Regression found in some embedded panels traces back to the earliest
upstreamed ASSR patch. The changed code flow are causing problems
with some panels.

[How]
- Change ASSR enabling code while preserving original code flow
  as much as possible
- Simplify the code on guarding with internal display flag

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=213779
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1620
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1675,9 +1675,6 @@ static enum dp_panel_mode try_enable_ass
 	} else
 		panel_mode = DP_PANEL_MODE_DEFAULT;
 
-#else
-	/* turn off ASSR if the implementation is not compiled in */
-	panel_mode = DP_PANEL_MODE_DEFAULT;
 #endif
 	return panel_mode;
 }


