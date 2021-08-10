Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3473E7E82
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhHJRdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhHJRdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3AF860F13;
        Tue, 10 Aug 2021 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616782;
        bh=nrCmIb4AruyukeULlliE3orbEI85qOJB3L9iiqPuQ4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAlA0Gk/3MPjTPt96porWn7twO2hMuNXkOZuevPSbUuX3TmigAnKi5norqD2uAhRl
         53LbSyOCA2qqFpp0Z5y7+EB7KBleUQdUmDTw+VPImvLxZvR2O0yJ3EvdFHPD12GiMt
         WMcWVai31m4ewabgVbvl9u03cImLrbkM+2lX7j+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xu <yinxu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/54] sctp: move the active_key update after sh_keys is added
Date:   Tue, 10 Aug 2021 19:30:05 +0200
Message-Id: <20210810172944.557219837@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit ae954bbc451d267f7d60d7b49db811d5a68ebd7b ]

In commit 58acd1009226 ("sctp: update active_key for asoc when old key is
being replaced"), sctp_auth_asoc_init_active_key() is called to update
the active_key right after the old key is deleted and before the new key
is added, and it caused that the active_key could be found with the key_id.

In Ying Xu's testing, the BUG_ON in sctp_auth_asoc_init_active_key() was
triggered:

  [ ] kernel BUG at net/sctp/auth.c:416!
  [ ] RIP: 0010:sctp_auth_asoc_init_active_key.part.8+0xe7/0xf0 [sctp]
  [ ] Call Trace:
  [ ]  sctp_auth_set_key+0x16d/0x1b0 [sctp]
  [ ]  sctp_setsockopt.part.33+0x1ba9/0x2bd0 [sctp]
  [ ]  __sys_setsockopt+0xd6/0x1d0
  [ ]  __x64_sys_setsockopt+0x20/0x30
  [ ]  do_syscall_64+0x5b/0x1a0

So fix it by moving the active_key update after sh_keys is added.

Fixes: 58acd1009226 ("sctp: update active_key for asoc when old key is being replaced")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/auth.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index b2ca66c4a21d..9e0c98df20da 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -880,14 +880,18 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	memcpy(key->data, &auth_key->sca_key[0], auth_key->sca_keylength);
 	cur_key->key = key;
 
-	if (replace) {
-		list_del_init(&shkey->key_list);
-		sctp_auth_shkey_release(shkey);
-		if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
-			sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+	if (!replace) {
+		list_add(&cur_key->key_list, sh_keys);
+		return 0;
 	}
+
+	list_del_init(&shkey->key_list);
+	sctp_auth_shkey_release(shkey);
 	list_add(&cur_key->key_list, sh_keys);
 
+	if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
+		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+
 	return 0;
 }
 
-- 
2.30.2



