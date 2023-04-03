Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D886D493F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjDCOgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjDCOgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:36:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFA717652
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C23FBCE12E4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84CEC433EF;
        Mon,  3 Apr 2023 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532563;
        bh=8km0x1vLwE9boiOOdqbni5fdBgKSZiQh0+IwayiLD28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5cWmaddl/2UXUkLp13/XrsfE5murbDg8zygktsuapuCln/nPxfukeukDLDQ0HtFl
         0jygInd/3E3rCJXyq+ysj0meDNUitKH+T6Crtn/OkJd1EVN01gzUFYGR5mmna/DEDi
         DsQ/UTdAPG6YZs16LSTqSWNV95AcT1Ki3yseFN5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com,
        Hyunwoo Kim <v4bel@theori.io>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/181] xfrm: Zero padding when dumping algos and encap
Date:   Mon,  3 Apr 2023 16:07:46 +0200
Message-Id: <20230403140416.179580867@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 8222d5910dae08213b6d9d4bc9a7f8502855e624 ]

When copying data to user-space we should ensure that only valid
data is copied over.  Padding in structures may be filled with
random (possibly sensitve) data and should never be given directly
to user-space.

This patch fixes the copying of xfrm algorithms and the encap
template in xfrm_user so that padding is zeroed.

Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com
Reported-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 45 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e73f9efc54c12..83f35ecacf24f 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -997,7 +997,9 @@ static int copy_to_user_aead(struct xfrm_algo_aead *aead, struct sk_buff *skb)
 		return -EMSGSIZE;
 
 	ap = nla_data(nla);
-	memcpy(ap, aead, sizeof(*aead));
+	strscpy_pad(ap->alg_name, aead->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = aead->alg_key_len;
+	ap->alg_icv_len = aead->alg_icv_len;
 
 	if (redact_secret && aead->alg_key_len)
 		memset(ap->alg_key, 0, (aead->alg_key_len + 7) / 8);
@@ -1017,7 +1019,8 @@ static int copy_to_user_ealg(struct xfrm_algo *ealg, struct sk_buff *skb)
 		return -EMSGSIZE;
 
 	ap = nla_data(nla);
-	memcpy(ap, ealg, sizeof(*ealg));
+	strscpy_pad(ap->alg_name, ealg->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = ealg->alg_key_len;
 
 	if (redact_secret && ealg->alg_key_len)
 		memset(ap->alg_key, 0, (ealg->alg_key_len + 7) / 8);
@@ -1028,6 +1031,40 @@ static int copy_to_user_ealg(struct xfrm_algo *ealg, struct sk_buff *skb)
 	return 0;
 }
 
+static int copy_to_user_calg(struct xfrm_algo *calg, struct sk_buff *skb)
+{
+	struct nlattr *nla = nla_reserve(skb, XFRMA_ALG_COMP, sizeof(*calg));
+	struct xfrm_algo *ap;
+
+	if (!nla)
+		return -EMSGSIZE;
+
+	ap = nla_data(nla);
+	strscpy_pad(ap->alg_name, calg->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = 0;
+
+	return 0;
+}
+
+static int copy_to_user_encap(struct xfrm_encap_tmpl *ep, struct sk_buff *skb)
+{
+	struct nlattr *nla = nla_reserve(skb, XFRMA_ENCAP, sizeof(*ep));
+	struct xfrm_encap_tmpl *uep;
+
+	if (!nla)
+		return -EMSGSIZE;
+
+	uep = nla_data(nla);
+	memset(uep, 0, sizeof(*uep));
+
+	uep->encap_type = ep->encap_type;
+	uep->encap_sport = ep->encap_sport;
+	uep->encap_dport = ep->encap_dport;
+	uep->encap_oa = ep->encap_oa;
+
+	return 0;
+}
+
 static int xfrm_smark_put(struct sk_buff *skb, struct xfrm_mark *m)
 {
 	int ret = 0;
@@ -1083,12 +1120,12 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
 			goto out;
 	}
 	if (x->calg) {
-		ret = nla_put(skb, XFRMA_ALG_COMP, sizeof(*(x->calg)), x->calg);
+		ret = copy_to_user_calg(x->calg, skb);
 		if (ret)
 			goto out;
 	}
 	if (x->encap) {
-		ret = nla_put(skb, XFRMA_ENCAP, sizeof(*x->encap), x->encap);
+		ret = copy_to_user_encap(x->encap, skb);
 		if (ret)
 			goto out;
 	}
-- 
2.39.2



