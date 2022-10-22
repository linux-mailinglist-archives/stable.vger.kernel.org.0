Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756E860867D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbiJVHuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiJVHso (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35ED1D4DD0;
        Sat, 22 Oct 2022 00:45:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E863D60AFA;
        Sat, 22 Oct 2022 07:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA41C433D6;
        Sat, 22 Oct 2022 07:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424498;
        bh=APosRWLMWXRR23CdEQKkKNR6lfRUIpIXd8OHjaqegVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTGBxYbgJoKS99uLqaMAdKTWeMuwDj5x0vFkxlR/YD3Q9/eFp47/0IRlEIllRb3aW
         uO+tJATFa4zYeI/mfWLpeBcNqUj7F+l3PJLEM3Xc+Y7mBTGpCS3VIVOfxeNwCVn6CK
         bzrt6PcG/1+eyBTSyR7vL/NM6V1SQ1YHX6du7VLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, mingo@redhat.com,
        Zheng Yejian <zhengyejian1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 138/717] ftrace: Properly unset FTRACE_HASH_FL_MOD
Date:   Sat, 22 Oct 2022 09:20:17 +0200
Message-Id: <20221022072439.964516610@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

commit 0ce0638edf5ec83343302b884fa208179580700a upstream.

When executing following commands like what document said, but the log
"#### all functions enabled ####" was not shown as expect:
  1. Set a 'mod' filter:
    $ echo 'write*:mod:ext3' > /sys/kernel/tracing/set_ftrace_filter
  2. Invert above filter:
    $ echo '!write*:mod:ext3' >> /sys/kernel/tracing/set_ftrace_filter
  3. Read the file:
    $ cat /sys/kernel/tracing/set_ftrace_filter

By some debugging, I found that flag FTRACE_HASH_FL_MOD was not unset
after inversion like above step 2 and then result of ftrace_hash_empty()
is incorrect.

Link: https://lkml.kernel.org/r/20220926152008.2239274-1-zhengyejian1@huawei.com

Cc: <mingo@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 8c08f0d5c6fb ("ftrace: Have cached module filters be an active filter")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6037,8 +6037,12 @@ int ftrace_regex_release(struct inode *i
 
 		if (filter_hash) {
 			orig_hash = &iter->ops->func_hash->filter_hash;
-			if (iter->tr && !list_empty(&iter->tr->mod_trace))
-				iter->hash->flags |= FTRACE_HASH_FL_MOD;
+			if (iter->tr) {
+				if (list_empty(&iter->tr->mod_trace))
+					iter->hash->flags &= ~FTRACE_HASH_FL_MOD;
+				else
+					iter->hash->flags |= FTRACE_HASH_FL_MOD;
+			}
 		} else
 			orig_hash = &iter->ops->func_hash->notrace_hash;
 


