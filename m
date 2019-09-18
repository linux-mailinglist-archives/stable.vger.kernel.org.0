Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67233B68FA
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 19:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfIRRVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 13:21:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46688 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfIRRVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 13:21:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id a3so198329pgm.13
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 10:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4LdTXDWq3Uv3L2zd/NR5TCqm7My244nHQo+ObnVgt58=;
        b=FqHH+Zoiq7lEG9/x/GOxUNp3JykuQnt4TdgW49TajHQUWWepwS/HhcutIkbTc4TJAE
         4AbCZ075/oyErat+7EzcRPMlsw1Tuq9+zLj1jiNvm389RDdDz4BbUTjHMYxbPadBeIZd
         AfR111JYfHvEOUFNCxRc/7NN+KyNPcw+NrlNkitfevmCkybcHhr2WyKWdy+/J5Y1xEmJ
         YXOY/2Fv3axFRAGi7dDcS61Kn2TdKu0obx78TJWYSkFLNgkRUdQTZALdXujWzPCdwZxh
         8gtu1fggCs8ry8ZHBOmL1OBKnHT0DeyHLfNo2xrbWmSNpmpBpNvQAWqNPcCc0rRu1qrO
         xA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4LdTXDWq3Uv3L2zd/NR5TCqm7My244nHQo+ObnVgt58=;
        b=Pj/f06zm8jxy3CF9xJ1VcIkFIMdBMfLuCygh5T3v+E2aVgeXnEvMLDfr8drQH5eaVq
         2MEksuA/W68iSDkWgGHzeaAUOPMViD8LWkt6bIp066dqPoxLbjSjKIC5vF/7iFjRABox
         iltknZMc+28wQjkGNkjshyhOQgELRr0YRDjrGo6h4Geol+qNeQUvu5Fabnk7n6wPPvKx
         ymlk0Vi7hxCujHhWn+m6mhUvbDb2hS7jl4f89r4ikcJnDm6bd4PYzhMCZHGQ95G6XFQW
         adpyUogW8gEH/UAwXhyfxmiMaS8wGBpHjR2mXVo6in4mxbOchK1eu8Od/5RIvi7O2yiP
         I3mA==
X-Gm-Message-State: APjAAAWDmDWz4ubDGfOhrEf/mShuASU1eVCHRMdfwbYXjws8bLy/Gfaz
        xfrYM29hROIKkPs08FcSUXj0Dw==
X-Google-Smtp-Source: APXvYqwNoFVjaPm3eL6jMcaK8G2c8PabKi7HOM0JHnfEaNT+uqzgU9EB16AZzHifjaoL4rpVj6VvPw==
X-Received: by 2002:a62:ed17:: with SMTP id u23mr5387020pfh.147.1568827281215;
        Wed, 18 Sep 2019 10:21:21 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id g5sm6977032pfh.133.2019.09.18.10.21.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 10:21:20 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] net: qrtr: Stop rx_worker before freeing node
Date:   Wed, 18 Sep 2019 10:21:17 -0700
Message-Id: <20190918172117.4116-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As the endpoint is unregistered there might still be work pending to
handle incoming messages, which will result in a use after free
scenario. The plan is to remove the rx_worker, but until then (and for
stable@) ensure that the work is stopped before the node is freed.

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 net/qrtr/qrtr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 6c8b0f6d28f9..88f98f27ad88 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -150,6 +150,7 @@ static void __qrtr_node_release(struct kref *kref)
 	list_del(&node->item);
 	mutex_unlock(&qrtr_node_lock);
 
+	cancel_work_sync(&node->work);
 	skb_queue_purge(&node->rx_queue);
 	kfree(node);
 }
-- 
2.18.0

