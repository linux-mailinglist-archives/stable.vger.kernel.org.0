Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9694989F1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344806AbiAXS7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343508AbiAXS5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:57:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93977C06175B;
        Mon, 24 Jan 2022 10:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D71CB8121F;
        Mon, 24 Jan 2022 18:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE7DC340E5;
        Mon, 24 Jan 2022 18:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050524;
        bh=Us75XI7l1VTBnBYvjSJriVtvVpSWcfd0l6dAH8GK9QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHKfwLkiCxp6SGf5nQ0g7P41bCeFs3YnQcgcBvmKhsyY3YXayuJ1n6Z7fXMUDqTIS
         GtL6li6vbN0HnfGMdnYMIS/NpckCaCkUN6AgZhsG93NhRbhaMHHgkN2rmWYqITjE7H
         hq/URxFKg2O52ZI22HpUhcC/bWRGdcaxlAj2ZWoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 029/157] Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
Date:   Mon, 24 Jan 2022 19:41:59 +0100
Message-Id: <20220124183933.720677033@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 2a7ca7459d905febf519163bd9e3eed894de6bb7 ]

I got a kernel BUG report when doing fault injection test:

------------[ cut here ]------------
kernel BUG at lib/list_debug.c:45!
...
RIP: 0010:__list_del_entry_valid.cold+0x12/0x4d
...
Call Trace:
 proto_unregister+0x83/0x220
 cmtp_cleanup_sockets+0x37/0x40 [cmtp]
 cmtp_exit+0xe/0x1f [cmtp]
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

If cmtp_init_sockets() in cmtp_init() fails, cmtp_init() still returns
success. This will cause a kernel bug when accessing uncreated ctmp
related data when the module exits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/cmtp/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index 0bb150e68c53f..e2e580c747f4b 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -499,9 +499,7 @@ static int __init cmtp_init(void)
 {
 	BT_INFO("CMTP (CAPI Emulation) ver %s", VERSION);
 
-	cmtp_init_sockets();
-
-	return 0;
+	return cmtp_init_sockets();
 }
 
 static void __exit cmtp_exit(void)
-- 
2.34.1



