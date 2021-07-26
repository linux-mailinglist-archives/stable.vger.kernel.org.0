Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164DD3D5F65
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbhGZPRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236760AbhGZPPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4809960F9C;
        Mon, 26 Jul 2021 15:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314772;
        bh=xzxagQdLtR+w7t1dWXM9THl7GLFCequ8Q4x6p+iW+mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ad9JleIiWru2RK3sjoVJyOiOl0kZUvAyx6/u2MZ3gpCFfEvMypUBtDSFdd184M8m+
         vQPnqXQN597RlKM3h2W5zz7aUm6kcJrfb1qw4in3Lvwgkkr7OxxGcefZo/RDneyZa4
         Gr1+jqjCEnr0Xu22k0c75DOeOywG1iqluhPgFtZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b774577370208727d12b@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/120] sctp: update active_key for asoc when old key is being replaced
Date:   Mon, 26 Jul 2021 17:38:58 +0200
Message-Id: <20210726153835.145528741@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 58acd10092268831e49de279446c314727101292 ]

syzbot reported a call trace:

  BUG: KASAN: use-after-free in sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
  Call Trace:
   sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
   sctp_set_owner_w net/sctp/socket.c:131 [inline]
   sctp_sendmsg_to_asoc+0x152e/0x2180 net/sctp/socket.c:1865
   sctp_sendmsg+0x103b/0x1d30 net/sctp/socket.c:2027
   inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
   sock_sendmsg_nosec net/socket.c:703 [inline]
   sock_sendmsg+0xcf/0x120 net/socket.c:723

This is an use-after-free issue caused by not updating asoc->shkey after
it was replaced in the key list asoc->endpoint_shared_keys, and the old
key was freed.

This patch is to fix by also updating active_key for asoc when old key is
being replaced with a new one. Note that this issue doesn't exist in
sctp_auth_del_key_id(), as it's not allowed to delete the active_key
from the asoc.

Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
Reported-by: syzbot+b774577370208727d12b@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/auth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 2bd8c80bd85f..b2ca66c4a21d 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -883,6 +883,8 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	if (replace) {
 		list_del_init(&shkey->key_list);
 		sctp_auth_shkey_release(shkey);
+		if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
+			sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
 	}
 	list_add(&cur_key->key_list, sh_keys);
 
-- 
2.30.2



