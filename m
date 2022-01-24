Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE95E499ACF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573951AbiAXVqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456716AbiAXVjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4196C0419C7;
        Mon, 24 Jan 2022 12:26:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42E02614ED;
        Mon, 24 Jan 2022 20:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C07C340E5;
        Mon, 24 Jan 2022 20:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055981;
        bh=Qu5Alj4np2rsmPwZeeQ8YmvOKti3I/KQtYcIQZVE/lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBWmAsIB0uhTnSKpU4bHkxDbImc2CDTGLi+uMcC7dqv4zpzPk39Oc//9rDDX5HhDF
         Tf4NOjds2I+UK1ydaJ1Pegz+XQE+WAKSbIPGu8y/MNPuKikZwpnpWIbn9r0h9KKskv
         09/3zhIIQ9Le1zxfjX3Xevx8sbAO7CupipW1IR4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arseny Demidov <a.demidov@yadro.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/846] hwmon: (mr75203) fix wrong power-up delay value
Date:   Mon, 24 Jan 2022 19:36:54 +0100
Message-Id: <20220124184111.157997827@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arseny Demidov <arsdemal@gmail.com>

[ Upstream commit a8d6d4992ad9d92356619ac372906bd29687bb46 ]

In the file mr75203.c we have a macro named POWER_DELAY_CYCLE_256,
the correct value should be 0x100. The register ip_tmr is expressed
in units of IP clk cycles, in accordance with the datasheet.
Typical power-up delays for Temperature Sensor are 256 cycles i.e. 0x100.

Fixes: 9d823351a337 ("hwmon: Add hardware monitoring driver for Moortec MR75203 PVT controller")
Signed-off-by: Arseny Demidov <a.demidov@yadro.com>
Link: https://lore.kernel.org/r/20211219102239.1112-1-a.demidov@yadro.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/mr75203.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/mr75203.c b/drivers/hwmon/mr75203.c
index 868243dba1ee0..1ba1e31459690 100644
--- a/drivers/hwmon/mr75203.c
+++ b/drivers/hwmon/mr75203.c
@@ -93,7 +93,7 @@
 #define VM_CH_REQ	BIT(21)
 
 #define IP_TMR			0x05
-#define POWER_DELAY_CYCLE_256	0x80
+#define POWER_DELAY_CYCLE_256	0x100
 #define POWER_DELAY_CYCLE_64	0x40
 
 #define PVT_POLL_DELAY_US	20
-- 
2.34.1



