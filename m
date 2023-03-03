Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCB26AA3C8
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbjCCWFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbjCCWE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:04:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E955848F2;
        Fri,  3 Mar 2023 13:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8354B81A27;
        Fri,  3 Mar 2023 21:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2632C433A4;
        Fri,  3 Mar 2023 21:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880054;
        bh=RX2HojgIGJFon60lL8yY3xWnDo08Bn8qPy9+rxyyRmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3QZWn1+Ue6pvlsmhyd0DYrs+F8rykHrMt1SlrgasCBkKT2wq2zM3zF0s2s1TRkYU
         6nVAcBJlQmq5Vxb5kFprxoVDmE1bvf71H0TuCxNpLRvxEif/d7ueDn7SrvIgIADZYD
         9CDDRabAFwFNPoRfokc2C4iaC+eME43nsBfd89DOkmaeN0IDGJE3FHpEuhayjqsDY6
         lxm7EmsK2cAvxvgy23BiaADgu458jZ3pTW785PpVNqAULl7xnyoUqK8pP1nDDrH30O
         ascPvNgHpykAHyIs7TFfLNErij+Ar7HdP2LAUKV2tkLx44tSguiK24xJjw9x7SPV54
         H380mfBBJWwXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yulong Zhang <yulong.zhang@metoak.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/30] tools/iio/iio_utils:fix memory leak
Date:   Fri,  3 Mar 2023 16:46:58 -0500
Message-Id: <20230303214715.1452256-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214715.1452256-1-sashal@kernel.org>
References: <20230303214715.1452256-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yulong Zhang <yulong.zhang@metoak.net>

[ Upstream commit f2edf0c819a4823cd6c288801ce737e8d4fcde06 ]

1. fopen sysfs without fclose.
2. asprintf filename without free.
3. if asprintf return error,do not need to free the buffer.

Signed-off-by: Yulong Zhang <yulong.zhang@metoak.net>
Link: https://lore.kernel.org/r/20230117025147.69890-1-yulong.zhang@metoak.net
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_utils.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index d66b18c54606a..48360994c2a13 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -262,6 +262,7 @@ int iioutils_get_param_float(float *output, const char *param_name,
 			if (fscanf(sysfsfp, "%f", output) != 1)
 				ret = errno ? -errno : -ENODATA;
 
+			fclose(sysfsfp);
 			break;
 		}
 error_free_filename:
@@ -342,9 +343,9 @@ int build_channel_array(const char *device_dir,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
@@ -354,7 +355,6 @@ int build_channel_array(const char *device_dir,
 				if (fclose(sysfsfp))
 					perror("build_channel_array(): Failed to close file");
 
-				free(filename);
 				goto error_close_dir;
 			}
 			if (ret == 1)
@@ -362,11 +362,9 @@ int build_channel_array(const char *device_dir,
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
-			free(filename);
 		}
 
 	*ci_array = malloc(sizeof(**ci_array) * (*counter));
@@ -392,9 +390,9 @@ int build_channel_array(const char *device_dir,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
@@ -402,20 +400,17 @@ int build_channel_array(const char *device_dir,
 			errno = 0;
 			if (fscanf(sysfsfp, "%i", &current_enabled) != 1) {
 				ret = errno ? -errno : -ENODATA;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
 
 			if (!current_enabled) {
-				free(filename);
 				count--;
 				continue;
 			}
@@ -426,7 +421,6 @@ int build_channel_array(const char *device_dir,
 						strlen(ent->d_name) -
 						strlen("_en"));
 			if (!current->name) {
-				free(filename);
 				ret = -ENOMEM;
 				count--;
 				goto error_cleanup_array;
@@ -436,7 +430,6 @@ int build_channel_array(const char *device_dir,
 			ret = iioutils_break_up_name(current->name,
 						     &current->generic_name);
 			if (ret) {
-				free(filename);
 				free(current->name);
 				count--;
 				goto error_cleanup_array;
@@ -447,17 +440,16 @@ int build_channel_array(const char *device_dir,
 				       scan_el_dir,
 				       current->name);
 			if (ret < 0) {
-				free(filename);
 				ret = -ENOMEM;
 				goto error_cleanup_array;
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				fprintf(stderr, "failed to open %s\n",
-					filename);
-				free(filename);
+				fprintf(stderr, "failed to open %s/%s_index\n",
+					scan_el_dir, current->name);
 				goto error_cleanup_array;
 			}
 
@@ -467,17 +459,14 @@ int build_channel_array(const char *device_dir,
 				if (fclose(sysfsfp))
 					perror("build_channel_array(): Failed to close file");
 
-				free(filename);
 				goto error_cleanup_array;
 			}
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				goto error_cleanup_array;
 			}
 
-			free(filename);
 			/* Find the scale */
 			ret = iioutils_get_param_float(&current->scale,
 						       "scale",
-- 
2.39.2

