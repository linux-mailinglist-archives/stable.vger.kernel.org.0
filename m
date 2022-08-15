Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1F3595187
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbiHPE6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbiHPE6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:58:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629D1BC82E;
        Mon, 15 Aug 2022 13:51:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D57C7B811A6;
        Mon, 15 Aug 2022 20:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10096C433C1;
        Mon, 15 Aug 2022 20:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596707;
        bh=HubnvPKLK/24iZKT7eHbcqFhZULylH0KNpVFqRjJCys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QERzGDnUWg6myrFkl76uG3qCBwKXTf5W/I0pOvRd4kdU2mUXLDB3SPfiTfLkQFZ6q
         e4TNkvchVfVrWG//1fZW+kVdw/fGODHks7erGpJwyGUZeNzOVEaruXiOpMaW5Y/+55
         fFq5tCW1MKe/4kBblIhcWYhcjGHYjwitaoD3pL/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 1152/1157] tracing: Use a copy of the va_list for __assign_vstr()
Date:   Mon, 15 Aug 2022 20:08:28 +0200
Message-Id: <20220815180526.618951842@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 3a2dcbaf4d31023106975d6ae75b6df080c454cb upstream.

If an instance of tracing enables the same trace event as another
instance, or the top level instance, or even perf, then the va_list passed
into some tracepoints can be used more than once.

As va_list can only be traversed once, this can cause issues:

 # cat /sys/kernel/tracing/instances/qla2xxx/trace
             cat-56106   [012] ..... 2419873.470098: ql_dbg_log: qla2xxx [0000:05:00.0]-1054:14:  Entered (null).
             cat-56106   [012] ..... 2419873.470101: ql_dbg_log: qla2xxx [0000:05:00.0]-1000:14:  Entered ×+<96>²Ü<98>^H.
             cat-56106   [012] ..... 2419873.470102: ql_dbg_log: qla2xxx [0000:05:00.0]-1006:14:  Prepare to issue mbox cmd=0xde589000.

 # cat /sys/kernel/tracing/trace
             cat-56106   [012] ..... 2419873.470097: ql_dbg_log: qla2xxx [0000:05:00.0]-1054:14:  Entered qla2x00_get_firmware_state.
             cat-56106   [012] ..... 2419873.470100: ql_dbg_log: qla2xxx [0000:05:00.0]-1000:14:  Entered qla2x00_mailbox_command.
             cat-56106   [012] ..... 2419873.470102: ql_dbg_log: qla2xxx [0000:05:00.0]-1006:14:  Prepare to issue mbox cmd=0x69.

The instance version is corrupted because the top level instance iterated
the va_list first.

Use va_copy() in the __assign_vstr() macro to make sure that each trace
event for each use case gets a fresh va_list.

Link: https://lore.kernel.org/all/259d53a5-958e-6508-4e45-74dba2821242@marvell.com/
Link: https://lkml.kernel.org/r/20220719182004.21daa83e@gandalf.local.home

Fixes: 0563231f93c6d ("tracing/events: Add __vstring() and __assign_vstr() helper macros")
Reported-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/stages/stage6_event_callback.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/trace/stages/stage6_event_callback.h
+++ b/include/trace/stages/stage6_event_callback.h
@@ -40,7 +40,12 @@
 
 #undef __assign_vstr
 #define __assign_vstr(dst, fmt, va)					\
-	vsnprintf(__get_str(dst), TRACE_EVENT_STR_MAX, fmt, *(va))
+	do {								\
+		va_list __cp_va;					\
+		va_copy(__cp_va, *(va));				\
+		vsnprintf(__get_str(dst), TRACE_EVENT_STR_MAX, fmt, __cp_va); \
+		va_end(__cp_va);					\
+	} while (0)
 
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)


