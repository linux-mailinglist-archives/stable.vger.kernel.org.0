Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D5828B676
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389034AbgJLNeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389007AbgJLNcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:32:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617B32087E;
        Mon, 12 Oct 2020 13:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509574;
        bh=gXAumGFMbP9CeIt6iIs55nIlaRny0KzXuMXPeYDImVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiwB378STm2ImoL9+u6Joe3K0w20VQDnYgzyPNBxVA6TYqUBlOmJeYUqIB7efMChs
         QKQkcfigN1kxesi5NOCBE+sVN919ChSibQopE64GzomFq/e46jXByigv4UQDlWBVfP
         WbapRQoRjJfIx3HLXG9ZMJ1yB230mmqJiZVcAirI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 34/39] xfrm: Use correct address family in xfrm_state_find
Date:   Mon, 12 Oct 2020 15:27:04 +0200
Message-Id: <20201012132629.735737921@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
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
index a3114abe74f20..5bb5950d6276b 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -742,7 +742,8 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 	 */
 	if (x->km.state == XFRM_STATE_VALID) {
 		if ((x->sel.family &&
-		     !xfrm_selector_match(&x->sel, fl, x->sel.family)) ||
+		     (x->sel.family != family ||
+		      !xfrm_selector_match(&x->sel, fl, family))) ||
 		    !security_xfrm_state_pol_flow_match(x, pol, fl))
 			return;
 
@@ -755,7 +756,9 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
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
@@ -791,7 +794,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->mode == x->props.mode &&
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
-			xfrm_state_look_at(pol, x, fl, encap_family,
+			xfrm_state_look_at(pol, x, fl, family,
 					   &best, &acquire_in_progress, &error);
 	}
 	if (best || acquire_in_progress)
@@ -807,7 +810,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->mode == x->props.mode &&
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
-			xfrm_state_look_at(pol, x, fl, encap_family,
+			xfrm_state_look_at(pol, x, fl, family,
 					   &best, &acquire_in_progress, &error);
 	}
 
-- 
2.25.1



