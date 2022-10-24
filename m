Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E4B60A424
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiJXMFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiJXMEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:04:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8427CB7C;
        Mon, 24 Oct 2022 04:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F01EB811B2;
        Mon, 24 Oct 2022 11:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965FFC433C1;
        Mon, 24 Oct 2022 11:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612192;
        bh=mXfUfUMNJxS2BzRQ6KR9PDjAr0TpVUooJu+qILoXLsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/DOJJBulW+YwMo1/gNd6Bp1hDW8qU2enm70MJm18OA6dV6HQnQs4Kjm5eP7s3r0m
         ZZ0Pf1FAb29cXga1BPD4EV3i/nIvU5a5utnG9gkv1z5qajwyYaGdJbCeLU6JCa7YR7
         bNudLTnGaohvSPwVlCAeAs1FLN0tEt2NdFmU+/ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, mingo@redhat.com,
        Zheng Yejian <zhengyejian1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 073/210] ftrace: Properly unset FTRACE_HASH_FL_MOD
Date:   Mon, 24 Oct 2022 13:29:50 +0200
Message-Id: <20221024112959.430185592@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -5128,8 +5128,12 @@ int ftrace_regex_release(struct inode *i
 
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
 


