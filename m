Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B78657DE6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbiL1PsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbiL1Pr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:47:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A614178AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:47:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 430C9B81716
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB9BC433EF;
        Wed, 28 Dec 2022 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242474;
        bh=nSangEpkODi3Yx9RWnu5jrOUO/BKt9zYkLzqko56W7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwqq5pwE1bum63n2F7UQV0xkBbOjCmZa7SeGCpZf0b0GaXcZOCvrYsmsGhG9UaSwz
         jc9xzDugUgOJGavJgpjc95mCobtbr903O4nswI+Ui86xKuss5ffpQ26evol7X7unMb
         d4XtlPyh+l6PUEWTPwxuza0qTKggcJ0roUGJmMS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0414/1073] wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()
Date:   Wed, 28 Dec 2022 15:33:22 +0100
Message-Id: <20221228144339.267922917@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 895b3b06efc285c1245242e9638b9ae251dc13ec ]

urbs does not be freed in exception paths in __lf_x_usb_enable_rx().
That will trigger memory leak. To fix it, add kfree() for urbs within
"error" label. Compile tested only.

Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221119051900.1192401-1-william.xuanziyang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 39e54b3787d6..76d0a778636a 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -247,6 +247,7 @@ static int __lf_x_usb_enable_rx(struct plfxlc_usb *usb)
 		for (i = 0; i < RX_URBS_COUNT; i++)
 			free_rx_urb(urbs[i]);
 	}
+	kfree(urbs);
 	return r;
 }
 
-- 
2.35.1



