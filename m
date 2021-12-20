Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB0D47AF29
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbhLTPKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbhLTPIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:08:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918C7C0A8863;
        Mon, 20 Dec 2021 06:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46598B80EE8;
        Mon, 20 Dec 2021 14:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B014C36AE7;
        Mon, 20 Dec 2021 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012042;
        bh=2o1LfZC2LO+vXU1TtDoeLbUR64ap/JEL9A1PZbXqMQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKnWFw7FpgikoKHZG7kUeiznQQykfA6hA/Qdq40BNnDamP6cFhcfz1ul5Rp8HSJAI
         LotAm7haGSPV6kqDzviCHe8NtmyBo2TRztb5TyMBYP6vvm3p67qLHCKFqhSvhzr2e/
         OAccmGO39NgkzQSTE03zYnIbv88uJbct/RcVANrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Jie2x Zhou <jie2x.zhou@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/177] selftests: net: Correct ping6 expected rc from 2 to 1
Date:   Mon, 20 Dec 2021 15:33:29 +0100
Message-Id: <20211220143042.090033967@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie2x Zhou <jie2x.zhou@intel.com>

[ Upstream commit 92816e2629808726af015c7f5b14adc8e4f8b147 ]

./fcnal-test.sh -v -t ipv6_ping
TEST: ping out, VRF bind - ns-B IPv6 LLA                                      [FAIL]
TEST: ping out, VRF bind - multicast IP                                       [FAIL]

ping6 is failing as it should.
COMMAND: ip netns exec ns-A /bin/ping6 -c1 -w1 fe80::7c4c:bcff:fe66:a63a%red
strace of ping6 shows it is failing with '1',
so change the expected rc from 2 to 1.

Fixes: c0644e71df33 ("selftests: Add ipv6 ping tests to fcnal-test")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jie2x Zhou <jie2x.zhou@intel.com>
Link: https://lore.kernel.org/r/20211209020230.37270-1-jie2x.zhou@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 7f5b265fcb905..966787c2f9f0f 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -2191,7 +2191,7 @@ ipv6_ping_vrf()
 		log_start
 		show_hint "Fails since VRF device does not support linklocal or multicast"
 		run_cmd ${ping6} -c1 -w1 ${a}
-		log_test_addr ${a} $? 2 "ping out, VRF bind"
+		log_test_addr ${a} $? 1 "ping out, VRF bind"
 	done
 
 	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV} ${MCAST}%${NSA_DEV}
-- 
2.33.0



