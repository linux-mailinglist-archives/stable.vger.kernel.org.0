Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA8254EF97
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 05:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiFQDcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 23:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiFQDcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 23:32:53 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A641F630;
        Thu, 16 Jun 2022 20:32:52 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 25H3WPV90009121, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 25H3WPV90009121
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Jun 2022 11:32:25 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 17 Jun 2022 11:32:25 +0800
Received: from localhost.localdomain (172.21.177.191) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 17 Jun 2022 11:32:25 +0800
From:   Edward Wu <edwardwu@realtek.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Edward Wu <edwardwu@realtek.com>, Tejun Heo <tj@kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>
Subject: [PATCH v4] ata: libata: add qc->flags in ata_qc_complete_template tracepoint
Date:   Fri, 17 Jun 2022 11:32:20 +0800
Message-ID: <20220617033221.22049-1-edwardwu@realtek.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220616001615.11636-1-edwardwu@realtek.com>
References: <20220616001615.11636-1-edwardwu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.177.191]
X-ClientProxiedBy: RTEXH36504.realtek.com.tw (172.21.6.27) To
 RTEXMBS03.realtek.com.tw (172.21.6.96)
X-KSE-ServerInfo: RTEXMBS03.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/17/2022 03:22:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzYvMTcgpFekyCAwMToxMjowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add flags value to check the result of ata completion

Fixes: 255c03d15a29 ("libata: Add tracepoints")
Cc: stable@vger.kernel.org
Signed-off-by: Edward Wu <edwardwu@realtek.com>
---
Fixed, thanks again

 include/trace/events/libata.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/trace/events/libata.h b/include/trace/events/libata.h
index d4e631aa976f..6025dd8ba4aa 100644
--- a/include/trace/events/libata.h
+++ b/include/trace/events/libata.h
@@ -288,6 +288,7 @@ DECLARE_EVENT_CLASS(ata_qc_complete_template,
 		__entry->hob_feature	= qc->result_tf.hob_feature;
 		__entry->nsect		= qc->result_tf.nsect;
 		__entry->hob_nsect	= qc->result_tf.hob_nsect;
+		__entry->flags		= qc->flags;
 	),
 
 	TP_printk("ata_port=%u ata_dev=%u tag=%d flags=%s status=%s " \
-- 
2.17.1

