Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7FA3C8DF0
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhGNTqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhGNTpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ABD0613DC;
        Wed, 14 Jul 2021 19:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291724;
        bh=fNAfgilUz+BSyvc/aOHy3dfty8RsDUxO9eDDWTBjaSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhKVId9pqSpa+Ym76ErcUWdCUp/DSmJYPHnw2Dn+N2D7I88g9CtkzjV+1fwCZ95+v
         vG8fUri7t+v8D+g+NYkUlemkNzv8xrO6635gVnhzVOoA4ecVYHonqI+spRqT+qxyAY
         xks5nf0IDeY5gSonPGxDxLIi2QEnrXmI0KPTdstHh53bNDLUQ7FU9oXX1qC7uVpb2A
         TWFSVQLh4J2fOIPpy70I4882l/DKr3QhEVEeqsHd14BcP+l2T12LtMP7OojKkdmb12
         Mep9lex8yh+jQ1POmLkDd/MF/eEVKsw9G3R9QIvUy/vn3Wpj+J9Z8lAhGbenG+j3cK
         Snw0QYA/C9sSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Etienne Carriere <etienne.carriere@linaro.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 062/102] firmware: arm_scmi: Add SMCCC discovery dependency in Kconfig
Date:   Wed, 14 Jul 2021 15:39:55 -0400
Message-Id: <20210714194036.53141-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5dd19dbd67a3..6f24b0429f36 100644
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
index c0fb45e7c3e8..9c1f06759536 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -244,7 +244,7 @@ struct scmi_desc {
 };
 
 extern const struct scmi_desc scmi_mailbox_desc;
-#ifdef CONFIG_HAVE_ARM_SMCCC
+#ifdef CONFIG_HAVE_ARM_SMCCC_DISCOVERY
 extern const struct scmi_desc scmi_smc_desc;
 #endif
 
-- 
2.30.2

