Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E006AA494
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbjCCWiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbjCCWho (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:37:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392575FCB;
        Fri,  3 Mar 2023 14:35:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B438B819FA;
        Fri,  3 Mar 2023 21:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4FFC433A0;
        Fri,  3 Mar 2023 21:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879987;
        bh=YX/21BYrmjlYFBFWNNqTXN4rfX0UhjUGZkGvfSZuZ9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5ahEo5EmOULx1jzg1eBRxjv09wB2Vc4paTlcPo6giA2n0XMXMwQLMY52lZPweWa4
         Wg3anpQ1u+MhV7l/YffXYzTieAv4RyPQgWoUVO0Qm0XCLg9n8a2qVIrORHFrlj7wpD
         8x/NyY+VvGDIsk3RlO9YTWe/tgH/wsh2iG8Y4IRjJ/i8DO0NVo4ObPkkIrn4Ha8vdV
         AUW2u9phdacn4AdswZP+5/yCRg7nsypkZrO/tJFBI06PuwOBaTwkV+0dWNMYj2F8AP
         gbxwawr4wPTSKudqUuePJ3r4cruei0oMZ7r9ovOt416haEJDCHf8J4tCBx4/CrAhF3
         LhjbKzkOSQ0uQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh@kernel.org,
        mailhol.vincent@wanadoo.fr, ardb@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 25/50] USB: fotg210: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:06 -0500
Message-Id: <20230303214531.1450154-25-sashal@kernel.org>
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
index 4b02ace09f3dc..d9a3fd8af7a01 100644
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

