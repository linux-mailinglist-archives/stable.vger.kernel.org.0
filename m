Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B262B6B3822
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 09:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjCJIIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 03:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjCJIIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 03:08:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1C9F4B79;
        Fri, 10 Mar 2023 00:07:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F325060F5D;
        Fri, 10 Mar 2023 08:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66A1DC433EF;
        Fri, 10 Mar 2023 08:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678435656;
        bh=MBsYfjfwW/rmvE0gLI4/NSeVvvOwKkEYquLXFvYR9d4=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=tR27wX7rP+axAePuvF5YfZvXyV8GK0gd4g9XBi5fG9lmjK+2mZR/j67UjvuBhnluN
         ko976C3omeUDXl7C8Y4R1m6qSvTn3N0M75I8pj71mi1oLc7T/n72NzspfbRrmMyBS6
         KghudbAhQ51/ne3baCEmVRYIWJGrrvnE3hABp4mu0Tb+SM9SVRz4eHbMxxIiazwBPy
         nvrqjYx3xqfTYDNZxXq+hrzpnmMMEiJ3/1lwzHQZNL2J/hm8wfNyms9LPlRI6pJNy5
         NSw5TMLmGS9YGGKO3NqRJCMWIgXBTmK9L94u1yQP7EbPzEOgdrpbP0/vKOrKlQzM98
         ZU0gT9xvNHtAA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 33654C64EC4;
        Fri, 10 Mar 2023 08:07:36 +0000 (UTC)
From:   Sasha Finkelstein via B4 Relay 
        <devnull+fnkl.kernel.gmail.com@kernel.org>
Date:   Fri, 10 Mar 2023 09:07:33 +0100
Subject: [PATCH RESEND] bluetooth: btbcm: Fix logic error in forming the
 board name.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-btbcm-wtf-v1-1-d2dbd7ca7ae4@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sasha Finkelstein <fnkl.kernel@gmail.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1678435655; l=1021;
 i=fnkl.kernel@gmail.com; s=20230213; h=from:subject:message-id;
 bh=liXj6eso7YibAPpq3C6GEb2euORWvG95T35Md9MPiuM=;
 b=7R+3sE6FGxSwElKG3xR8d3Up8y0qyG/1zw2uAQP/cLjg7ciqcMZgxV9f0J8QrL5vV3dZTV0jx
 P9vQM/QPcioCqEvgyVVluZl7j4scNKItXuj362r+Tg6W/sJ1nOVL13D
X-Developer-Key: i=fnkl.kernel@gmail.com; a=ed25519;
 pk=7LFSAJtxIWAs9LzCIyX0sSvCZy2wQTyEIu1zch6o804=
X-Endpoint-Received: by B4 Relay for fnkl.kernel@gmail.com/20230213 with auth_id=28
X-Original-From: Sasha Finkelstein <fnkl.kernel@gmail.com>
Reply-To: <fnkl.kernel@gmail.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Finkelstein <fnkl.kernel@gmail.com>

This patch fixes an incorrect loop exit condition in code that replaces
'/' symbols in the board name. There might also be a memory corruption
issue here, but it is unlikely to be a real problem.

Signed-off-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
---
 drivers/bluetooth/btbcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 3006e2a0f37e..43e98a598bd9 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -511,7 +511,7 @@ static const char *btbcm_get_board_name(struct device *dev)
 	len = strlen(tmp) + 1;
 	board_type = devm_kzalloc(dev, len, GFP_KERNEL);
 	strscpy(board_type, tmp, len);
-	for (i = 0; i < board_type[i]; i++) {
+	for (i = 0; i < len; i++) {
 		if (board_type[i] == '/')
 			board_type[i] = '-';
 	}

---
base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
change-id: 20230224-btbcm-wtf-ff32fed3e930

Best regards,
-- 
Sasha Finkelstein <fnkl.kernel@gmail.com>

