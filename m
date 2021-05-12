Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0C637CEE7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345152AbhELRHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244745AbhELQvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EC6961D66;
        Wed, 12 May 2021 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836263;
        bh=wMdrOhALEI8Q29za130i5uXLIHn102sEwgGrIjIHoSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3tST5kzEhwpYhLJQJXl6/gIaFUfkZKpLhuNBjpz4tphAlnwJRtPN5VNc9jGkEuTO
         kKI0uDFcy5Wf4plvEc9PyGv0KK9z47yDMHt8eGkHTI4Mq+7EnT41dDJzH+F04umsN7
         8lp9sBI1JiiPF7X9YJbkS4vMdC/dZZjrxeO5GNaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 641/677] selftests: mlxsw: Remove a redundant if statement in port_scale test
Date:   Wed, 12 May 2021 16:51:27 +0200
Message-Id: <20210512144858.663010952@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit b6fc2f212108b3676f54d00a2c38e3bc36753980 ]

Currently, the error return code of the failure condition is lost after
using an if statement, so the test doesn't fail when it should.

Remove the if statement that separates the condition and the error code
check, so the test won't always pass.

Fixes: 5154b1b826d9b ("selftests: mlxsw: Add a scale test for physical ports")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/port_scale.sh | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
index f813ffefc07e..65f43a7ce9c9 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
@@ -55,10 +55,6 @@ port_test()
 	      | jq '.[][][] | select(.name=="physical_ports") |.["occ"]')
 
 	[[ $occ -eq $max_ports ]]
-	if [[ $should_fail -eq 0 ]]; then
-		check_err $? "Mismatch ports number: Expected $max_ports, got $occ."
-	else
-		check_err_fail $should_fail $? "Reached more ports than expected"
-	fi
+	check_err_fail $should_fail $? "Attempt to create $max_ports ports (actual result $occ)"
 
 }
-- 
2.30.2



