Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A23A619B1C0
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388746AbgDAQhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389009AbgDAQhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:37:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2A1212CC;
        Wed,  1 Apr 2020 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759066;
        bh=tmjogg9yI+Opax21DufBCCunzR9HJWzo5dAUBKQVx3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqoPXYLutnEx4H+3tTW7sm6Tvn5+/T6iuvKZMcgNdGnOe0Q+K+nPtOCMMoNLim2EX
         1FeMBK1b1OgAh1JxqOfkeXOQ8nNNgoeB13EBRoYjWlE9Busb3WKtoDsNPo6cmL3Vn+
         mbCymu5aYos0mChyS2MVLEoUxwUtFhhO/YJQHKLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.9 066/102] xfrm: fix uctx len check in verify_sec_ctx_len
Date:   Wed,  1 Apr 2020 18:18:09 +0200
Message-Id: <20200401161543.863244296@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 171d449a028573b2f0acdc7f31ecbb045391b320 upstream.

It's not sufficient to do 'uctx->len != (sizeof(struct xfrm_user_sec_ctx) +
uctx->ctx_len)' check only, as uctx->len may be greater than nla_len(rt),
in which case it will cause slab-out-of-bounds when accessing uctx->ctx_str
later.

This patch is to fix it by return -EINVAL when uctx->len > nla_len(rt).

Fixes: df71837d5024 ("[LSM-IPSec]: Security association restriction.")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_user.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -109,7 +109,8 @@ static inline int verify_sec_ctx_len(str
 		return 0;
 
 	uctx = nla_data(rt);
-	if (uctx->len != (sizeof(struct xfrm_user_sec_ctx) + uctx->ctx_len))
+	if (uctx->len > nla_len(rt) ||
+	    uctx->len != (sizeof(struct xfrm_user_sec_ctx) + uctx->ctx_len))
 		return -EINVAL;
 
 	return 0;


