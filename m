Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF2B38A95D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbhETLBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239335AbhETK7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9504361D00;
        Thu, 20 May 2021 10:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504972;
        bh=CjuAzQW9FYvydYL6RLKGhIB4LWUs9CAKBq9pQV1X8MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bs0XfIuuKwZbt+oymw1NTrN5jxr6isscuR/QT2DDjmaJ1EsX4YeBlTfM9y9d8Agmu
         xAQ+vTXTvqo0AcM7nfLgp0R8N13RhwOfQk6RXkQ25Sh5Ru3q1PZcwDPQArkfOodsno
         RkGd+IZjzsHEA99VkPISXMMpRsShNtuk19WJr+l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 164/240] net:nfc:digital: Fix a double free in digital_tg_recv_dep_req
Date:   Thu, 20 May 2021 11:22:36 +0200
Message-Id: <20210520092114.157127912@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index f864ce19e13d..582f97d035ef 100644
--- a/net/nfc/digital_dep.c
+++ b/net/nfc/digital_dep.c
@@ -1289,6 +1289,8 @@ static void digital_tg_recv_dep_req(struct nfc_digital_dev *ddev, void *arg,
 	}
 
 	rc = nfc_tm_data_received(ddev->nfc_dev, resp);
+	if (rc)
+		resp = NULL;
 
 exit:
 	kfree_skb(ddev->chaining_skb);
-- 
2.30.2



