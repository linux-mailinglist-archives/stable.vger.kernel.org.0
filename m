Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74325643475
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiLETrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbiLETqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:46:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FCD1D0E0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:42:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EBAEB8120C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEACC433D7;
        Mon,  5 Dec 2022 19:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269376;
        bh=auZhxvxz4sJGIrU0fenexQ7fBZroaF+/wSC69+63isM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJKDncNejJ4b6Gy1U/UKeh4V2AN2aH6v/Qe1QdJXI5bGYMxZSK6cLyzoYbZ9pDI2g
         eTJxoLpOKuQPZ3+IM8tyr0re399Q/PkE8accgerZeHwai8FCfAWNV+DBhAHHscmR5p
         ya0LdX4XvM2TiToXfU3+uzIzPvO012EJiOHTHcMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/153] net: net_netdev: Fix error handling in ntb_netdev_init_module()
Date:   Mon,  5 Dec 2022 20:10:28 +0100
Message-Id: <20221205190811.731444021@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit b8f79dccd38edf7db4911c353d9cd792ab13a327 ]

The ntb_netdev_init_module() returns the ntb_transport_register_client()
directly without checking its return value, if
ntb_transport_register_client() failed, the NTB client device is not
unregistered.

Fix by unregister NTB client device when ntb_transport_register_client()
failed.

Fixes: 548c237c0a99 ("net: Add support for NTB virtual ethernet device")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ntb_netdev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index a5bab614ff84..1b7d588ff3c5 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -484,7 +484,14 @@ static int __init ntb_netdev_init_module(void)
 	rc = ntb_transport_register_client_dev(KBUILD_MODNAME);
 	if (rc)
 		return rc;
-	return ntb_transport_register_client(&ntb_netdev_client);
+
+	rc = ntb_transport_register_client(&ntb_netdev_client);
+	if (rc) {
+		ntb_transport_unregister_client_dev(KBUILD_MODNAME);
+		return rc;
+	}
+
+	return 0;
 }
 module_init(ntb_netdev_init_module);
 
-- 
2.35.1



