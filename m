Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA03531D70
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 23:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiEWVL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 17:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiEWVL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 17:11:57 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58B25DA05
        for <stable@vger.kernel.org>; Mon, 23 May 2022 14:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1653340315; x=1684876315;
  h=date:from:to:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=6mrbpzAsI3UIu51uCrX0wEbkoUm4MtxCEXRmMNaeJYw=;
  b=mxbydKGPaQeFLNpdJ61bsLSstx01ox6gwvToNASmAX6KEvhhJrpsi+bp
   86UcICLCpgb/tpjzMTpn/KcBCJu/QF+YnMAe2+x57+6DxzkCICWreVE+b
   ZatIeFKivcV3KYbArf/9c6WJdGNFpvhXcNPntpYKL6YtDyt2jC13Vvp6b
   s=;
X-IronPort-AV: E=Sophos;i="5.91,247,1647302400"; 
   d="scan'208";a="197168144"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 23 May 2022 21:11:54 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id AD9CA1A001D
        for <stable@vger.kernel.org>; Mon, 23 May 2022 21:11:53 +0000 (UTC)
Received: from EX13D27UEE001.ant.amazon.com (10.43.62.82) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 23 May 2022 21:11:52 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D27UEE001.ant.amazon.com (10.43.62.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 23 May 2022 21:11:52 +0000
Received: from dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com (10.189.32.138)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.36 via Frontend Transport; Mon, 23 May 2022 21:11:52 +0000
Received: by dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com (Postfix, from userid 22056925)
        id DD3582AA0; Mon, 23 May 2022 21:11:52 +0000 (UTC)
Date:   Mon, 23 May 2022 21:11:52 +0000
From:   Julian Schroeder <jumaco@amazon.com>
To:     <stable@vger.kernel.org>
Subject: [PATCH] nfsd: destroy percpu stats counters after reply cache
 #5.11.0-rc5
Message-ID: <20220523211152.GB23843@dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-12.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Schroeder <jumaco@amazon.com>
Date: Fri, 20 May 2022 18:33:27 +0000
Subject: [PATCH] nfsd: destroy percpu stats counters after reply cache
 shutdown
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
        struct svc_cacherep     *rp;
        unsigned int i;
 
-       nfsd_reply_cache_stats_destroy(nn);
        unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
 
        for (i = 0; i < nn->drc_hashsize; i++) {
@@ -217,6 +216,7 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
                                                                        rp, nn);
                }
        }
+       nfsd_reply_cache_stats_destroy(nn);
 
        kvfree(nn->drc_hashtbl);
        nn->drc_hashtbl = NULL;
-- 
2.32.0

