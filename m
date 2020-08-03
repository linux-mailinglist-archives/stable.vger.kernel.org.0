Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B39723A68E
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgHCMtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgHCMYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB52F2086A;
        Mon,  3 Aug 2020 12:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457455;
        bh=G+I9uB95KuNChzskSKMQPHWU7ceWfhqiN3yDDHLw8Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJ5fkIpUBVhms3KKERjkrkPf7vJInpTFUmHXD7L9H18NaGfCTfnxHbOYOPrNuTqMU
         BvB4u2onkgJOJ04us6qKQb9rXiB0JSflw90P+EeOz1Ie6wySnpq/BM5qCce607e9h2
         st4zCUxt7z1bEzEmGEZZNfjKkcUa8Oyn8bYfbw1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@mellanox.com>,
        Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 074/120] selftests: ethtool: Fix test when only two speeds are supported
Date:   Mon,  3 Aug 2020 14:18:52 +0200
Message-Id: <20200803121906.405466973@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

[ Upstream commit 10fef9ca6a879e7bee090b8e51c9812d438d3fb1 ]

The test case check_highest_speed_is_chosen() configures $h1 to
advertise a subset of its supported speeds and checks that $h2 chooses
the highest speed from the subset.

To find the common advertised speeds between $h1 and $h2,
common_speeds_get() is called.

Currently, the first speed returned from common_speeds_get() is removed
claiming "h1 does not advertise this speed". The claim is wrong because
the function is called after $h1 already advertised a subset of speeds.

In case $h1 supports only two speeds, it will advertise a single speed
which will be later removed because of previously mentioned bug. This
results in the test needlessly failing. When more than two speeds are
supported this is not an issue because the first advertised speed
is the lowest one.

Fix this by not removing any speed from the list of commonly advertised
speeds.

Fixes: 64916b57c0b1 ("selftests: forwarding: Add speed and auto-negotiation test")
Reported-by: Danielle Ratson <danieller@mellanox.com>
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/ethtool.sh | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/ethtool.sh b/tools/testing/selftests/net/forwarding/ethtool.sh
index eb8e2a23bbb4c..43a948feed265 100755
--- a/tools/testing/selftests/net/forwarding/ethtool.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool.sh
@@ -252,8 +252,6 @@ check_highest_speed_is_chosen()
 	fi
 
 	local -a speeds_arr=($(common_speeds_get $h1 $h2 0 1))
-	# Remove the first speed, h1 does not advertise this speed.
-	unset speeds_arr[0]
 
 	max_speed=${speeds_arr[0]}
 	for current in ${speeds_arr[@]}; do
-- 
2.25.1



