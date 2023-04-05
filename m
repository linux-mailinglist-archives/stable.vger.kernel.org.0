Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5246D7865
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbjDEJcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbjDEJc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:32:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C1E91
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 02:31:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 4-20020a251904000000b00b7f75c3cafdso19594709ybz.16
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 02:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680687098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/f7k2pCQfyKc9i/c1APoOdFbnqMktgzwaYI9MvzI7I=;
        b=ekKxX2C34tJMVaSXEvswV0dn6KXZYLxQfRnib0ncGtIcCdhLZO6fp2nRbolxeyWGzA
         AYVX07eNPDMYwUsG3dP9BPeP2e5BeikACMPWKsdDgc9PBzoPPBBUTk13ZhX6F2+JKfY6
         0OD8NNIJRYP47IGm3P76WE55/EhcYUESreY4vB7hWrB4RXU2uyx6p/zbGqbRv9IrZT1o
         3SX29/CnmHD0LUzKLULvlZPEIAsp9DmlVdWIbFIOTDAi41BBAkSO3R3dHc62ZaimoKx5
         DMZ56/BJN9X5Vfs7MNZwyOpTZ1qU4u2jyV1QMMmjqflFOkckrT5g9iMG32sRJt8BUZ1F
         xtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680687098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/f7k2pCQfyKc9i/c1APoOdFbnqMktgzwaYI9MvzI7I=;
        b=PXZFnmSLyKxtp97395fP+9346SAL1kghhWyCOKu3+CHvILNAVvR+/MIfvNjV+mYx7M
         l75DDI36j4ZFgCwjNm3QAdO7gMpgT1MQ7HCHabNFJjd8yx59qwCn7OWmtf86KoJZp57S
         +ssQ7VKWiTX8Xf4WON3vLxRkFfmjs+PTI4bzfwpcQa2MA8ImE0dvlhCfiBsbS6mdWyvN
         LAddAoOt5lua7a87y9kncz/eAFBRunvQJMigvvUuGLTO/tUeM2N+fXjp6BQf8gTd4dXQ
         xeFb67BTS3T2Osbysgvu1UiOtU1Iae7RjUiU1vHOt3BWvwCi/6s0KWNH5dwW5IF959aF
         JYLw==
X-Gm-Message-State: AAQBX9ceie9tbbrl34lgTfNpyPl89ZAOEreJ67lDlXgVT30MWfMr1KTS
        osjd+HtsMj/xxitjxUbTUJzaSFM7Bx8=
X-Google-Smtp-Source: AKy350aKsyRuBxaFkts/Dkw/YAKF8fPlfRHIbx10T2+rN8xaLh+uXq86LvxxLKF39pNGTOckwR/zSyrRIDs=
X-Received: from badhri.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:6442])
 (user=badhri job=sendgmr) by 2002:a81:ad04:0:b0:544:5aa0:e212 with SMTP id
 l4-20020a81ad04000000b005445aa0e212mr3163443ywh.6.1680687097844; Wed, 05 Apr
 2023 02:31:37 -0700 (PDT)
Date:   Wed,  5 Apr 2023 09:31:33 +0000
In-Reply-To: <20230405093133.1858140-1-badhri@google.com>
Mime-Version: 1.0
References: <20230405093133.1858140-1-badhri@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405093133.1858140-2-badhri@google.com>
Subject: [PATCH v1 2/2] usb: gadget: udc: core: Prevent redundant calls to pullup
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        colin.i.king@gmail.com, xuetao09@huawei.com,
        quic_eserrao@quicinc.com, water.zhangjiantao@huawei.com,
        peter.chen@freescale.com, balbi@ti.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

usb_gadget_connect calls gadget->ops->pullup without
checking whether gadget->connected was previously set.
Make this symmetric to usb_gadget_disconnect by returning
early if gadget->connected is already set.

Cc: stable@vger.kernel.org

Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Fixes: 5a1da544e572 ("usb: gadget: core: do not try to disconnect gadget if it is not connected")
---
 drivers/usb/gadget/udc/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 890f92cb6344..7eeaf7dbb350 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -708,6 +708,9 @@ int usb_gadget_connect(struct usb_gadget *gadget)
 		goto out;
 	}
 
+	if (gadget->connected)
+		goto out;
+
 	if (gadget->deactivated) {
 		/*
 		 * If gadget is deactivated we only save new state.
-- 
2.40.0.348.gf938b09366-goog

