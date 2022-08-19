Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB1C59A527
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353533AbiHSQmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353548AbiHSQkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:40:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CAFD5DFF;
        Fri, 19 Aug 2022 09:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E43E0617F2;
        Fri, 19 Aug 2022 16:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012AFC433C1;
        Fri, 19 Aug 2022 16:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925310;
        bh=SmZYZEpOelWUIJG7oTgTHs2s9xh0YRCxcCr5ctiy6do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xrll6Zp/lM7tnaCxBo795t7fuXOTTgVadqfPozh6+PwPg7lIvkrA/ssG+AbYkXwxA
         U7fAXu7mhOOGXpzffGslBrOumtvUkLP7aPrTjb144LJQ9IFgEMusM7DwaORl9n58tX
         Kbm1xfDzJkHaYOnAndCs7RrJeULhEdgQhtf/P76g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        David Collins <quic_collinsd@quicinc.com>
Subject: [PATCH 5.10 451/545] spmi: trace: fix stack-out-of-bound access in SPMI tracing functions
Date:   Fri, 19 Aug 2022 17:43:41 +0200
Message-Id: <20220819153849.598164839@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: David Collins <quic_collinsd@quicinc.com>

commit 2af28b241eea816e6f7668d1954f15894b45d7e3 upstream.

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
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: David Collins <quic_collinsd@quicinc.com>
Link: https://lore.kernel.org/r/20220627235512.2272783-1-quic_collinsd@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/spmi.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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


