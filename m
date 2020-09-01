Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDDF25964D
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731814AbgIAQA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgIAQAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 12:00:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADAC8206A5;
        Tue,  1 Sep 2020 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598976029;
        bh=s0ggdQsQRTUXjPSnRMT/mKNOR2wQJ4J6Duk4z7ey7AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsvPncwcm3jI4EyLvjTW2QYsiyRTjLAqhWxlaD5W8JvYgCi+YpBHV6e2y1ScXX5Jm
         glJwFJaqKkOAZqLBmYp47x/+Fw3dRw3DuBqG059ynwh1Rm7kzFKw2fOKLZAbhR2Fhc
         hpbCIbUZFSpe1Z3+trSxJQYSXHZWqlsIX+5gYXBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 103/255] vdpa: ifcvf: free config irq in ifcvf_free_irq()
Date:   Tue,  1 Sep 2020 17:09:19 +0200
Message-Id: <20200901151005.649123147@linuxfoundation.org>
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

[ Upstream commit 2b9f28d5e8efad34f472542315911c5ee9a65b6c ]

We don't free config irq in ifcvf_free_irq() which will trigger a
BUG() in pci core since we try to free the vectors that has an
action. Fixing this by recording the config irq in ifcvf_hw structure
and free it in ifcvf_free_irq().

Fixes: e7991f376a4d ("ifcvf: implement config interrupt in IFCVF")
Cc: Zhu Lingshan <lingshan.zhu@intel.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20200723091254.20617-2-jasowang@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Zhu Lingshan <lingshan.zhu@intel.com>
Fixes: e7991f376a4d ("ifcvf: implement config interrupt in IFCVF")
Cc: Zhu Lingshan <a class="moz-txt-link-rfc2396E" href="mailto:lingshan.zhu@intel.com">&lt;lingshan.zhu@intel.com&gt;</a>
Signed-off-by: Jason Wang <a class="moz-txt-link-rfc2396E" href="mailto:jasowang@redhat.com">&lt;jasowang@redhat.com&gt;</a>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_base.h | 2 +-
 drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index f4554412e607f..29efa75cdfce5 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -84,7 +84,7 @@ struct ifcvf_hw {
 	void __iomem * const *base;
 	char config_msix_name[256];
 	struct vdpa_callback config_cb;
-
+	unsigned int config_irq;
 };
 
 struct ifcvf_adapter {
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ae7110955a44d..7a6d899e541df 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -53,6 +53,7 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
 	for (i = 0; i < queues; i++)
 		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
 
+	devm_free_irq(&pdev->dev, vf->config_irq, vf);
 	ifcvf_free_irq_vectors(pdev);
 }
 
@@ -72,8 +73,8 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
 		 pci_name(pdev));
 	vector = 0;
-	irq = pci_irq_vector(pdev, vector);
-	ret = devm_request_irq(&pdev->dev, irq,
+	vf->config_irq = pci_irq_vector(pdev, vector);
+	ret = devm_request_irq(&pdev->dev, vf->config_irq,
 			       ifcvf_config_changed, 0,
 			       vf->config_msix_name, vf);
 	if (ret) {
-- 
2.25.1



