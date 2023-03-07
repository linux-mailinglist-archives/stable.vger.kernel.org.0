Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF1F6AEC85
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCGR4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjCGRzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:55:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF18B94F76
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81073B819BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7FCC433EF;
        Tue,  7 Mar 2023 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211421;
        bh=ijq5We4/PB4bteZ2uucxvpZBxvcVw2TUrtmpsUKbHTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUtKxLK+K2i2nZ6vR2C8AsBADG9kr3HDIASrNuUjuhVNIHJJlfJEtxcFajR7u1me/
         jDyb7CgCbrhiBjE54dmTyPM+U8va/M5/p9NAmb18Wr6ig2F54+E3MnDHQ+losSTmNi
         as53Zu5FKirswwh7l6LbKg3Bgga2EGwYWihagvsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.2 0855/1001] selftests/ftrace: Fix eprobe syntax test case to check filter support
Date:   Tue,  7 Mar 2023 18:00:27 +0100
Message-Id: <20230307170058.941403953@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a457e944df92789ab31aaf35fae9db064e3c51c4 upstream.

Fix eprobe syntax test case to check whether the kernel supports the filter
on eprobe for filter syntax test command. Without this fix, this test case
will fail if the kernel supports eprobe but doesn't support the filter on
eprobe.

Link: https://lore.kernel.org/all/167309834742.640500.379128668288448035.stgit@devnote3/

Fixes: 9e14bae7d049 ("selftests/ftrace: Add eprobe syntax error testcase")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/dynevent/eprobes_syntax_errors.tc |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/ftrace/test.d/dynevent/eprobes_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/eprobes_syntax_errors.tc
@@ -22,6 +22,8 @@ check_error 'e:foo/^bar.1 syscalls/sys_e
 check_error 'e:foo/bar syscalls/sys_enter_openat arg=^dfd'	# BAD_FETCH_ARG
 check_error 'e:foo/bar syscalls/sys_enter_openat ^arg=$foo'	# BAD_ATTACH_ARG
 
-check_error 'e:foo/bar syscalls/sys_enter_openat if ^'	# NO_EP_FILTER
+if grep -q '<attached-group>\.<attached-event>.*\[if <filter>\]' README; then
+  check_error 'e:foo/bar syscalls/sys_enter_openat if ^'	# NO_EP_FILTER
+fi
 
 exit 0


