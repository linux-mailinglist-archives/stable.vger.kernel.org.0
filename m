Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD2E535097
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 16:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiEZO23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 10:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiEZO22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 10:28:28 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BC4C5E73
        for <stable@vger.kernel.org>; Thu, 26 May 2022 07:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1653575308; x=1685111308;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qlwpBZqgVyx3J3Sdo0u/OKW/zSctsn5xJgveXy0nbpc=;
  b=RpuEu4JWytQCZD21+L6+8Xr4k6JLvzFmKACxHquHb3IVHejbibvUqNvm
   eTSG7BVpbDPk605QMS1CS9fq9+mkCmyVKcFjw/ChLYKS8Mtii0Lb61ZEC
   Ojxsj6HFj1ZLoA09SC/8oRIeejWAqd9VMeL5CDw1+ZYJbC1c4ceh1+qjG
   k=;
X-IronPort-AV: E=Sophos;i="5.91,252,1647302400"; 
   d="scan'208";a="92176886"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 26 May 2022 14:28:27 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com (Postfix) with ESMTPS id F2B78427D1
        for <stable@vger.kernel.org>; Thu, 26 May 2022 14:28:26 +0000 (UTC)
Received: from EX13D01UWA001.ant.amazon.com (10.43.160.60) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 26 May 2022 14:28:26 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13d01UWA001.ant.amazon.com (10.43.160.60) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 26 May 2022 14:28:26 +0000
Received: from dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com (10.189.32.138)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.36 via Frontend Transport; Thu, 26 May 2022 14:28:25 +0000
Received: by dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com (Postfix, from userid 22056925)
        id BCED430E8; Thu, 26 May 2022 14:28:24 +0000 (UTC)
From:   Julian Schroeder <jumaco@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Julian Schroeder <jumaco@amazon.com>
Subject: [PATCH] nfsd: destroy percpu stats counters after reply cache shutdown
Date:   Thu, 26 May 2022 14:28:12 +0000
Message-ID: <20220526142812.16563-1-jumaco@amazon.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upon nfsd shutdown any pending DRC cache is freed. DRC cache use is
tracked via a percpu counter. In the current code the percpu counter
is destroyed before. If any pending cache is still present,
percpu_counter_add is called with a percpu counter==NULL. This causes
a kernel crash.
The solution is to destroy the percpu counter after the cache is freed.

Fixes: e567b98ce9a4b (“nfsd: protect concurrent access to nfsd stats counters”)
Signed-off-by: Julian Schroeder <jumaco@amazon.com>
---
 fs/nfsd/nfscache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 0b3f12aa37ff..7da88bdc0d6c 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -206,7 +206,6 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
 	struct svc_cacherep	*rp;
 	unsigned int i;
 
-	nfsd_reply_cache_stats_destroy(nn);
 	unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
 
 	for (i = 0; i < nn->drc_hashsize; i++) {
@@ -217,6 +216,7 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
 									rp, nn);
 		}
 	}
+	nfsd_reply_cache_stats_destroy(nn);
 
 	kvfree(nn->drc_hashtbl);
 	nn->drc_hashtbl = NULL;
-- 
2.32.0

