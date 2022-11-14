Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46249627EE5
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbiKNMw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiKNMwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:52:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6771B252B3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:52:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 033816112D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E2BC433D6;
        Mon, 14 Nov 2022 12:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430373;
        bh=hRW1vzj5frNZZPOAZ3Qe8cHgExhf9VfZmSpfrXnJ4bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoofuzlgOIV0h4mspsrpUiP+8CdkSc33E5GkN3CWWwD1ABWPaRm5XuRJ30p/Xzs+F
         PSTgVw9kVhFgu5VX2FiBmPQR5pvztbA+1u8ttjbZdLI+cxzhN0VjHGvmO9PI1H7LuY
         nKET9DxEv40CpsRqD9PuU6WMK7ezG+j60ebLdy24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/131] wifi: cfg80211: fix memory leak in query_regdb_file()
Date:   Mon, 14 Nov 2022 13:44:39 +0100
Message-Id: <20221114124449.188513242@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit 57b962e627ec0ae53d4d16d7bd1033e27e67677a ]

In the function query_regdb_file() the alpha2 parameter is duplicated
using kmemdup() and subsequently freed in regdb_fw_cb(). However,
request_firmware_nowait() can fail without calling regdb_fw_cb() and
thus leak memory.

Fixes: 007f6c5e6eb4 ("cfg80211: support loading regulatory database as firmware file")
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 54c13ea7d977..7b19a2087db9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1083,6 +1083,8 @@ MODULE_FIRMWARE("regulatory.db");
 
 static int query_regdb_file(const char *alpha2)
 {
+	int err;
+
 	ASSERT_RTNL();
 
 	if (regdb)
@@ -1092,9 +1094,13 @@ static int query_regdb_file(const char *alpha2)
 	if (!alpha2)
 		return -ENOMEM;
 
-	return request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
-				       &reg_pdev->dev, GFP_KERNEL,
-				       (void *)alpha2, regdb_fw_cb);
+	err = request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
+				      &reg_pdev->dev, GFP_KERNEL,
+				      (void *)alpha2, regdb_fw_cb);
+	if (err)
+		kfree(alpha2);
+
+	return err;
 }
 
 int reg_reload_regdb(void)
-- 
2.35.1



