Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15ECD6AEACA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjCGRha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbjCGRhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:37:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA00158B9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D488E61506
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB06C4339B;
        Tue,  7 Mar 2023 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210380;
        bh=FT5BzBiFOOoVnrVep2O460kqXxM/NKSSiiE9MmPUhhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKZTLp66YpDsutNuh2hl/u+W38i6h/nIZ4DlxT2fVVA1wJdDNcXHGom9GTGFWIAWe
         GcObOzHEYQt4a+SPAGxCaqtz/RZkw+AH6rBGXldIsFMXUWAoLzN+yFoTEP1tANhw4y
         LYCqrKyF4Ny6wD5kFbQ9I1xkaTIJkgldydYGLETA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0521/1001] misc/mei/hdcp: Use correct macros to initialize uuid_le
Date:   Tue,  7 Mar 2023 17:54:53 +0100
Message-Id: <20230307170044.047783673@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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



