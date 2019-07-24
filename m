Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F93273A8B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391636AbfGXTvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391357AbfGXTvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:51:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F6B21873;
        Wed, 24 Jul 2019 19:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997876;
        bh=uq21gVyXFcPi9M0qRBxB/Da7t/O8Rt04ItZp9tsO6ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcjpMSBEnA6EIMxSImfwA6SfwmRUMbTFYrxy4zeGSrJJ3yvCFVQevwOHfYWZ4wVr8
         6q46NY6E1Ax3y0vRKK6fKlFXvHS8DZ1eXsN17q0VCJSxOHc0ufz3iXi4EiNnQZQHWt
         1Mdi6baNgeDXmEE+c6hgO9iPjw/QScLB7jmcUCNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dundi Raviteja <dundi@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 175/371] ath10k: Fix memory leak in qmi
Date:   Wed, 24 Jul 2019 21:18:47 +0200
Message-Id: <20190724191738.402072687@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c709df58832c5f575f0255bea4b09ad477fc62ea ]

Currently the memory allocated for qmi handle is
not being freed during de-init which leads to memory leak.

Free the allocated qmi memory in qmi deinit
to avoid memory leak.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Fixes: fda6fee0001e ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Dundi Raviteja <dundi@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index a7bc2c70d076..8f8f717a23ee 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -1002,6 +1002,7 @@ int ath10k_qmi_deinit(struct ath10k *ar)
 	qmi_handle_release(&qmi->qmi_hdl);
 	cancel_work_sync(&qmi->event_work);
 	destroy_workqueue(qmi->event_wq);
+	kfree(qmi);
 	ar_snoc->qmi = NULL;
 
 	return 0;
-- 
2.20.1



