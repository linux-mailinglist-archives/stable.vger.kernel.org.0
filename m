Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066EF665C8F
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 14:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbjAKNcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 08:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbjAKNcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 08:32:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DB41B9F5;
        Wed, 11 Jan 2023 05:27:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EC71B81BDE;
        Wed, 11 Jan 2023 13:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE70C433EF;
        Wed, 11 Jan 2023 13:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673443660;
        bh=fGkN7Tcc9YTFcYUuxGh5EQduQh3KswjLvTWHPdFxYnc=;
        h=From:To:Cc:Subject:Date:From;
        b=KiUfZjUWmfHq0/XQGiaPWbfPX/CSbW4q70PHlrmD1K7EQO4Mtbpc4LckwJjbGoHGG
         JSWvvuW1uOpnGcMAH9ZQZfmaffW+PfwSWAN4NLdt+jetVAh8MD8rmFzkM6BZH6gPut
         lBNca1hzxWXB479IgDhUA2S6m0McQKh2XIuq/vpWFJymk2ZUkk1qBBR2TUeBKzMojY
         ZzupKzxTK0eK4P9Dmq4AgNRwtXeQOiOOFmscJY/HjS//h8GIrl3Zqvk0KGNjpNelkf
         vIM3nyUwEvPhd3qjIGtlBpp+67pgu9set6fx9mNTtIcURb1WdjX8D4YCNMZ/bDRa+E
         SSGe9BMwk2TqA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: PRM: Check whether EFI runtime is available
Date:   Wed, 11 Jan 2023 14:27:34 +0100
Message-Id: <20230111132734.1571990-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1147; i=ardb@kernel.org; h=from:subject; bh=fGkN7Tcc9YTFcYUuxGh5EQduQh3KswjLvTWHPdFxYnc=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjvrlFfo2LBgRZH0zU03llnibes9XBYoffyPOnpuFq vTkLh+KJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY765RQAKCRDDTyI5ktmPJOONC/ 4/vJv9xi6/BiB5c+xeG27gaIyf8QuOQcjjhyQcQ95m+a50rAZ12GyGXcNbvm2IOyKSPPLZEu5rrELC U0SvX5JT97vzJbr7LvViamn5rmxfZjoB+FufIfEMz5EhVNvnPfiIzzWCVLVMtNBEh7G5iBNJMgNcEX rmDcmQXFv1J+z7yOU8iBxx5SFkZvEkZM+lXgRzFc/O53Dbg5XA3zlAHKCSm0gVNZxEJeYhRZ2ZbxYy Ehvd2y9KYzt0Rfk7xbwQ0mbPDVv6FHP/0si6pK/M/QzkXN1Tqlebf1movMvQ2ix3cWIwkfo7BGeC9W b8kOdaDjXWskI4JAfFILDFhpI5seio3dtUloPTlgplZtkadrJe46d8Zdggv4drO1Wq8882WMaBkPZu BuzhIh8eBaMu3PMddJtJYwpdk40M2cMNHHjstKeJKEZEqU9DdUHBv1bR2PNvj9PhWi3ALqBqOPwZKI phhsfsgdR8vjDjyq8yaDAagSgvWLcgWyjN+PIIBkmN08o=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ACPI PRM address space handler calls efi_call_virt_pointer() to
execute PRM firmware code, but doing so is only permitted when the EFI
runtime environment is available. Otherwise, such calls are guaranteed
to result in a crash, and must therefore be avoided.

Cc: <stable@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/acpi/prmt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
index 998101cf16e47145..74f924077866ae69 100644
--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
 	efi_status_t status;
 	struct prm_context_buffer context;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_err("PRM: EFI runtime services unavailable\n");
+		return AE_NOT_IMPLEMENTED;
+	}
+
 	/*
 	 * The returned acpi_status will always be AE_OK. Error values will be
 	 * saved in the first byte of the PRM message buffer to be used by ASL.
-- 
2.39.0

