Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EFB4F32B4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243015AbiDEJiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243848AbiDEJJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:09:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A57B4C7A7;
        Tue,  5 Apr 2022 01:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC4C561573;
        Tue,  5 Apr 2022 08:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0BCC385A1;
        Tue,  5 Apr 2022 08:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149125;
        bh=CSM//Rz3PDHvzk+BYq71+X+1Jm1t0/cBCElyGnnl1/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAK8f1e7E1XaY9qdGECPYedyJNjCmTdbG2h0SvMKRBXJHf1ZkE4zr/2UTQDwpwap+
         YSIVaQcfQTsXNEX9EyQmTyEkW8nmeaL0uELvK1KBPhP9G88jLE6qh1hZnpFF/mFOSQ
         VqtP5cUIewMT48YqBGCvBwRwCpn5QjErdsszkXEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0604/1017] USB: storage: ums-realtek: fix error code in rts51x_read_mem()
Date:   Tue,  5 Apr 2022 09:25:17 +0200
Message-Id: <20220405070412.206774640@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b07cabb8361dc692522538205552b1b9dab134be ]

The rts51x_read_mem() function should return negative error codes.
Currently if the kmalloc() fails it returns USB_STOR_TRANSPORT_ERROR (3)
which is treated as success by the callers.

Fixes: 065e60964e29 ("ums_realtek: do not use stack memory for DMA")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220304073504.GA26464@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/realtek_cr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 3789698d9d3c..0c423916d7bf 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -365,7 +365,7 @@ static int rts51x_read_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 
 	buf = kmalloc(len, GFP_NOIO);
 	if (buf == NULL)
-		return USB_STOR_TRANSPORT_ERROR;
+		return -ENOMEM;
 
 	usb_stor_dbg(us, "addr = 0x%x, len = %d\n", addr, len);
 
-- 
2.34.1



