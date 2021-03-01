Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D02032862F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhCARFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236292AbhCAQ6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:58:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53F8D64FE1;
        Mon,  1 Mar 2021 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616635;
        bh=2VnzAFN/fq4biR6xgtsn2hnLhJh6Ar0+Mlqs/05rGMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ee7qIv0PbK+VE1QYXPZphDsLrJkKHJBCmcVzM0W+mocY9uUzOb5JZy/OuyfPgVsZ6
         sqYhRXsiO8vJGU7YVXVSA7G5LJr5TcVi3JVv37fF4037NdFCVANzeCpcO90HFLyyWL
         k+FDIpGH+mlnOORoylR5unIHNF/k78PVaQAb4gAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/247] Bluetooth: drop HCI device reference before return
Date:   Mon,  1 Mar 2021 17:11:03 +0100
Message-Id: <20210301161033.779049039@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 5a3ef03afe7e12982dc3b978f4c5077c907f7501 ]

Call hci_dev_put() to decrement reference count of HCI device hdev if
fails to duplicate memory.

Fixes: 0b26ab9dce74 ("Bluetooth: AMP: Handle Accept phylink command status evt")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/a2mp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/a2mp.c b/net/bluetooth/a2mp.c
index 888813342cfc8..e09ea78356c36 100644
--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -519,6 +519,7 @@ static int a2mp_createphyslink_req(struct amp_mgr *mgr, struct sk_buff *skb,
 		assoc = kmemdup(req->amp_assoc, assoc_len, GFP_KERNEL);
 		if (!assoc) {
 			amp_ctrl_put(ctrl);
+			hci_dev_put(hdev);
 			return -ENOMEM;
 		}
 
-- 
2.27.0



