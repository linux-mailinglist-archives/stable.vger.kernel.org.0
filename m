Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E4C6AF035
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbjCGS33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbjCGS3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD09A21A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:21:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AB67614E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C69C433D2;
        Tue,  7 Mar 2023 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213313;
        bh=FT5BzBiFOOoVnrVep2O460kqXxM/NKSSiiE9MmPUhhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4jmOiYWte8i0hoYKnWZg8YuFvCdNtdawGbU0pVdbgGyC+mtW2xaWU9WpfqzWJYRt
         azf8qUOU7qtPm9Wlw6g9oA9FMmMSeRBISXmtBxsMGbn1F5xNa2kuEfCs0d28UPtR3e
         nQlB49WzC1llyBnCiOR/kaKPB6kfs4rAvPaM2Uhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 440/885] misc/mei/hdcp: Use correct macros to initialize uuid_le
Date:   Tue,  7 Mar 2023 17:56:14 +0100
Message-Id: <20230307170021.527648781@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 512ba04d8211dd1a54dd36adc3ecc527a28069c5 ]

GUID_INIT() is for internal guid_t type and shouldn't be used
for the uuid_le. I.o.w. relying on the implementation details
is layering violation. Use correct macros to initialize uuid_le.

Fixes: 64e9bbdd9588 ("misc/mei/hdcp: Client driver for HDCP application")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20221228160500.21220-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/hdcp/mei_hdcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
index e889a8bd7ac88..e0dcd5c114db1 100644
--- a/drivers/misc/mei/hdcp/mei_hdcp.c
+++ b/drivers/misc/mei/hdcp/mei_hdcp.c
@@ -859,8 +859,8 @@ static void mei_hdcp_remove(struct mei_cl_device *cldev)
 		dev_warn(&cldev->dev, "mei_cldev_disable() failed\n");
 }
 
-#define MEI_UUID_HDCP GUID_INIT(0xB638AB7E, 0x94E2, 0x4EA2, 0xA5, \
-				0x52, 0xD1, 0xC5, 0x4B, 0x62, 0x7F, 0x04)
+#define MEI_UUID_HDCP UUID_LE(0xB638AB7E, 0x94E2, 0x4EA2, 0xA5, \
+			      0x52, 0xD1, 0xC5, 0x4B, 0x62, 0x7F, 0x04)
 
 static const struct mei_cl_device_id mei_hdcp_tbl[] = {
 	{ .uuid = MEI_UUID_HDCP, .version = MEI_CL_VERSION_ANY },
-- 
2.39.2



