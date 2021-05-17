Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26674382F4C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhEQOPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238482AbhEQONB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E5AA61377;
        Mon, 17 May 2021 14:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260507;
        bh=UWpbrYskpnh6yjz5JX5jnlSxDsV2p+ybcsR7Fj3BBc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzZ9wWXjZLDhMCuYtCaM0o/ZTlgJU+JWTbV4Z2KVaNiEJyJe/W4afRNuqH2YLAVeW
         iNpRE4a2xGUd902MzvyyGyBfG+/Z2fbyd24B5kGn1BMO/Hr5fcz+LFu/F/Pr2YtQ+l
         u0nqFw0RVVQlAGESv2NtmUYxb2pJRxseOTLLW6RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 113/363] selftests: mlxsw: Increase the tolerance of backlog buildup
Date:   Mon, 17 May 2021 15:59:39 +0200
Message-Id: <20210517140306.440088319@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit dda7f4fa55839baeb72ae040aeaf9ccf89d3e416 ]

The intention behind this test is to make sure that qdisc limit is
correctly projected to the HW. However, first, due to rounding in the
qdisc, and then in the driver, the number cannot actually be accurate. And
second, the approach to testing this is to oversubscribe the port with
traffic generated on the same switch. The actual backlog size therefore
fluctuates.

In practice, this test proved to be noisier than the rest, and spuriously
fails every now and then. Increase the tolerance to 10 % to avoid these
issues.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index b0cb1aaffdda..33ddd01689be 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -507,8 +507,8 @@ do_red_test()
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
 	local diff=$((limit - backlog))
 	pct=$((100 * diff / limit))
-	((0 <= pct && pct <= 5))
-	check_err $? "backlog $backlog / $limit expected <= 5% distance"
+	((0 <= pct && pct <= 10))
+	check_err $? "backlog $backlog / $limit expected <= 10% distance"
 	log_test "TC $((vlan - 10)): RED backlog > limit"
 
 	stop_traffic
-- 
2.30.2



