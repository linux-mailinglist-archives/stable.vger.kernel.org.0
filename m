Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828F83D5F9A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhGZPSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236782AbhGZPPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD3D760F6F;
        Mon, 26 Jul 2021 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314774;
        bh=AulFh4I2Hm8Bs9NgA0mwj5X+FjZOIoMOYIf1DoMM9Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bss6J83mNlMtRAG9MDgBNfU2/QMWv3paGujeBq5gl5vxBHWHXHC2knv3PMlj8PvIu
         mi7mPYGbaw0pAMC4BCE1Mjuu4px1qscaAEiygZurDtVWwuWQeJbHTGuTOE1NqqjASg
         ybIltx7APP2RSR+s3JxUj0rxF4UvP65Uu3SLpZRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/120] net: sched: cls_api: Fix the the wrong parameter
Date:   Mon, 26 Jul 2021 17:38:59 +0200
Message-Id: <20210726153835.178302180@linuxfoundation.org>
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

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 9d85a6f44bd5585761947f40f7821c9cd78a1bbe ]

The 4th parameter in tc_chain_notify() should be flags rather than seq.
Let's change it back correctly.

Fixes: 32a4f5ecd738 ("net: sched: introduce chain object to uapi")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 184c20b86393..4413aa8d4e82 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1918,7 +1918,7 @@ replay:
 		break;
 	case RTM_GETCHAIN:
 		err = tc_chain_notify(chain, skb, n->nlmsg_seq,
-				      n->nlmsg_seq, n->nlmsg_type, true);
+				      n->nlmsg_flags, n->nlmsg_type, true);
 		if (err < 0)
 			NL_SET_ERR_MSG(extack, "Failed to send chain notify message");
 		break;
-- 
2.30.2



