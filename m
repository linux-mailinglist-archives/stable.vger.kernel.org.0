Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225B54B42BE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 08:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbiBNHYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 02:24:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbiBNHYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 02:24:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3AB593A2
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 23:24:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2737161303
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 07:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04419C340F0;
        Mon, 14 Feb 2022 07:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644823474;
        bh=X48GUL1czH2VRR074k6xDNGsx5+V9KpVFYv63P8W+FA=;
        h=Subject:To:Cc:From:Date:From;
        b=pd4mDuyAfDT3X/ELgZtZg0kAoC/j9tdGQ51+FPovw0AoScXdMmjmSAVpJRIhidSOO
         L7eN5Nedn+EfePtA3Y0K3GpGHbW6tzpygaGX/wH7TzDL+RMGSVwxKFBFQ+72E1PF3/
         3lw/z4o+cSucG4/PB17Qp5R1gH0W7fFrxD52WsoY=
Subject: FAILED: patch "[PATCH] selftests: mptcp: add missing join check" failed to apply to 5.15-stable tree
To:     matthieu.baerts@tessares.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, pabeni@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 08:24:19 +0100
Message-ID: <1644823459120186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 857898eb4b28daf3faca3ae334c78b2bb141475e Mon Sep 17 00:00:00 2001
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Wed, 9 Feb 2022 17:25:07 -0800
Subject: [PATCH] selftests: mptcp: add missing join check

This function also writes the name of the test with its ID, making clear
a new test has been executed.

Without that, the ADD_ADDR results from this test was appended at the
end of the previous test causing confusions. Especially when the second
test was failing, we had:

  17 signal invalid addresses     syn[ ok ] - synack[ ok ] - ack[ ok ]
                                  add[ ok ] - echo  [ ok ]
                                  add[fail] got 2 ADD_ADDR[s] expected 3

In fact, this 17th test was OK but not the 18th one.

Now we have:

  17 signal invalid addresses     syn[ ok ] - synack[ ok ] - ack[ ok ]
                                  add[ ok ] - echo  [ ok ]
  18 signal addresses race test   syn[fail] got 2 JOIN[s] syn expected 3
   - synack[fail] got 2 JOIN[s] synack expected
   - ack[fail] got 2 JOIN[s] ack expected 3
                                  add[fail] got 2 ADD_ADDR[s] expected 3

Fixes: 33c563ad28e3 ("selftests: mptcp: add_addr and echo race test")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index b8bdbec0cf69..c0801df15f54 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1159,6 +1159,7 @@ signal_address_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal addresses race test" 3 3 3
 
 	# the server will not signal the address terminating
 	# the MPC subflow

