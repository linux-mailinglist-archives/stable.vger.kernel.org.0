Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9193D2996
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbhGVQFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234215AbhGVQE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7360261C24;
        Thu, 22 Jul 2021 16:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972289;
        bh=noKFCILb6PIUVj+e8wfqFFGfMkQKsjF205S4l1s3whE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGd6bN2KTad58+G41lWfYqmq5+eNEVoliDHg0+f47bZDO88IaT5kKhRudv6A7Pv2J
         E7f26vKfuDzojUCdyNKzdofva6uzOLDsC+usTHU+RjEMOuZ8wHbZZ3jsjo34N0DmBX
         OXPUbgXtQ8u5vo7obKqoZgcir9IFH3nyiqW25y48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 057/156] firmware: arm_scmi: Add SMCCC discovery dependency in Kconfig
Date:   Thu, 22 Jul 2021 18:30:32 +0200
Message-Id: <20210722155630.256419362@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Etienne Carriere <etienne.carriere@linaro.org>

[ Upstream commit c05b07963e965ae34e75ee8c33af1095350cd87e ]

ARM_SCMI_PROTOCOL depends on either MAILBOX or HAVE_ARM_SMCCC_DISCOVERY,
not MAILBOX alone. Fix the depedency in Kconfig file and driver to
reflect the same.

Link: https://lore.kernel.org/r/20210521134055.24271-1-etienne.carriere@linaro.org
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Etienne Carriere <etienne.carriere@linaro.org>
[sudeep.holla: Minor tweaks to subject and change log]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/Kconfig           | 2 +-
 drivers/firmware/arm_scmi/common.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index db0ea2d2d75a..a9c613c32282 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -9,7 +9,7 @@ menu "Firmware Drivers"
 config ARM_SCMI_PROTOCOL
 	tristate "ARM System Control and Management Interface (SCMI) Message Protocol"
 	depends on ARM || ARM64 || COMPILE_TEST
-	depends on MAILBOX
+	depends on MAILBOX || HAVE_ARM_SMCCC_DISCOVERY
 	help
 	  ARM System Control and Management Interface (SCMI) protocol is a
 	  set of operating system-independent software interfaces that are
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 228bf4a71d23..8685619d38f9 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -331,7 +331,7 @@ struct scmi_desc {
 };
 
 extern const struct scmi_desc scmi_mailbox_desc;
-#ifdef CONFIG_HAVE_ARM_SMCCC
+#ifdef CONFIG_HAVE_ARM_SMCCC_DISCOVERY
 extern const struct scmi_desc scmi_smc_desc;
 #endif
 
-- 
2.30.2



