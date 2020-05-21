Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A651DDB73
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgEUX6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77828C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i3so123215ybm.12
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K183wFQPFGPKk6NSzjr/5v+kbtVezQZ2UnZ6d7X9RM0=;
        b=UXfYum4gqu14/a3/WXG8tWpivYj2twTj335UbSNKcq7SH3yrgQyTXmL6SUZl61sfdU
         aRTCdMvBoeqpCFiO91X12Hntn+fxRJcJ+0kkaebAzvjxCwQVzbDc/1OwKcwgrwC69Xh6
         D8OWyVbZzQ2sSd6Kvo6iPZn4OWrQg5MjZtQd6CdOfihYswPx6GOUBUdtoae/OwNsRSrP
         CBMHg3wsLKqH1iqSyC9rlahuQXJIXonl3AOUStqFIb7pLlLYpwnOgGfiBW5j4I2r/EJW
         wr0JQc7ilCtLXcXvifvBseCf3Wn9xbESulgPUtORXsgY+8SthnJg9YN+p2lTjZfpDdBw
         bcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K183wFQPFGPKk6NSzjr/5v+kbtVezQZ2UnZ6d7X9RM0=;
        b=E/0YXPnBI0kY7SnK/+VDN5M10CRu3hIXcJDAbsOuRiG7+N9JcM1NKXLKSx68olEJyR
         +mR59ESuLcEtaXhOQvuzhVLurjnzRmuIUVF8DfAPbU3+gQymIUNG+X5Am+NcXk0jNTM2
         xx3O6cPqDLnRbu4bGsioMOlRfb17+J7FXQZTo5xECUaQofpbmptJEuszoHMNwNrG+Tny
         5XIRFJpNtU/Hnqvc4c4cRdDvI44NSUVYu728d/ucuunl11R5zc9pjXpzhxcM59mT0Udo
         j7Sfwpp56ttLBq5EmPOELa/+yFfYffQEMEFVsWMHX2YlLpcfgKbK7qYOES8rEr6kr0HY
         Ot3Q==
X-Gm-Message-State: AOAM530RcV+jI1PeFfpSo1oXextXsdWEldvToAcPCu3O4HikkX6Euf+9
        jckdDpW/483s5sQdnsgz2BydaQn5V4XSog==
X-Google-Smtp-Source: ABdhPJzgwEDy81TohwTK2Px26lX4ImqL/Bf3vWpBNNADn2OFlNVDGN+ph0HU9nQa3i/tNA2tWRuMWqCl7NYF4w==
X-Received: by 2002:a25:4455:: with SMTP id r82mr20208868yba.213.1590105504717;
 Thu, 21 May 2020 16:58:24 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:28 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-16-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 15/27] l2tp: initialise session's refcount before making it reachable
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

commit 9ee369a405c57613d7c83a3967780c3e30c52ecc upstream.

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
index 7e593e399774..c0abd5efd824 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1853,6 +1853,8 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 
 		l2tp_session_set_header_len(session, tunnel->version);
 
+		l2tp_session_inc_refcount(session);
+
 		err = l2tp_session_add_to_tunnel(tunnel, session);
 		if (err) {
 			kfree(session);
@@ -1860,10 +1862,6 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 			return ERR_PTR(err);
 		}
 
-		/* Bump the reference count. The session context is deleted
-		 * only when this drops to zero.
-		 */
-		l2tp_session_inc_refcount(session);
 		l2tp_tunnel_inc_refcount(tunnel);
 
 		/* Ensure tunnel socket isn't deleted */
-- 
2.27.0.rc0.183.gde8f92d652-goog

