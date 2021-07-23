Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C71E3D3B56
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 15:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhGWNCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 09:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbhGWNCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 09:02:08 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9257AC061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 06:42:41 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id x3so1366693qkl.6
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 06:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jakma-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=iWZerGbwjoVxQTeT8tsyEDW75uJrbUDtI+N1FFthDTg=;
        b=vX+jISU+TiBWdmmKVTXLGn2OPkpeqA0l/e4pDYQcml7LGaUEitgQhzn1BJmJio92Z1
         US8oGhQJekg2/opmPGQPlqnKnZA9lwaGlho4eZ5Z1vvKBgpVvnEsfCm6bMDzU+SrjoVI
         W9PTMnkFZtoDG4JvMEhsMph3dpqFJFKR6nUCJwTrpnTreEHXHbv6lY2kLGAKICyrROHn
         AMy7MIErxUlWSZkboOfgIRwJdqvW4AmRnjD3hlBbz5hkaoSrUTaaIOUv58mSReiQ9ONL
         UOjVRLwntQeMg6MUlUuwtIYBsEdBOAHskTGNBF7nNhZuAqS6HKlyv4OOpAufpURBbdm/
         89mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=iWZerGbwjoVxQTeT8tsyEDW75uJrbUDtI+N1FFthDTg=;
        b=IKg/y29Y3BBxqRxoywzJa0lX9BxE8kduNUhp32lPlpDwhO2e7h9nZcfWJeYZnNiiCH
         CKSOLOlUHCWL2K7ZF2hh9C86UCkzGNIjc+Ba7dwLbhk3ZIB8SFrybXPsHgznxTO5nYKR
         dmEmkaA3/r0P56m1DfoohTKRbiFyBUAjw/vlxgflypMYn3c8phYu3uCexJqmNS/XOV02
         iKsaKbf3LIDT2eRN3RNS5docqq4iQEBXUTMQDTqZoF1agUApJv6EKV75XjSoeJBuXozQ
         1UUL9aXfH1/aB0DF3e+9jOAKUdHKFnFupow6OHkJaTC3HRfZ/VeNjVvASqCXmIZL7CpN
         6H/A==
X-Gm-Message-State: AOAM533/Dg1rEyV6lOSHCY5BSl9RJbN27N+nS6Vh/xXelIT4Lm1JGnD4
        uuk+sGnyZPnBqrVJnBElwMcBHA==
X-Google-Smtp-Source: ABdhPJyTrhHZYpHB+tj3ZrlP3htoL1FQJYqo1ubiSI49BzEasWsI7PhPzytTVcTQHcN1CcYqr/G+1Q==
X-Received: by 2002:a37:84c1:: with SMTP id g184mr4617230qkd.102.1627047760743;
        Fri, 23 Jul 2021 06:42:40 -0700 (PDT)
Received: from sagan.jakma.org ([2a01:ac:1000:100::ab])
        by smtp.gmail.com with ESMTPSA id f3sm11277219qti.65.2021.07.23.06.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 06:42:40 -0700 (PDT)
From:   Paul Jakma <paul@jakma.org>
To:     linux-netdev@vger.kernel.org
Cc:     Paul Jakma <paul@jakma.org>, Kangjie Lu <kjlu@umn.edu>,
        Shannon Nelson <shannon.lee.nelson@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] NIU: fix incorrect error return, missed in previous revert
Date:   Fri, 23 Jul 2021 14:41:54 +0100
Message-Id: <20210723134154.1252732-2-paul@jakma.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210723134154.1252732-1-paul@jakma.org>
References: <20210721.084759.550228860951288308.davem () davemloft ! net>
 <20210723134154.1252732-1-paul@jakma.org>
Reply-To: paul@jakma.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7930742d6, reverting 26fd962, missed out on reverting an incorrect
change to a return value.  The niu_pci_vpd_scan_props(..) == 1 case appears
to be a normal path - treating it as an error and return -EINVAL was
breaking VPD_SCAN and causing the driver to fail to load.

Fix, so my Neptune card works again.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Shannon Nelson <shannon.lee.nelson@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Fixes: 7930742d ('Revert "niu: fix missing checks of niu_pci_eeprom_read"')
Signed-off-by: Paul Jakma <paul@jakma.org>
---
 drivers/net/ethernet/sun/niu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 74e748662ec0..860644d182ab 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -8191,8 +8191,9 @@ static int niu_pci_vpd_fetch(struct niu *np, u32 start)
 		err = niu_pci_vpd_scan_props(np, here, end);
 		if (err < 0)
 			return err;
+		/* ret == 1 is not an error */
 		if (err == 1)
-			return -EINVAL;
+			return 0;
 	}
 	return 0;
 }
-- 
2.31.1

