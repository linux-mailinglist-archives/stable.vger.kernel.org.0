Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183A81A0B52
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgDGKZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728942AbgDGKZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CE5A2074F;
        Tue,  7 Apr 2020 10:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255124;
        bh=ojqA7GJty1sXsLltzpUdgQpF8D6qRE1HTnadQNXvzSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fldE7JfG2QJil7Qyh3Ih7CAdaiL0M/TMOJMifiQvPGOUmuqot9aqG/tnyI9fZ/my3
         00Bwqoe3qvBbd5Sjx9Kf7wbj/8NHZrK1k0H2nCnkQsTwjTKZ2pmWlMMJXqatx2IHzP
         N0ZJYNJOSqihfZneSFEE4smi/IOTFqedPGZIO8Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 40/46] sched: act: count in the size of action flags bitfield
Date:   Tue,  7 Apr 2020 12:22:11 +0200
Message-Id: <20200407101503.698766874@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

commit 1521a67e6016664941f0917d50cb20053a8826a2 upstream.

The put of the flags was added by the commit referenced in fixes tag,
however the size of the message was not extended accordingly.

Fix this by adding size of the flags bitfield to the message size.

Fixes: e38226786022 ("net: sched: update action implementations to support flags")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/act_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -186,6 +186,7 @@ static size_t tcf_action_shared_attrs_si
 		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
 		+ cookie_len /* TCA_ACT_COOKIE */
 		+ nla_total_size(0) /* TCA_ACT_STATS nested */
+		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_FLAGS */
 		/* TCA_STATS_BASIC */
 		+ nla_total_size_64bit(sizeof(struct gnet_stats_basic))
 		/* TCA_STATS_PKT64 */


