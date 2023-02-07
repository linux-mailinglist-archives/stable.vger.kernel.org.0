Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2520768D833
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjBGNHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjBGNHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4383A1116E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1A02B81995
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D418C433D2;
        Tue,  7 Feb 2023 13:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775186;
        bh=fpUQUoq0adnD/CahJ68tUfvXHb4Q5EZwacrdUdOheeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O50+d6A09PbKE5ijyRCgyctsTwLDgju2NZ2NedekcO/WVf9HhqwgLGlefgAUDWm2W
         N9p1wmgP350wOJlAEvGmYIB/vJ8bsasK4NHW+2AGt0r/bf0ej0lkSqCySdrBxl/i0j
         uvu/m3RAYiHalQarujTxnij64H6Mn/wWk27Qfe1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        Russ Weight <russell.h.weight@intel.com>,
        Marco Pagani <marpagan@redhat.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 6.1 165/208] fpga: m10bmc-sec: Fix probe rollback
Date:   Tue,  7 Feb 2023 13:56:59 +0100
Message-Id: <20230207125641.889469962@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 60ce26d10e5850f33cc76fce52f5377045e75a15 upstream.

Handle probe error rollbacks properly to avoid leaks.

Fixes: 5cd339b370e2 ("fpga: m10bmc-sec: add max10 secure update functions")
Reviewed-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
Reviewed-by: Russ Weight <russell.h.weight@intel.com>
Reviewed-by: Marco Pagani <marpagan@redhat.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20221214144952.8392-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/intel-m10-bmc-sec-update.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/fpga/intel-m10-bmc-sec-update.c b/drivers/fpga/intel-m10-bmc-sec-update.c
index 79d48852825e..03f1bd81c434 100644
--- a/drivers/fpga/intel-m10-bmc-sec-update.c
+++ b/drivers/fpga/intel-m10-bmc-sec-update.c
@@ -574,20 +574,27 @@ static int m10bmc_sec_probe(struct platform_device *pdev)
 	len = scnprintf(buf, SEC_UPDATE_LEN_MAX, "secure-update%d",
 			sec->fw_name_id);
 	sec->fw_name = kmemdup_nul(buf, len, GFP_KERNEL);
-	if (!sec->fw_name)
-		return -ENOMEM;
+	if (!sec->fw_name) {
+		ret = -ENOMEM;
+		goto fw_name_fail;
+	}
 
 	fwl = firmware_upload_register(THIS_MODULE, sec->dev, sec->fw_name,
 				       &m10bmc_ops, sec);
 	if (IS_ERR(fwl)) {
 		dev_err(sec->dev, "Firmware Upload driver failed to start\n");
-		kfree(sec->fw_name);
-		xa_erase(&fw_upload_xa, sec->fw_name_id);
-		return PTR_ERR(fwl);
+		ret = PTR_ERR(fwl);
+		goto fw_uploader_fail;
 	}
 
 	sec->fwl = fwl;
 	return 0;
+
+fw_uploader_fail:
+	kfree(sec->fw_name);
+fw_name_fail:
+	xa_erase(&fw_upload_xa, sec->fw_name_id);
+	return ret;
 }
 
 static int m10bmc_sec_remove(struct platform_device *pdev)
-- 
2.39.1



