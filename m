Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AF16B434A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjCJOMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjCJOMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:12:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3A311A98F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:11:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 370F661380
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425E7C433D2;
        Fri, 10 Mar 2023 14:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457472;
        bh=gpUSKB3kC9G6mWSenLq1kBUG6QCbvz++Xvx6mViL4wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNGWOHsJ0EkrCB8U8rX0arSRQFF/gViYCpb8C9nxQ8uctMwOIT4FI9UgV4MWmE/Pl
         YpSArHaRkfGLwvhdPw0VxJuIPGmN6k3MR8xJfGzeWs+/vDMnXElx3gjhzl3Ivj/SqP
         OEUpxbm8Af1wIhSSeJNMZxl8JBvh8cPJm1rWeIGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Olav Kongas <ok@artecdesign.ee>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/200] USB: isp116x: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:39:16 +0100
Message-Id: <20230310133721.701515949@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit a95f62d5813facbec20ec087472eb313ee5fa8af ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Olav Kongas <ok@artecdesign.ee>
Link: https://lore.kernel.org/r/20230202153235.2412790-6-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/isp116x-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 4f564d71bb0bc..49ae01487af4d 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1205,7 +1205,7 @@ static void create_debug_file(struct isp116x *isp116x)
 
 static void remove_debug_file(struct isp116x *isp116x)
 {
-	debugfs_remove(debugfs_lookup(hcd_name, usb_debug_root));
+	debugfs_lookup_and_remove(hcd_name, usb_debug_root);
 }
 
 #else
-- 
2.39.2



