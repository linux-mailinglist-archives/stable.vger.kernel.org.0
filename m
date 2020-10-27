Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1817D29B75E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799579AbgJ0PcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799571AbgJ0PcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1F6822202;
        Tue, 27 Oct 2020 15:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812732;
        bh=XMkQTYUfMEhIA+a+lO8Oxa/bNczWeriCd977SjZGeZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEPRbbi8QABpuqWPUcJ1aTsq80ZnwZUrPXE6ZhVteOzKirsx9y02Az0bbiBhjyONO
         9T9Lm4kUwuPEMRiQix4H3JLc8WJDwbQM5ygin71sK7KSX4tQFoYfVW0tqrGCzCStta
         VE1lOlK0NRUsO/UbzTh0nNIx1GIfGxqxZCjK81Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 281/757] selftests: mptcp: interpret \n as a new line
Date:   Tue, 27 Oct 2020 14:48:51 +0100
Message-Id: <20201027135503.757829789@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 8b974778f998ab1be23eca7436fc13d2d8c6bd59 ]

In case of errors, this message was printed:

  (...)
  # read: Resource temporarily unavailable
  #  client exit code 0, server 3
  # \nnetns ns1-0-BJlt5D socket stat for 10003:
  (...)

Obviously, the idea was to add a new line before the socket stat and not
print "\nnetns".

Fixes: b08fbf241064 ("selftests: add test-cases for MPTCP MP_JOIN")
Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 4 ++--
 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 57d75b7f62203..e9449430f98df 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -444,9 +444,9 @@ do_transfer()
 	duration=$(printf "(duration %05sms)" $duration)
 	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
 		echo "$duration [ FAIL ] client exit code $retc, server $rets" 1>&2
-		echo "\nnetns ${listener_ns} socket stat for $port:" 1>&2
+		echo -e "\nnetns ${listener_ns} socket stat for ${port}:" 1>&2
 		ip netns exec ${listener_ns} ss -nita 1>&2 -o "sport = :$port"
-		echo "\nnetns ${connector_ns} socket stat for $port:" 1>&2
+		echo -e "\nnetns ${connector_ns} socket stat for ${port}:" 1>&2
 		ip netns exec ${connector_ns} ss -nita 1>&2 -o "dport = :$port"
 
 		cat "$capout"
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f39c1129ce5f0..c2943e4dfcfe6 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -176,9 +176,9 @@ do_transfer()
 
 	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
 		echo " client exit code $retc, server $rets" 1>&2
-		echo "\nnetns ${listener_ns} socket stat for $port:" 1>&2
+		echo -e "\nnetns ${listener_ns} socket stat for ${port}:" 1>&2
 		ip netns exec ${listener_ns} ss -nita 1>&2 -o "sport = :$port"
-		echo "\nnetns ${connector_ns} socket stat for $port:" 1>&2
+		echo -e "\nnetns ${connector_ns} socket stat for ${port}:" 1>&2
 		ip netns exec ${connector_ns} ss -nita 1>&2 -o "dport = :$port"
 
 		cat "$capout"
-- 
2.25.1



