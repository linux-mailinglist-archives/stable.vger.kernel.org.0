Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB7028B836
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389613AbgJLNuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731918AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 744772076E;
        Mon, 12 Oct 2020 13:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510493;
        bh=3mnmW4Kn3WSOaWuJNFlbQfs1FOqdw20rPVotspi8Mw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9aAN3F1PIv+7Qexw5FtZALUGcGvuR7sZXVRlcopttujhQFuiRQmnqVOpATuk1Yzx
         s1zB3fKEOTjCERLQMoyRvoHV5q+cQ53Rb4n55gbWz2ql0etG+YikizNb9uQlYCPMOX
         gvXgYHl48Md21S4dUoqsFNJ6jZhRuBtKsmb6f4Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 116/124] net: bridge: fdb: dont flush ext_learn entries
Date:   Mon, 12 Oct 2020 15:32:00 +0200
Message-Id: <20201012133152.464287592@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit f2f3729fb65c5c2e6db234e6316b71a7bdc4b30b upstream.

When a user-space software manages fdb entries externally it should
set the ext_learn flag which marks the fdb entry as externally managed
and avoids expiring it (they're treated as static fdbs). Unfortunately
on events where fdb entries are flushed (STP down, netlink fdb flush
etc) these fdbs are also deleted automatically by the bridge. That in turn
causes trouble for the managing user-space software (e.g. in MLAG setups
we lose remote fdb entries on port flaps).
These entries are completely externally managed so we should avoid
automatically deleting them, the only exception are offloaded entries
(i.e. BR_FDB_ADDED_BY_EXT_LEARN + BR_FDB_OFFLOADED). They are flushed as
before.

Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entries from user-space")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bridge/br_fdb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -404,6 +404,8 @@ void br_fdb_delete_by_port(struct net_br
 
 		if (!do_all)
 			if (test_bit(BR_FDB_STATIC, &f->flags) ||
+			    (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags) &&
+			     !test_bit(BR_FDB_OFFLOADED, &f->flags)) ||
 			    (vid && f->key.vlan_id != vid))
 				continue;
 


