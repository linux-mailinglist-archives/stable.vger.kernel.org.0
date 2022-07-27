Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E8B582F09
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241766AbiG0RUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241987AbiG0RT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28A323153;
        Wed, 27 Jul 2022 09:44:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47B6D601C3;
        Wed, 27 Jul 2022 16:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F904C433D6;
        Wed, 27 Jul 2022 16:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940285;
        bh=YVIFpYhYR7TrLZMwL/dPwTtMcZHNQKpHAC6jaoFSOE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCXygaYp2/Uk88bluhUnpU30YOFnE8u855bFxaRqRIIXkkqMgLQQdODxM6+dNsRN8
         EuZTQV62mw/uZzses/8mgfutBj29nFAcFPn+IAfPDzeqBIMtXHtkayYfBBRYTImlxZ
         J/w78o+LqfogPx4UQ3txtMUD+1lBZtz7XXXKpIUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/201] tracing: Have event format check not flag %p* on __get_dynamic_array()
Date:   Wed, 27 Jul 2022 18:11:13 +0200
Message-Id: <20220727161034.837596500@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 499f12168aebd6da8fa32c9b7d6203ca9b5eb88d ]

The print fmt check against trace events to make sure that the format does
not use pointers that may be freed from the time of the trace to the time
the event is read, gives a false positive on %pISpc when reading data that
was saved in __get_dynamic_array() when it is perfectly fine to do so, as
the data being read is on the ring buffer.

Link: https://lore.kernel.org/all/20220407144524.2a592ed6@canb.auug.org.au/

Cc: stable@vger.kernel.org
Fixes: 5013f454a352c ("tracing: Add check of trace event print fmts for dereferencing pointers")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c072e8b9849c..ea3fbfa87fdd 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -407,7 +407,14 @@ static void test_event_printk(struct trace_event_call *call)
 				a = strchr(fmt + i, '&');
 				if ((a && (a < r)) || test_field(r, call))
 					dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_dynamic_array(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_sockaddr(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
 			}
+
 		next_arg:
 			i--;
 			arg++;
-- 
2.35.1



