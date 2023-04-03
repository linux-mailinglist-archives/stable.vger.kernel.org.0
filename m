Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885D56D479C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjDCOVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjDCOVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:21:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3F82D7F3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26831B801BE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99879C433D2;
        Mon,  3 Apr 2023 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531669;
        bh=AfG34DsN1616X0x9ZR2N96lwTwgm9iUcT8fle88h2+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJEwkEkdO4acHnghv04lDVdRQCLBboO+DtFkQXwrtcEZ5pKEGBYg6dztRaSKfCjLO
         ceIvWETf5lg8vEirKHz83dx99bC21BS/T4Hpq6Tg3QUahRF4UOag/nw8naug0cuZfc
         JkXFKUBwE4C4+7DzUK4T7BtdLiLh0EMD7XtQcics=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/104] Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work
Date:   Mon,  3 Apr 2023 16:08:18 +0200
Message-Id: <20230403140405.296074433@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 1e9ac114c4428fdb7ff4635b45d4f46017e8916f ]

In btsdio_probe, &data->work was bound with btsdio_work.In
btsdio_send_frame, it was started by schedule_work.

If we call btsdio_remove with an unfinished job, there may
be a race condition and cause UAF bug on hdev.

Fixes: ddbaf13e3609 ("[Bluetooth] Add generic driver for Bluetooth SDIO devices")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btsdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
index fd9571d5fdac9..81125fb180351 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -343,6 +343,7 @@ static void btsdio_remove(struct sdio_func *func)
 
 	BT_DBG("func %p", func);
 
+	cancel_work_sync(&data->work);
 	if (!data)
 		return;
 
-- 
2.39.2



