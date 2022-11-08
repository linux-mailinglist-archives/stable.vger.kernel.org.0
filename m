Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24C1621411
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiKHN5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiKHN5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:57:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A039965E6F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:57:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C91D6157B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48423C433D6;
        Tue,  8 Nov 2022 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915820;
        bh=Cvpo5tVYOFYnMN7BMyp+dKqYFzw1vqodvVjqDbaK69w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohFxXUV5RCD0wQw7ujG4upvm5FRdbSBA4/2IxKpUj1watJiTjaRRlzo5zngiUFLBG
         R9Qe/F1DdZMoWkSN3pM7dvvGnew8+mvaAJGvEqpjuzfZ5moqRu7ELcHQUanw/IgR6C
         AUd7BPZ2HcGcQ+LXa4pJq4wODzT2TmYlTRA+DhYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 100/118] perf/x86/intel: Add Cooper Lake stepping to isolation_ucodes[]
Date:   Tue,  8 Nov 2022 14:39:38 +0100
Message-Id: <20221108133345.074415860@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 6f8faf471446844bb9c318e0340221049d5c19f4 upstream.

The intel_pebs_isolation quirk checks both model number and stepping.
Cooper Lake has a different stepping (11) than the other Skylake Xeon.
It cannot benefit from the optimization in commit 9b545c04abd4f
("perf/x86/kvm: Avoid unnecessary work in guest filtering").

Add the stepping of Cooper Lake into the isolation_ucodes[] table.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221031154550.571663-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4412,6 +4412,7 @@ static const struct x86_cpu_desc isolati
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 5, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 6, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 7, 0x00000000),
+	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		11, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_L,		 3, 0x0000007c),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE,		 3, 0x0000007c),
 	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE,		 9, 0x0000004e),


