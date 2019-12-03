Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8081D111E3C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfLCW5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:57:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730509AbfLCW5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:57:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DA3720656;
        Tue,  3 Dec 2019 22:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413824;
        bh=yh+2c6J0zAyztqR0GF8zOuMWQhpHsSGmydaLfkOhlhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chjUQv9v9HMuyO55vm7oTIhFMwd+5dO/dh2gwe/cym9N+qzLIJJP6pxsYj2FiZYXr
         PUftCuu4fwMWeQtPpGNAIeuumPQi0nsQ5l+OtDYEdlFBYWU1O5EBrGzUAnJOO4tCdx
         H5LaaTlM/dXxjKetPn6JvsePhmmLuBj9khRjiJWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JD <jdtxs00@gmail.com>,
        Paul Wouters <paul@nohats.ca>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.19 276/321] xfrm: Fix memleak on xfrm state destroy
Date:   Tue,  3 Dec 2019 23:35:42 +0100
Message-Id: <20191203223441.485499204@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

commit 86c6739eda7d2a03f2db30cbee67a5fb81afa8ba upstream.

We leak the page that we use to create skb page fragments
when destroying the xfrm_state. Fix this by dropping a
page reference if a page was assigned to the xfrm_state.

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Reported-by: JD <jdtxs00@gmail.com>
Reported-by: Paul Wouters <paul@nohats.ca>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -456,6 +456,8 @@ static void ___xfrm_state_destroy(struct
 		x->type->destructor(x);
 		xfrm_put_type(x->type);
 	}
+	if (x->xfrag.page)
+		put_page(x->xfrag.page);
 	xfrm_dev_state_free(x);
 	security_xfrm_state_free(x);
 	xfrm_state_free(x);


