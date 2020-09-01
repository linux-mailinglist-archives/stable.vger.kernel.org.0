Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08012259645
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbgIAQAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgIAQAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 12:00:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51531207D3;
        Tue,  1 Sep 2020 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598976026;
        bh=ueGUDcVtF+Xvrd4bBbg/KL6B43dN5ke2eP7sHPNQdkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZCedX2ZYMDs8Vu7DhCspYukgrvCjJIMo9++cEkMPiFaZLeDnutaGCtnFg4mQZdiv
         9msTAAk7H9Eg+7hbK4FkHbcsFwpFev70TIV9IKfXzral/StRLH4qnkh3PvJRwYxD8D
         VI6cXpBWiZgpK+Qme3i9cwB2X7lh4GvJPphZ2e+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 102/255] vdpa: ifcvf: return err when fail to request config irq
Date:   Tue,  1 Sep 2020 17:09:18 +0200
Message-Id: <20200901151005.601082207@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 9f4ce5d72b8e7a1f750598407c99f9e39dfb12fc ]

We ignore the err of requesting config interrupt, fix this.

Fixes: e7991f376a4d ("ifcvf: implement config interrupt in IFCVF")
Cc: Zhu Lingshan <lingshan.zhu@intel.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20200723091254.20617-1-jasowang@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Zhu Lingshan <lingshan.zhu@intel.com>
Fixes: e7991f376a4d ("ifcvf: implement config interrupt in IFCVF")
Cc: Zhu Lingshan <a class="moz-txt-link-rfc2396E" href="mailto:lingshan.zhu@intel.com">&lt;lingshan.zhu@intel.com&gt;</a>
Signed-off-by: Jason Wang <a class="moz-txt-link-rfc2396E" href="mailto:jasowang@redhat.com">&lt;jasowang@redhat.com&gt;</a>
Tested-by: Maxime Coquelin <maxime.coquelin@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index f5a60c14b9799..ae7110955a44d 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -76,6 +76,10 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 	ret = devm_request_irq(&pdev->dev, irq,
 			       ifcvf_config_changed, 0,
 			       vf->config_msix_name, vf);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to request config irq\n");
+		return ret;
+	}
 
 	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
 		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
-- 
2.25.1



