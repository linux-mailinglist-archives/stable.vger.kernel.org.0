Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B52C60B6D8
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbiJXTMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbiJXTLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:11:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FC9CF1B2;
        Mon, 24 Oct 2022 10:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 172A1B819A4;
        Mon, 24 Oct 2022 12:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C647C433C1;
        Mon, 24 Oct 2022 12:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615371;
        bh=zbp4AXKUfv3HaM7iZ3pIS42q/U+YgNKon4cYmy2Inrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1hp3UWX1M1WcVKx4/c3UMXUbuDX36xYyrkAKLOYZEFA9j6giTwcjOMk8SIkhylWk
         ULMU9F735mTKLZYAxTGfV39JkqxeLFZw4JwzScUqMfrXDmB5UeyUFXmwZoWpnXyVF0
         u6F0EhqQF7cnu6JdMyNW6KBGzIU08zI3xM5IXB8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 224/530] platform/chrome: cros_ec_typec: Correct alt mode index
Date:   Mon, 24 Oct 2022 13:29:28 +0200
Message-Id: <20221024113055.230599539@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 4e477663e396f48c5cfc5f2d75d4b514f409516a ]

Alt mode indices used by USB PD (Power Delivery) start with 1, not 0.

Update the alt mdoe registration code to factor this in to the alt mode
descriptor.

Fixes: de0f49487db3 ("platform/chrome: cros_ec_typec: Register partner altmodes")
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20220819190807.1275937-3-pmalani@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 4027c3ef90d7..aadb8d237aef 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -691,7 +691,7 @@ static int cros_typec_register_altmodes(struct cros_typec_data *typec, int port_
 		for (j = 0; j < sop_disc->svids[i].mode_count; j++) {
 			memset(&desc, 0, sizeof(desc));
 			desc.svid = sop_disc->svids[i].svid;
-			desc.mode = j;
+			desc.mode = j + 1;
 			desc.vdo = sop_disc->svids[i].mode_vdo[j];
 
 			if (is_partner)
-- 
2.35.1



