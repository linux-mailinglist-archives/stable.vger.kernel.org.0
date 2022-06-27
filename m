Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467CA55DC35
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240872AbiF0Xz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 19:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbiF0Xz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 19:55:58 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875EF186E7;
        Mon, 27 Jun 2022 16:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656374157; x=1687910157;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rq/4gEVKFpg5ay0+GYJpcJLfsj+qRRQffLwqTvVaOEs=;
  b=MXIHmMizfzvBr8uPqhS7UiuhmsNYM3ZFizOpOI+m2FpnA94bEJHZJhwI
   zBku+iiR7bzlrEoxi1dqH312+G2UO5qDgBzaa3LUPIQ/7OMUSGVEYyevO
   EzAE/qssrxVR3j1vGZOE8u02JCWPqY8TYPCbwFdJFlx7ZXjuoHC3rg6cI
   Y=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 27 Jun 2022 16:55:56 -0700
X-QCInternal: smtphost
Received: from nasanex01b.na.qualcomm.com ([10.46.141.250])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 16:55:56 -0700
Received: from hu-collinsd-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 27 Jun 2022 16:55:56 -0700
From:   David Collins <quic_collinsd@quicinc.com>
To:     Stephen Boyd <sboyd@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
CC:     David Collins <quic_collinsd@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>,
        Ankit Gupta <ankgupta@codeaurora.org>,
        "Gilad Avidov" <gavidov@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] spmi: trace: fix stack-out-of-bound access in SPMI tracing functions
Date:   Mon, 27 Jun 2022 16:55:12 -0700
Message-ID: <20220627235512.2272783-1-quic_collinsd@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

trace_spmi_write_begin() and trace_spmi_read_end() both call
memcpy() with a length of "len + 1".  This leads to one extra
byte being read beyond the end of the specified buffer.  Fix
this out-of-bound memory access by using a length of "len"
instead.

Here is a KASAN log showing the issue:

BUG: KASAN: stack-out-of-bounds in trace_event_raw_event_spmi_read_end+0x1d0/0x234
Read of size 2 at addr ffffffc0265b7540 by task thermal@2.0-ser/1314
...
Call trace:
 dump_backtrace+0x0/0x3e8
 show_stack+0x2c/0x3c
 dump_stack_lvl+0xdc/0x11c
 print_address_description+0x74/0x384
 kasan_report+0x188/0x268
 kasan_check_range+0x270/0x2b0
 memcpy+0x90/0xe8
 trace_event_raw_event_spmi_read_end+0x1d0/0x234
 spmi_read_cmd+0x294/0x3ac
 spmi_ext_register_readl+0x84/0x9c
 regmap_spmi_ext_read+0x144/0x1b0 [regmap_spmi]
 _regmap_raw_read+0x40c/0x754
 regmap_raw_read+0x3a0/0x514
 regmap_bulk_read+0x418/0x494
 adc5_gen3_poll_wait_hs+0xe8/0x1e0 [qcom_spmi_adc5_gen3]
 ...
 __arm64_sys_read+0x4c/0x60
 invoke_syscall+0x80/0x218
 el0_svc_common+0xec/0x1c8
 ...

addr ffffffc0265b7540 is located in stack of task thermal@2.0-ser/1314 at offset 32 in frame:
 adc5_gen3_poll_wait_hs+0x0/0x1e0 [qcom_spmi_adc5_gen3]

this frame has 1 object:
 [32, 33) 'status'

Memory state around the buggy address:
 ffffffc0265b7400: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
 ffffffc0265b7480: 04 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
>ffffffc0265b7500: 00 00 00 00 f1 f1 f1 f1 01 f3 f3 f3 00 00 00 00
                                           ^
 ffffffc0265b7580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffc0265b7600: f1 f1 f1 f1 01 f2 07 f2 f2 f2 01 f3 00 00 00 00
==================================================================

Fixes: a9fce374815d ("spmi: add command tracepoints for SPMI")
Cc: stable@vger.kernel.org
Signed-off-by: David Collins <quic_collinsd@quicinc.com>
---
 include/trace/events/spmi.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/spmi.h b/include/trace/events/spmi.h
index 8b60efe18ba6..a6819fd85cdf 100644
--- a/include/trace/events/spmi.h
+++ b/include/trace/events/spmi.h
@@ -21,15 +21,15 @@ TRACE_EVENT(spmi_write_begin,
 		__field		( u8,         sid       )
 		__field		( u16,        addr      )
 		__field		( u8,         len       )
-		__dynamic_array	( u8,   buf,  len + 1   )
+		__dynamic_array	( u8,   buf,  len       )
 	),
 
 	TP_fast_assign(
 		__entry->opcode = opcode;
 		__entry->sid    = sid;
 		__entry->addr   = addr;
-		__entry->len    = len + 1;
-		memcpy(__get_dynamic_array(buf), buf, len + 1);
+		__entry->len    = len;
+		memcpy(__get_dynamic_array(buf), buf, len);
 	),
 
 	TP_printk("opc=%d sid=%02d addr=0x%04x len=%d buf=0x[%*phD]",
@@ -92,7 +92,7 @@ TRACE_EVENT(spmi_read_end,
 		__field		( u16,        addr      )
 		__field		( int,        ret       )
 		__field		( u8,         len       )
-		__dynamic_array	( u8,   buf,  len + 1   )
+		__dynamic_array	( u8,   buf,  len       )
 	),
 
 	TP_fast_assign(
@@ -100,8 +100,8 @@ TRACE_EVENT(spmi_read_end,
 		__entry->sid    = sid;
 		__entry->addr   = addr;
 		__entry->ret    = ret;
-		__entry->len    = len + 1;
-		memcpy(__get_dynamic_array(buf), buf, len + 1);
+		__entry->len    = len;
+		memcpy(__get_dynamic_array(buf), buf, len);
 	),
 
 	TP_printk("opc=%d sid=%02d addr=0x%04x ret=%d len=%02d buf=0x[%*phD]",
-- 
2.25.1

