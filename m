Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A037B4E8645
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 08:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbiC0G0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 02:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiC0G0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 02:26:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDBA2B6;
        Sat, 26 Mar 2022 23:24:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gb19so11194529pjb.1;
        Sat, 26 Mar 2022 23:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=dr1pfWEjH/LtXsB7tWBt6bQIyc8GynNaruocx5UK+p4=;
        b=NrLU0Tud7dKyPrRn8FqNdKPZ7B+J9NM5tUooHHg3BkdUnZcMyXyEWggcERwvymf/D5
         NHttV+aFJg3cbs6CYTIPfr6oAxg1Uik0CQ5xkH6Pk8XYDOOtm0Sc+VPIDE8v5FIcDER4
         ujPKjNuz0Im4hQ5LXHN+57P1RWpXRdLtM3HNNeNaIr8RIulQStfCfLil2W2gN7rXDTfL
         qqFGTlabkl4FVmxP8AM/qfqWNnAshka/ZgPMYw974Yl1LonF47klbzkITdVK6S87SVZh
         pGxeGJHwamPBf0b9qkfcoMoMnpQTuRIIurLdpeOiEeyDEfQFSElvZxFP9ZNzo2CTM9mw
         yELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dr1pfWEjH/LtXsB7tWBt6bQIyc8GynNaruocx5UK+p4=;
        b=wRbHMkWSlgb9XGm9OLhLhivtyNvvoS3TnvaGCmNIU9b2OML0VlXYsx4LcOZGzZO6Gx
         vbjm9SLtLX/b9qxUPMvqbLPs0nQHyf3y/3DpdGMJlDQ7sx5LyB2zhe3HQuhyZcT622V/
         FlshoQRbYQYnZ4Unfj/zUoqEHftE/xEjpqPQus3qmmcdtj5SWj+9rp5YgClBrRbqRBnL
         Q4RbE9i0NW76L9CGABU9IPDO4XWSIYtS8yJn2F4eKPFXPJqbCvyFFt/NPc+unYOEJsB+
         38ccrqGgal9PUEcwXt1PnneTaTQdeNtD1DNSIr8tDO0YtIdc0f9k9LrNfrBEiurq9B8A
         QsPw==
X-Gm-Message-State: AOAM533ZlAFZHvP/VYE51Sm7Zbd95Gb+tn6j4RsIBdeb0gfrj6/cBikU
        Brgr7oN2E+CHICAR+Co/jBw=
X-Google-Smtp-Source: ABdhPJyGXjU/L3SAlfRX+kjprH5TGZQAun8MSIIIXSf68KUd+2NTcRZWbqiVuhcKNd4iHFEwB3EEyA==
X-Received: by 2002:a17:90a:ca96:b0:1c6:b478:788e with SMTP id y22-20020a17090aca9600b001c6b478788emr22401255pjt.162.1648362278797;
        Sat, 26 Mar 2022 23:24:38 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id l5-20020a056a0016c500b004f768db4c94sm12228443pfc.212.2022.03.26.23.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 23:24:38 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     balbi@kernel.org
Cc:     gregkh@linuxfoundation.org, joel@jms.id.au, andrew@aj.id.au,
        rentao.bupt@gmail.com, caihuoqing@baidu.com,
        benh@kernel.crashing.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] aspeed-vhub: epn: fix an incorrect member check on list iterator
Date:   Sun, 27 Mar 2022 14:24:31 +0800
Message-Id: <20220327062431.5847-1-xiam0nd.tong@gmail.com>
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
	if (&req->req == u_req) {

The list iterator 'req' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it may bypass
the 'if (&req->req == u_req) {' check in theory, if '*u_req' obj is
just allocated in the same addr with '&req->req'.

To fix this bug, just mova all thing inside the loop and return 0,
otherwise return error.

Cc: stable@vger.kernel.org
Fixes: 7ecca2a4080cb ("usb/gadget: Add driver for Aspeed SoC virtual hub")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/usb/gadget/udc/aspeed-vhub/epn.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/gadget/udc/aspeed-vhub/epn.c b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
index 917892ca8753..aae4ce3e1029 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/epn.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
@@ -468,27 +468,24 @@ static int ast_vhub_epn_dequeue(struct usb_ep* u_ep, struct usb_request *u_req)
 	struct ast_vhub *vhub = ep->vhub;
 	struct ast_vhub_req *req;
 	unsigned long flags;
-	int rc = -EINVAL;
 
 	spin_lock_irqsave(&vhub->lock, flags);
 
 	/* Make sure it's actually queued on this endpoint */
 	list_for_each_entry (req, &ep->queue, queue) {
-		if (&req->req == u_req)
-			break;
-	}
-
-	if (&req->req == u_req) {
-		EPVDBG(ep, "dequeue req @%p active=%d\n",
-		       req, req->active);
-		if (req->active)
-			ast_vhub_stop_active_req(ep, true);
-		ast_vhub_done(ep, req, -ECONNRESET);
-		rc = 0;
+		if (&req->req == u_req) {
+			EPVDBG(ep, "dequeue req @%p active=%d\n",
+				req, req->active);
+			if (req->active)
+				ast_vhub_stop_active_req(ep, true);
+			ast_vhub_done(ep, req, -ECONNRESET);
+			spin_unlock_irqrestore(&vhub->lock, flags);
+			return 0;
+		}
 	}
 
 	spin_unlock_irqrestore(&vhub->lock, flags);
-	return rc;
+	return -EINVAL;
 }
 
 void ast_vhub_update_epn_stall(struct ast_vhub_ep *ep)
-- 
2.17.1

