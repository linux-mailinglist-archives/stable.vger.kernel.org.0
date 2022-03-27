Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC4A4E868E
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 09:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbiC0Hha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 03:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbiC0Hh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 03:37:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FA9332;
        Sun, 27 Mar 2022 00:35:51 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gp15-20020a17090adf0f00b001c7cd11b0b3so7078473pjb.3;
        Sun, 27 Mar 2022 00:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=oaebWp7D4MUHyUoKIoLJFY0JU1VM1fmEvn6foPTILTU=;
        b=YP8NjTil7KxUY2HdoecalzqQudxUazTfY9nAqX2x9gevt6A3hVNNfV08HFxhIHo6aT
         tK8wsWyJIOyFjGb/AvqW6rLBibfMxmA1NuJT9wRH5akisYc2N4lI9iWV2GG7N/LapLJ0
         h6236p4SEBx/g34O5e4Q3/jKvekGQnaSVAzJ5WHG4V8GEwBCA8ECtRAw/YCK/vR8eN2R
         acgjMPYa2gZpNCDf/NFQhywIEM9qc1Wn0HHT1hICA4/bHuJ2ZcGHwtpFFW4u+SFJQrXM
         tgTvjHN2IaBA1DloExSLyY9Uu/edsxl+iviXOFM+i27F7hrU9tBookJDS7U4T3piKSSn
         BBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oaebWp7D4MUHyUoKIoLJFY0JU1VM1fmEvn6foPTILTU=;
        b=KavbF8i7mBmzb4H3+UXp5K4ZRwz8+0aMVcJZoY32MRYYOgGSN/Emi6XtYoSMGWoBU6
         NXwXGqa7trxlDgn1HWDWyaXwrRKs+FBpGIJOyanVWy8YJSNXWfgN4sGSXCQREtCNmkZr
         X+jl3TNGGt1GyU7fB1pEcra708mAoMbMyA/q/+tvLMxEvdItZrxBj+2hSOlUqzHqMKtO
         DKm+CRHO3+gkgAYjIm5ueTfY9+zvX+NqyBBotitsqwkIDIMUlsUmiUq6DPicNDgXdPFZ
         zBZ/BW9FZtaeoIoqdUm+Fow1SsDs09BeE6ku8VqwJY8ODQt03u0dAAqvNk1eWqmvIKZX
         utwQ==
X-Gm-Message-State: AOAM533C7TA1lDlm7Hyb0SmqCiAraPUZTptO36Lof6REEaXZCImtziPF
        oav13pxe57naZ18XxP17uzkucrzFQRE=
X-Google-Smtp-Source: ABdhPJx8jGxn11aYa+VbaK2O4RxjTAaII9SFWLOEbyHrqX+r7PNpou4YYaA4n2rp3UFwNB3xPuRASQ==
X-Received: by 2002:a17:902:f78d:b0:14f:ce61:eaf2 with SMTP id q13-20020a170902f78d00b0014fce61eaf2mr20472668pln.124.1648366550608;
        Sun, 27 Mar 2022 00:35:50 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id w9-20020a056a0014c900b004fb2ca5f6d7sm4189936pfu.136.2022.03.27.00.35.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 00:35:50 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     bharat@chelsio.com, jgg@ziepe.ca
Cc:     vipul@chelsio.com, roland@purestorage.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] cxgb4: cm: fix a incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 15:35:42 +0800
Message-Id: <20220327073542.10990-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	if (!pdev) {

The list iterator value 'pdev' will *always* be set and non-NULL
by for_each_netdev(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
found (in this case, the check 'if (!pdev)' can be bypassed as
it always be false unexpectly).

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'pdev' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 830662f6f032f ("RDMA/cxgb4: Add support for active and passive open connection with IPv6 address")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c16017f6e8db..870d8517310b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2071,7 +2071,7 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
 {
 	struct neighbour *n;
 	int err, step;
-	struct net_device *pdev;
+	struct net_device *pdev = NULL, *iter;
 
 	n = dst_neigh_lookup(dst, peer_ip);
 	if (!n)
@@ -2083,14 +2083,14 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
 		if (iptype == 4)
 			pdev = ip_dev_find(&init_net, *(__be32 *)peer_ip);
 		else if (IS_ENABLED(CONFIG_IPV6))
-			for_each_netdev(&init_net, pdev) {
+			for_each_netdev(&init_net, iter) {
 				if (ipv6_chk_addr(&init_net,
 						  (struct in6_addr *)peer_ip,
-						  pdev, 1))
+						  iter, 1)) {
+					pdev = iter;
 					break;
+				}
 			}
-		else
-			pdev = NULL;
 
 		if (!pdev) {
 			err = -ENODEV;
-- 
2.17.1

