Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C74947AD15
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhLTOtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236686AbhLTOrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2096AC08EA3F;
        Mon, 20 Dec 2021 06:43:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B0C611AA;
        Mon, 20 Dec 2021 14:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A1AC36AF0;
        Mon, 20 Dec 2021 14:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011429;
        bh=nQodzaySB3e69utxvHFvdIqyYOS9x+WOF1zzhX5vv38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMvc8m3r6y3DY0QrGwxYUd9BGqw7c9Prz3a11OFkqEOK4RAtN7v/PK8aru6A0euub
         BykVskWMA5G/DuhJq5FoBatR+54kusovK3fQiaYQmdMIhJXRXFvXVTY/RZve2a/XyA
         uC+DCpvMsTs/vC1fnNQuN7uo6QOv+J29ltrg88t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Jie2x Zhou <jie2x.zhou@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/71] selftests: net: Correct ping6 expected rc from 2 to 1
Date:   Mon, 20 Dec 2021 15:34:07 +0100
Message-Id: <20211220143026.301338222@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
index 782a8da5d9500..475ac62373e92 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1884,7 +1884,7 @@ ipv6_ping_vrf()
 		log_start
 		show_hint "Fails since VRF device does not support linklocal or multicast"
 		run_cmd ${ping6} -c1 -w1 ${a}
-		log_test_addr ${a} $? 2 "ping out, VRF bind"
+		log_test_addr ${a} $? 1 "ping out, VRF bind"
 	done
 
 	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV} ${MCAST}%${NSA_DEV}
-- 
2.33.0



