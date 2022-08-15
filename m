Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CDF593DBB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345314AbiHOTzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244214AbiHOTxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC7E45996;
        Mon, 15 Aug 2022 11:51:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AAEAB810A2;
        Mon, 15 Aug 2022 18:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F6C433C1;
        Mon, 15 Aug 2022 18:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589506;
        bh=hnv1XE0p9Z6h0Gz83S5EsiaobBnLS3/MzDyCxzBMYV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgkhp+5VRR1Mc75Hyui8YL21ASzf5F4QNzagsLe0L2SOsWDge3ik86MXg7BHsOrY/
         MUyHuJLesproGOGhIehryohv6VkCi+EruRzvgAH6Xiu6y/N1TA79M/B3O0/cXUzqDj
         POhqEoz391K/Z9C7KJitrl2wIe9OQ8bYnrsEYEaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 740/779] tracing: Avoid -Warray-bounds warning for __rel_loc macro
Date:   Mon, 15 Aug 2022 20:06:24 +0200
Message-Id: <20220815180409.073906833@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 58c5724ec2cdd72b22107ec5de00d90cc4797796 ]

Since -Warray-bounds checks the destination size from the type of given
pointer, __assign_rel_str() macro gets warned because it passes the
pointer to the 'u32' field instead of 'trace_event_raw_*' data structure.
Pass the data address calculated from the 'trace_event_raw_*' instead of
'u32' __rel_loc field.

Link: https://lkml.kernel.org/r/20220125233154.dac280ed36944c0c2fe6f3ac@kernel.org

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
[ This did not fix the warning, but is still a nice clean up ]
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/trace_events.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index 8c6f7c433518..65d927e059d3 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -318,9 +318,10 @@ TRACE_MAKE_SYSTEM_STR();
 #define __get_str(field) ((char *)__get_dynamic_array(field))
 
 #undef __get_rel_dynamic_array
-#define __get_rel_dynamic_array(field)	\
-		((void *)(&__entry->__rel_loc_##field) +	\
-		 sizeof(__entry->__rel_loc_##field) +		\
+#define __get_rel_dynamic_array(field)					\
+		((void *)__entry + 					\
+		 offsetof(typeof(*__entry), __rel_loc_##field) +	\
+		 sizeof(__entry->__rel_loc_##field) +			\
 		 (__entry->__rel_loc_##field & 0xffff))
 
 #undef __get_rel_dynamic_array_len
-- 
2.35.1



