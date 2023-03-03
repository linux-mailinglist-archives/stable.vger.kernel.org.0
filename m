Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732986AA240
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjCCVpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbjCCVot (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:44:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFB064251;
        Fri,  3 Mar 2023 13:43:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EDCDBCE229C;
        Fri,  3 Mar 2023 21:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F235EC4339C;
        Fri,  3 Mar 2023 21:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879743;
        bh=gpUSKB3kC9G6mWSenLq1kBUG6QCbvz++Xvx6mViL4wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqB+0BRravamsuwm/BzfBkO8I6Hu7GLY9+fGw7Y1Goa4hJ1+DsdT99rqjcc9LXUMD
         6YYAPnczTIReCuosPTQsiLSIX8yrB8QF/CpxnIJnlO0r7b3cuynrOizhvsPLOvkW4L
         1TgWVtkbdujLZB+FGsXE38c7wery+iN9WK4uouuUIfdKPUeNbMBdx9XgviRO2LDm+k
         I6GlwxowFVBbr/ok37AnBVJt3jrNGuUQmlRBhQ2cjRDCTQOlGNk6wtC86y8cZz1+E3
         dxu17SXIog6lpE+QC4NdiOC0Pd4kSpEiS0Ao3BHmeVtYDfxbOmgrf5Ijn+puDKEbzY
         eyy/fEAcGd9cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olav Kongas <ok@artecdesign.ee>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 36/64] USB: isp116x: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:40:38 -0500
Message-Id: <20230303214106.1446460-36-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

