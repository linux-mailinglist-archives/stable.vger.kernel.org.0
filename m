Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD14A4A2D62
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 10:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiA2JbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 04:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiA2JbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 04:31:03 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CA0C06173B
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:31:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so17383095ybg.8
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 01:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eQiF13v2Gsd7OivTrV/U/UDNZ731mX3c3wpLefP6cJw=;
        b=dGKm8kCRfr/obRdHtiZJnzlManXsVaOXRWUBx/zeLE1FiuUXnlnkU6UYocCbpZekjX
         WXE3V5Ma1aexAqQmBKQguT2HhSDKNOpm6wb3DjaBdzVttIemJAqbzwFw4XIxSqYRWsnv
         Nf32wA6Z2PxGO+ifJlZLkbDBUhf5+GWlv6tQA1ayX8WZrxfE0hf34YAAZoMKD671O6/0
         e0PwldCxszga5aKdvpKPdSAib6o4X9Wt1KvwpJFQwD/mYXe0iPgqivgqi6d1Wji7dmlb
         LMWtkB8SmC60TpGIDM6/aNGNL8RaF62wOHeCXtTNSJWXwI0xiRFvSvyBBPiObIYq2gT5
         FSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eQiF13v2Gsd7OivTrV/U/UDNZ731mX3c3wpLefP6cJw=;
        b=OtArduryNyvJIbJx7xtlvw4fMwC7uj+T5F5aH98vPvIqy9PLGvVImOFPmhKGb86trm
         4T+oFjaAm8vqp5nqeOsnoiEBvryHWca5KnJj8mXnXHc9Fj4Tc2kU4odZc09nip+Cabem
         y2xk9BOjZFNGUDvZqEIeRWzEDveqV92pmSMtAHLHyNiMw2NGjecPN/cUbJ2FD0RbKV4S
         AKkXmWE21SuBRohUO4GKDHSw4cURXDNvEkt69MdikjUt6j8Iuvpi9i65JIAAJRQ56L+o
         JQxcwxHlXqHEaIgopCZ/jJ4AKSMGo5+7WhXYH1rQ1Hk4b+tdtYCDJSrn3zjfvZumldJB
         USww==
X-Gm-Message-State: AOAM530hkTz3b57Qrc7ZodrA/F1V0OL2Q4sc9X6P9KiBkheKh1O5Ze+X
        E3mY7yG9ZeW5QP/J48z8VAq0vfmhwNPk
X-Google-Smtp-Source: ABdhPJySTU9JqPpXZ+xr2kOfpBPYym9Fd+bimdqVuTR+Dro5+7AjxNgg8+CbiD5EvQ+hLJtiN1GM//X0cydf
X-Received: from pumahsu.ntc.corp.google.com ([2401:fa00:fc:202:e174:365:53b4:80cd])
 (user=pumahsu job=sendgmr) by 2002:a0d:cf81:: with SMTP id
 r123mr1548ywd.59.1643448661327; Sat, 29 Jan 2022 01:31:01 -0800 (PST)
Date:   Sat, 29 Jan 2022 17:30:36 +0800
Message-Id: <20220129093036.488231-1-pumahsu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH v6] xhci: re-initialize the HC during resume if HCE was set
From:   Puma Hsu <pumahsu@google.com>
To:     mathias.nyman@intel.com, gregkh@linuxfoundation.org
Cc:     s.shtylyov@omp.ru, albertccwang@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Puma Hsu <pumahsu@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When HCE(Host Controller Error) is set, it means an internal
error condition has been detected. Software needs to re-initialize
the HC, so add this check in xhci resume.

Cc: stable@vger.kernel.org
Signed-off-by: Puma Hsu <pumahsu@google.com>
---
v2: Follow Sergey Shtylyov <s.shtylyov@omp.ru>'s comment.
v3: Add stable@vger.kernel.org for stable release.
v4: Refine the commit message.
v5: Add a debug log. Follow Mathias Nyman <mathias.nyman@linux.intel.com>'s comment.
v6: Fix the missing declaration for str.

 drivers/usb/host/xhci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index dc357cabb265..6f1198068004 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1091,6 +1091,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	int			retval = 0;
 	bool			comp_timer_running = false;
 	bool			pending_portevent = false;
+	char			str[XHCI_MSG_MAX];
 
 	if (!hcd->state)
 		return 0;
@@ -1146,8 +1147,10 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		temp = readl(&xhci->op_regs->status);
 	}
 
-	/* If restore operation fails, re-initialize the HC during resume */
-	if ((temp & STS_SRE) || hibernated) {
+	/* If restore operation fails or HC error is detected, re-initialize the HC during resume */
+	if ((temp & (STS_SRE | STS_HCE)) || hibernated) {
+		xhci_warn(xhci, "re-initialize HC during resume, USBSTS:%s\n",
+			  xhci_decode_usbsts(str, temp));
 
 		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
 				!(xhci_all_ports_seen_u0(xhci))) {
-- 
2.35.0.rc2.247.g8bbb082509-goog

