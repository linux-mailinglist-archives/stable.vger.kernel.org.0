Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66D71333AF
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgAGVEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:04:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbgAGVEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:04:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98D0B214D8;
        Tue,  7 Jan 2020 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431049;
        bh=mCIsjUFYY2CU44Xl8pU6vMBNjhgSTJO5tIurYnrLIR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXHTxnOIusN5xaBDevXtOxTYaSlOqfLT2ifccHPn7N523ERu5vEDmJrEZNi2oJrNv
         3/5zG0KNP+sm/z+6XtBaf8lVjWKKUFMCbFyhdfcl8ZdoY9TEWDFczcBcT0QfAYn6dS
         3KStxHRjbbZrtO/h5nCrd0eaqJx0OYMOR7sYtanQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Galiffi <David.Galiffi@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/115] drm/amd/display: Fixed kernel panic when booting with DP-to-HDMI dongle
Date:   Tue,  7 Jan 2020 21:53:35 +0100
Message-Id: <20200107205243.329934126@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Galiffi <David.Galiffi@amd.com>

[ Upstream commit a51d9f8fe756beac51ce26ef54195da00a260d13 ]

[Why]
In dc_link_is_dp_sink_present, if dal_ddc_open fails, then
dal_gpio_destroy_ddc is called, destroying pin_data and pin_clock. They
are created only on dc_construct, and next aux access will cause a panic.

[How]
Instead of calling dal_gpio_destroy_ddc, call dal_ddc_close.

Signed-off-by: David Galiffi <David.Galiffi@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index c6f7c1344a9b..2f42964fb9f4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -348,7 +348,7 @@ bool dc_link_is_dp_sink_present(struct dc_link *link)
 
 	if (GPIO_RESULT_OK != dal_ddc_open(
 		ddc, GPIO_MODE_INPUT, GPIO_DDC_CONFIG_TYPE_MODE_I2C)) {
-		dal_gpio_destroy_ddc(&ddc);
+		dal_ddc_close(ddc);
 
 		return present;
 	}
-- 
2.20.1



