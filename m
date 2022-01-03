Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6480248326C
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbiACO1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:27:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57366 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiACO0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:26:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A2606113A;
        Mon,  3 Jan 2022 14:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA2EC36AED;
        Mon,  3 Jan 2022 14:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220007;
        bh=meaVt6qxs1Pw8r6eqm0M+H25XV8Bj1eq9wBfuKdhyr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQhGHHcAs5e3dXTbUKAltLJGEKblC2vtn7QioF7t+r/v//zlOlhNYV5mnV4Em12/t
         YBXFHG1n4wD18XsLOQo9jwggCnzJbjtYzgSboWasXgIeksYU/dzrLmjigoy4Q0Y/nX
         8lyEyRAJToO72NfKO+h6Bp3BW4LpeKWLXwIanUSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/37] ionic: Initialize the lif->dbid_inuse bitmap
Date:   Mon,  3 Jan 2022 15:23:57 +0100
Message-Id: <20220103142052.471530511@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 140c7bc7d1195750342ea0e6ab76179499ae7cd7 ]

When allocated, this bitmap is not initialized. Only the first bit is set a
few lines below.

Use bitmap_zalloc() to make sure that it is cleared before being used.

Fixes: 6461b446f2a0 ("ionic: Add interrupts and doorbells")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Link: https://lore.kernel.org/r/6a478eae0b5e6c63774e1f0ddb1a3f8c38fa8ade.1640527506.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 99ba3551458fc..f9c303d76658a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1995,7 +1995,7 @@ static int ionic_lif_init(struct ionic_lif *lif)
 		return -EINVAL;
 	}
 
-	lif->dbid_inuse = bitmap_alloc(lif->dbid_count, GFP_KERNEL);
+	lif->dbid_inuse = bitmap_zalloc(lif->dbid_count, GFP_KERNEL);
 	if (!lif->dbid_inuse) {
 		dev_err(dev, "Failed alloc doorbell id bitmap, aborting\n");
 		return -ENOMEM;
-- 
2.34.1



