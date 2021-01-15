Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDB62F79B6
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732190AbhAOMjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729409AbhAOMjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9586C2399C;
        Fri, 15 Jan 2021 12:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714353;
        bh=G8hWhxVEJt2ydwtQjT7XhKDCirqG7g/kKbU6IWwjgvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lK3mQr/T4frRm6KeLmksuea2bIAGvm3m7fJ79FdDgyvnjhGjyRzzlFE+0E5leN/TF
         I9F94P0A6FpyzWqBJ71U2A176XcE5hnYPwVV1M07ge2STPlMLx3MI9aIiAz3Eg9t0m
         8wrYrmAuyQb0j4I2XsmtZ2LyJV6MlNOYgO43HDlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <georgi.djakov@linaro.org>
Subject: [PATCH 5.10 067/103] interconnect: qcom: fix rpmh link failures
Date:   Fri, 15 Jan 2021 13:28:00 +0100
Message-Id: <20210115122009.284192435@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 512d4a26abdbd11c6ffa03032740e5ab3c62c55b upstream.

When CONFIG_COMPILE_TEST is set, it is possible to build some
of the interconnect drivers into the kernel while their dependencies
are loadable modules, which is bad:

arm-linux-gnueabi-ld: drivers/interconnect/qcom/bcm-voter.o: in function `qcom_icc_bcm_voter_commit':
(.text+0x1f8): undefined reference to `rpmh_invalidate'
arm-linux-gnueabi-ld: (.text+0x20c): undefined reference to `rpmh_write_batch'
arm-linux-gnueabi-ld: (.text+0x2b0): undefined reference to `rpmh_write_batch'
arm-linux-gnueabi-ld: (.text+0x2e8): undefined reference to `rpmh_write_batch'
arm-linux-gnueabi-ld: drivers/interconnect/qcom/icc-rpmh.o: in function `qcom_icc_bcm_init':
(.text+0x2ac): undefined reference to `cmd_db_read_addr'
arm-linux-gnueabi-ld: (.text+0x2c8): undefined reference to `cmd_db_read_aux_data'

The exact dependencies are a bit complicated, so split them out into a
hidden Kconfig symbol that all drivers can in turn depend on to get it
right.

Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20201204165030.3747484-1-arnd@kernel.org
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/interconnect/qcom/Kconfig |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/interconnect/qcom/Kconfig
+++ b/drivers/interconnect/qcom/Kconfig
@@ -42,13 +42,23 @@ config INTERCONNECT_QCOM_QCS404
 	  This is a driver for the Qualcomm Network-on-Chip on qcs404-based
 	  platforms.
 
+config INTERCONNECT_QCOM_RPMH_POSSIBLE
+	tristate
+	default INTERCONNECT_QCOM
+	depends on QCOM_RPMH || (COMPILE_TEST && !QCOM_RPMH)
+	depends on QCOM_COMMAND_DB || (COMPILE_TEST && !QCOM_COMMAND_DB)
+	depends on OF || COMPILE_TEST
+	help
+	  Compile-testing RPMH drivers is possible on other platforms,
+	  but in order to avoid link failures, drivers must not be built-in
+	  when QCOM_RPMH or QCOM_COMMAND_DB are loadable modules
+
 config INTERCONNECT_QCOM_RPMH
 	tristate
 
 config INTERCONNECT_QCOM_SC7180
 	tristate "Qualcomm SC7180 interconnect driver"
-	depends on INTERCONNECT_QCOM
-	depends on (QCOM_RPMH && QCOM_COMMAND_DB && OF) || COMPILE_TEST
+	depends on INTERCONNECT_QCOM_RPMH_POSSIBLE
 	select INTERCONNECT_QCOM_RPMH
 	select INTERCONNECT_QCOM_BCM_VOTER
 	help
@@ -57,8 +67,7 @@ config INTERCONNECT_QCOM_SC7180
 
 config INTERCONNECT_QCOM_SDM845
 	tristate "Qualcomm SDM845 interconnect driver"
-	depends on INTERCONNECT_QCOM
-	depends on (QCOM_RPMH && QCOM_COMMAND_DB && OF) || COMPILE_TEST
+	depends on INTERCONNECT_QCOM_RPMH_POSSIBLE
 	select INTERCONNECT_QCOM_RPMH
 	select INTERCONNECT_QCOM_BCM_VOTER
 	help
@@ -67,8 +76,7 @@ config INTERCONNECT_QCOM_SDM845
 
 config INTERCONNECT_QCOM_SM8150
 	tristate "Qualcomm SM8150 interconnect driver"
-	depends on INTERCONNECT_QCOM
-	depends on (QCOM_RPMH && QCOM_COMMAND_DB && OF) || COMPILE_TEST
+	depends on INTERCONNECT_QCOM_RPMH_POSSIBLE
 	select INTERCONNECT_QCOM_RPMH
 	select INTERCONNECT_QCOM_BCM_VOTER
 	help
@@ -77,8 +85,7 @@ config INTERCONNECT_QCOM_SM8150
 
 config INTERCONNECT_QCOM_SM8250
 	tristate "Qualcomm SM8250 interconnect driver"
-	depends on INTERCONNECT_QCOM
-	depends on (QCOM_RPMH && QCOM_COMMAND_DB && OF) || COMPILE_TEST
+	depends on INTERCONNECT_QCOM_RPMH_POSSIBLE
 	select INTERCONNECT_QCOM_RPMH
 	select INTERCONNECT_QCOM_BCM_VOTER
 	help


