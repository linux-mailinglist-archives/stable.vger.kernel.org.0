Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E436AEAC9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjCGRh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjCGRg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:36:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC22113C0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A171061514
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B49C433A0;
        Tue,  7 Mar 2023 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210377;
        bh=GOU+0pSlYB/cK03Cs2Y/5cetiJivKgCiOg+y4nMlhz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmVDjDnkb3fL/wmc+b/v7SJUdwW72wM9jSZs9iOgzUbko++980Qcn7hj8jGHAIJh+
         d5Nu16Isrmy3yTrhrKYj2Qr4oSYFwUF9lNJId1Z1SbYdj1k1OqrI3UVuoYNvMq2GpA
         xw4SE5YFYydkQRXEAQABZEB8UhdPD5EysI2S+kgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0520/1001] mei: pxp: Use correct macros to initialize uuid_le
Date:   Tue,  7 Mar 2023 17:54:52 +0100
Message-Id: <20230307170043.999827702@linuxfoundation.org>
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

[ Upstream commit 503b676dde2780330c90a10b37a844686601a784 ]

GUID_INIT() is for internal guid_t type and shouldn't be used
for the uuid_le. I.o.w. relying on the implementation details
is layering violation. Use correct macros to initialize uuid_le.

Fixes: c2004ce99ed7 ("mei: pxp: export pavp client to me client bus")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20221228160558.21311-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/pxp/mei_pxp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/pxp/mei_pxp.c b/drivers/misc/mei/pxp/mei_pxp.c
index 8dd09b1722ebd..7ee1fa7b1cb31 100644
--- a/drivers/misc/mei/pxp/mei_pxp.c
+++ b/drivers/misc/mei/pxp/mei_pxp.c
@@ -238,8 +238,8 @@ static void mei_pxp_remove(struct mei_cl_device *cldev)
 }
 
 /* fbf6fcf1-96cf-4e2e-a6a6-1bab8cbe36b1 : PAVP GUID*/
-#define MEI_GUID_PXP GUID_INIT(0xfbf6fcf1, 0x96cf, 0x4e2e, 0xA6, \
-			       0xa6, 0x1b, 0xab, 0x8c, 0xbe, 0x36, 0xb1)
+#define MEI_GUID_PXP UUID_LE(0xfbf6fcf1, 0x96cf, 0x4e2e, 0xA6, \
+			     0xa6, 0x1b, 0xab, 0x8c, 0xbe, 0x36, 0xb1)
 
 static struct mei_cl_device_id mei_pxp_tbl[] = {
 	{ .uuid = MEI_GUID_PXP, .version = MEI_CL_VERSION_ANY },
-- 
2.39.2



