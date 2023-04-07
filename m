Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CCD6DA7CC
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 04:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjDGCqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 22:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjDGCqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 22:46:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA9A83D0
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 19:46:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a25230b000000b00b6871c296bdso40456889ybj.5
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 19:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680835581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nUz0udxJSncClIXfXpDEBX9ECoOtSVVpf/KdMJ7vysQ=;
        b=Wt0oTZn2fcVjC7J7ao1RrEACmnskuXW5Y7RH57Bg0T+h9jBUlNoupAWUyDyLfTW/pN
         WEd44/ggQ2SzaO14FiShx/WghxIFA4ZvwSSwzHeVlSyTQ1gxSXBbh2sLYU4F2izjb8QN
         D6fUQFjaTQYfUYkHVbNHCdW8Kk2NZT/ZDf8oB12Ro5L8pv0U5Qd/VIUtWhF/EWflY0aG
         S3fb37isoWdDMd07xuEl++VVRtp8HXfdt3nJJpsdbncr2egeat7GJH/mpqAySzq9iv3b
         I1PUThLbYl4RNWQqFx3znDP9jE20Cxne92rT6P44z6cwwITtEnKAL3ebacl9O1Atzcie
         HPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680835581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nUz0udxJSncClIXfXpDEBX9ECoOtSVVpf/KdMJ7vysQ=;
        b=0e+Xauos3eg5YdQ6KB63bfgoMmcG9CnRXf1MMAVOT/J/LtgdpGd2U+731KagjbzOm2
         e3YUh1SM+26x3EUtNjruOngax7lt0qsnbPk1jNfSOMhXXWkwkZFuZOcBqf4nqcfzd8pt
         ueQt4MIOayMeuDFoaYUfFuqvvSf2DcTjdvw+W/R1Q+8plcNQqRMBJk0It1riYnn1w+Qc
         JqHQRq9qSSFKw5gIAS3CbmtH1Mmw5tHNBS9lA2RVGsSsS624YVF34jpfAEjKzhQOgIS9
         eZCus6r3C7YVdZOubna/OcNED9WouhYpdmj80/kts4GxCoDiYzQioRR/IQG91MKdvYOq
         DHkQ==
X-Gm-Message-State: AAQBX9fhcrYdfB0FrXR9lZiIf9ibWmIlE+y3wZ1fIcXN6syBnIEo0iUe
        Fuk6USc5lUMVag66EdJHyVmReORoKPQ=
X-Google-Smtp-Source: AKy350Y1ZkusZZ/d+V9apvkNKAvkrhEIZbqxRghfGTgTfVypjt2VIPRyggOZ5HCkwgUmnfW9u0i18xl3aMI=
X-Received: from badhri.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:6442])
 (user=badhri job=sendgmr) by 2002:a05:690c:72c:b0:52f:184a:da09 with SMTP id
 bt12-20020a05690c072c00b0052f184ada09mr355489ywb.2.1680835581211; Thu, 06 Apr
 2023 19:46:21 -0700 (PDT)
Date:   Fri,  7 Apr 2023 02:46:16 +0000
In-Reply-To: <20230407024616.2883701-1-badhri@google.com>
Mime-Version: 1.0
References: <20230407024616.2883701-1-badhri@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407024616.2883701-2-badhri@google.com>
Subject: [PATCH v3 2/2] usb: gadget: udc: core: Prevent redundant calls to pullup
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

usb_gadget_connect calls gadget->ops->pullup without checking whether
gadget->connected was previously set. Make this symmetric to
usb_gadget_disconnect by returning early if gadget->connected is
already set.

Cc: stable@vger.kernel.org
Fixes: 5a1da544e572 ("usb: gadget: core: do not try to disconnect gadget if it is not connected")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
Changes since v2:
* none
Changes since v1:
* Fixed commit message comments.
---
 drivers/usb/gadget/udc/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 3eb5d4e392db..7e9ce872451e 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -702,6 +702,9 @@ int usb_gadget_connect_locked(struct usb_gadget *gadget) __must_hold(&gadget->ud
 		goto out;
 	}
 
+	if (gadget->connected)
+		goto out;
+
 	if (gadget->deactivated || !gadget->udc->started) {
 		/*
 		 * If gadget is deactivated we only save new state.
-- 
2.40.0.577.gac1e443424-goog

