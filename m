Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6656431E2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiLETVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiLETVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:21:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BD92A70B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:17:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 223716130C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33064C433D6;
        Mon,  5 Dec 2022 19:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267807;
        bh=+hMuTk58TiXrV3C2zCt/3t7SPsVhb5d1obzQSw/eGsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEimsSngk7fK89Pk8tlO3j54EJ0H5MG5mrQ/ZIpoNuynIApM1PD8y86J9+uvA5fQj
         b5rLyfY66vqVVOavF0HkCoKaTpqFNJ4n4ekFShfVuuclCTkjJSE2mEu5FsDmVX3tD6
         okGMWSc+pPekv3J2j9j5tEWevEbPOoqYRivMsp3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 59/77] perf: Add sample_flags to indicate the PMU-filled sample data
Date:   Mon,  5 Dec 2022 20:09:50 +0100
Message-Id: <20221205190802.951152249@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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

[ Upstream commit 3aac580d5cc3001ca1627725b3b61edb529f341d ]

On some platforms, some data e.g., timestamps, can be retrieved from
the PMU driver. Usually, the data from the PMU driver is more accurate.
The current perf kernel should output the PMU-filled sample data if
it's available.

To check the availability of the PMU-filled sample data, the current
perf kernel initializes the related fields in the
perf_sample_data_init(). When outputting a sample, the perf checks
whether the field is updated by the PMU driver. If yes, the updated
value will be output. If not, the perf uses an SW way to calculate the
value or just outputs the initialized value if an SW way is unavailable
either.

With more and more data being provided by the PMU driver, more fields
has to be initialized in the perf_sample_data_init(). That will
increase the number of cache lines touched in perf_sample_data_init()
and be harmful to the performance.

Add new "sample_flags" to indicate the PMU-filled sample data. The PMU
driver should set the corresponding PERF_SAMPLE_ flag when the field is
updated. The initialization of the corresponding field is not required
anymore. The following patches will make use of it and remove the
corresponding fields from the perf_sample_data_init(), which will
further minimize the number of cache lines touched.

Only clear the sample flags that have already been done by the PMU
driver in the perf_prepare_sample() for the PERF_RECORD_SAMPLE. For the
other PERF_RECORD_ event type, the sample data is not available.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220901130959.1285717-2-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h |  2 ++
 kernel/events/core.c       | 17 +++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 41a3307a971c..5efd8109ad0a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -899,6 +899,7 @@ struct perf_sample_data {
 	 * Fields set by perf_sample_data_init(), group so as to
 	 * minimize the cachelines touched.
 	 */
+	u64				sample_flags;
 	u64				addr;
 	struct perf_raw_record		*raw;
 	struct perf_branch_stack	*br_stack;
@@ -950,6 +951,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 					 u64 addr, u64 period)
 {
 	/* remaining struct members initialized in perf_prepare_sample() */
+	data->sample_flags = 0;
 	data->addr = addr;
 	data->raw  = NULL;
 	data->br_stack = NULL;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2ad8acff03db..7ad142a5327e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5767,11 +5767,10 @@ perf_output_sample_ustack(struct perf_output_handle *handle, u64 dump_size,
 
 static void __perf_event_header__init_id(struct perf_event_header *header,
 					 struct perf_sample_data *data,
-					 struct perf_event *event)
+					 struct perf_event *event,
+					 u64 sample_type)
 {
-	u64 sample_type = event->attr.sample_type;
-
-	data->type = sample_type;
+	data->type = event->attr.sample_type;
 	header->size += event->id_header_size;
 
 	if (sample_type & PERF_SAMPLE_TID) {
@@ -5800,7 +5799,7 @@ void perf_event_header__init_id(struct perf_event_header *header,
 				struct perf_event *event)
 {
 	if (event->attr.sample_id_all)
-		__perf_event_header__init_id(header, data, event);
+		__perf_event_header__init_id(header, data, event, event->attr.sample_type);
 }
 
 static void __perf_event__output_id_sample(struct perf_output_handle *handle,
@@ -6148,6 +6147,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 			 struct pt_regs *regs)
 {
 	u64 sample_type = event->attr.sample_type;
+	u64 filtered_sample_type;
 
 	header->type = PERF_RECORD_SAMPLE;
 	header->size = sizeof(*header) + event->header_size;
@@ -6155,7 +6155,12 @@ void perf_prepare_sample(struct perf_event_header *header,
 	header->misc = 0;
 	header->misc |= perf_misc_flags(regs);
 
-	__perf_event_header__init_id(header, data, event);
+	/*
+	 * Clear the sample flags that have already been done by the
+	 * PMU driver.
+	 */
+	filtered_sample_type = sample_type & ~data->sample_flags;
+	__perf_event_header__init_id(header, data, event, filtered_sample_type);
 
 	if (sample_type & PERF_SAMPLE_IP)
 		data->ip = perf_instruction_pointer(regs);
-- 
2.35.1



