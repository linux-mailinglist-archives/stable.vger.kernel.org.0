Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE9D66CD74
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbjAPRga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbjAPRgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:36:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152ED3251A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F429B810A1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7782C433EF;
        Mon, 16 Jan 2023 17:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889140;
        bh=YcW6EGOuhnnMMLC0NQuNnIn+RmsUiq4Wev7oxqWGiLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbeuDpfHaSGXVcYwjmYRP4BtjuXRPjpua7MUguGplHkoTsFLEH3gk/DDUYX9COOxy
         Nv7NKUCXe30rIm4c4r9xIa6BLD5YAmHjUf0ksbbTN42TYtNt+bVdDgwu2rFc5CE/RA
         uD19cHUErWv+F4gp0TY9cc4Ty72Y/VRI6Y+EiJiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.14 272/338] tpm: tpm_tis: Add the missed acpi_put_table() to fix memory leak
Date:   Mon, 16 Jan 2023 16:52:25 +0100
Message-Id: <20230116154832.960108134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

commit db9622f762104459ff87ecdf885cc42c18053fd9 upstream.

In check_acpi_tpm2(), we get the TPM2 table just to make
sure the table is there, not used after the init, so the
acpi_put_table() should be added to release the ACPI memory.

Fixes: 4cb586a188d4 ("tpm_tis: Consolidate the platform and acpi probe flow")
Cc: stable@vger.kernel.org
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -105,6 +105,7 @@ static int check_acpi_tpm2(struct device
 	const struct acpi_device_id *aid = acpi_match_device(tpm_acpi_tbl, dev);
 	struct acpi_table_tpm2 *tbl;
 	acpi_status st;
+	int ret = 0;
 
 	if (!aid || aid->driver_data != DEVICE_IS_TPM2)
 		return 0;
@@ -112,8 +113,7 @@ static int check_acpi_tpm2(struct device
 	/* If the ACPI TPM2 signature is matched then a global ACPI_SIG_TPM2
 	 * table is mandatory
 	 */
-	st =
-	    acpi_get_table(ACPI_SIG_TPM2, 1, (struct acpi_table_header **)&tbl);
+	st = acpi_get_table(ACPI_SIG_TPM2, 1, (struct acpi_table_header **)&tbl);
 	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
 		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
 		return -EINVAL;
@@ -121,9 +121,10 @@ static int check_acpi_tpm2(struct device
 
 	/* The tpm2_crb driver handles this device */
 	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
-		return -ENODEV;
+		ret = -ENODEV;
 
-	return 0;
+	acpi_put_table((struct acpi_table_header *)tbl);
+	return ret;
 }
 #else
 static int check_acpi_tpm2(struct device *dev)


