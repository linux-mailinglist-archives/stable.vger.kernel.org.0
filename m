Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE121F447F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733165AbgFISFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:05:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732714AbgFIRvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:51:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3702C20774;
        Tue,  9 Jun 2020 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725104;
        bh=YUQ3zE6gHknWLZQ8cWA+ZL/A4ox6L2Wm10Hf9XSjg5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuG3f/WgEjhhwoSvFLWEFenvf3xEE4H9UfUOJdxihMb6CULYzHGSyJpZfCOgvQb5C
         B2RHn60sXC3gkMbupcbDBp7ZdVndEy4BQg1hZXGu6eaHKJvO20tcU76QwszO0n4OBN
         BkdkmZI010O08pfryRlsn+chthxDlST9QU+hVoLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 05/25] NFC: st21nfca: add missed kfree_skb() in an error path
Date:   Tue,  9 Jun 2020 19:44:55 +0200
Message-Id: <20200609174049.232877910@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174048.576094775@linuxfoundation.org>
References: <20200609174048.576094775@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 3decabdc714ca56c944f4669b4cdec5c2c1cea23 ]

st21nfca_tm_send_atr_res() misses to call kfree_skb() in an error path.
Add the missed function call to fix it.

Fixes: 1892bf844ea0 ("NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/st21nfca/dep.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nfc/st21nfca/dep.c
+++ b/drivers/nfc/st21nfca/dep.c
@@ -184,8 +184,10 @@ static int st21nfca_tm_send_atr_res(stru
 		memcpy(atr_res->gbi, atr_req->gbi, gb_len);
 		r = nfc_set_remote_general_bytes(hdev->ndev, atr_res->gbi,
 						  gb_len);
-		if (r < 0)
+		if (r < 0) {
+			kfree_skb(skb);
 			return r;
+		}
 	}
 
 	info->dep_info.curr_nfc_dep_pni = 0;


