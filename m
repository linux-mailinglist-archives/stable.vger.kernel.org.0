Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6001C68131B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237670AbjA3O2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236493AbjA3O2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:28:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B003D086
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:26:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04DD261015
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11650C433EF;
        Mon, 30 Jan 2023 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088796;
        bh=ezzE3+CW8K03nv60S3Y5tB/PV/lTwsGqG3OO2IAdH58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oS7jyKeEeAdENhW+hZSwJp3yzOadTx2RC6+ZTjvPjKcUPk6QgRIbcpmnGOPz/CMM9
         7N07Fv5g0iLnfAQPszTjDVUHfSxCOAzyGreSQVEzgJu6+gK+RJAFCRDz5MpzoBcCbY
         nJd2lGkKiD3Vmg3rgJ8SKwUN7fKs+9SzYCW/3IJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [PATCH 5.10 138/143] Revert "selftests/ftrace: Update synthetic event syntax errors"
Date:   Mon, 30 Jan 2023 14:53:15 +0100
Message-Id: <20230130134312.537877225@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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

From: Zheng Yejian <zhengyejian1@huawei.com>

This reverts commit 31c2e369b5335d70e913afee3ae11e54d61afef2 which is commit
b5734e997e1117afb479ffda500e36fa91aea3e8 upstream.

The reverted commit belongs to patchset which updated synthetic event
command parsing and testcase 'trigger-synthetic_event_syntax_errors.tc'
Link: https://lore.kernel.org/all/20210211020950.102294806@goodmis.org/

However this testcase update was backported alone without feature
update, which makes the testcase cannot pass on stable branch.

Revert this commit to make the testcase correct.

Fixes: 31c2e369b533 ("selftests/ftrace: Update synthetic event syntax errors")
Reported-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc |   35 ++--------
 1 file changed, 8 insertions(+), 27 deletions(-)

--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
@@ -1,38 +1,19 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: event trigger - test synthetic_events syntax parser errors
-# requires: synthetic_events error_log "char name[]' >> synthetic_events":README
+# requires: synthetic_events error_log
 
 check_error() { # command-with-error-pos-by-^
     ftrace_errlog_check 'synthetic_events' "$1" 'synthetic_events'
 }
 
-check_dyn_error() { # command-with-error-pos-by-^
-    ftrace_errlog_check 'synthetic_events' "$1" 'dynamic_events'
-}
-
 check_error 'myevent ^chr arg'			# INVALID_TYPE
-check_error 'myevent ^unsigned arg'		# INCOMPLETE_TYPE
-
-check_error 'myevent char ^str]; int v'		# BAD_NAME
-check_error '^mye-vent char str[]'		# BAD_NAME
-check_error 'myevent char ^st-r[]'		# BAD_NAME
-
-check_error 'myevent char str;^[]'		# INVALID_FIELD
-check_error 'myevent char str; ^int'		# INVALID_FIELD
-
-check_error 'myevent char ^str[; int v'		# INVALID_ARRAY_SPEC
-check_error 'myevent char ^str[kdjdk]'		# INVALID_ARRAY_SPEC
-check_error 'myevent char ^str[257]'		# INVALID_ARRAY_SPEC
-
-check_error '^mye;vent char str[]'		# INVALID_CMD
-check_error '^myevent ; char str[]'		# INVALID_CMD
-check_error '^myevent; char str[]'		# INVALID_CMD
-check_error '^myevent ;char str[]'		# INVALID_CMD
-check_error '^; char str[]'			# INVALID_CMD
-check_error '^;myevent char str[]'		# INVALID_CMD
-check_error '^myevent'				# INVALID_CMD
-
-check_dyn_error '^s:junk/myevent char str['	# INVALID_DYN_CMD
+check_error 'myevent ^char str[];; int v'	# INVALID_TYPE
+check_error 'myevent char ^str]; int v'		# INVALID_NAME
+check_error 'myevent char ^str;[]'		# INVALID_NAME
+check_error 'myevent ^char str[; int v'		# INVALID_TYPE
+check_error '^mye;vent char str[]'		# BAD_NAME
+check_error 'myevent char str[]; ^int'		# INVALID_FIELD
+check_error '^myevent'				# INCOMPLETE_CMD
 
 exit 0


