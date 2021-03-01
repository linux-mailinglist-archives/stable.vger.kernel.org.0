Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B71328632
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhCARF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235681AbhCAQ7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:59:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B05B564FE3;
        Mon,  1 Mar 2021 16:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616638;
        bh=5COGKQzqNg1ljGpM7SbGpPQ1mjsAY9IQdisCKOmFDlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBKawYbTdzmsboXdUUv5CczBtVJeEBaFtGE0K0yGIlc+2od1UbPKXwdb/0TP4u0/s
         eJyYcwLzqK1Ism/1GHut4L7837Bun0HCxHtgMj3PHTmJaexn7blLh9DZN/goyMEOI5
         GOgUgjv5DMuSc6M0Duts87izyQ1u61nYtrfLHQOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christopher William Snowhill <chris@kode54.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/247] Bluetooth: Fix initializing response id after clearing struct
Date:   Mon,  1 Mar 2021 17:10:46 +0100
Message-Id: <20210301161032.977024558@linuxfoundation.org>
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
index be9640e9ca006..888813342cfc8 100644
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



