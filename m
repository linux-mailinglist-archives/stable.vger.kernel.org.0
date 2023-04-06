Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03ED06D8F47
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbjDFGTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbjDFGTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:19:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A198A68
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 23:19:11 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54476ef9caeso378647687b3.6
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 23:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680761951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/f7k2pCQfyKc9i/c1APoOdFbnqMktgzwaYI9MvzI7I=;
        b=HC1tvqen+SYVHhiRrMODrf/6S8bdwKpI+yt4teqebTIbY0JBmRRXhr20JjZXktd3I4
         F66rfE2Is4Qu9p1TfNS5iCUeIomqVNB5B9pfoUwHBcCe+jCtE7iHW5NSO/+DU9mThwEk
         9snHuN8YGSee2wvz2Idm7U2+wqV2Qy6ssaFNI2sxaEpMba45OPyqNDWImo6Sc/5k2KUf
         9YeX2q7D783NI+HlWIJdrk66Ki4oVoLI+Yut4ZYAW8I5mOz/EnuJviU0CWGco3MFDl4j
         LamLj+bt8zhJrkna8q8FVBQVM9Y7sh9ay6CfAJm7DUKZTK1obcEHq/hZzxoh66/Oqtdg
         FuNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680761951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/f7k2pCQfyKc9i/c1APoOdFbnqMktgzwaYI9MvzI7I=;
        b=XAgk8I0Fsbq6zyC8cgmHa2qTCy20gBhua7QbrTgWTfqsYwjFh0ik2vpapaiXnIyI1t
         H/7L3M7T8g0P7XU4Um1eoUEYyE+0RzJ2sszgFFuHMc+bgxwdR8rL1/9ztgQWauzHUL1U
         sl6hckZMJBa/f8Z2WNoH+gKhda/Nemvumvm4zutziej6qf28GxRUwHKL3TUbiyVnmRPF
         oadxAKIM0eNZ9JjvdtAcULlRraMTCX7s5n8tCS42gWCfeDIKmzsoAhY94Y+1HVPNdgqR
         R6niMcECtASvxyrXqXWOLbhLIShNT8bBHbq7tMintcVAu5qFje4pZbSk2jSxbW5m5HW1
         lizQ==
X-Gm-Message-State: AAQBX9dwIiDyWndjI7Pwsfy8F+DUD3Guy5eemkQGououSQZ14Y8MuMlz
        klZPwAXN5zmyqS4vIHQwzZl7LsMx5Ws=
X-Google-Smtp-Source: AKy350Z27oP6FQknZlBJY3VEEuuN5Fbe6TE3Go6ZF49WVR2vlInKkeeEI2A8kAjBmcEm+hNGu+IRXRCtHaY=
X-Received: from badhri.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:6442])
 (user=badhri job=sendgmr) by 2002:a25:cf88:0:b0:b8b:f1ac:9c6c with SMTP id
 f130-20020a25cf88000000b00b8bf1ac9c6cmr1399315ybg.3.1680761950871; Wed, 05
 Apr 2023 23:19:10 -0700 (PDT)
Date:   Thu,  6 Apr 2023 06:19:05 +0000
In-Reply-To: <20230406061905.2460827-1-badhri@google.com>
Mime-Version: 1.0
References: <20230406061905.2460827-1-badhri@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230406061905.2460827-2-badhri@google.com>
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

