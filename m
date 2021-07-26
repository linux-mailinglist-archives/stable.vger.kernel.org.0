Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F973D617D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhGZPcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237939AbhGZP3d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA6D760EB2;
        Mon, 26 Jul 2021 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315799;
        bh=OnmCAZmxl3znqtjryu9z1Ze0bAstNaEY/GvUyOkWjZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYt21ewryuq6z6dAAQeZ8Q11mGJS48WoNKMVOqqZlTOUJIi+rVqaeTptCSeyPKrHN
         XNHPKVVEQszoSGV8A80t8DuSE18BtM5lEH6AQAvxVWVjx9ogig0nunC8dItL1lwPBb
         hKVL6yYTWs+0BiePPPSsFH7zJWCjfctniddQTS0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Jianguo Wu <wujianguo@chinatelecom.cn>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 035/223] selftests: mptcp: fix case multiple subflows limited by server
Date:   Mon, 26 Jul 2021 17:37:07 +0200
Message-Id: <20210726153847.404152295@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit a7da441621c7945fbfd43ed239c93b8073cda502 ]

After patch "mptcp: fix syncookie process if mptcp can not_accept new
subflow", if subflow is limited, MP_JOIN SYN is dropped, and no SYN/ACK
will be replied.

So in case "multiple subflows limited by server", the expected SYN/ACK
number should be 1.

Fixes: 00587187ad30 ("selftests: mptcp: add test cases for mptcp join tests with syn cookies")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index fd99485cf2a4..e8ac852c6ff6 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1341,7 +1341,7 @@ syncookies_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "subflows limited by server w cookies" 2 2 1
+	chk_join_nr "subflows limited by server w cookies" 2 1 1
 
 	# test signal address with cookies
 	reset_with_cookies
-- 
2.30.2



