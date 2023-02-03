Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A8468A236
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 19:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjBCSrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 13:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjBCSrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 13:47:49 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1812FA07E1
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675450068; x=1706986068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PqSj1C/8oTESJmvPh1elOP7/1b6NUKtXs2i+6fzNGmA=;
  b=NYnJH+emZraD7/hO1KN3DjMEl4K8ivc4dJQ67wzIBaRHqvagD7k5GZih
   bi+P+t/Bnr+DzEESCi8SLoNNLYdZx3f0i42a5OqUHfoJb4/j7yV/LEcN9
   XQJ9hde+8vut2i6TPEeAPHtoeC5l9Vo2haQrhrmufZXJ+2UkC1MRR5n+z
   g=;
X-IronPort-AV: E=Sophos;i="5.97,271,1669075200"; 
   d="scan'208";a="295182090"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 18:47:47 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com (Postfix) with ESMTPS id A714A43932;
        Fri,  3 Feb 2023 18:47:45 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Fri, 3 Feb 2023 18:47:44 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.162.56)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Fri, 3 Feb 2023 18:47:44 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <dsahern@kernel.org>, <idosch@nvidia.com>, <kuba@kernel.org>,
        <patches@lists.linux.dev>, <sashal@kernel.org>,
        <stable@vger.kernel.org>, Shaoying Xu <shaoyi@amazon.com>
Subject: Re: [PATCH 5.4 60/67] ipv4: Fix incorrect route flushing when source address is deleted
Date:   Fri, 3 Feb 2023 18:47:29 +0000
Message-ID: <20230203184729.30269-1-shaoyi@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130920.482075438@linuxfoundation.org>
References: <20221212130920.482075438@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D41UWC002.ant.amazon.com (10.43.162.127) To
 EX19D046UWB004.ant.amazon.com (10.13.139.164)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, 

It seems this patch deletes the whole fib_tests.sh that causes new
failure in kselftests run. Looking at the upstream patch [1] and given the
context that ipv4_del_addr test is not available to kernel 5.4, I
updated the patch like attached below to resolve the potentail mistake.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=f96a3d74554df537b6db5c99c27c80e7afadc8d1

Thanks,
Shaoying

================================ >8 ===========================================

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 908913d75847..f45b9daf62cf 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -420,6 +420,7 @@ static struct fib_info *fib_find_info(struct fib_info *nfi)
                    nfi->fib_prefsrc == fi->fib_prefsrc &&
                    nfi->fib_priority == fi->fib_priority &&
                    nfi->fib_type == fi->fib_type &&
+                   nfi->fib_tb_id == fi->fib_tb_id &&
                    memcmp(nfi->fib_metrics, fi->fib_metrics,
                           sizeof(u32) * RTAX_MAX) == 0 &&
                    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&
