Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40504205C9E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388098AbgFWUDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388096AbgFWUDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:03:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 471762082F;
        Tue, 23 Jun 2020 20:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942625;
        bh=CxE7DB/DxfV2qd4+TdcBAW9MuHejz0PAQ9Qz9EB1qrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdviU5AJ0DJC43qvr+RHGwYxeWjukwNqU/j0eMsJp0ChOduDyau5PawrmS86l1Ptf
         +A/mb0UZpgGuM9frNTvEl29Jhben6v3SkI5VojFaUGhsGf6jW3V8wW/aptlsZeJiZt
         6b6FhHdagmgLBDOH2ytDLb8CkrQDe4H1eptudgWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Wen Yang <wenyang@linux.alibaba.com>,
        chenqiwu <chenqiwu@xiaomi.com>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 041/477] usb: roles: Switch on role-switch uevent reporting
Date:   Tue, 23 Jun 2020 21:50:38 +0200
Message-Id: <20200623195409.546274713@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 3e63cff384e625f09758ce8f4d01ae3033402b63 ]

Right now we don't report to user-space a role switch when doing a
usb_role_switch_set_role() despite having registered the uevent callbacks.

This patch switches on the notifications allowing user-space to see
role-switch change notifications and subsequently determine the current
controller data-role.

example:
PFX=/devices/platform/soc/78d9000.usb/ci_hdrc.0

root@somebox# udevadm monitor -p

KERNEL[49.894994] change $PFX/usb_role/ci_hdrc.0-role-switch (usb_role)
ACTION=change
DEVPATH=$PFX/usb_role/ci_hdrc.0-role-switch
SUBSYSTEM=usb_role
DEVTYPE=usb_role_switch
USB_ROLE_SWITCH=ci_hdrc.0-role-switch
SEQNUM=2432

Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Wen Yang <wenyang@linux.alibaba.com>
Cc: chenqiwu <chenqiwu@xiaomi.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20200508162937.2566818-1-bryan.odonoghue@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/roles/class.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/roles/class.c b/drivers/usb/roles/class.c
index 5b17709821dfd..27d92af296351 100644
--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -49,8 +49,10 @@ int usb_role_switch_set_role(struct usb_role_switch *sw, enum usb_role role)
 	mutex_lock(&sw->lock);
 
 	ret = sw->set(sw, role);
-	if (!ret)
+	if (!ret) {
 		sw->role = role;
+		kobject_uevent(&sw->dev.kobj, KOBJ_CHANGE);
+	}
 
 	mutex_unlock(&sw->lock);
 
-- 
2.25.1



