Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF95328B94A
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389651AbgJLN7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388787AbgJLNkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:40:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E41B1221FC;
        Mon, 12 Oct 2020 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510013;
        bh=gfcMD41HGhTeQ9DNaXOghSyGdFHy7OJGp03ALSKnYcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNwZ9O7/NhhISjYqB5L8TxkcyAW1P9pm2u40LprJqJ2eEA3+6H9vu6Sme7o+1zxCi
         2YacP9TlsYXhIPiYLk3HeRrehwWR6k0BkDaQn4wBQJxLbZJKuRmXrPRHQf/Thhkz42
         KKUAGTuNYMr1eehjcyAd+cFRg1cQURkkRTDvwI6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/49] xfrm: Use correct address family in xfrm_state_find
Date:   Mon, 12 Oct 2020 15:27:22 +0200
Message-Id: <20201012132631.109848901@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit e94ee171349db84c7cfdc5fefbebe414054d0924 ]

The struct flowi must never be interpreted by itself as its size
depends on the address family.  Therefore it must always be grouped
with its original family value.

In this particular instance, the original family value is lost in
the function xfrm_state_find.  Therefore we get a bogus read when
it's coupled with the wrong family which would occur with inter-
family xfrm states.

This patch fixes it by keeping the original family value.

Note that the same bug could potentially occur in LSM through
the xfrm_state_pol_flow_match hook.  I checked the current code
there and it seems to be safe for now as only secid is used which
is part of struct flowi_common.  But that API should be changed
so that so that we don't get new bugs in the future.  We could
do that by replacing fl with just secid or adding a family field.

Reported-by: syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com
Fixes: 48b8d78315bf ("[XFRM]: State selection update to use inner...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index c68eb587c0efb..a649d7c2f48ca 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -923,7 +923,8 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 	 */
 	if (x->km.state == XFRM_STATE_VALID) {
 		if ((x->sel.family &&
-		     !xfrm_selector_match(&x->sel, fl, x->sel.family)) ||
+		     (x->sel.family != family ||
+		      !xfrm_selector_match(&x->sel, fl, family))) ||
 		    !security_xfrm_state_pol_flow_match(x, pol, fl))
 			return;
 
@@ -936,7 +937,9 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 		*acq_in_progress = 1;
 	} else if (x->km.state == XFRM_STATE_ERROR ||
 		   x->km.state == XFRM_STATE_EXPIRED) {
-		if (xfrm_selector_match(&x->sel, fl, x->sel.family) &&
+		if ((!x->sel.family ||
+		     (x->sel.family == family &&
+		      xfrm_selector_match(&x->sel, fl, family))) &&
 		    security_xfrm_state_pol_flow_match(x, pol, fl))
 			*error = -ESRCH;
 	}
@@ -976,7 +979,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->mode == x->props.mode &&
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
-			xfrm_state_look_at(pol, x, fl, encap_family,
+			xfrm_state_look_at(pol, x, fl, family,
 					   &best, &acquire_in_progress, &error);
 	}
 	if (best || acquire_in_progress)
@@ -993,7 +996,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->mode == x->props.mode &&
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
-			xfrm_state_look_at(pol, x, fl, encap_family,
+			xfrm_state_look_at(pol, x, fl, family,
 					   &best, &acquire_in_progress, &error);
 	}
 
-- 
2.25.1



