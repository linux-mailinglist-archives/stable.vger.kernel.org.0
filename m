Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D907A54270F
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382554AbiFHBPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386291AbiFHAWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EACF1973CD;
        Tue,  7 Jun 2022 12:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1993061947;
        Tue,  7 Jun 2022 19:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207BDC385A2;
        Tue,  7 Jun 2022 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629610;
        bh=OcWhrdsFQIgNPCqf/QrOHTOvPgdXZMIducRNLcG6Qdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLrGoU6PjoTwR3dTsYNoD9AwMI3ydfIfW0JZ5OzAA0vYvKD7vWKs7TIB1UornFAFo
         PTntIuDaf5cHtE7xu4m4TG+TbemKtqz9a6kXo8eviCqwa1T3tkTGrVUEwPTCGmsoxI
         vEFxtCEqKYjOuJF33Yi9eJI4ghICZ+/etSFatbI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Gautam Menghani <gautammenghani201@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.18 752/879] tracing: Initialize integer variable to prevent garbage return value
Date:   Tue,  7 Jun 2022 19:04:30 +0200
Message-Id: <20220607165024.689097542@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gautam Menghani <gautammenghani201@gmail.com>

commit 154827f8e53d8c492b3fb0cb757fbcadb5d516b5 upstream.

Initialize the integer variable to 0 to fix the clang scan warning:
Undefined or garbage value returned to caller
[core.uninitialized.UndefReturn]
        return ret;

Link: https://lkml.kernel.org/r/20220522061826.1751-1-gautammenghani201@gmail.com

Cc: stable@vger.kernel.org
Fixes: 8993665abcce ("tracing/boot: Support multiple handlers for per-event histogram")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -300,7 +300,7 @@ trace_boot_hist_add_handlers(struct xbc_
 {
 	struct xbc_node *node;
 	const char *p, *handler;
-	int ret;
+	int ret = 0;
 
 	handler = xbc_node_get_data(hnode);
 


