Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D45318E6E
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhBKP0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230436AbhBKPWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B2D764F38;
        Thu, 11 Feb 2021 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613056043;
        bh=Gyko2fH262bh7ohxuvJOx5kBhTezFJQX5eqq9T8pDbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISDQ8ZBLr3S6lWnDEp8UkG9Y2bQXxhvjFrN78AiTNVzBOIcj1lNP/p/Qp0ShvYzJJ
         Crr7EK8Xuzfpt2CC2Mne8AlR9jxfbGjQpes3h8/LtcWjWl5WFWbmAnKCCdUuoePkN5
         0O1RUcH1tQWb5qg3BlHq3VGEmcwK0IHE93kg2rr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/24] af_key: relax availability checks for skb size calculation
Date:   Thu, 11 Feb 2021 16:02:40 +0100
Message-Id: <20210211150148.026903055@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
References: <20210211150147.743660073@linuxfoundation.org>
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
index e340e97224c3a..c7d5a6015389b 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2908,7 +2908,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg) && aalg->available)
+		if (aalg_tmpl_set(t, aalg))
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2926,7 +2926,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
+		if (!(ealg_tmpl_set(t, ealg)))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2937,7 +2937,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg) && aalg->available)
+			if (aalg_tmpl_set(t, aalg))
 				sz += sizeof(struct sadb_comb);
 		}
 	}
-- 
2.27.0



