Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144CF22E89E
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 11:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgG0JPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 05:15:08 -0400
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:21202 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgG0JPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 05:15:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1595841306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3jbhXHOtCfIXZMzu/xfRs6KCwvTkEik1EFWK3NUjQ5c=;
  b=TUqDbBF3UM3J3DuvHFMNaIPOrsRtgHOSMbQfNoMvCyKmph/ucBJers0q
   1+tg5CB0/m9NCj+VUYCcfS2EjQeolGGu0Km8ZCqb52v16Cp1vPmqMVlF1
   euJIcLZPtq5PQYY70QUxk1YgMYHIUXn3rMxRkNWvDgrcDxPNLfiqSFyG+
   4=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: XBCsU74yw3gqieztP4QqoHMKHwPQS43HrGWtokfqoYQFLLraPZfghSADkh+tDlVKFLfYjy+t7V
 wLpS4OPM3WrCC5ogCSsCLNIU308UvGq9/KoTNu0vq/EKwIwdsM8K6oJgPGIdB0UeQHrLnfH6N4
 nBhXexVhbxOjiRM8L3yo31TsUDflXk+vNdRma2GVo9FscqU3iUbZ46O2r587gpwT7DUugcVKgk
 LWnMbM2lZQSLIKZNj9ffanaC/24ugers1l1uocUJ2wim1ysobo/k1h8q4hRYpKSzGmJHkStpvU
 haw=
X-SBRS: 2.7
X-MesageID: 23254979
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,402,1589256000"; 
   d="scan'208";a="23254979"
From:   Roger Pau Monne <roger.pau@citrix.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Roger Pau Monne <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>, <stable@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: [PATCH v3 2/4] xen/balloon: make the balloon wait interruptible
Date:   Mon, 27 Jul 2020 11:13:40 +0200
Message-ID: <20200727091342.52325-3-roger.pau@citrix.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727091342.52325-1-roger.pau@citrix.com>
References: <20200727091342.52325-1-roger.pau@citrix.com>
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
Reviewed-by: Juergen Gross <jgross@suse.com>
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

