Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3299318E3B
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBKPXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230289AbhBKPUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:20:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FB6D64F20;
        Thu, 11 Feb 2021 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055991;
        bh=xEWP+fGZmU/urvuGG1wp8hX4FKmcGSuJjWsWnxl9LGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1y0UMNIfSA9kgF99F7JlIwIEpWoS9goXp87MytA/8SWCKheWB/uISrLzkKZE0OJNi
         eBY+sIH9I46qk//gs7xldpqJAOBoxnUSK0tStf5rEns28ZZM7ZimcjGdZNA92SYff4
         jv1Sq2aOqWTyhBucvAVyT3tSzKixMEkb/IA99RJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/24] af_key: relax availability checks for skb size calculation
Date:   Thu, 11 Feb 2021 16:02:25 +0100
Message-Id: <20210211150148.628413844@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit afbc293add6466f8f3f0c3d944d85f53709c170f ]

xfrm_probe_algs() probes kernel crypto modules and changes the
availability of struct xfrm_algo_desc. But there is a small window
where ealg->available and aalg->available get changed between
count_ah_combs()/count_esp_combs() and dump_ah_combs()/dump_esp_combs(),
in this case we may allocate a smaller skb but later put a larger
amount of data and trigger the panic in skb_put().

Fix this by relaxing the checks when counting the size, that is,
skipping the test of ->available. We may waste some memory for a few
of sizeof(struct sadb_comb), but it is still much better than a panic.

Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index a915bc86620af..907d04a474597 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2902,7 +2902,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg) && aalg->available)
+		if (aalg_tmpl_set(t, aalg))
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2920,7 +2920,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
+		if (!(ealg_tmpl_set(t, ealg)))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2931,7 +2931,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg) && aalg->available)
+			if (aalg_tmpl_set(t, aalg))
 				sz += sizeof(struct sadb_comb);
 		}
 	}
-- 
2.27.0



