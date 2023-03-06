Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D376AC003
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 13:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjCFM6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 07:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjCFM62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 07:58:28 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451661F921;
        Mon,  6 Mar 2023 04:58:22 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 6DDAC164C;
        Mon,  6 Mar 2023 13:58:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678107499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3jggkbUJ5OxlpR1kYN/iXcmteZ/OMssiGsaodrVJEL4=;
        b=hXJNDQSoSWkg00rCZBI4b8JalYiJb2rgm3Okc+AJ/JdLMTlY8vz0QWVssJdvq951+qV6Kw
        WrO55vXSj6jQh2g3EybN6mYt8/nuRlCPRwcBGC6zlAdXOAdyrU54J9j5T4+NKKvXee83x6
        WTZq+NJ6iHRVZEmu341ddw/jmRCxG6iSSZX3xh0cOKohRVi/aStX9Nv9kVDki4Zel8B7+j
        eZsy2kee3/pGOwVVfu6d9UMlNgAM8zqiOTDF01qNzHkSZTrs+ftCoEgTUvsB/uKpyiQHkE
        77+rCVi4vAvi7glMGN/hJpybw7s3BSS6wf+CiLffcdTAjKX/NHtyXdreWNQvWQ==
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>, stable@vger.kernel.org
Subject: [PATCH 3/4] mtd: core: fix error path for nvmem provider
Date:   Mon,  6 Mar 2023 13:58:04 +0100
Message-Id: <20230306125805.678668-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230306125805.678668-1-michael@walle.cc>
References: <20230306125805.678668-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If mtd_otp_nvmem_add() fails, the partitions won't be removed
because there is simply no call to del_mtd_partitions().
Unfortunately, add_mtd_partitions() will print all partitions to
the kernel console. If mtd_otp_nvmem_add() returns -EPROBE_DEFER
this would print the partitions multiple times to the kernel
console. Instead move mtd_otp_nvmem_add() to the beginning of the
function.

Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/mtd/mtdcore.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 4a19e69fb77b..d6675bf03557 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1022,10 +1022,14 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char * const *types,
 
 	mtd_set_dev_defaults(mtd);
 
+	ret = mtd_otp_nvmem_add(mtd);
+	if (ret)
+		goto out;
+
 	if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER)) {
 		ret = add_mtd_device(mtd);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	/* Prefer parsed partitions over driver-provided fallback */
@@ -1060,9 +1064,12 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char * const *types,
 		register_reboot_notifier(&mtd->reboot_notifier);
 	}
 
-	ret = mtd_otp_nvmem_add(mtd);
-
 out:
+	if (ret) {
+		nvmem_unregister(mtd->otp_user_nvmem);
+		nvmem_unregister(mtd->otp_factory_nvmem);
+	}
+
 	if (ret && device_is_registered(&mtd->dev))
 		del_mtd_device(mtd);
 
-- 
2.30.2

