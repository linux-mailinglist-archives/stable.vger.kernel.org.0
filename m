Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A31554987A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347553AbiFMKzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350443AbiFMKyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71E320F6B;
        Mon, 13 Jun 2022 03:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55BB160B8B;
        Mon, 13 Jun 2022 10:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D152C34114;
        Mon, 13 Jun 2022 10:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116289;
        bh=hqCtAb/WgSm7rzufedKllC993dM4mSQ0Ss6AEyB21jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apSgV/VFbgdxN5e5/iBxn73TnXSa1TlEZwQi8L6Sg38HXwoyMSsAIWpaeA9rSOJ9x
         woMGI4Kno2EJx3ssYdpfAVGI9nrvtugPAb5zu/yGzUrxZsKugzyI2EMjvUTZ6AvWgm
         gX/Ulgj2mef8MxXN/pBh/LNRNNoV18eZii7vRYT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/411] rtlwifi: Use pr_warn instead of WARN_ONCE
Date:   Mon, 13 Jun 2022 12:05:22 +0200
Message-Id: <20220613094929.982180231@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit ad732da434a2936128769216eddaece3b1af4588 ]

This memory allocation failure can be triggered by fault injection or
high pressure testing, resulting a WARN.

Fix this by replacing WARN with pr_warn.

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220511014453.1621366-1-dzm91@hust.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index bad06939a247..9bcb187d37dc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1013,7 +1013,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	hw = ieee80211_alloc_hw(sizeof(struct rtl_priv) +
 				sizeof(struct rtl_usb_priv), &rtl_ops);
 	if (!hw) {
-		WARN_ONCE(true, "rtl_usb: ieee80211 alloc failed\n");
+		pr_warn("rtl_usb: ieee80211 alloc failed\n");
 		return -ENOMEM;
 	}
 	rtlpriv = hw->priv;
-- 
2.35.1



