Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804CC328F4F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242351AbhCATsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241726AbhCATix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B01465162;
        Mon,  1 Mar 2021 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618362;
        bh=RrI+sEIYk/NjwARn75vURPzpz5FjfpmTHNColCYARbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UN+Bw407g8VBhNlvwWhnjEh3aNWl1VX7GGkFcabtt8t7h/fOsdxoSWBbmGxz0HIV9
         A1tQ3qPmGZNUboXH1c7b3++53CSBC2P8WMKIygEqf3/VHaRm6IL7LpT0CTxyD/pBDa
         Gp1mz49yZVGsCBL29gjEv9XEPhRo9r1KB0lTjowg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/663] Bluetooth: drop HCI device reference before return
Date:   Mon,  1 Mar 2021 17:05:07 +0100
Message-Id: <20210301161144.653584399@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index cc26e4c047ad0..463bad58478b2 100644
--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -512,6 +512,7 @@ static int a2mp_createphyslink_req(struct amp_mgr *mgr, struct sk_buff *skb,
 		assoc = kmemdup(req->amp_assoc, assoc_len, GFP_KERNEL);
 		if (!assoc) {
 			amp_ctrl_put(ctrl);
+			hci_dev_put(hdev);
 			return -ENOMEM;
 		}
 
-- 
2.27.0



