Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFC563575A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbiKWJl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237975AbiKWJlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:41:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83646E541
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:38:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB130B81EF0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA166C433C1;
        Wed, 23 Nov 2022 09:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196318;
        bh=h+OpAtOgLGyQkYlELTZvqT6dsEhDilPG4dDcccwImL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQaqRp2MlfzP7PxURn7jfljoGvH9VnTVTCFsSOVmu9BpvkOHq7BYTIwxOJ+KA4ym/
         X/cIxg71y7khszFFZ77zgsTMex+Vi/omjAvvIy72Tjpa1VEcu/uynLQLKVn8yM9QdW
         DXKt+oPfLSApXktQvBLMgbzNr/FrXLhEMoQHBMkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Aashish Sharma <shraash@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/181] tracing: Fix warning on variable struct trace_array
Date:   Wed, 23 Nov 2022 09:52:05 +0100
Message-Id: <20221123084609.346200226@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Aashish Sharma <shraash@google.com>

[ Upstream commit bedf06833b1f63c2627bd5634602e05592129d7a ]

Move the declaration of 'struct trace_array' out of #ifdef
CONFIG_TRACING block, to fix the following warning when CONFIG_TRACING
is not set:

>> include/linux/trace.h:63:45: warning: 'struct trace_array' declared
inside parameter list will not be visible outside of this definition or
declaration

Link: https://lkml.kernel.org/r/20221107160556.2139463-1-shraash@google.com

Fixes: 1a77dd1c2bb5 ("scsi: tracing: Fix compile error in trace_array calls when TRACING is disabled")
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arun Easi <aeasi@marvell.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Aashish Sharma <shraash@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/trace.h b/include/linux/trace.h
index b5e16e438448..80ffda871749 100644
--- a/include/linux/trace.h
+++ b/include/linux/trace.h
@@ -26,13 +26,13 @@ struct trace_export {
 	int flags;
 };
 
+struct trace_array;
+
 #ifdef CONFIG_TRACING
 
 int register_ftrace_export(struct trace_export *export);
 int unregister_ftrace_export(struct trace_export *export);
 
-struct trace_array;
-
 void trace_printk_init_buffers(void);
 __printf(3, 4)
 int trace_array_printk(struct trace_array *tr, unsigned long ip,
-- 
2.35.1



