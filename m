Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3087E64A1AA
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiLLNn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiLLNni (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D75555B6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:42:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B48161074
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BD6C433D2;
        Mon, 12 Dec 2022 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852571;
        bh=ywrchfMtWhaZSpsf5YoNrqg5V7tuc7+/bI+thI0kY8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIzsQ9o4inKHFvUmR9MxIxab5aFsnSYUviMrLRQSQjcXCF6/oDt49DF0wgISNblfk
         g6upf+ko/bxztcdyso7arfboSnj9SwMRZrPU5l3hfoMW4Cvog5zADVt3CbtdAj1qlP
         e+HHHrpC+iseydqjaoq9YQc3r6RZDgDHrUFRpzIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 107/157] Bluetooth: hci_conn: add missing hci_dev_put() in iso_listen_bis()
Date:   Mon, 12 Dec 2022 14:17:35 +0100
Message-Id: <20221212130939.142510350@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 7e7df2c10c92cab7d1dde3b301e584e2e877fbda ]

hci_get_route() takes reference, we should use hci_dev_put() to release
it when not need anymore.

Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index f825857db6d0..26db929b97c4 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -879,6 +879,7 @@ static int iso_listen_bis(struct sock *sk)
 				 iso_pi(sk)->bc_sid);
 
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	return err;
 }
-- 
2.35.1



