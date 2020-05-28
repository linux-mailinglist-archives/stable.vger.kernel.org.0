Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CDC1E5FBC
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389357AbgE1MEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388954AbgE1L5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:57:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030D1215A4;
        Thu, 28 May 2020 11:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667033;
        bh=gs9/lY+1QDQ5E52V460MMXznwqxNumfuWvVTDb9U+uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFezxgOHRdv6SFiiALe9+yfN8Q2KDzVwq3Q35c2vAE68QWfbckrqtk/FckEl98ath
         mLZK8UxCYMfQuStWTJkIeIT6lb6nnyF1lh/1sV0oJ1kcKazRuNGtpqsgHV4ktLqP1p
         u8JIfRA6HvQXG1TNbjyp/S9JViQpokK+G/PhGKn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Cohen <amitc@mellanox.com>, Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/26] selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer
Date:   Thu, 28 May 2020 07:56:45 -0400
Message-Id: <20200528115654.1406165-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115654.1406165-1-sashal@kernel.org>
References: <20200528115654.1406165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

[ Upstream commit 46ca11177ed593f39d534f8d2c74ec5344e90c11 ]

Starting from iputils s20190709 (used in Fedora 31), arping does not
support timeout being specified as a decimal:

$ arping -c 1 -I swp1 -b 192.0.2.66 -q -w 0.1
arping: invalid argument: '0.1'

Previously, such timeouts were rounded to an integer.

Fix this by specifying the timeout as an integer.

Fixes: a5ee171d087e ("selftests: mlxsw: qos_mc_aware: Add a test for UC awareness")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
index 24dd8ed48580..b025daea062d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
@@ -300,7 +300,7 @@ test_uc_aware()
 	local i
 
 	for ((i = 0; i < attempts; ++i)); do
-		if $ARPING -c 1 -I $h1 -b 192.0.2.66 -q -w 0.1; then
+		if $ARPING -c 1 -I $h1 -b 192.0.2.66 -q -w 1; then
 			((passes++))
 		fi
 
-- 
2.25.1

