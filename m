Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A6037CF24
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhELRJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244562AbhELQuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AED7A61480;
        Wed, 12 May 2021 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836221;
        bh=FsZeAw//v92LkymATobB55lFSC3pvMf3ZkZlTCPDhY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gW6E3t/ymKg/tqJmG4Jlz38UAsS26xlUQW/PtidZTEQY/vhyUjm/jXCGKXyo5blUi
         tzabReoVS9D6hI2ekJsVVpAQIM3z0hzhd8gw9M73s3GRA3pyvPIypCs77aSUr/b7B6
         mWozHYNXGl36gpq1+xNLPCwXvxOBrEwBsFjnisrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 659/677] net:nfc:digital: Fix a double free in digital_tg_recv_dep_req
Date:   Wed, 12 May 2021 16:51:45 +0200
Message-Id: <20210512144859.261996356@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 5971fb6f51cc..dc21b4141b0a 100644
--- a/net/nfc/digital_dep.c
+++ b/net/nfc/digital_dep.c
@@ -1273,6 +1273,8 @@ static void digital_tg_recv_dep_req(struct nfc_digital_dev *ddev, void *arg,
 	}
 
 	rc = nfc_tm_data_received(ddev->nfc_dev, resp);
+	if (rc)
+		resp = NULL;
 
 exit:
 	kfree_skb(ddev->chaining_skb);
-- 
2.30.2



