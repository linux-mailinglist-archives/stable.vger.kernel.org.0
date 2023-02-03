Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A585C6895CC
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbjBCKUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbjBCKTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:19:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC55B918B7
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:19:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4F95B82A6E
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C119C433D2;
        Fri,  3 Feb 2023 10:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419554;
        bh=diPWlQb4+APV97XDRoCi+V0M9aY5NDxBDtIyxZuo6ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vboiHOtSIV8BZRj0r9oLP58+JqobQqnGQrznMhVNOUs965IK9bYWh6rebrUGqLO0o
         sflWcLgF6dQYcrMtkejMWbyp2zylQ+mkkFePY3xkTBQGzPJfRvrIC0k+s91CSF7AgK
         YOyq/AGFKTfDrnc8zs8j2+nukribpcmF8G5frZy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Natalia Petrova <n.petrova@fintech.ru>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 40/80] trace_events_hist: add check for return value of create_hist_field
Date:   Fri,  3 Feb 2023 11:12:34 +0100
Message-Id: <20230203101016.901638724@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Natalia Petrova <n.petrova@fintech.ru>

commit 8b152e9150d07a885f95e1fd401fc81af202d9a4 upstream.

Function 'create_hist_field' is called recursively at
trace_events_hist.c:1954 and can return NULL-value that's why we have
to check it to avoid null pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20230111120409.4111-1-n.petrova@fintech.ru

Cc: stable@vger.kernel.org
Fixes: 30350d65ac56 ("tracing: Add variable support to hist triggers")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2314,6 +2314,8 @@ static struct hist_field *create_hist_fi
 		unsigned long fl = flags & ~HIST_FIELD_FL_LOG2;
 		hist_field->fn = hist_field_log2;
 		hist_field->operands[0] = create_hist_field(hist_data, field, fl, NULL);
+		if (!hist_field->operands[0])
+			goto free;
 		hist_field->size = hist_field->operands[0]->size;
 		hist_field->type = kstrdup(hist_field->operands[0]->type, GFP_KERNEL);
 		if (!hist_field->type)


