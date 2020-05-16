Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8757B1D5F89
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 10:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgEPIH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 May 2020 04:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgEPIHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 May 2020 04:07:25 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A177C061A0C
        for <stable@vger.kernel.org>; Sat, 16 May 2020 01:07:23 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id q11so5083895qvu.13
        for <stable@vger.kernel.org>; Sat, 16 May 2020 01:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m6FXJWTVjdVibVnBuvWq7S2FSfO+tv4HQu2DRpDNQEM=;
        b=OUZpHqIacF0EjlyoeZty3BJIuBBUFJITwSRluRMVLb36uvGl11S9Y2e+3NLT9N4SJ+
         eA7xLL8KvYBTlr+5i5yPmxHUCnXLou+MI812JH79Mm2DM/sAKxRP/bwbNR3QrQ6PkKhi
         fXyFzc9WmhI9vf06/kp3aKMBSHqJvuI5DQ+h0FE/BwJCCdDqFtnAO+qwVtBSA2cWpRM4
         qiE/+7bjH3b8esojgR5uxeFGKPSsceuAiadaD1IlWnl6l4jgel2i1iF3EwtHLmrfiedw
         MAfOi2X7djt+HafR/evWSM01IWDwEiXtpoaFGCPu/iFJ/rtD03fC6iyCHZcniGwB3VRc
         hBnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m6FXJWTVjdVibVnBuvWq7S2FSfO+tv4HQu2DRpDNQEM=;
        b=NtJN8bLXOsYFqBYSZWFf4xSuYjYdk8xA8XbVQgB4howyywC7fsEkAjZHdHqAKJOhfp
         wHrAjRbo8oHNiTVOALvR0Hpv/AW2r9aOU/o5/xydgk6BYNCIMg23h/gb+hpJMTVGYvm7
         0TpTc+AF8HaCnWgCgwoqL66v/aVhP1j33FT80vDaZWvO3XBHfttbsZYpTxpiku+W6y77
         aysY/kDWAwHWn9hWVasxC00tpmXzQ6KV0yWzEf1h7Vki4YRdRqfFkwlQAf4nvwCnwg0T
         w6SYbbPoQaqxmMOiaeLAOgwK94bbeCcXuCo0iwCgMT2Ept3LBOOTDQrfHV5g9Nz6H7t0
         HJxQ==
X-Gm-Message-State: AOAM530Lm0qkac23OF/63/ljBpEdhjL2/DbjcCemTzeLm7UTY4KmONt1
        I0QbaY8zkbNIgOCfg1W7SXoUZEb+KD6rOrE=
X-Google-Smtp-Source: ABdhPJx18LwhURFMw6en0MLHSwDPcau1vDqd0MZzLikef5cQQL1JC0nc7/3sNdzSBXAFw67BkXXw3p6jshvPIp4=
X-Received: by 2002:a0c:a619:: with SMTP id s25mr7145926qva.21.1589616442680;
 Sat, 16 May 2020 01:07:22 -0700 (PDT)
Date:   Sat, 16 May 2020 01:07:18 -0700
Message-Id: <20200516080718.166676-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v1] driver core: Fix memory leak when adding SYNC_STATE_ONLY
 device links
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
core: Add device link support for SYNC_STATE_ONLY flag"),
device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
device link to the supplier's and consumer's "device link" list. So the
"device link" is lost forever from driver core if the caller didn't keep
track of it (typically isn't expected to).

If the same SYNC_STATE_ONLY device link is created again using
device_link_add(), instead of returning the pointer to the previously
created device link, a new device link is created and returned. This can
cause memory leaks in conjunction with fw_devlinks.

Cc: stable@vger.kernel.org
Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 84c569726d75..d36e9289b2df 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -436,12 +436,16 @@ struct device_link *device_link_add(struct device *consumer,
 	    flags & DL_FLAG_PM_RUNTIME)
 		pm_runtime_resume(supplier);
 
+	list_add_tail_rcu(&link->s_node, &supplier->links.consumers);
+	list_add_tail_rcu(&link->c_node, &consumer->links.suppliers);
+
 	if (flags & DL_FLAG_SYNC_STATE_ONLY) {
 		dev_dbg(consumer,
 			"Linked as a sync state only consumer to %s\n",
 			dev_name(supplier));
 		goto out;
 	}
+
 reorder:
 	/*
 	 * Move the consumer and all of the devices depending on it to the end
@@ -452,12 +456,9 @@ struct device_link *device_link_add(struct device *consumer,
 	 */
 	device_reorder_to_tail(consumer, NULL);
 
-	list_add_tail_rcu(&link->s_node, &supplier->links.consumers);
-	list_add_tail_rcu(&link->c_node, &consumer->links.suppliers);
-
 	dev_dbg(consumer, "Linked as a consumer to %s\n", dev_name(supplier));
 
- out:
+out:
 	device_pm_unlock();
 	device_links_write_unlock();
 
-- 
2.26.2.761.g0e0b3e54be-goog

