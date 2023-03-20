Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235966C1928
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbjCTPbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjCTPav (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:30:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E7C32E78
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 769916154E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8684FC433D2;
        Mon, 20 Mar 2023 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325794;
        bh=8L9HVobar10FaUPDLvq+ib92Ii0zI2ClCJQU03fK3M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCqTXl/1uxNgT6Yuk0x3BHZAI76zA7Bly9y0tyfDyvFj/ut0NNjnkcMLZmCiqLaT+
         9/MCJ/Si49RpGh8ooRAaAx3IEjRMaAdy6pKL5F3gwKrg+tKQixlHAkjc2MQ3LzNQCO
         HcybZmiwkBrnECmiIuUFkb/+kSl07Q2kmzt+WYrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 144/198] tracing: Check field value in hist_field_name()
Date:   Mon, 20 Mar 2023 15:54:42 +0100
Message-Id: <20230320145513.590962566@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 9f116f76fa8c04c81aef33ad870dbf9a158e5b70 upstream.

The function hist_field_name() cannot handle being passed a NULL field
parameter. It should never be NULL, but due to a previous bug, NULL was
passed to the function and the kernel crashed due to a NULL dereference.
Mark Rutland reported this to me on IRC.

The bug was fixed, but to prevent future bugs from crashing the kernel,
check the field and add a WARN_ON() if it is NULL.

Link: https://lkml.kernel.org/r/20230302020810.762384440@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Mark Rutland <mark.rutland@arm.com>
Fixes: c6afad49d127f ("tracing: Add hist trigger 'sym' and 'sym-offset' modifiers")
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1330,6 +1330,9 @@ static const char *hist_field_name(struc
 {
 	const char *field_name = "";
 
+	if (WARN_ON_ONCE(!field))
+		return field_name;
+
 	if (level > 1)
 		return field_name;
 


