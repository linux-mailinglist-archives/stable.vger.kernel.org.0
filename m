Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F58947E1CC
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 11:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347813AbhLWKxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 05:53:16 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:58602 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347812AbhLWKxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 05:53:14 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BCACB210DB;
        Thu, 23 Dec 2021 10:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1640256792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=pEet0UNjNiJJwdUa4GB5z/GjJ/9loWEgRoSSHCDo0MI=;
        b=GsWW+u52CVrXy/vpfXc8KX5A2yWqgv3EK9oOirwgQ0Gr0O1h7xYNy1dzIr7CVwH8pIyy1E
        4287Ay+xHRmD4BjwygX/wErVLaDyhhemTFZkE8F3fip+NO9hkES8nue3xTE7y4Ib6lQ6YE
        Uzosznh1ttmMURDOL0bwbPDSr0cwvDI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D19113E4C;
        Thu, 23 Dec 2021 10:53:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zOzSJBhVxGFGHwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 23 Dec 2021 10:53:12 +0000
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Cc:     xen-devel@lists.xenproject.org, Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen/blkfront: fix bug in backported patch
Date:   Thu, 23 Dec 2021 11:53:08 +0100
Message-Id: <20211223105308.17077-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The backport of commit 8f5a695d99000fc ("xen/blkfront: don't take local
copy of a request from the ring page") to stable 4.4 kernel introduced
a bug when adding the needed blkif_ring_get_request() function, as
info->ring.req_prod_pvt was incremented twice now.

Fix that be deleting the now superfluous increments after calling that
function.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/block/xen-blkfront.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 1e44b7880200..ae2c47e99c88 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -493,8 +493,6 @@ static int blkif_queue_discard_req(struct request *req)
 	else
 		ring_req->u.discard.flag = 0;
 
-	info->ring.req_prod_pvt++;
-
 	/* Copy the request to the ring page. */
 	*final_ring_req = *ring_req;
 	info->shadow[id].inflight = true;
@@ -711,8 +709,6 @@ static int blkif_queue_rw_req(struct request *req)
 	if (setup.segments)
 		kunmap_atomic(setup.segments);
 
-	info->ring.req_prod_pvt++;
-
 	/* Copy request(s) to the ring page. */
 	*final_ring_req = *ring_req;
 	info->shadow[id].inflight = true;
-- 
2.26.2

