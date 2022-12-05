Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF0643251
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiLETZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiLETZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:25:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E8924F35
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:21:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 728A7612FE
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EBDC433C1;
        Mon,  5 Dec 2022 19:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268062;
        bh=84zzblUWamD0hmqQrMDS/J273xNnEWn70LprASaCVaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0LKZMfBMHGBtbcJzwVpm9cphmb33YPRbS7PskW66R2950RX2d5yu3dncAnE5s6na
         BNqV88U+IDiDN5qJ58tYFZYTv6y4gPHera8DP5aMyqz8euG5nMBZiBBxtSK7ZnvV6W
         dXq+/+XQhBeF2cCi3IBBFgAqiyn6ikn27gS+W2zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/105] net: net_netdev: Fix error handling in ntb_netdev_init_module()
Date:   Mon,  5 Dec 2022 20:09:45 +0100
Message-Id: <20221205190805.630539868@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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
index df8d49ad48c3..33974e7519ce 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -506,7 +506,14 @@ static int __init ntb_netdev_init_module(void)
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



