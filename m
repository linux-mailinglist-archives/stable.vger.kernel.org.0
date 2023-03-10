Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FC96B4ADD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbjCJP1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjCJP06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:26:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ED912BAC3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 752FCB822C4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4280C4339E;
        Fri, 10 Mar 2023 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461321;
        bh=vK5yQ45E+qHgdpbNyIIWfKmPjp/7AjgM+6mb2yjleXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFobvNrZ3DlRZR2HO9njT3ecA7r6rt5/+YekDONubJM5OBFVNCaA/z0KZyEqDUXYA
         OhXs2eKW30l/oDlvLmo84jra2YPQE4+nzYgaCRpsxdqQlAU2p7E6LZBVZ6Jc6HbTZn
         80z4NysFKVAggBklVwiwJzpFP1LEHjdXSh/n7n5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yulong Zhang <yulong.zhang@metoak.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/136] tools/iio/iio_utils:fix memory leak
Date:   Fri, 10 Mar 2023 14:43:33 +0100
Message-Id: <20230310133709.911302945@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 8d35893b2fa85..6a00a6eecaef0 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -264,6 +264,7 @@ int iioutils_get_param_float(float *output, const char *param_name,
 			if (fscanf(sysfsfp, "%f", output) != 1)
 				ret = errno ? -errno : -ENODATA;
 
+			fclose(sysfsfp);
 			break;
 		}
 error_free_filename:
@@ -345,9 +346,9 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
@@ -357,7 +358,6 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 				if (fclose(sysfsfp))
 					perror("build_channel_array(): Failed to close file");
 
-				free(filename);
 				goto error_close_dir;
 			}
 			if (ret == 1)
@@ -365,11 +365,9 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
-			free(filename);
 		}
 
 	*ci_array = malloc(sizeof(**ci_array) * (*counter));
@@ -395,9 +393,9 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
@@ -405,20 +403,17 @@ int build_channel_array(const char *device_dir, int buffer_idx,
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
@@ -429,7 +424,6 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 						strlen(ent->d_name) -
 						strlen("_en"));
 			if (!current->name) {
-				free(filename);
 				ret = -ENOMEM;
 				count--;
 				goto error_cleanup_array;
@@ -439,7 +433,6 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 			ret = iioutils_break_up_name(current->name,
 						     &current->generic_name);
 			if (ret) {
-				free(filename);
 				free(current->name);
 				count--;
 				goto error_cleanup_array;
@@ -450,17 +443,16 @@ int build_channel_array(const char *device_dir, int buffer_idx,
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
 
@@ -470,17 +462,14 @@ int build_channel_array(const char *device_dir, int buffer_idx,
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



