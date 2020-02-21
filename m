Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460FF16765A
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731810AbgBUIck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732763AbgBUIL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:11:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E34E20722;
        Fri, 21 Feb 2020 08:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272717;
        bh=nX975cmkEA4sifV9b0KMKOPMIxYt2YzC5TeY+ulhTIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZbEqOs3NiGdBrYPgQZtqXdjzWiFfwE+WSKcpjLajMj2E+9Xo1RUWzhDbOFyLXO4r
         ct0ATqZvpkiWXlwxN8PvueXmz10FY98WMrRUBCsVQzEqZx/jM41CAYqj9lqXi62juS
         Y9MLyXUpClUWvFMRmMo2Px+geE5BTUIEtSO4BtKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Li RongQing <lirongqing@baidu.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/344] bpf: Return -EBADRQC for invalid map type in __bpf_tx_xdp_map
Date:   Fri, 21 Feb 2020 08:40:20 +0100
Message-Id: <20200221072409.277055765@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0a29275b6300f39f78a87f2038bbfe5bdbaeca47 ]

A negative value should be returned if map->map_type is invalid
although that is impossible now, but if we run into such situation
in future, then xdpbuff could be leaked.

Daniel Borkmann suggested:

-EBADRQC should be returned to stay consistent with generic XDP
for the tracepoint output and not to be confused with -EOPNOTSUPP
from other locations like dev_map_enqueue() when ndo_xdp_xmit is
missing and such.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/1578618277-18085-1-git-send-email-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1a78d64096bbd..d59dbc88fef5d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3543,7 +3543,7 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 		return err;
 	}
 	default:
-		break;
+		return -EBADRQC;
 	}
 	return 0;
 }
-- 
2.20.1



