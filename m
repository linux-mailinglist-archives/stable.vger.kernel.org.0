Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FF91DD047
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgEUOlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729694AbgEUOlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE09EC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i190so5517756ybg.6
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pd4PcsezU06yo2aQIfnWT+Vqgl+7N/MBWeaqwirBn9o=;
        b=eaZ/EgXdnfopX8/+94pqzPGn92NGfDqRxIPczMoBPax62dzWB1p7jRzxnY+k0hZr8Y
         2ZUbappakacMLTauqx19k7aX8mvjrNHA6o9Z+upgQatyyeY/nX70CnnoauDQGhQHwdeD
         rEhDxGDMF6FBo+NoXYvbMV3G4e1nKAi7tISXJJIdjGTMTuUl4w5UenJksnPSo8ANNs19
         O5QGaoXeS5cgBV1LdnDLXBtj/Z/B4AIoYdE15TlMqt4l7aUdfw2cg8jLAgdFmkkM+c/D
         BUr4+RZP6rQh6m1PlbugUSGLMwkD7u+2WLgzQkKF6jhTxCQ8jTP41DEUJK2wmR3sap5m
         ck2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pd4PcsezU06yo2aQIfnWT+Vqgl+7N/MBWeaqwirBn9o=;
        b=dbBJV//aEWZUB426Arl3kgrgfqsiGc2pvcppAV4IJm7AVUcMh6XeDH2NtZrmTyn5rq
         t2sFb5z2Ry3WcZJ1lsndIXF64V7QDLlbHAF0KSfz6vJGHe+neLYS9YNT2wr+FWtzM0if
         XQ+54roiKSirgot1qcPhky4S0xQAtHTPdblUU5LFNhk/rwPOWgEQUT2RZXBtYFQuqidi
         qYo9+Xm2nphw4l8adD8zOJCawQzuXVcwmST9lRt34wc3pU3Lh7NMYxajWWV0h3RPmXtE
         vLYeenKN1yeQsyu/bwkao4CofzQpZj0sIRmDe6UwJZ9NaRuh8DpRVOOl0GIVUldUxlUr
         rDDQ==
X-Gm-Message-State: AOAM532Dparlu+2LYLL2RBuKHVhxi3WIBNrmmHKp/Nt5A7ePrKoN9YIj
        DkRoDZ4QB8YSPEIBVuCrn2TQWfUJfrMxLw==
X-Google-Smtp-Source: ABdhPJw0vKDC3zhdpTYL4ZITMZqDaCIKwjn4TsvlUvX6r5obmlq33yygXzUc/RMUKqARPPqNFOaBEbUUjFP7Ew==
X-Received: by 2002:a25:8b04:: with SMTP id i4mr15325973ybl.399.1590072091107;
 Thu, 21 May 2020 07:41:31 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:48 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-11-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 10/22] l2tp: initialise session's refcount before making it reachable
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

commit 9ee369a405c57613d7c83a3967780c3e30c52ecc uptream.

Sessions must be fully initialised before calling
l2tp_session_add_to_tunnel(). Otherwise, there's a short time frame
where partially initialised sessions can be accessed by external users.

Backporting Notes

l2tp_core.c: moving code that had been converted from atomic to
refcount_t by an earlier change (which isn't being included in this
patch series).

Fixes: dbdbc73b4478 ("l2tp: fix duplicate session creation")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a9d4d42e2ef6..7f72957405b8 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1847,6 +1847,8 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 
 		l2tp_session_set_header_len(session, tunnel->version);
 
+		l2tp_session_inc_refcount(session);
+
 		err = l2tp_session_add_to_tunnel(tunnel, session);
 		if (err) {
 			kfree(session);
@@ -1854,10 +1856,6 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 			return ERR_PTR(err);
 		}
 
-		/* Bump the reference count. The session context is deleted
-		 * only when this drops to zero.
-		 */
-		l2tp_session_inc_refcount(session);
 		l2tp_tunnel_inc_refcount(tunnel);
 
 		/* Ensure tunnel socket isn't deleted */
-- 
2.26.2.761.g0e0b3e54be-goog

