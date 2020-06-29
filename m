Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5903820E6D9
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgF2Sfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38CAC2417A;
        Mon, 29 Jun 2020 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443946;
        bh=TbuXKkWK6Wnle4WCzHVoxqRANxqbnVeGz1vYu64Bbkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzcQohNy+dtlPLXfrpnzOUIeJ51fbnngcxfEvP6dU6VZMJDb3L0jlIrxyAH8mjNZM
         Ne3ofRY70kTomI5A3mQsZ6+zTG/fRD4wyAC0B2L/zg8CD4DiG/U+3jH53lBDHZVwLu
         MPZSDFhn8nve5nRvjHhQYmzb2o2M7Y8FZlTRFGxM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin <martin.varghese@nokia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 048/265] bareudp: Fixed multiproto mode configuration
Date:   Mon, 29 Jun 2020 11:14:41 -0400
Message-Id: <20200629151818.2493727-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin <martin.varghese@nokia.com>

[ Upstream commit 4c98045c9b74feab837be58986c0517d3cc661f1 ]

Code to handle multiproto configuration is missing.

Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS")
Signed-off-by: Martin <martin.varghese@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bareudp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 5d3c691a1c668..3dd46cd551145 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -572,6 +572,9 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 	if (data[IFLA_BAREUDP_SRCPORT_MIN])
 		conf->sport_min =  nla_get_u16(data[IFLA_BAREUDP_SRCPORT_MIN]);
 
+	if (data[IFLA_BAREUDP_MULTIPROTO_MODE])
+		conf->multi_proto_mode = true;
+
 	return 0;
 }
 
-- 
2.25.1

