Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913EB3C8CD2
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbhGNTmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234894AbhGNTmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9587613D8;
        Wed, 14 Jul 2021 19:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291573;
        bh=noKFCILb6PIUVj+e8wfqFFGfMkQKsjF205S4l1s3whE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhVFww9ZmxLT2LTv5HtNTnznT2MhoLunbJpSXTiBipv5Im73jY2b4EEN+lJ2AvooI
         sxfrbjpQCAouaMgfVjGajMPFtYR5/mIk78Va3wZz0Lds5OuhrP4nqVcgC8ZBOe19Cw
         QViuJvTUkuFzmNk536i8hPSZJ2CB/wmQ+UgyWsqFhEztvdHq5XmQRhR2Qit7THqa+C
         3pjYX9g8mHd0xlRaopy+AqhlKsZ+fM17QdJ7hJkaxPqRLABjiXWZWZvrFHPpahGptK
         pBc2+8A/32k+RJVp34QoUa/ufGyEbgCc2VCppGzQ+97g8XW+zNKAIdhc4+yO6WSsoJ
         QWghMPt+Hl3Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Etienne Carriere <etienne.carriere@linaro.org>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 064/108] firmware: arm_scmi: Add SMCCC discovery dependency in Kconfig
Date:   Wed, 14 Jul 2021 15:37:16 -0400
Message-Id: <20210714193800.52097-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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

