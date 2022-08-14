Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F955922D5
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241582AbiHNPwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241912AbiHNPuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:50:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2C71CFC0;
        Sun, 14 Aug 2022 08:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9180DB80B27;
        Sun, 14 Aug 2022 15:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFDEC433C1;
        Sun, 14 Aug 2022 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491359;
        bh=dw9NfNEJ5qccYg24V+CXWiMF5Lo5klkFrzq5j7gswkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZwMD50g+ebCmrygnuzFBDn62JAmqyQLtdRzIgtmiZ+eSws/Te1v89Y9F3AnKBRw1
         Yn5TXFCI3HVc8GYgvnUFji4Ql3GaNmGobP7wDs3KsOVX19HxHHdo5icUuSz/6H3hBo
         UVpx7ovzoCqzn39TtclM+OgvYSe8zBCuJbvmYL++xcKmNQAO9Wisl7XUeyPMlatvAC
         H09FSvItf2O5EtYK9uLiBwjKBtR92oLOzdqffeTPdDr730OOntvONLzs6MjufhpqZt
         YkWxRFmuia8TLw9YTrjsdUsi176xcUAiDiKtk3jMrpvFO0koVw9mtzL+KVOHg507H8
         A6tQ8Qw9tkxJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/21] selftests/kprobe: Do not test for GRP/ without event failures
Date:   Sun, 14 Aug 2022 11:35:25 -0400
Message-Id: <20220814153531.2379705-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153531.2379705-1-sashal@kernel.org>
References: <20220814153531.2379705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

[ Upstream commit f5eab65ff2b76449286d18efc7fee3e0b72f7d9b ]

A new feature is added where kprobes (and other probes) do not need to
explicitly state the event name when creating a probe. The event name will
come from what is being attached.

That is:

  # echo 'p:foo/ vfs_read' > kprobe_events

Will no longer error, but instead create an event:

  # cat kprobe_events
 p:foo/p_vfs_read_0 vfs_read

This should not be tested as an error case anymore. Remove it from the
selftest as now this feature "breaks" the selftest as it no longer fails
as expected.

Link: https://lore.kernel.org/all/1656296348-16111-1-git-send-email-quic_linyyuan@quicinc.com/
Link: https://lkml.kernel.org/r/20220712161707.6dc08a14@gandalf.local.home

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc       | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
index ef1e9bafb098..728c2762ee58 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
@@ -24,7 +24,6 @@ check_error 'p:^/bar vfs_read'		# NO_GROUP_NAME
 check_error 'p:^12345678901234567890123456789012345678901234567890123456789012345/bar vfs_read'	# GROUP_TOO_LONG
 
 check_error 'p:^foo.1/bar vfs_read'	# BAD_GROUP_NAME
-check_error 'p:foo/^ vfs_read'		# NO_EVENT_NAME
 check_error 'p:foo/^12345678901234567890123456789012345678901234567890123456789012345 vfs_read'	# EVENT_TOO_LONG
 check_error 'p:foo/^bar.1 vfs_read'	# BAD_EVENT_NAME
 
-- 
2.35.1

