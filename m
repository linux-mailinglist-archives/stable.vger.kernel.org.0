Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058C26B44C5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjCJO2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjCJO1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:27:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45121219D0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:26:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81F05B822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D698AC433D2;
        Fri, 10 Mar 2023 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458377;
        bh=z9Av7GPwa8suSv/7ygSdWHqXrR0LyMPHIQ7VukyEij8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ao5gxc7ofj+UVN1zE/DmXAXn88blaf7ywLe90XCRonmzkq6vnDmscRQLvnfph8r7e
         e70vybT2pzP42tDvrC4LDlsAH0O2rVvtr88V0dAc8SNeM8dEW/X9ff7iOIvfVkc0fx
         MRczoDJaBIMxDhJ7IHNSIfs6d7cj/FsOPjd7H3C8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 229/252] thermal: intel: quark_dts: fix error pointer dereference
Date:   Fri, 10 Mar 2023 14:39:59 +0100
Message-Id: <20230310133726.233927109@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit f1b930e740811d416de4d2074da48b6633a672c8 ]

If alloc_soc_dts() fails, then we can just return.  Trying to free
"soc_dts" will lead to an Oops.

Fixes: 8c1876939663 ("thermal: intel Quark SoC X1000 DTS thermal driver")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel_quark_dts_thermal.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/intel_quark_dts_thermal.c b/drivers/thermal/intel_quark_dts_thermal.c
index 5d33b350da1c6..ad92d8f0add19 100644
--- a/drivers/thermal/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel_quark_dts_thermal.c
@@ -440,22 +440,14 @@ MODULE_DEVICE_TABLE(x86cpu, qrk_thermal_ids);
 
 static int __init intel_quark_thermal_init(void)
 {
-	int err = 0;
-
 	if (!x86_match_cpu(qrk_thermal_ids) || !iosf_mbi_available())
 		return -ENODEV;
 
 	soc_dts = alloc_soc_dts();
-	if (IS_ERR(soc_dts)) {
-		err = PTR_ERR(soc_dts);
-		goto err_free;
-	}
+	if (IS_ERR(soc_dts))
+		return PTR_ERR(soc_dts);
 
 	return 0;
-
-err_free:
-	free_soc_dts(soc_dts);
-	return err;
 }
 
 static void __exit intel_quark_thermal_exit(void)
-- 
2.39.2



