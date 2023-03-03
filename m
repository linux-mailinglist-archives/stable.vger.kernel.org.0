Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8976AA57A
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 00:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCCXS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 18:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCCXS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 18:18:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F712106;
        Fri,  3 Mar 2023 15:18:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 536C8CE22A2;
        Fri,  3 Mar 2023 21:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535D8C4339B;
        Fri,  3 Mar 2023 21:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879992;
        bh=4Rlk7mTnFif+6NkIZtruu0A00Akx+z1pl5lWZlB0PPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbzL5MzKrN7NGYw7IF9i+WdyZ7bl2r0Pq176ekLJ1jnYZW49O06APFmpl/lkLwWMo
         gU7zVKJ25cvhbsbYUjvBBi8Y3O7l2QwJRaUZ0utx28B0HDllz6DOfsVsxHkBYnlhSW
         EuOiL6CRrVwPbAb6xVmaF5OYBRF9qLX2k3b9FJzkAmSwmo3ydsEsvIa/ad27DL1r8P
         eIT+gDtfyhdo3YTOvdFgOc8tOaoCGwWLDD7XJh8r+6jF/olaeBuA1nUWcPf1PtfSk2
         Xg8m7oqTWhNP30T2tPknL1CtAu/JNRSezBkYjpjdDKI87rxhSPghydjq67R+334B39
         YeHyAuAvka+nA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 27/50] USB: isp1362: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:08 -0500
Message-Id: <20230303214531.1450154-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit c26e682afc14caa87d44beed271eec8991e93c65 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20230202153235.2412790-7-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/isp1362-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index d8610ce8f2ecd..bc68669dfc50c 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2170,7 +2170,7 @@ static void create_debug_file(struct isp1362_hcd *isp1362_hcd)
 
 static void remove_debug_file(struct isp1362_hcd *isp1362_hcd)
 {
-	debugfs_remove(debugfs_lookup("isp1362", usb_debug_root));
+	debugfs_lookup_and_remove("isp1362", usb_debug_root);
 }
 
 /*-------------------------------------------------------------------------*/
-- 
2.39.2

