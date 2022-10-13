Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B585FD083
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiJMA1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiJMA0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:26:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AFD17AB0;
        Wed, 12 Oct 2022 17:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6616FB81CE8;
        Thu, 13 Oct 2022 00:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D269C433D7;
        Thu, 13 Oct 2022 00:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620593;
        bh=AovMnUVFaDgnuucVmCvW2YnL6/FL1thsQNXgFxRaPiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBrSB6+QDnx0GPCZO9sGNP+4HCZuI2t+ohfvNUL4InIsMw8PUW/F2aAVtGcOKoZrq
         XBugzMYVOSV1QdByNw8raNA8TJ5de9Khb0f2p/4cfSQF0QQdY5vcHyfiFZGGQ13lqm
         rhNz9s0T0ESdBjPcxPyic4wtQHq2F5lTIF847ZLfjQKv4osEJTq/rOwSKCZAI+P9cw
         Pyv7FOJ9isp5Rlj3pnEuqxfkX+EKAfWc+5ncp2nQdlJwegyp48ttA/DJI/C9JmLeb4
         m+I24ADz74J2F/Z9xoALAu4xHPOSzrWDFdw3BaHaaEr5ZeQs0qdHotDhjiKI8yRuRs
         94ekwlYyISF8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>, kernel test robot <lkp@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, mhiramat@kernel.org
Subject: [PATCH AUTOSEL 5.15 39/47] scsi: tracing: Fix compile error in trace_array calls when TRACING is disabled
Date:   Wed, 12 Oct 2022 20:21:14 -0400
Message-Id: <20221013002124.1894077-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 1a77dd1c2bb5d4a58c16d198cf593720787c02e4 ]

Fix this compilation error seen when CONFIG_TRACING is not enabled:

drivers/scsi/qla2xxx/qla_os.c: In function 'qla_trace_init':
drivers/scsi/qla2xxx/qla_os.c:2854:25: error: implicit declaration of function
'trace_array_get_by_name'; did you mean 'trace_array_set_clr_event'?
[-Werror=implicit-function-declaration]
 2854 |         qla_trc_array = trace_array_get_by_name("qla2xxx");
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         trace_array_set_clr_event

drivers/scsi/qla2xxx/qla_os.c: In function 'qla_trace_uninit':
drivers/scsi/qla2xxx/qla_os.c:2869:9: error: implicit declaration of function
'trace_array_put' [-Werror=implicit-function-declaration]
 2869 |         trace_array_put(qla_trc_array);
      |         ^~~~~~~~~~~~~~~

Link: https://lore.kernel.org/r/20220907233308.4153-2-aeasi@marvell.com
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace.h | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/linux/trace.h b/include/linux/trace.h
index bf169612ffe1..b5e16e438448 100644
--- a/include/linux/trace.h
+++ b/include/linux/trace.h
@@ -2,8 +2,6 @@
 #ifndef _LINUX_TRACE_H
 #define _LINUX_TRACE_H
 
-#ifdef CONFIG_TRACING
-
 #define TRACE_EXPORT_FUNCTION	BIT(0)
 #define TRACE_EXPORT_EVENT	BIT(1)
 #define TRACE_EXPORT_MARKER	BIT(2)
@@ -28,6 +26,8 @@ struct trace_export {
 	int flags;
 };
 
+#ifdef CONFIG_TRACING
+
 int register_ftrace_export(struct trace_export *export);
 int unregister_ftrace_export(struct trace_export *export);
 
@@ -48,6 +48,38 @@ void osnoise_arch_unregister(void);
 void osnoise_trace_irq_entry(int id);
 void osnoise_trace_irq_exit(int id, const char *desc);
 
+#else /* CONFIG_TRACING */
+static inline int register_ftrace_export(struct trace_export *export)
+{
+	return -EINVAL;
+}
+static inline int unregister_ftrace_export(struct trace_export *export)
+{
+	return 0;
+}
+static inline void trace_printk_init_buffers(void)
+{
+}
+static inline int trace_array_printk(struct trace_array *tr, unsigned long ip,
+				     const char *fmt, ...)
+{
+	return 0;
+}
+static inline int trace_array_init_printk(struct trace_array *tr)
+{
+	return -EINVAL;
+}
+static inline void trace_array_put(struct trace_array *tr)
+{
+}
+static inline struct trace_array *trace_array_get_by_name(const char *name)
+{
+	return NULL;
+}
+static inline int trace_array_destroy(struct trace_array *tr)
+{
+	return 0;
+}
 #endif	/* CONFIG_TRACING */
 
 #endif	/* _LINUX_TRACE_H */
-- 
2.35.1

