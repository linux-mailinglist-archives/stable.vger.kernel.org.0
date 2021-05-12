Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE82437C291
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhELPL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233618AbhELPJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:09:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC64A61482;
        Wed, 12 May 2021 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831755;
        bh=p45hPQ8O+fkxlTwd6Spr1cyrEqcooj8Jkabn2Ql+L7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6V8LjuLmjOG2C5nbhqT837iDqBgvzKcJ1yLNJa0h26NiMUTzF2D1R6n3d46M98yU
         9WkIQJ6ixeKkmqBHvi5MYbWhR5Mxe75CpImPy4/2e+UmSM+8NXNF/NfwJbNrRmZ0kg
         OjZpeapRchG+5IkkKrjpRlejXT76gLjv9Uflc+P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 235/244] net:nfc:digital: Fix a double free in digital_tg_recv_dep_req
Date:   Wed, 12 May 2021 16:50:06 +0200
Message-Id: <20210512144750.523890395@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 75258586793efc521e5dd52a5bf6c7a4cf7002be ]

In digital_tg_recv_dep_req, it calls nfc_tm_data_received(..,resp).
If nfc_tm_data_received() failed, the callee will free the resp via
kfree_skb() and return error. But in the exit branch, the resp
will be freed again.

My patch sets resp to NULL if nfc_tm_data_received() failed, to
avoid the double free.

Fixes: 1c7a4c24fbfd9 ("NFC Digital: Add target NFC-DEP support")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/digital_dep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/digital_dep.c b/net/nfc/digital_dep.c
index 65aaa9d7c813..bcd4d74e8a82 100644
--- a/net/nfc/digital_dep.c
+++ b/net/nfc/digital_dep.c
@@ -1276,6 +1276,8 @@ static void digital_tg_recv_dep_req(struct nfc_digital_dev *ddev, void *arg,
 	}
 
 	rc = nfc_tm_data_received(ddev->nfc_dev, resp);
+	if (rc)
+		resp = NULL;
 
 exit:
 	kfree_skb(ddev->chaining_skb);
-- 
2.30.2



