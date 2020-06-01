Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852471EAEF0
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgFAS6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728751AbgFAR64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:58:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DBF92074B;
        Mon,  1 Jun 2020 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034335;
        bh=JSlbU1kHIKYTSMDFJHwtn2d0rJQ+nYpbgprf3p8WLb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyXAqwkJU20xXgqFla7sTR6QBRh1dLVdwCbjjAaNKThIZl5X2QYbLR2PTVr/B3laX
         Qja+iZMTLMpkynT/AfR2kK4UMrj9hkcBIuTska3bJQCVdleH7e9iQLd9Ory41UWZZR
         UY/xjAsl6838uhc8ecbGLzV2T5hQd6WA4meKaWig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 07/61] net: qrtr: Fix passing invalid reference to qrtr_local_enqueue()
Date:   Mon,  1 Jun 2020 19:53:14 +0200
Message-Id: <20200601174012.779601264@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit d28ea1fbbf437054ef339afec241019f2c4e2bb6 ]

Once the traversal of the list is completed with list_for_each_entry(),
the iterator (node) will point to an invalid object. So passing this to
qrtr_local_enqueue() which is outside of the iterator block is erroneous
eventhough the object is not used.

So fix this by passing NULL to qrtr_local_enqueue().

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -571,7 +571,7 @@ static int qrtr_bcast_enqueue(struct qrt
 	}
 	mutex_unlock(&qrtr_node_lock);
 
-	qrtr_local_enqueue(node, skb);
+	qrtr_local_enqueue(NULL, skb);
 
 	return 0;
 }


