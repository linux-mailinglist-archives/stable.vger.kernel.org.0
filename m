Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9851F3D2860
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhGVP4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232833AbhGVP4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EAE96135A;
        Thu, 22 Jul 2021 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971838;
        bh=SZnq5VVEghT7dcss/neDjXEOAvWnzcf2v5dVXoj4GhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWu49i5r6XsU3SO/bL3DI9E+QGPKKt/pFj9V4hgNyScJCUIOohg7zzGKoA9IQ/6t5
         SzSeC64LPFcgCKsw5NqtH+3wm82jB0vO3iluabeHS2lNfAECXP2OfAecLfB0L6J2FA
         hJKGysE+HjQHj3QGekPvz8Xkzru0FjzizKjKWeBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Etienne Carriere <etienne.carriere@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/125] firmware: arm_scmi: Add SMCCC discovery dependency in Kconfig
Date:   Thu, 22 Jul 2021 18:30:38 +0200
Message-Id: <20210722155626.283159319@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
index 5fa6b3ca0a38..c08968c5ddf8 100644
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
index 65063fa948d4..34b7ae7980a3 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -243,7 +243,7 @@ struct scmi_desc {
 };
 
 extern const struct scmi_desc scmi_mailbox_desc;
-#ifdef CONFIG_HAVE_ARM_SMCCC
+#ifdef CONFIG_HAVE_ARM_SMCCC_DISCOVERY
 extern const struct scmi_desc scmi_smc_desc;
 #endif
 
-- 
2.30.2



