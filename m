Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185C11236A5
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbfLQUKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:10:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728464AbfLQUKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:10:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C1A42146E;
        Tue, 17 Dec 2019 20:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613444;
        bh=hCfYOICVQJtSmvDtFvD4zB7rBm7v96AeRD9UugTEBwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8FoP6htbN91EvgdrxPsnH2ixn84KzCAr0lsQcZw4180UuG1wMqYg4iHdrQqKdELs
         kN9TwMaG2wLGSDhnifAAGhvt5hlqIrQLKMueysGVh0jTyiFeGQ8p4X0rqyo5Fwnz48
         /1428ADn9fw2rmAeTVrTWMu1KLczDJe8h7Pb26sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 23/37] gre: refetch erspan header from skb->data after pskb_may_pull()
Date:   Tue, 17 Dec 2019 21:09:44 +0100
Message-Id: <20191217200729.075022800@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 0e4940928c26527ce8f97237fef4c8a91cd34207 ]

After pskb_may_pull() we should always refetch the header
pointers from the skb->data in case it got reallocated.

In gre_parse_header(), the erspan header is still fetched
from the 'options' pointer which is fetched before
pskb_may_pull().

Found this during code review of a KMSAN bug report.

Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Acked-by: William Tu <u9012063@gmail.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/gre_demux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -127,7 +127,7 @@ int gre_parse_header(struct sk_buff *skb
 		if (!pskb_may_pull(skb, nhs + hdr_len + sizeof(*ershdr)))
 			return -EINVAL;
 
-		ershdr = (struct erspan_base_hdr *)options;
+		ershdr = (struct erspan_base_hdr *)(skb->data + nhs + hdr_len);
 		tpi->key = cpu_to_be32(get_session_id(ershdr));
 	}
 


