Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0C463DD39
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiK3SZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiK3SZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:25:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE7B6314;
        Wed, 30 Nov 2022 10:25:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 058E7CE1ACC;
        Wed, 30 Nov 2022 18:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D68C433C1;
        Wed, 30 Nov 2022 18:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832726;
        bh=62Fqnu0SpwoA4vK91A3SZ3ETuJz1j4DVnrjfKEssupE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkODjCpudfDhF+W3v5wVNN0s2cMZERDF3zqrCCpxNTimPBGEP0hLDKiefO70fms5O
         8oqSVh8EAO+GboYd+i1fGbGpUPeprUaZ/RrPjUI6B5ZHj6NdOvQvk4ZoBk/M7HaefE
         gUibNnexdysWD8LY3He/l0B0I6hd6ROB72zgwjjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kalle Valo <kvalo@kernel.org>,
        linux-wireless@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/162] wifi: airo: do not assign -1 to unsigned char
Date:   Wed, 30 Nov 2022 19:21:40 +0100
Message-Id: <20221130180529.017718295@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit e6cb8769452e8236b52134e5cb4a18b8f5986932 ]

With char becoming unsigned by default, and with `char` alone being
ambiguous and based on architecture, we get a warning when assigning the
unchecked output of hex_to_bin() to that unsigned char. Mark `key` as a
`u8`, which matches the struct's type, and then check each call to
hex_to_bin() before casting.

Cc: Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221024162843.535921-1-Jason@zx2c4.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/cisco/airo.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 0569f37e9ed5..8c9c6bfbaeee 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5236,7 +5236,7 @@ static int get_wep_tx_idx(struct airo_info *ai)
 	return -1;
 }
 
-static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
+static int set_wep_key(struct airo_info *ai, u16 index, const u8 *key,
 		       u16 keylen, int perm, int lock)
 {
 	static const unsigned char macaddr[ETH_ALEN] = { 0x01, 0, 0, 0, 0, 0 };
@@ -5287,7 +5287,7 @@ static void proc_wepkey_on_close(struct inode *inode, struct file *file)
 	struct net_device *dev = PDE_DATA(inode);
 	struct airo_info *ai = dev->ml_priv;
 	int i, rc;
-	char key[16];
+	u8 key[16];
 	u16 index = 0;
 	int j = 0;
 
@@ -5315,12 +5315,22 @@ static void proc_wepkey_on_close(struct inode *inode, struct file *file)
 	}
 
 	for (i = 0; i < 16*3 && data->wbuffer[i+j]; i++) {
+		int val;
+
+		if (i % 3 == 2)
+			continue;
+
+		val = hex_to_bin(data->wbuffer[i+j]);
+		if (val < 0) {
+			airo_print_err(ai->dev->name, "WebKey passed invalid key hex");
+			return;
+		}
 		switch(i%3) {
 		case 0:
-			key[i/3] = hex_to_bin(data->wbuffer[i+j])<<4;
+			key[i/3] = (u8)val << 4;
 			break;
 		case 1:
-			key[i/3] |= hex_to_bin(data->wbuffer[i+j]);
+			key[i/3] |= (u8)val;
 			break;
 		}
 	}
-- 
2.35.1



