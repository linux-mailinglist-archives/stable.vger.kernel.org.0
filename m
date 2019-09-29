Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE847C1597
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbfI2OBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbfI2OBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:01:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B562F21835;
        Sun, 29 Sep 2019 14:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765695;
        bh=qeigDGnQEqbq7eKGlPKF8Jz+DU+1KB141CmTPZDrkkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faFQdXr1Yl0VbiIJIZQ0788Ago7qto/7W2+uCJS4EQfQbR8dMF6sFqkuWQt7yNQYF
         Fv8e2p/hhriIGgYT34H5ZZ4KB2koP+WV/sTRZu+AC/Wi/2698QdA/ZJ55K72CXFmpl
         LIPLVJIL6+vO1HpRpF0dRdGVFyubKWx54wN02ZDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Juliet Kim <julietk@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 32/45] net/ibmvnic: Fix missing { in __ibmvnic_reset
Date:   Sun, 29 Sep 2019 15:56:00 +0200
Message-Id: <20190929135032.225036483@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit c8dc55956b09b53ccffceb6e3146981210e27821 ]

Commit 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
adds a } without corresponding { causing build break.

Fixes: 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Juliet Kim <julietk@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 6644cabc8e756..5cb55ea671e35 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1984,7 +1984,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
 		if (adapter->state == VNIC_REMOVING ||
-		    adapter->state == VNIC_REMOVED)
+		    adapter->state == VNIC_REMOVED) {
 			kfree(rwi);
 			rc = EBUSY;
 			break;
-- 
2.20.1



