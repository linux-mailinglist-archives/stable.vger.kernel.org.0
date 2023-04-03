Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DA66D46F3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjDCOPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbjDCOPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:15:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46842B0E5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:15:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E1F561C83
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5508CC433EF;
        Mon,  3 Apr 2023 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531336;
        bh=Ln/lfPB/i44AdjzE3fAZ0YGhQc5SmLWIszoCNLrFTeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHQlloryzJyGegV45rqqNHtDjC4UzeUrJyk2bO4pxi8GYtT+Q3wJOVShLQqyQyx8q
         cfRqUqM/sO7StkB+NUOWvBw8XVLaVBY1GbcPRmmomGq+Zkb6Fwy2ttACpDNw5soaT7
         BSk45u4N3N69sFi6WpyzRvIp2hoBp8ss4BVtCNxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/84] Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work
Date:   Mon,  3 Apr 2023 16:08:25 +0200
Message-Id: <20230403140354.193385390@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
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
index 20142bc77554c..bd55bf7a9914c 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -353,6 +353,7 @@ static void btsdio_remove(struct sdio_func *func)
 
 	BT_DBG("func %p", func);
 
+	cancel_work_sync(&data->work);
 	if (!data)
 		return;
 
-- 
2.39.2



