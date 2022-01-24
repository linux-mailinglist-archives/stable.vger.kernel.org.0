Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4142E4988EF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343813AbiAXSvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245344AbiAXSuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:50:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7432AC061401;
        Mon, 24 Jan 2022 10:50:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11A4E61502;
        Mon, 24 Jan 2022 18:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CCDC340E5;
        Mon, 24 Jan 2022 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050236;
        bh=yDBSgpBW6dgHBL2qjwJh5vA0ZzJY2QqpuiH7rtUVgX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4hec8MJns+B6zOTsiGbXgOiOP7MVKEGb9aw/lhtZ4EtkUZSQ53LrYcfJjcAfgVdr
         bNKw6wG59ftNHEp062T/pJTrPR9khfLUYXLbDWq0w7FNiZhH8v+V9a9DH+mdK0lssw
         6jnAp9uCo/TUfGdJ4vj8K+ngPut97XaO1F0u2p20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 020/114] Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
Date:   Mon, 24 Jan 2022 19:41:55 +0100
Message-Id: <20220124183927.749639988@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
index b1757895c4ad2..23bad44bb0850 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -500,9 +500,7 @@ static int __init cmtp_init(void)
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



