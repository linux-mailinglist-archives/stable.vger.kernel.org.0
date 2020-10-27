Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C9429B4BA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752425AbgJ0PAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1787496AbgJ0PAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:00:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 147D220714;
        Tue, 27 Oct 2020 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810810;
        bh=1Aj6JeR182PwkxhNRcNlUtJai3evxxD9/5dvhRXyi1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Iyi+CJrXJMPyaSVb1V+fBX4IJIsBptFNajSY1SlGZWMAV7SEAHjzFPXR4IoYabb4
         +/q9R1FQsAuPaN/VNg8TN+WMOCrpZd1HUnsJIxf+87wjUo+IGz0Vdh+M4XndSKReKQ
         DFNF5l7kh30/O5+U3gDBW1WuyCGcEU54GSllGYAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 271/633] slimbus: core: do not enter to clock pause mode in core
Date:   Tue, 27 Oct 2020 14:50:14 +0100
Message-Id: <20201027135535.380939789@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit df2c471c4ae07e18a0396db670dca2ef867c5153 ]

Let the controller logic decide when to enter into clock pause mode!
Entering in to pause mode during unregistration does not really make
sense as the controller is totally going down at that point in time.

Fixes: 4b14e62ad3c9e ("slimbus: Add support for 'clock-pause' feature")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200925095520.27316-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/slimbus/core.c b/drivers/slimbus/core.c
index 58b63ae0e75a6..1d2bc181da050 100644
--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -301,8 +301,6 @@ int slim_unregister_controller(struct slim_controller *ctrl)
 {
 	/* Remove all clients */
 	device_for_each_child(ctrl->dev, NULL, slim_ctrl_remove_device);
-	/* Enter Clock Pause */
-	slim_ctrl_clk_pause(ctrl, false, 0);
 	ida_simple_remove(&ctrl_ida, ctrl->id);
 
 	return 0;
-- 
2.25.1



