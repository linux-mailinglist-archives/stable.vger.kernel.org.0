Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300ED594149
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245605AbiHOVUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbiHOVOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:14:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01A5DB7C7;
        Mon, 15 Aug 2022 12:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2EFC6009B;
        Mon, 15 Aug 2022 19:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA31C433D7;
        Mon, 15 Aug 2022 19:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591193;
        bh=fQ8GGMOh4zLwx6CDpw5/MD/NznF498JGC0ZDntJHGnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBqGCKnvInDMjojKuHtAVBv9VxVb6KKu7/uWLm/NQ/efX5dAtYOfzlpED1SDktDLy
         c7JtWxYGM0+JXRo30/PYFG0ITA7xH0EOEycaE9Bk/EuRBVCvFxbN6c2UKeC3UzZRX+
         uckTtHulZ8CkJ4hW7lA7uPR27A5ZqcsA5VJjyWCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0469/1095] wifi: p54: add missing parentheses in p54_flush()
Date:   Mon, 15 Aug 2022 19:57:48 +0200
Message-Id: <20220815180449.000893569@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Subkhankulov <subkhankulov@ispras.ru>

[ Upstream commit bcfd9d7f6840b06d5988c7141127795cf405805e ]

The assignment of the value to the variable total in the loop
condition must be enclosed in additional parentheses, since otherwise,
in accordance with the precedence of the operators, the conjunction
will be performed first, and only then the assignment.

Due to this error, a warning later in the function after the loop may
not occur in the situation when it should.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Fixes: 0d4171e2153b ("p54: implement flush callback")
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220714134831.106004-1-subkhankulov@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intersil/p54/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index a3ca6620dc0c..8fa3ec71603e 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -682,7 +682,7 @@ static void p54_flush(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 	 * queues have already been stopped and no new frames can sneak
 	 * up from behind.
 	 */
-	while ((total = p54_flush_count(priv) && i--)) {
+	while ((total = p54_flush_count(priv)) && i--) {
 		/* waste time */
 		msleep(20);
 	}
-- 
2.35.1



