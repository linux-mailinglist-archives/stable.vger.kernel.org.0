Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D2E420C5F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhJDNFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235025AbhJDNDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEA6060E0C;
        Mon,  4 Oct 2021 12:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352397;
        bh=1Ook0az1oK0+KVyFFdhJhRziO7F/Wuv81VPLFCDn7Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaruXftQkadXOS3sD6o5+55878vcUC7GE8izEM62Di50g9o80zl3wS49bYhJNqAGF
         jTndKLyhPfnsay34MvWINQPv/SML0C6BK+ruSf1rp2tMXOCBgiqJpFTIF7aTuYzdnK
         YHKu2f6tOh+PkcBBJzIBrBcA7U6rONDsTZYN3nCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Chen <yiche@redhat.com>,
        Andrea Claudi <aclaudi@redhat.com>,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 46/75] ipvs: check that ip_vs_conn_tab_bits is between 8 and 20
Date:   Mon,  4 Oct 2021 14:52:21 +0200
Message-Id: <20211004125033.074210545@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Claudi <aclaudi@redhat.com>

[ Upstream commit 69e73dbfda14fbfe748d3812da1244cce2928dcb ]

ip_vs_conn_tab_bits may be provided by the user through the
conn_tab_bits module parameter. If this value is greater than 31, or
less than 0, the shift operator used to derive tab_size causes undefined
behaviour.

Fix this checking ip_vs_conn_tab_bits value to be in the range specified
in ipvs Kconfig. If not, simply use default value.

Fixes: 6f7edb4881bf ("IPVS: Allow boot time change of hash size")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 3d2ac71a83ec..620c865c230b 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1406,6 +1406,10 @@ int __init ip_vs_conn_init(void)
 	int idx;
 
 	/* Compute size and mask */
+	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
+		pr_info("conn_tab_bits not in [8, 20]. Using default value\n");
+		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
+	}
 	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
 	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;
 
-- 
2.33.0



