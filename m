Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBD522C58A
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 14:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgGXMuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 08:50:02 -0400
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:33576 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGXMuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 08:50:01 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2020 08:50:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1595595002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7Tw4G/V7kxbTklR4OkIgBDvRcTQey+xrJa3KZIIL0yE=;
  b=KnwLW2BfmGrxRo3Vc6PdPU3NPioTJdzMihB0amZpQX2QTI4f1Xsra58K
   u8pa5W2snN4cFepfe5u3gykvq78MMfLm5UiR/nWDq6lSp0/b+thrBNvil
   HmXP6Ruc0C0EEUcDsLQ1rNWppscInlTX2HTxNW1pKC1NEMIwC3HIaDN2m
   M=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: 1RmtWXLEVLsjBBebMyNb9dJntTLAmrgMDJmAs3T9l48/E9hvv/9Zz/JGcwmC/qk907TZ5cCnhv
 JD3rZBNMfCwCn/WlbKh5LBFv7oL/dKr6eU4+jdqj7dHQOQQqNjdvpYQ66LyEy3gb9PIHCC1MrD
 kmD0iJEk7E1uJWWtM02WnuIA+Yoq9Ra2+LyjJAAjbuuR1etEvwEpbBKBYFOxclIwriVbLZlQRM
 khIh9nzeMT3Dhtv9/vt6aqAXVFbKhToIhnx5qJOUTVfm1CHLGLlsws80oqkAFKPc/SW8TD/l4h
 FnA=
X-SBRS: 2.7
X-MesageID: 23139909
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,390,1589256000"; 
   d="scan'208";a="23139909"
From:   Roger Pau Monne <roger.pau@citrix.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Roger Pau Monne <roger.pau@citrix.com>, <stable@vger.kernel.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: [PATCH v2 2/4] xen/balloon: make the balloon wait interruptible
Date:   Fri, 24 Jul 2020 14:42:39 +0200
Message-ID: <20200724124241.48208-3-roger.pau@citrix.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724124241.48208-1-roger.pau@citrix.com>
References: <20200724124241.48208-1-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

So it can be killed, or else processes can get hung indefinitely
waiting for balloon pages.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: stable@vger.kernel.org
---
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
---
 drivers/xen/balloon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 3cb10ed32557..292413b27575 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -568,11 +568,13 @@ static int add_ballooned_pages(int nr_pages)
 	if (xen_hotplug_unpopulated) {
 		st = reserve_additional_memory();
 		if (st != BP_ECANCELED) {
+			int rc;
+
 			mutex_unlock(&balloon_mutex);
-			wait_event(balloon_wq,
+			rc = wait_event_interruptible(balloon_wq,
 				   !list_empty(&ballooned_pages));
 			mutex_lock(&balloon_mutex);
-			return 0;
+			return rc ? -ENOMEM : 0;
 		}
 	}
 
-- 
2.27.0

