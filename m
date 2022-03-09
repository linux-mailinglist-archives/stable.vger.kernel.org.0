Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1424D3276
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiCIQDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbiCIQCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:02:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2584517F6BE;
        Wed,  9 Mar 2022 08:01:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C92B61672;
        Wed,  9 Mar 2022 16:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D543C340E8;
        Wed,  9 Mar 2022 16:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841712;
        bh=hgyMPXKpyrjFSr7gjjGkb1FgtZRbJo9afPZLy+xNAuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wWupqOPD2EtS0Tbjf8YveJhxWeuG7CeOyAbNDRliN6QdLpHv+KrT7zRQ7DeesM6h
         +YCR0u3gVv7nuwfYERKSwaZLJICBQrYOJh3oqirvOCvjxjq+aPQuN0GctQ9ACYddAX
         pOzBYBFBUgynVhoC/nx5OXrGQEOK13fcgdc1OOKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.9 18/24] arm/arm64: smccc/psci: add arm_smccc_1_1_get_conduit()
Date:   Wed,  9 Mar 2022 16:59:31 +0100
Message-Id: <20220309155856.837348646@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.295480966@linuxfoundation.org>
References: <20220309155856.295480966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 6b7fe77c334ae59fed9500140e08f4f896b36871 upstream.

SMCCC callers are currently amassing a collection of enums for the SMCCC
conduit, and are having to dig into the PSCI driver's internals in order
to figure out what to do.

Let's clean this up, with common SMCCC_CONDUIT_* definitions, and an
arm_smccc_1_1_get_conduit() helper that abstracts the PSCI driver's
internal state.

We can kill off the PSCI_CONDUIT_* definitions once we've migrated users
over to the new interface.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/psci.c   |   15 +++++++++++++++
 include/linux/arm-smccc.h |   16 ++++++++++++++++
 2 files changed, 31 insertions(+)

--- a/drivers/firmware/psci.c
+++ b/drivers/firmware/psci.c
@@ -64,6 +64,21 @@ struct psci_operations psci_ops = {
 	.smccc_version = SMCCC_VERSION_1_0,
 };
 
+enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
+{
+	if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
+		return SMCCC_CONDUIT_NONE;
+
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_SMC:
+		return SMCCC_CONDUIT_SMC;
+	case PSCI_CONDUIT_HVC:
+		return SMCCC_CONDUIT_HVC;
+	default:
+		return SMCCC_CONDUIT_NONE;
+	}
+}
+
 typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
 static psci_fn *invoke_psci_fn;
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -89,6 +89,22 @@
 
 #include <linux/linkage.h>
 #include <linux/types.h>
+
+enum arm_smccc_conduit {
+	SMCCC_CONDUIT_NONE,
+	SMCCC_CONDUIT_SMC,
+	SMCCC_CONDUIT_HVC,
+};
+
+/**
+ * arm_smccc_1_1_get_conduit()
+ *
+ * Returns the conduit to be used for SMCCCv1.1 or later.
+ *
+ * When SMCCCv1.1 is not present, returns SMCCC_CONDUIT_NONE.
+ */
+enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void);
+
 /**
  * struct arm_smccc_res - Result from SMC/HVC call
  * @a0-a3 result values from registers 0 to 3


