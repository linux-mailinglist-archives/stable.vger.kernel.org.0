Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEF64CE5F7
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 17:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiCEQpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 11:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCEQpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 11:45:43 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5357E972E8
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 08:44:53 -0800 (PST)
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 09FF73F61F
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646498692;
        bh=91gUovgwKJ5DLGOHRuVyw9SD+EFQtKrhfPdgvnBGTeA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=usreoN8yAmyA3nqIQ7WWm1lNWcqqkIKc7Ri5518m4Ir3tJQu75ly951vyDrDNmojV
         sgGI3rtpBKyIkjJom1rA922sK12p6tcry/7IX2aCPHt3Ooha5QaQvto13YVL17E9Hl
         ru4TNsN/1DX/5K/VdkPGlC5ac5cGj21+q8GKEInoHG/6R/7Vefx2O0d9yaige0N+Pr
         JGUHxheABo1a28FBnbn0kViCDlg9vy6lc/JpCyWuEW5LZH9EsORvYYhzIwFhibImSv
         WYuho0i0Xbcv28vbX22TfqaR/0tdmKtBFQdjDC/v3fxZ/i9T3R/qwoes2e4/dS93tn
         zSoRhKias9crg==
Received: by mail-il1-f198.google.com with SMTP id x6-20020a923006000000b002bea39c3974so7612723ile.12
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 08:44:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=91gUovgwKJ5DLGOHRuVyw9SD+EFQtKrhfPdgvnBGTeA=;
        b=ueiCBoP8W7K1eJMSooxybxXA0MQznvJHcm0HPiRskI8Y2woXyl+ZRDSdUN+syQQn1g
         XBWDGuCTObixdyaJU+86cq5swPF206T5eYbQU3ZN8xOfY3tDLC9JoUts4BYVIs7rlxeE
         tP005oTxZnrNY1FOv387jGddfCntGrHE1kdmFt3mfZmH52c3BjQbRWyc7uNVhtFpEuOj
         2MIAcdALj2vQSrIZIIIXOpijRKAY6lwktCh8icPKT5hXr1/J0MBaUIJZ75Wmtkwyts9u
         5i+6YKN90JVw3Sh0fq+FQoqFv1d5UmjQ6Vjj+S+0jz19KF/NVGuMAwrJxtFr7XC7Qikd
         JQkg==
X-Gm-Message-State: AOAM532edEF2+p8k2E/9AcIldxaK5ioLJls876RnhWdKOmjI5GJimJm7
        qb+8IcNxwhS0Cu9FOEJqXmbd+0VKam6fb1UU7ognNArsJjc8Sq74WQZsrPuyWJbuFN9kLhtyOuC
        r+75pZ8ZKcOlqNGKPzgJ8LSsP+kJSRtzNDQ==
X-Received: by 2002:a02:cb5c:0:b0:317:201a:951f with SMTP id k28-20020a02cb5c000000b00317201a951fmr3825307jap.181.1646498686253;
        Sat, 05 Mar 2022 08:44:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwRFXjul4I4nIVFRDhogQAm7luLzvS/w2BGIN3Tb5DEuZraXitlL7FY9u4UBfBITIIEZYXWFg==
X-Received: by 2002:a02:cb5c:0:b0:317:201a:951f with SMTP id k28-20020a02cb5c000000b00317201a951fmr3825284jap.181.1646498686049;
        Sat, 05 Mar 2022 08:44:46 -0800 (PST)
Received: from localhost (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id m7-20020a056e02158700b002c61541edd7sm4011274ilu.3.2022.03.05.08.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 08:44:44 -0800 (PST)
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org
Cc:     Miao Xie <miaox@cn.fujitsu.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Anatoly Pugachev <matorola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.10+5.4 2/3] sched/topology: Fix sched_domain_topology_level alloc in sched_init_numa()
Date:   Sat,  5 Mar 2022 09:44:29 -0700
Message-Id: <20220305164430.245125-3-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220305164430.245125-1-dann.frazier@canonical.com>
References: <20220305164430.245125-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

commit 71e5f6644fb2f3304fcb310145ded234a37e7cc1 upstream.

Commit "sched/topology: Make sched_init_numa() use a set for the
deduplicating sort" allocates 'i + nr_levels (level)' instead of
'i + nr_levels + 1' sched_domain_topology_level.

This led to an Oops (on Arm64 juno with CONFIG_SCHED_DEBUG):

sched_init_domains
  build_sched_domains()
    __free_domain_allocs()
      __sdt_free() {
	...
        for_each_sd_topology(tl)
	  ...
          sd = *per_cpu_ptr(sdd->sd, j); <--
	  ...
      }

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Barry Song <song.bao.hua@hisilicon.com>
Link: https://lkml.kernel.org/r/6000e39e-7d28-c360-9cd6-8798fd22a9bf@arm.com
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 kernel/sched/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index f2951eba9592..ff2c6d3ba6c7 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1655,7 +1655,7 @@ void sched_init_numa(void)
 	/* Compute default topology size */
 	for (i = 0; sched_domain_topology[i].mask; i++);
 
-	tl = kzalloc((i + nr_levels) *
+	tl = kzalloc((i + nr_levels + 1) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
-- 
2.25.1

