Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347AA6B3C09
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 11:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCJK2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 05:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCJK2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 05:28:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC6ABD4CA;
        Fri, 10 Mar 2023 02:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06970B82255;
        Fri, 10 Mar 2023 10:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E8A6C433D2;
        Fri, 10 Mar 2023 10:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678444124;
        bh=cw6JqgVRcBRQwD+z2NKbYa9SyRaPNNVKjwnBlcot7bE=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=aI7whm0G7BL+SDbSEQLMo19R/Yl0B8vCDcerm/+ZDBLcGbKQn7hntvpCUgDfsqL5U
         Xh1soBiEtw7ps/57DW7E8ShbDcMiRG7Mid6MzIE6c9YFw4yKncFUu1eUrCwGaJKkT1
         UOGKSlFXnn+WxEca9H54oswFcLgrfkiNqhZU9iWscfsZ7V0KLB57zSl5rsKTI6s0YU
         DckXvX4pVPc7xaHW7dmYLgsiaxOfPd0VUt8G4ObGFYbMrvh7EcTtyKKLNhUTws366i
         nIxsw0h2pUknPsNz/HFXsdiW4fCfdg5vOnYEWWMWRtTR60XSm1LKwgCs5O1lK44YA1
         Yu/q1tDfBBJXQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE39C6FA99;
        Fri, 10 Mar 2023 10:28:44 +0000 (UTC)
From:   Sasha Finkelstein via B4 Relay 
        <devnull+fnkl.kernel.gmail.com@kernel.org>
Date:   Fri, 10 Mar 2023 11:28:42 +0100
Subject: [PATCH RESEND] bluetooth: btbcm: Fix logic error in forming the
 board name.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-btbcm-wtf-v1-1-98b56133a5b7@gmail.com>
X-B4-Tracking: v=1; b=H4sIAFkGC2QC/x2NsQ7CMAxEf6XyTKSQsMBMVwYYUYckdYiHpsiOo
 FXVfydhfO/udBsIMqHApduA8UNCc65wPHQQkssvVDRWBqON1caclC8+TOpboorRmoijxbPVUPv
 eCSrPLofUFpOTgtyCN2Ok5X/yhHv/6G9XGKpPJGXmtelh3383ljhSiwAAAA==
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sasha Finkelstein <fnkl.kernel@gmail.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1678444123; l=1051;
 i=fnkl.kernel@gmail.com; s=20230213; h=from:subject:message-id;
 bh=+hMNA2WpUNZu2o8n2bsPzKVxjKjxWwSwKggqeF2dZBY=;
 b=mnQHxqtnBZuBU3DFpb7akNdZHagVnnVmY8+FCTDQjEVM1DQ4fsHWry00l2w0Im+Fgy5WF0vLl
 75//dVWW7IFBLEApayjftPEIfRMwpLeYHsC8x9DmKeliO8NQJN6XsnD
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

Cc: <stable@vger.kernel.org>
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
base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
change-id: 20230224-btbcm-wtf-ff32fed3e930

Best regards,
-- 
Sasha Finkelstein <fnkl.kernel@gmail.com>

