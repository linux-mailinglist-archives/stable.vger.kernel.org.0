Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A50C69CE65
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjBTN7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbjBTN7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1968C1EBD6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24EE1B80D57
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E493C433D2;
        Mon, 20 Feb 2023 13:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901504;
        bh=d6CZ0p2XaEvVvvGGWfez04ihZMUA05AWaNwyxxw+U9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2wjACq6rOWHrcufhyUr90GeKtb1NKGOkYxPQjcxRygUslueOd7sjWE3dvFgIPuDn
         V6mGmBa/ewPxPypMRVnDfUrTYUwlbeMCODPI9hjQb6VxgCz05Js+a9GSbxX+B3hYuD
         +ttILj9BBpiaDPkH/hrdYhLHMzozqnFPxP9BP45s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/118] selftests: mptcp: userspace: fix v4-v6 test in v6.1
Date:   Mon, 20 Feb 2023 14:35:59 +0100
Message-Id: <20230220133602.161204340@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

The commit 4656d72c1efa ("selftests: mptcp: userspace: validate v4-v6 subflows mix")
has been backported to v6.1.8 without any conflicts. But it looks like
it was depending on a previous one:

  commit 1cc94ac1af4b ("selftests: mptcp: make evts global in userspace_pm")

Without it, the test fails with:

  ./userspace_pm.sh: line 788: : No such file or directory
  # ADD_ADDR4 id:14 10.0.2.1 (ns1) => ns2, reuse port        [FAIL]
  sed: can't read : No such file or directory

This dependence refactors the way the monitoring files are being
created: only once for all the different sub-tests instead of per
sub-test.

It is probably better to avoid backporting the refactoring. That is why
the new sub-test has been adapted to work using the previous way that is
still in place here in v6.1: the monitoring is started at the beginning
of each sub-test and the created file is removed at the end.

Fixes: f59549814a64 ("selftests: mptcp: userspace: validate v4-v6 subflows mix")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 0040e3bc7b16e..ad6547c79b831 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -778,6 +778,14 @@ test_subflows()
 
 test_subflows_v4_v6_mix()
 {
+	local client_evts
+	client_evts=$(mktemp)
+	# Capture events on the network namespace running the client
+	:>"$client_evts"
+	ip netns exec "$ns2" ./pm_nl_ctl events >> "$client_evts" 2>&1 &
+	evts_pid=$!
+	sleep 0.5
+
 	# Attempt to add a listener at 10.0.2.1:<subflow-port>
 	ip netns exec "$ns1" ./pm_nl_ctl listen 10.0.2.1\
 	   $app6_port > /dev/null 2>&1 &
@@ -820,6 +828,9 @@ test_subflows_v4_v6_mix()
 	ip netns exec "$ns1" ./pm_nl_ctl rem id $server_addr_id token\
 	   "$server6_token" > /dev/null 2>&1
 	sleep 0.5
+
+	kill_wait $evts_pid
+	rm -f "$client_evts"
 }
 
 test_prio()
-- 
2.39.0



