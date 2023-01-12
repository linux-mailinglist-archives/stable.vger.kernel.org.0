Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1BF6675CE
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbjALOZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235889AbjALOYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:24:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D625B17A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58547B81E71
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C21C433EF;
        Thu, 12 Jan 2023 14:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532986;
        bh=xLCKIVTyxc5iXMup3R7QlwQ/nATQuK9GeRUHel2Nxo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUaaY6YV8j6C4fxJUD9ejYlUsjtzjny+CJi95pB6nES7v6QMswmvZlsEB5SW0Av04
         Y7PzpHHuRqQxmca1hGzmrHO6lpyRTVqVGCSnGnfwE75S9DzljvkdD9gEypQu4p/e25
         BdfO1KCql7VA3ukDrKH9AppCng1UQlXL6FPHPT3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/783] RDMA/hfi1: Fix error return code in parse_platform_config()
Date:   Thu, 12 Jan 2023 14:50:48 +0100
Message-Id: <20230112135539.698747101@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 725349f8ba1e78a146c6ff8f3ee5e2712e517106 ]

In the previous iteration of the while loop, the "ret" may have been
assigned a value of 0, so the error return code -EINVAL may have been
incorrectly set to 0. To fix set valid return code before calling to
goto.

Fixes: 97167e813415 ("staging/rdma/hfi1: Tune for unknown channel if configuration file is absent")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/1669953638-11747-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/firmware.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 2cf102b5abd4..f3e64c850aa5 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1786,6 +1786,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 
 	if (!dd->platform_config.data) {
 		dd_dev_err(dd, "%s: Missing config file\n", __func__);
+		ret = -EINVAL;
 		goto bail;
 	}
 	ptr = (u32 *)dd->platform_config.data;
@@ -1794,6 +1795,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	ptr++;
 	if (magic_num != PLATFORM_CONFIG_MAGIC_NUM) {
 		dd_dev_err(dd, "%s: Bad config file\n", __func__);
+		ret = -EINVAL;
 		goto bail;
 	}
 
@@ -1817,6 +1819,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	if (file_length > dd->platform_config.size) {
 		dd_dev_info(dd, "%s:File claims to be larger than read size\n",
 			    __func__);
+		ret = -EINVAL;
 		goto bail;
 	} else if (file_length < dd->platform_config.size) {
 		dd_dev_info(dd,
@@ -1837,6 +1840,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			dd_dev_err(dd, "%s: Failed validation at offset %ld\n",
 				   __func__, (ptr - (u32 *)
 					      dd->platform_config.data));
+			ret = -EINVAL;
 			goto bail;
 		}
 
@@ -1880,6 +1884,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 					   __func__, table_type,
 					   (ptr - (u32 *)
 					    dd->platform_config.data));
+				ret = -EINVAL;
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table = ptr;
@@ -1899,6 +1904,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 					   __func__, table_type,
 					   (ptr -
 					    (u32 *)dd->platform_config.data));
+				ret = -EINVAL;
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table_metadata =
-- 
2.35.1



