Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411A35B2736
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 21:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiIHT5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 15:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiIHT5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 15:57:10 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16532EC746
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 12:57:07 -0700 (PDT)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E772B3F473
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 19:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1662667025;
        bh=IjQUSsBxUbXPPJNFF22vbeme4Du9WUP3ITpWdiHo7LQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=YaxURXPPOdwXFg5WS/yErfPg7MT3f3QxJG48+YXqJsD9CBfFc96LIBo4bUibWCfbv
         QpNN1FpXFYo1vJcrpgkjhbeJcd12mhoQp+EVGsN9F5DVF5Oi+Qpiwg46mJfnicx4KX
         eCyHZzqILqXkzQX18G57QqRoeseW9FUxqN46aVKbzvhdF7OH6HsH5pLmr5QnBtZbSw
         +5k2+oITQ4mooaDEzSpEMjFHxcPLbIn2MR8zq+wMmpd2tihmbeqSAsI61xnyDb18kR
         /EqerSPMsf89VAVtMTnys7SzpLrA3Lcn/GOgiCfIUWoOFfTCSFrx8PkBNilDrzQfpJ
         Q6dC5Fk4PDLrw==
Received: by mail-pf1-f198.google.com with SMTP id dc10-20020a056a0035ca00b0053870674be9so9811773pfb.12
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 12:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=IjQUSsBxUbXPPJNFF22vbeme4Du9WUP3ITpWdiHo7LQ=;
        b=7xQuyATb8PqHfcWTt4lGSYTRRvGZxqpKVxnYAMiPQSuztz9JMdl7r1QY7XS9znbH6Z
         E8bP1eWVUxcxCBLljqEm9ZLhltR7/hvQ/HHHZSJ/or3zatnsy/qDAcJwgYf01Bmj0iSI
         H1V6U393P2IYbbJQwxH+Z1RKk0yxe2x58iJb+HscSthU+B/8veRW+L1k5/8T5+co29ka
         gRiKeVHiXjLwCuSOPCy2I3Ej+TEjN5Pf9YWh/4ICekEMAqY00YSwBhzapJL7GNcmAI1Y
         HBh2fl1ho2xDPvLLfFYACykUs3RmrlZHm6Cx9ekByyq/3LE+AW3yVPQ9Ok2XagETbytn
         WHkQ==
X-Gm-Message-State: ACgBeo340Ox7jtHRUXYGHed5rgz4wdYANqQ9x1w+D9aYJnxLCc9xfau+
        OEtfFgpoC1PQ/AlVhrqJEFo+XIKnljX97YPhZbRZBhojaMyfbEjqt8tPb6g5ce4J9FFSYJdJC6g
        F9p0GYyJmFo7MhT6toEThJZ5FC8jThDRCeg==
X-Received: by 2002:a05:6a00:240f:b0:52e:f99d:1157 with SMTP id z15-20020a056a00240f00b0052ef99d1157mr10582684pfh.70.1662667024592;
        Thu, 08 Sep 2022 12:57:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7YTQwu3f3HJ09pUt9QA8K0CNoK2ivN2WNkdRX8POovQL8ka4MifEcHDoLIR+Cswp5vSmWV2Q==
X-Received: by 2002:a05:6a00:240f:b0:52e:f99d:1157 with SMTP id z15-20020a056a00240f00b0052ef99d1157mr10582672pfh.70.1662667024360;
        Thu, 08 Sep 2022 12:57:04 -0700 (PDT)
Received: from luke-ubuntu.buildd (cpe-75-80-146-43.san.res.rr.com. [75.80.146.43])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902684900b00172f6726d8esm14863255pln.277.2022.09.08.12.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 12:57:03 -0700 (PDT)
From:   Luke Nowakowski-Krijger <luke.nowakowskikrijger@canonical.com>
To:     kernel-team@lists.ubuntu.com, nicolas.dichtel@6wind.com
Cc:     stable@vger.kernel.org, kernel test robot <yujie.liu@intel.com>,
        Heng Qi <hengqi@linux.alibaba.com>,
        David Ahern <dsahern@kernel.org>
Subject: [SRU][F][J][PATCH 2/3] ip: fix triggering of 'icmp redirect'
Date:   Thu,  8 Sep 2022 12:56:21 -0700
Message-Id: <564805b92b9972181e66419e69bbcfb5359e3a5f.1662666093.git.luke.nowakowskikrijger@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1662666093.git.luke.nowakowskikrijger@canonical.com>
References: <cover.1662666093.git.luke.nowakowskikrijger@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

BugLink: https://bugs.launchpad.net/bugs/1988809

__mkroute_input() uses fib_validate_source() to trigger an icmp redirect.
My understanding is that fib_validate_source() is used to know if the src
address and the gateway address are on the same link. For that,
fib_validate_source() returns 1 (same link) or 0 (not the same network).
__mkroute_input() is the only user of these positive values, all other
callers only look if the returned value is negative.

Since the below patch, fib_validate_source() didn't return anymore 1 when
both addresses are on the same network, because the route lookup returns
RT_SCOPE_LINK instead of RT_SCOPE_HOST. But this is, in fact, right.
Let's adapat the test to return 1 again when both addresses are on the same
link.

CC: stable@vger.kernel.org
Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
Reported-by: kernel test robot <yujie.liu@intel.com>
Reported-by: Heng Qi <hengqi@linux.alibaba.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220829100121.3821-1-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry-picked from commit eb55dc09b5dd040232d5de32812cc83001a23da6)
Signed-off-by: Luke Nowakowski-Krijger <luke.nowakowskikrijger@canonical.com>
---
 net/ipv4/fib_frontend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index ef3e7a3e3a29e..d38c8ca93ba09 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -399,7 +399,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	dev_match = dev_match || (res.type == RTN_LOCAL &&
 				  dev == net->loopback_dev);
 	if (dev_match) {
-		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
+		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
 		return ret;
 	}
 	if (no_addr)
@@ -411,7 +411,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	ret = 0;
 	if (fib_lookup(net, &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE) == 0) {
 		if (res.type == RTN_UNICAST)
-			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
+			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
 	}
 	return ret;
 
-- 
2.34.1

