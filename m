Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F43A3E7EDA
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhHJRfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233075AbhHJRep (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C8B561008;
        Tue, 10 Aug 2021 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616863;
        bh=+Ylqh2w+jUyPQBTknZLn+olVeTM7vnAxXtLfAuFIaNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6Oe90+IV4hLGvYhKyiftJnWhXChmKFbUvO5IExWhLILe45BBoLC8Dsxg8hU3Tur/
         FTtu0CkcONHXwVq0oUxFHCa8LtVRuXV48xYn+pEqAoUfwlN2H8v1DhZhJmYXQ5IU2V
         Ddy3r3yI1975iMw9V4VTm9+nilfj1dQPmOvcAX0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xu <yinxu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/85] sctp: move the active_key update after sh_keys is added
Date:   Tue, 10 Aug 2021 19:29:59 +0200
Message-Id: <20210810172949.082960814@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
index 7eced1e523a5..3b2d0bd616dd 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -863,14 +863,18 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
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



