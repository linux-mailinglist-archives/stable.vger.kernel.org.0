Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DA647AD39
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbhLTOu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53094 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbhLTOrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9457B80EA3;
        Mon, 20 Dec 2021 14:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F40AC36AE8;
        Mon, 20 Dec 2021 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011666;
        bh=sbP4T8Yj2au5CFpwOvS4yflPh2cetJ6ruL2HC9dH25k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X13MhZFGtxk6JkARfpp81qbn6HZH5j+qdD1y4ziXpfSaM+aaZ0QOBytS/AkILPmza
         NcYZId56RBCrJCWW4Q3YYSTFbyEV1sdxkpBoifgAlRPZqUwZipN1cyLhkxQ5too8io
         Sw3QAoXQ1Dy+7RZSC6m6qexc1KlB/QQKs2den/iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Jie2x Zhou <jie2x.zhou@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/99] selftests: net: Correct ping6 expected rc from 2 to 1
Date:   Mon, 20 Dec 2021 15:34:04 +0100
Message-Id: <20211220143030.399424875@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
index 7c9ace9d15991..a830358ba2496 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -2128,7 +2128,7 @@ ipv6_ping_vrf()
 		log_start
 		show_hint "Fails since VRF device does not support linklocal or multicast"
 		run_cmd ${ping6} -c1 -w1 ${a}
-		log_test_addr ${a} $? 2 "ping out, VRF bind"
+		log_test_addr ${a} $? 1 "ping out, VRF bind"
 	done
 
 	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV} ${MCAST}%${NSA_DEV}
-- 
2.33.0



