Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AC76CF5AD
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 23:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjC2Vwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 17:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjC2Vwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 17:52:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9D36A41
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 14:52:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j11-20020a25230b000000b00b6871c296bdso16592553ybj.5
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 14:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680126746;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CsFO/UcDyqF5hzYyaOpux0kSInGSNXB7fWOr/Mojtdc=;
        b=RHxHrD0riHQdNklAwbOyOVwMytX1Zqo4yL4S28/sbh6YsGl3q09hPtWIUDRbdZr9ge
         rgU4I6Ln1QlZaq7jeYhT3hOzGtJwdorkfUBHDkIXV2DJ0tzCFN/N4umhnogf4N+OcQL4
         TfjA3qSdao6/K6doCajwtW7tly3qsDVnoh8E14Ga3rEveQXWEBcQIyd/W46QOcOVdWTY
         pCthXDCjjmoI3+xsjKACJfQWXu4fLyBQDLQIVaK/CoS+6mj3NZM37nUrhMu3ad8JFeZm
         wZNlQDVTLRDobPBGxfA2OAZ0N/IbVDrNFcI217dNNH2JYWvcdvwN/JS+GalbnM9rvp3r
         oUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680126746;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CsFO/UcDyqF5hzYyaOpux0kSInGSNXB7fWOr/Mojtdc=;
        b=CpjvWErG850Ob+B6IKAtymLNkPoEYjmvm4/biipeDe0fvQmnwBhq3IXMc0/EZwMv5k
         eANS0aJJaTcW1dUK+pH9K0kK5Tlwnq1lxNmjKRbHaJbdb+vC3Z3kbxzFNM9Jwb183L9T
         5fsWPmnUecMoerHf0qoABv3GIatjXjbC8ryOZnULuXscuypsqlNXs3wfAxHTe0xe6y9l
         XG0PYlvUJvA5nP+d8hfcM/lwWEBqTZIf1A13TFlAzaaIZ0DcE2uO4zAoG3YjePhKr94+
         1H6mWwWd/Z9jHuCPVi0H+oGjmDJJBSUjEKnvNwmIbxhQv8uoR9U3D7sTWr+ReAAxiHKC
         QdAA==
X-Gm-Message-State: AAQBX9eS42O3Zc7JnAJeaSKBW3O4BUR97pSQ5jQE/Q6Nbu53JfIf7NM4
        j8ltvOMP/QqVdzzCZIkoRmwf6FxkffnIDa4=
X-Google-Smtp-Source: AKy350YKLD0cYnhPAs3bUyHqq7zxakvTmmcso2sSBuLkCH7jFi1VvPjsAnG4V9XxwVaWzeCZqxDyYEFYB8svaNg=
X-Received: from rdbabiera.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:18a8])
 (user=rdbabiera job=sendgmr) by 2002:a05:6902:168d:b0:b26:47f3:6cb with SMTP
 id bx13-20020a056902168d00b00b2647f306cbmr10969166ybb.4.1680126746160; Wed,
 29 Mar 2023 14:52:26 -0700 (PDT)
Date:   Wed, 29 Mar 2023 21:51:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329215159.2046932-1-rdbabiera@google.com>
Subject: [PATCH v1] usb: typec: altmodes/displayport: Fix configure initial
 pin assignment
From:   RD Babiera <rdbabiera@google.com>
Cc:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        RD Babiera <rdbabiera@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.5 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While determining the initial pin assignment to be sent in the configure
message, using the DP_PIN_ASSIGN_DP_ONLY_MASK mask causes the DFP_U to
send both Pin Assignment C and E when both are supported by the DFP_U and
UFP_U. The spec (Table 5-7 DFP_U Pin Assignment Selection Mandates,
VESA DisplayPort Alt Mode Standard v2.0) indicates that the DFP_U never
selects Pin Assignment E when Pin Assignment C is offered.

Update the DP_PIN_ASSIGN_DP_ONLY_MASK conditional to intially select only
Pin Assignment C if it is available.

Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
---
 drivers/usb/typec/altmodes/displayport.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index 662cd043b50e..8f3e884222ad 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -112,8 +112,12 @@ static int dp_altmode_configure(struct dp_altmode *dp, u8 con)
 		if (dp->data.status & DP_STATUS_PREFER_MULTI_FUNC &&
 		    pin_assign & DP_PIN_ASSIGN_MULTI_FUNC_MASK)
 			pin_assign &= DP_PIN_ASSIGN_MULTI_FUNC_MASK;
-		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK)
+		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK) {
 			pin_assign &= DP_PIN_ASSIGN_DP_ONLY_MASK;
+			/* Default to pin assign C if available */
+			if (pin_assign & BIT(DP_PIN_ASSIGN_C))
+				pin_assign = BIT(DP_PIN_ASSIGN_C);
+		}
 
 		if (!pin_assign)
 			return -EINVAL;

base-commit: 97318d6427f62b723c89f4150f8f48126ef74961
-- 
2.40.0.348.gf938b09366-goog

