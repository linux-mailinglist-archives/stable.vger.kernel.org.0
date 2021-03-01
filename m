Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11888328788
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbhCARYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:24:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237741AbhCARUo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:20:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C63DE6505E;
        Mon,  1 Mar 2021 16:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617273;
        bh=LVJYJzYCHt8LMM75mc3z4G7uDAWBdRJ5QNQtzGSA9Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dX3VZI6UKji5yg2V44MGWqVDzZoJ/FOdn8qGNeo5Z8wewpFhn4kvmFnash5ttkmXs
         Qfp++/LHLDd00OTLsVvhv8Adk32zU39QoGMOUkCPXWebOu7eUdKBFwUfghh+ARrADh
         WvhCb4mK0buqgSQBfQdODNj0Prt5rKvMzylyLusY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christopher William Snowhill <chris@kode54.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/340] Bluetooth: Fix initializing response id after clearing struct
Date:   Mon,  1 Mar 2021 17:09:20 +0100
Message-Id: <20210301161049.112303062@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index da7fd7c8c2dc0..cc26e4c047ad0 100644
--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -381,9 +381,9 @@ static int a2mp_getampassoc_req(struct amp_mgr *mgr, struct sk_buff *skb,
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



