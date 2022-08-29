Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC335A4949
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiH2LWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiH2LVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:21:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED556E899;
        Mon, 29 Aug 2022 04:14:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6D1061211;
        Mon, 29 Aug 2022 11:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6645C433C1;
        Mon, 29 Aug 2022 11:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771648;
        bh=6Ltr5qBukKjhhHTvLgKNizGlEkxMiV2rNVMmQfGMDXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5Kv5ADIdIqJYWi0ozU6HfuHHUCpvppVCo0iJCpkMFz1YAokjGWbSuVzFvZyq95jP
         v64rpoLujfpWkwlKmwoAMRdQnpvIueeVZaUc2o+eRCwlXAwHqN6VyfDxPv9Ooj1eSK
         qgJQdndKwLU0aisNls/nUydeV05m7JbZ7gK6A0xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 132/136] perf/x86/intel/ds: Fix precise store latency handling
Date:   Mon, 29 Aug 2022 12:59:59 +0200
Message-Id: <20220829105810.112913670@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

commit d4bdb0bebc5ba3299d74f123c782d99cd4e25c49 upstream.

With the existing code in store_latency_data(), the memory operation (mem_op)
returned to the user is always OP_LOAD where in fact, it should be OP_STORE.
This comes from the fact that the function is simply grabbing the information
from a data source map which covers only load accesses. Intel 12th gen CPU
offers precise store sampling that captures both the data source and latency.
Therefore it can use the data source mapping table but must override the
memory operation to reflect stores instead of loads.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220818054613.1548130-1-eranian@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -236,6 +236,7 @@ static u64 load_latency_data(u64 status)
 static u64 store_latency_data(u64 status)
 {
 	union intel_x86_pebs_dse dse;
+	union perf_mem_data_src src;
 	u64 val;
 
 	dse.val = status;
@@ -263,7 +264,14 @@ static u64 store_latency_data(u64 status
 
 	val |= P(BLK, NA);
 
-	return val;
+	/*
+	 * the pebs_data_source table is only for loads
+	 * so override the mem_op to say STORE instead
+	 */
+	src.val = val;
+	src.mem_op = P(OP,STORE);
+
+	return src.val;
 }
 
 struct pebs_record_core {


