Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06CD32840B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhCAQ2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233298AbhCAQYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:24:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F37B64E6B;
        Mon,  1 Mar 2021 16:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615652;
        bh=GuFZUTlsmQ05FkrB4261N8Wq4tDh1IRG/jfj/9sL4lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wBX6JeeU0RnpNtEtcURAnU56XfrdzAE99oRp+2duLUU848s9T0W2NqTElI2zNHXp
         akreC1eSy/cTUaSu4trq+MS8ZFq/cSiEKuN/27vQz6/Or8YTPmvY3tgDlE9i02nQ4K
         VQD1gl91am6g6AgAUd9gzQqf6Tsr21UsnXQPYQ/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christopher William Snowhill <chris@kode54.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 013/134] Bluetooth: Fix initializing response id after clearing struct
Date:   Mon,  1 Mar 2021 17:11:54 +0100
Message-Id: <20210301161014.227314662@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christopher William Snowhill <chris@kode54.net>

[ Upstream commit a5687c644015a097304a2e47476c0ecab2065734 ]

Looks like this was missed when patching the source to clear the structures
throughout, causing this one instance to clear the struct after the response
id is assigned.

Fixes: eddb7732119d ("Bluetooth: A2MP: Fix not initializing all members")
Signed-off-by: Christopher William Snowhill <chris@kode54.net>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/a2mp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/a2mp.c b/net/bluetooth/a2mp.c
index 8f918155685db..242ef2abd0911 100644
--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -388,9 +388,9 @@ static int a2mp_getampassoc_req(struct amp_mgr *mgr, struct sk_buff *skb,
 	hdev = hci_dev_get(req->id);
 	if (!hdev || hdev->amp_type == AMP_TYPE_BREDR || tmp) {
 		struct a2mp_amp_assoc_rsp rsp;
-		rsp.id = req->id;
 
 		memset(&rsp, 0, sizeof(rsp));
+		rsp.id = req->id;
 
 		if (tmp) {
 			rsp.status = A2MP_STATUS_COLLISION_OCCURED;
-- 
2.27.0



