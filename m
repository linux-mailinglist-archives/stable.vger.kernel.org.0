Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEF42A57ED
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbgKCUtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731700AbgKCUtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA0222404;
        Tue,  3 Nov 2020 20:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436589;
        bh=UhyYgVp+1KR7j5IDTpEgX1c8mS2WPI5TB7Sqf8WcqCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yS5LSSLrLkpnZm98ExgoXsOtkN6MJ0phrUpr9jsUxStsgfcyAeVr5aY0scoRe5J20
         BDnxqxWG1h2ro05aZ6B9FHzPC5uSSBNZIgd+pkLB0SW2tZkRzw95Pa42/K8isgMUZV
         42xHCgUcVfCeKAdzDZxhGkFbr2zrki8yBE1M18gY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Galiffi <David.Galiffi@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 317/391] drm/amd/display: Fix incorrect backlight register offset for DCN
Date:   Tue,  3 Nov 2020 21:36:08 +0100
Message-Id: <20201103203408.501224393@linuxfoundation.org>
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

From: David Galiffi <David.Galiffi@amd.com>

commit 651111be24aa4c8b62c10f6fff51d9ad82411249 upstream.

[Why]
Typo in backlight refactor introduced wrong register offset.

[How]
SR(BIOS_SCRATCH_2) to NBIO_SR(BIOS_SCRATCH_2).

Signed-off-by: David Galiffi <David.Galiffi@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.h
@@ -54,7 +54,7 @@
 	SR(BL_PWM_CNTL2), \
 	SR(BL_PWM_PERIOD_CNTL), \
 	SR(BL_PWM_GRP1_REG_LOCK), \
-	SR(BIOS_SCRATCH_2)
+	NBIO_SR(BIOS_SCRATCH_2)
 
 #define DCE_PANEL_CNTL_SF(reg_name, field_name, post_fix)\
 	.field_name = reg_name ## __ ## field_name ## post_fix


