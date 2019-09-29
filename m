Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA57C14F8
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbfI2N7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729749AbfI2N7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:59:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19721218DE;
        Sun, 29 Sep 2019 13:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765573;
        bh=zFfIRNrFFWQsyWj5Acfi8RAu9h6ayl9Cm3Zjp8HSquE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP/0/cUGaxmruoW7dRKGNp8K9vET1VQ271SUbJIy//DoZGrs6ZF7f4cysFkfh2e+q
         LlDIbee8TsqiPZN9LUjLgmYy8C7gIcz3Ko02+R+kdR24U+ISI73xYXg9YBGrbo6uJH
         nTDqhh29w45ckSfDqO3lcdZbKMdL4mv802vV74vE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Juliet Kim <julietk@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/63] net/ibmvnic: Fix missing { in __ibmvnic_reset
Date:   Sun, 29 Sep 2019 15:54:25 +0200
Message-Id: <20190929135040.332831606@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
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
index f232943c818bf..aa067a7a72d40 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1999,7 +1999,7 @@ static void __ibmvnic_reset(struct work_struct *work)
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



