Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010011E2AD5
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389452AbgEZS71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389923AbgEZS70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18843208DB;
        Tue, 26 May 2020 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519565;
        bh=s5uIdwHoq0DUL8XtbeEATZDxARzNHyHj8OxFlLF9QVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mc/uEHXFU1sQS+HDuHMhzVMNcZtN2GipUXXTfI7sxKjS3/moCL+L/ZJuvWunxuvBx
         pCCdigEC2B+9rl62jMaZn0x1e2KSSGysM+umWz6c5nAgzQDg9/XVbG5e+E72uiMoYo
         LBWVs23GyyRFZe0nmrOMFeR4chfDw59MFXt481CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 36/64] l2tp: initialise sessions refcount before making it reachable
Date:   Tue, 26 May 2020 20:53:05 +0200
Message-Id: <20200526183924.899863279@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1847,6 +1847,8 @@ struct l2tp_session *l2tp_session_create
 
 		l2tp_session_set_header_len(session, tunnel->version);
 
+		l2tp_session_inc_refcount(session);
+
 		err = l2tp_session_add_to_tunnel(tunnel, session);
 		if (err) {
 			kfree(session);
@@ -1854,10 +1856,6 @@ struct l2tp_session *l2tp_session_create
 			return ERR_PTR(err);
 		}
 
-		/* Bump the reference count. The session context is deleted
-		 * only when this drops to zero.
-		 */
-		l2tp_session_inc_refcount(session);
 		l2tp_tunnel_inc_refcount(tunnel);
 
 		/* Ensure tunnel socket isn't deleted */


