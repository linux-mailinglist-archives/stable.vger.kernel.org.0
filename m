Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1106737CA91
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241810AbhELQaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240743AbhELQZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 743FF61CA7;
        Wed, 12 May 2021 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834496;
        bh=AKv4CvF9i/8LNs7eWbsTS8lJ3mQ65fN4GO5d/CpftOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a10JBb9su7iKRz5PRUJhQD45jLcL+cqF2V8DN/VNQJXCtCGZS3fAZHPswtoGwXFhX
         R4fq+AT+IPFDb/VnVm9dRWLBi6sQDgg77uAe5QqnpwJd2lrmQif8ZLE+wHiHTiUlnx
         3XXPEm3ZBIrfTa+NH+iG50n7T7ny8kIKHcR61hqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 568/601] selftests: mlxsw: Remove a redundant if statement in tc_flower_scale test
Date:   Wed, 12 May 2021 16:50:45 +0200
Message-Id: <20210512144846.560415363@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit 1f1c92139e36223b89d8140f2b72f75e79baf8bd ]

Currently, the error return code of the failure condition is lost after
using an if statement, so the test doesn't fail when it should.

Remove the if statement that separates the condition and the error code
check, so the test won't always pass.

Fixes: abfce9e062021 ("selftests: mlxsw: Reduce running time using offload indication")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh  | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
index cc0f07e72cf2..aa74be9f47c8 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
@@ -98,11 +98,7 @@ __tc_flower_test()
 			jq -r '[ .[] | select(.kind == "flower") |
 			.options | .in_hw ]' | jq .[] | wc -l)
 	[[ $((offload_count - 1)) -eq $count ]]
-	if [[ $should_fail -eq 0 ]]; then
-		check_err $? "Offload mismatch"
-	else
-		check_err_fail $should_fail $? "Offload more than expacted"
-	fi
+	check_err_fail $should_fail $? "Attempt to offload $count rules (actual result $((offload_count - 1)))"
 }
 
 tc_flower_test()
-- 
2.30.2



