Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF8C4626B2
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbhK2W4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbhK2WzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:55:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2C3C1E03F7;
        Mon, 29 Nov 2021 10:41:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7BF6CE1626;
        Mon, 29 Nov 2021 18:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674DAC53FAD;
        Mon, 29 Nov 2021 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211301;
        bh=l3JGOqUrRIZyX3WExihIQ9YWO/M7LKCCIfjqjQt6aB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwimHXKS10T/XWxHt39Tvjvnc7SShl3zmWa9PNnG+/gjkl7t7Ho6zJrHY97x4blac
         mcRAlZs4zdc+UISnadwcNy9LrV0JY+mpBr3fW0kjEqEupQi1ELbYDOv15wj/hmLjcq
         KVgE5q4HPSaJ6uMT584vmtIfZiebzBwH8VlXpr/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.15 174/179] firmware: arm_scmi: Fix type error in sensor protocol
Date:   Mon, 29 Nov 2021 19:19:28 +0100
Message-Id: <20211129181724.661901066@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

commit bd074e5039ee16d71833a67337e2f6bf5d106b3a upstream.

Fix incorrect type error reported by sparse as:

drivers/firmware/arm_scmi/sensors.c:640:28: warning: incorrect type in argument 1 (different base types)
drivers/firmware/arm_scmi/sensors.c:640:28: expected unsigned int [usertype] val
drivers/firmware/arm_scmi/sensors.c:640:28: got restricted __le32 [usertype]

Link: https://lore.kernel.org/r/20211115154043.49284-2-cristian.marussi@arm.com
Fixes: 7b83c5f410889 ("firmware: arm_scmi: Add SCMI v3.0 sensor configuration support")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/sensors.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -637,7 +637,7 @@ static int scmi_sensor_config_get(const
 	if (ret)
 		return ret;
 
-	put_unaligned_le32(cpu_to_le32(sensor_id), t->tx.buf);
+	put_unaligned_le32(sensor_id, t->tx.buf);
 	ret = ph->xops->do_xfer(ph, t);
 	if (!ret) {
 		struct sensors_info *si = ph->get_priv(ph);


