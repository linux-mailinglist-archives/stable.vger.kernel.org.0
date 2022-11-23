Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360E0635444
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbiKWJD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbiKWJDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:03:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D847FCDE8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1BA6B81ECB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA84C433D6;
        Wed, 23 Nov 2022 09:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194194;
        bh=szS3QkFqpIu8mbDgyz5/uhov/DHdsSLMaYVs/w94Yrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op/7MZ5/Y91eoC9vYNtR2PuSA56pIHw16gSQMw/ttcfk/6ic4HYfp0MEjojt+2751
         uUgipqsTa5rFbyYXFxjAxZd0mhiQLSds5KgrcErIPux0WZ2FpnbaJxMnu9ZgV3GF4F
         jJeTQyDjXBwjpWltxapbyOUZq0OedWzWNlcZ06tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 002/114] wifi: cfg80211: fix memory leak in query_regdb_file()
Date:   Wed, 23 Nov 2022 09:49:49 +0100
Message-Id: <20221123084551.955021281@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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
index dd8503a3ef1e..07d053603e3a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1050,6 +1050,8 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 
 static int query_regdb_file(const char *alpha2)
 {
+	int err;
+
 	ASSERT_RTNL();
 
 	if (regdb)
@@ -1059,9 +1061,13 @@ static int query_regdb_file(const char *alpha2)
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



