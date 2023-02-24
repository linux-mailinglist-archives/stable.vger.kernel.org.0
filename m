Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE306A1BB2
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 12:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjBXL7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 06:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjBXL7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 06:59:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBED16AC9;
        Fri, 24 Feb 2023 03:59:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7920B81C60;
        Fri, 24 Feb 2023 11:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F9C5C433EF;
        Fri, 24 Feb 2023 11:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677239982;
        bh=MBsYfjfwW/rmvE0gLI4/NSeVvvOwKkEYquLXFvYR9d4=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=hEkrV8GB0nqtZxNInYSLUkdoapoIDBvBWbWIf1LZwAEiLgp5UKJWgu5e+gsQM9l2F
         7KdQQygYRLw2vj3iQB0iS+r/F+JE54zXaxuM2oT/WfM3nyIK9XWTcRKWsfNAbf8HBl
         QoDzV9upnKpAFkJZkYIGPOEdUoMM54SkvUBn+m2TNf6+/o/K109VXmYms9iIMvAFq/
         UxyKwddlpyAsvp1wD4VQDK0512lMhK6btqZenQCahcPzA5Ni4JvetPukD6dT9Ct0ot
         dJYsEGl7P1mDfAOeJrzmP19caRbZGBaNWDJxPQ86wI0UVboO7FtNkjBICQuX0citwz
         Wf8PnTulRQnvQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 4233EC61DA3;
        Fri, 24 Feb 2023 11:59:42 +0000 (UTC)
From:   Sasha Finkelstein via B4 Relay 
        <devnull+fnkl.kernel.gmail.com@kernel.org>
Date:   Fri, 24 Feb 2023 12:59:31 +0100
Subject: [PATCH] bluetooth: btbcm: Fix logic error in forming the board
 name.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-btbcm-wtf-v1-1-be717d728e56@gmail.com>
X-B4-Tracking: v=1; b=H4sIAKKm+GMC/x2NQQ7CMAwEv1L5jKXg9AJfQRyS1G59aEB2BJWq/
 p2U42hnNTs4m7LDfdjB+KOur9rhehmgLKnOjDp1BgoUA9GIueWy4rcJikQSniLfYoDu5+SM2VI
 ty/lYkze2c3gbi27/yON5HD9e6z/4dAAAAA==
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sasha Finkelstein <fnkl.kernel@gmail.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1677239981; l=1021;
 i=fnkl.kernel@gmail.com; s=20230213; h=from:subject:message-id;
 bh=liXj6eso7YibAPpq3C6GEb2euORWvG95T35Md9MPiuM=;
 b=Fk8BUaDW2JcDWQIOtNnG7UY8stvFMte2f8CocTlQj9cWdcvSB9Q9Rq5Ltk3Y+zJDD4RD4ZG8d
 ZoqwvFk4SQCDcUwZhfNQp87ASdy5EqrY3VRFNyE2mtnVRXwFN7LgshB
X-Developer-Key: i=fnkl.kernel@gmail.com; a=ed25519;
 pk=7LFSAJtxIWAs9LzCIyX0sSvCZy2wQTyEIu1zch6o804=
X-Endpoint-Received: by B4 Relay for fnkl.kernel@gmail.com/20230213 with auth_id=28
X-Original-From: Sasha Finkelstein <fnkl.kernel@gmail.com>
Reply-To: <fnkl.kernel@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

