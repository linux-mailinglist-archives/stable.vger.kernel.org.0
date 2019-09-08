Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7826CACCDE
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfIHMnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729431AbfIHMnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:43:20 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A7A218AF;
        Sun,  8 Sep 2019 12:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946599;
        bh=mvzyqS+I5lfi/NFsoStqyrXMLbFW+sd2sHHzUZmUHNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAFss99gClM/2ubjh2FEyCZpGtLLLFj1QAmN9tXizbj4nfnH1Z2VLW6i+BReRAJrS
         NjEBNCNSW/D8S0K5rmnH3VY2cjGDjytKeqkLQdX/LM/XmMYFLJhLvJXqXgSvywpjyb
         cBAC52BRMr+fjBeAusP6n+qpHfjS3LZILKt5O0mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 07/23] net: myri10ge: fix memory leaks
Date:   Sun,  8 Sep 2019 13:41:42 +0100
Message-Id: <20190908121056.307391534@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121052.898169328@linuxfoundation.org>
References: <20190908121052.898169328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 20fb7c7a39b5c719e2e619673b5f5729ee7d2306 ]

In myri10ge_probe(), myri10ge_alloc_slices() is invoked to allocate slices
related structures. Later on, myri10ge_request_irq() is used to get an irq.
However, if this process fails, the allocated slices related structures are
not deallocated, leading to memory leaks. To fix this issue, revise the
target label of the goto statement to 'abort_with_slices'.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 83651ac8ddb9d..8ebf3611aba3c 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -4114,7 +4114,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * setup (if available). */
 	status = myri10ge_request_irq(mgp);
 	if (status != 0)
-		goto abort_with_firmware;
+		goto abort_with_slices;
 	myri10ge_free_irq(mgp);
 
 	/* Save configuration space to be restored if the
-- 
2.20.1



