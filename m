Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC229F7CEB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbfKKSvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:51:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730378AbfKKSvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:51:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96825222C1;
        Mon, 11 Nov 2019 18:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498271;
        bh=adpq1GeiD4Ew3QlqO1RCEkWdEP6zfS3FL2ey0sj1iRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7q81zx/e3YL/5hJxSooUn1yUNDqE7TPmEon7dAoOW6Ae90g6OluLdRAXOTvNH9k8
         ThMDt50801c7Xc+R0kr/GiCAjauXkkb+mBzQRRif407gHFGS40kUo1wAt3NlP7iS0c
         6AkYToQl06kr5jzBB+xtSNODMbc3LgFk4+U6jJs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 022/193] net/smc: fix ethernet interface refcounting
Date:   Mon, 11 Nov 2019 19:26:44 +0100
Message-Id: <20191111181501.851467676@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit 98f3375505b8d6517bd6710bc6d4f6289eeb30aa ]

If a pnet table entry is to be added mentioning a valid ethernet
interface, but an invalid infiniband or ISM device, the dev_put()
operation for the ethernet interface is called twice, resulting
in a negative refcount for the ethernet interface, which disables
removal of such a network interface.

This patch removes one of the dev_put() calls.

Fixes: 890a2cb4a966 ("net/smc: rework pnet table")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_pnet.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -376,8 +376,6 @@ static int smc_pnet_fill_entry(struct ne
 	return 0;
 
 error:
-	if (pnetelem->ndev)
-		dev_put(pnetelem->ndev);
 	return rc;
 }
 


