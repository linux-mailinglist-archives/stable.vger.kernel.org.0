Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53077167713
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbgBUIC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731353AbgBUICZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:02:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28E8222C4;
        Fri, 21 Feb 2020 08:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272145;
        bh=ADrNRk9Xu2Bg/SkJkQl9rV35sOxTlaMCztQvFTIMKlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIQL2znBts8xrR/MhTo3OT83KqwXiEDrfmGAeTiNjwcadrmAdVqAGTo0jInAJ3djf
         qynh/1jIJ8lKz0d4Lp9l9Fzd+/1bPanDIzYFqSlE0qom2VDgeOpatXbpHunZK4KvJA
         Vj/ko2DOWTTa54Kkve9R/Q1XiXpQDSEoNy9hvv0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 006/344] net/sched: flower: add missing validation of TCA_FLOWER_FLAGS
Date:   Fri, 21 Feb 2020 08:36:45 +0100
Message-Id: <20200221072349.866786649@linuxfoundation.org>
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

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit e2debf0852c4d66ba1a8bde12869b196094c70a7 ]

unlike other classifiers that can be offloaded (i.e. users can set flags
like 'skip_hw' and 'skip_sw'), 'cls_flower' doesn't validate the size of
netlink attribute 'TCA_FLOWER_FLAGS' provided by user: add a proper entry
to fl_policy.

Fixes: 5b33f48842fa ("net/flower: Introduce hardware offload support")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_flower.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -689,6 +689,7 @@ static const struct nla_policy fl_policy
 					    .len = 128 / BITS_PER_BYTE },
 	[TCA_FLOWER_KEY_CT_LABELS_MASK]	= { .type = NLA_BINARY,
 					    .len = 128 / BITS_PER_BYTE },
+	[TCA_FLOWER_FLAGS]		= { .type = NLA_U32 },
 };
 
 static const struct nla_policy


