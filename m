Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C89C594DC2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbiHPAkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242180AbiHPAjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:39:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCADABF21;
        Mon, 15 Aug 2022 13:38:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA650B8114A;
        Mon, 15 Aug 2022 20:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D047C433D7;
        Mon, 15 Aug 2022 20:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595913;
        bh=WX3GrhU3cMELvExJ8uFidpuIGUve/uH3dcx+G+aVKes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXYbo1oh4nW+C25t5ur0+knSPBKMNev6U53lYj4gVkkQrDuVKItjblJalXaDnO76r
         qZ7ZeGXqeyrC9KE257zkxGjPTr0hWFQuv8c4ErAyZb5Zx9UPQiSy5RrvRKSw3nlqVN
         F87ZStORtkLO+Pna+7q5kut2dw+CYFTLqVJDi1CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0915/1157] selftests/powerpc: Skip energy_scale_info test on older firmware
Date:   Mon, 15 Aug 2022 20:04:31 +0200
Message-Id: <20220815180516.053020540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 4228a996b072d36f3baafb4afdc2d2d66d2cbadf ]

Older machines don't have the firmware feature that enables the code
this test is testing. Skip the test if the sysfs directory doesn't
exist. Also use the FAIL_IF() macro to provide more verbose error
reporting if an error is encountered.

Fixes: 57201d657eb7 ("selftest/powerpc: Add PAPR sysfs attributes sniff test")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220619233103.2666171-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../powerpc/papr_attributes/attr_test.c       | 30 +++++++++++--------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/powerpc/papr_attributes/attr_test.c b/tools/testing/selftests/powerpc/papr_attributes/attr_test.c
index bab0dc06e90b..9b655be641c9 100644
--- a/tools/testing/selftests/powerpc/papr_attributes/attr_test.c
+++ b/tools/testing/selftests/powerpc/papr_attributes/attr_test.c
@@ -7,6 +7,7 @@
  * Copyright 2022, Pratik Rajesh Sampat, IBM Corp.
  */
 
+#include <errno.h>
 #include <stdio.h>
 #include <string.h>
 #include <dirent.h>
@@ -32,7 +33,7 @@ enum type {
 	NUM_VAL
 };
 
-int value_type(int id)
+static int value_type(int id)
 {
 	int val_type;
 
@@ -54,15 +55,21 @@ int value_type(int id)
 	return val_type;
 }
 
-int verify_energy_info(void)
+static int verify_energy_info(void)
 {
 	const char *path = "/sys/firmware/papr/energy_scale_info";
 	struct dirent *entry;
 	struct stat s;
 	DIR *dirp;
 
-	if (stat(path, &s) || !S_ISDIR(s.st_mode))
-		return -1;
+	errno = 0;
+	if (stat(path, &s)) {
+		SKIP_IF(errno == ENOENT);
+		FAIL_IF(errno);
+	}
+
+	FAIL_IF(!S_ISDIR(s.st_mode));
+
 	dirp = opendir(path);
 
 	while ((entry = readdir(dirp)) != NULL) {
@@ -76,25 +83,24 @@ int verify_energy_info(void)
 
 		id = atoi(entry->d_name);
 		attr_type = value_type(id);
-		if (attr_type == INVALID)
-			return -1;
+		FAIL_IF(attr_type == INVALID);
 
 		/* Check if the files exist and have data in them */
 		sprintf(file_name, "%s/%d/desc", path, id);
 		f = fopen(file_name, "r");
-		if (!f || fgetc(f) == EOF)
-			return -1;
+		FAIL_IF(!f);
+		FAIL_IF(fgetc(f) == EOF);
 
 		sprintf(file_name, "%s/%d/value", path, id);
 		f = fopen(file_name, "r");
-		if (!f || fgetc(f) == EOF)
-			return -1;
+		FAIL_IF(!f);
+		FAIL_IF(fgetc(f) == EOF);
 
 		if (attr_type == STR_VAL) {
 			sprintf(file_name, "%s/%d/value_desc", path, id);
 			f = fopen(file_name, "r");
-			if (!f || fgetc(f) == EOF)
-				return -1;
+			FAIL_IF(!f);
+			FAIL_IF(fgetc(f) == EOF);
 		}
 	}
 
-- 
2.35.1



