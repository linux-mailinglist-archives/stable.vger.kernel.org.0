Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8063216F6
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhBVMjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:39:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhBVMio (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:38:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 423F564EDB;
        Mon, 22 Feb 2021 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997470;
        bh=91G44idT22nHLpyzhPSx7iPam8mPe8MI1jM14ONeA9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvXoOsHxXf3qBvRwnmwLgmW9/aULwGAoSZBx9peTgQvIVnhB6aPSbXG5ZHafpmJzG
         9cNKaVR0mr+/g75o1FZVdyWZmCLew6DWElU4R64Yaa10hkoECUrYXHIOc6AvMx0B7O
         T6IkVzF+rjrBjsyAA7RLwLfr+Yis1DdASwvt1hd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/57] af_key: relax availability checks for skb size calculation
Date:   Mon, 22 Feb 2021 13:35:30 +0100
Message-Id: <20210222121027.522184952@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
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
index 0747747fffe58..a10336cd7f974 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2906,7 +2906,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg) && aalg->available)
+		if (aalg_tmpl_set(t, aalg))
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2924,7 +2924,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
+		if (!(ealg_tmpl_set(t, ealg)))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2935,7 +2935,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg) && aalg->available)
+			if (aalg_tmpl_set(t, aalg))
 				sz += sizeof(struct sadb_comb);
 		}
 	}
-- 
2.27.0



