Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438A06AA25F
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjCCVrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjCCVqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:46:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770E262D9B;
        Fri,  3 Mar 2023 13:44:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDE5E6192A;
        Fri,  3 Mar 2023 21:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6150FC4339C;
        Fri,  3 Mar 2023 21:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879862;
        bh=gW9hhBL4labV5P1WI6TlslQ9dU66H3xQxzXCjD9Z0NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KB1MGQ0F0A3mZdbSafmVNYCEyrbWo1tB+T3qZQ7tNARpQ7kFV/KhdGxmuxTzaToev
         p48rtKtssfwI70ae9zCPY4qqKVpUs+ZgxAPsHWBUQ9DsxL742QXxQA+DFpTo/7SNeo
         MYS9d4/PLNJb3dolFS+g685JkPNhSL1eg+4sn3GC3MOXAXGhVqOYO7ybMEhClqz50x
         56RxPwFk9GfxHce4RNRS1ACwFX8gkiRopUGxD0UxYscYL4GoGL8u61QneSRyhJV8VK
         T7ILNMJpGHp7qfDdRS7aJ7/NGMk1ABHRfTrLmwa4PUdu+IMYsUAtRT4wLF/31duvWl
         yxDEneJMIz4aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, stern@rowland.harvard.edu,
        ardb@kernel.org, alim.akhtar@samsung.com,
        mailhol.vincent@wanadoo.fr, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 31/60] USB: fotg210: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:42:45 -0500
Message-Id: <20230303214315.1447666-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
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

[ Upstream commit 6b4040f452037a7e95472577891d57c6b18c89c5 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230202153235.2412790-5-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/fotg210-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 3d1dbcf4c0732..c4c1fbc12b4cd 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -862,7 +862,7 @@ static inline void remove_debug_files(struct fotg210_hcd *fotg210)
 {
 	struct usb_bus *bus = &fotg210_to_hcd(fotg210)->self;
 
-	debugfs_remove(debugfs_lookup(bus->bus_name, fotg210_debug_root));
+	debugfs_lookup_and_remove(bus->bus_name, fotg210_debug_root);
 }
 
 /* handshake - spin reading hc until handshake completes or fails
-- 
2.39.2

