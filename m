Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7C94CF75E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238294AbiCGJpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238197AbiCGJiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:38:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2621169CF9;
        Mon,  7 Mar 2022 01:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55AD660C7D;
        Mon,  7 Mar 2022 09:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4796CC340F4;
        Mon,  7 Mar 2022 09:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645526;
        bh=tC2F6x7TDUkqwS0UP/ZuZht6uZTAjPAdpKW7Sy5CtOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOOTYzUtVSWDiBpkoPUe6OQUb0CxD2MHvNrRYNm5IPJOhRrCl5DIHyjDQQi1fR5cj
         HWpRly9tlbNBjE/gUO4UAXfwfQuWBLhLOgQPR/3eHBxQMoORKElpzimfu+gpO6Wd5z
         KdsWXJaOL5fFmyvIwvf03JclCc1hMOZezvdVhfGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 5.10 058/105] sched/topology: Fix sched_domain_topology_level alloc in sched_init_numa()
Date:   Mon,  7 Mar 2022 10:19:01 +0100
Message-Id: <20220307091645.813251748@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


