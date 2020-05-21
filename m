Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEE01DDB6F
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgEUX6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2E9C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h129so7185094ybc.3
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2q/ZTBKe+rRPOeAAmyf/c5a7kWQroO0f0bXwxZRItkU=;
        b=XK2BIkkJ6en/Le5R/K3FVqG8dUUmabBQm/ZFmyh47WlYZYkkibMogVbcalUbEqf57K
         vRiv7QkgbXIAGa6G09DN4nVlDt1RpqsSV4VK35XXfaEAEBATysssCvjfxpzl98uO5wsL
         kMD7H4sKxA+0bCpDs7Q3a4W/O/i648TlkMb+mZ5jZBOHa5mewGnLWNUCuZv2Qv/L+8nc
         6NI1Ww7mNrk+dMDD991Pg9jYk2mk102WCon72ZR+iBuHa/pCppxMwLdscwOFqg8usqWI
         +BSN1Lt+UnKqRFi1vDdzfJtFfxnOKjDKWrqRhLG8yjtrPb8uDIr9kFnezM5HCnyU4RmZ
         AGbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2q/ZTBKe+rRPOeAAmyf/c5a7kWQroO0f0bXwxZRItkU=;
        b=Epqzla4xJlGrp1CdlMxjnEqhOqOrJlQ0TzpPFgE1F5FUeDc2gQAYvIF+3qB5+PpRhz
         k4DNeGzNIzELccTHtjWTkagh+I4SsxAb8gAW2eD7YGWR7mxQKDbATj3gYeD/G0wdUsbA
         mdjgTMfGKsd5IT1RmL6FzgfooI35zUjKdvgYqIefoUtxnGg2+T/jYTMWwvRRYiIBfcuS
         8NKLi/YArBR7o19z/qC3DtbNq5SIUN/kKJzDMWH2WVN2sk0YlC0jQbeObdaTz4ZwWI4I
         YnCNacguUY9JLt0ooekP74DThKrM33WSup2TImi/ZYdL/bF8yY+HHPt/Gbe4eXr68fyM
         /RFQ==
X-Gm-Message-State: AOAM532+c23KzBbE9ostj3VoX4HEN86Wc7L1O5gbI3eKieKr9gNxMxSU
        X4JtJRgCojdC9IT3Gl5atTx+5d0YrYN3kQ==
X-Google-Smtp-Source: ABdhPJzUQ7p1NirNCHTp+diuqsg1PYCVVTK+7ZlJRHdZuLx5BgLC2oVdDY0kj/sF5ESAcCNcUFbP4kLzCcuKHw==
X-Received: by 2002:a25:cb53:: with SMTP id b80mr1316469ybg.480.1590105495920;
 Thu, 21 May 2020 16:58:15 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:24 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-12-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 11/27] l2tp: remove useless duplicate session detection in l2tp_netlink
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit af87ae465abdc070de0dc35d6c6a9e7a8cd82987 upstream.

There's no point in checking for duplicate sessions at the beginning of
l2tp_nl_cmd_session_create(); the ->session_create() callbacks already
return -EEXIST when the session already exists.

Furthermore, even if l2tp_session_find() returns NULL, a new session
might be created right after the test. So relying on ->session_create()
to avoid duplicate session is the only sane behaviour.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_netlink.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 63a2430ff40a..afee3d54e5ef 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -505,11 +505,6 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 		goto out;
 	}
 	session_id = nla_get_u32(info->attrs[L2TP_ATTR_SESSION_ID]);
-	session = l2tp_session_find(net, tunnel, session_id);
-	if (session) {
-		ret = -EEXIST;
-		goto out;
-	}
 
 	if (!info->attrs[L2TP_ATTR_PEER_SESSION_ID]) {
 		ret = -EINVAL;
-- 
2.27.0.rc0.183.gde8f92d652-goog

