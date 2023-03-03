Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABF76AA24B
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjCCVqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjCCVqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:46:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8FB70402;
        Fri,  3 Mar 2023 13:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D22C561944;
        Fri,  3 Mar 2023 21:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4AEC433AA;
        Fri,  3 Mar 2023 21:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879858;
        bh=4OwnsPE4H33XJHzWTzuz/cql0vvfoxRUgJnjZXxn1VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeRMyI0NUdcnmqoPD6OWzSZMNG8WFPyiecnbj7qjSWyyOeLQFW3UqOWDiTA2MrGkH
         OVc/FI1dtmMyaryMpkKFFkCvIQaPRx8FgvL36HeP5mIhVWbV3X5SXvFM1OCfEYJpyM
         riNaaZ4amgJv6E4VVKrFNBYeKhiCNU8+6+TzuAQHTmC0NBCmm/z8k/jPzZLHxen/NI
         3S/pqmwS6WLxdx7X7ZnFT+COGFW3vN6FdB030lGvH8zMsNkkSNzo9poe9YDxw+0Ze3
         cTtgLa4619q9y3kceqluMLZ2DcJNgZUQPhkUT2+elSy/MT/Ete5JR2usWu66wO92b+
         mDT+VVjbajwpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 30/60] USB: sl811: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:42:44 -0500
Message-Id: <20230303214315.1447666-30-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
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

[ Upstream commit e1523c4dbc54e164638ff8729d511cf91e27be04 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20230202153235.2412790-4-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/sl811-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index d206bd95c7bbc..b8b90eec91078 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1501,7 +1501,7 @@ static void create_debug_file(struct sl811 *sl811)
 
 static void remove_debug_file(struct sl811 *sl811)
 {
-	debugfs_remove(debugfs_lookup("sl811h", usb_debug_root));
+	debugfs_lookup_and_remove("sl811h", usb_debug_root);
 }
 
 /*-------------------------------------------------------------------------*/
-- 
2.39.2

