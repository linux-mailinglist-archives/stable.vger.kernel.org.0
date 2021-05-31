Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A160395D78
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhEaNq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233023AbhEaNoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:44:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B154614A5;
        Mon, 31 May 2021 13:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467758;
        bh=AScOhCo/IlhNEpPTGk3+u45hZi1yJkEdbDoP+P01ySE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGpFnYgeRB0z3Np5p1WyB4fAgdwlKfIs7Va2Yw+3uj82giS9MNI3I69ON+5NuJ5EW
         1AM+dQso9sCqgeTjf+Ks1unbD6NxfmeQaghKgtHTVovM29KASLaS6CHosvL25Z3v97
         xnHhy7EkYrRuwN8+z7djmg8C23XaS2x0pP15N4lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 68/79] staging: emxx_udc: fix loop in _nbu2ss_nuke()
Date:   Mon, 31 May 2021 15:14:53 +0200
Message-Id: <20210531130638.164598681@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e0112a7c9e847ada15a631b88e279d547e8f26a7 ]

The _nbu2ss_ep_done() function calls:

	list_del_init(&req->queue);

which means that the loop will never exit.

Fixes: ca3d253eb967 ("Staging: emxx_udc: Iterate list using list_for_each_entry")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YKUd0sDyjm/lkJfJ@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/emxx_udc/emxx_udc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index bb010cb98a1c..723bfec37cc9 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -2159,7 +2159,7 @@ static int _nbu2ss_nuke(struct nbu2ss_udc *udc,
 			struct nbu2ss_ep *ep,
 			int status)
 {
-	struct nbu2ss_req *req;
+	struct nbu2ss_req *req, *n;
 
 	/* Endpoint Disable */
 	_nbu2ss_epn_exit(udc, ep);
@@ -2171,7 +2171,7 @@ static int _nbu2ss_nuke(struct nbu2ss_udc *udc,
 		return 0;
 
 	/* called with irqs blocked */
-	list_for_each_entry(req, &ep->queue, queue) {
+	list_for_each_entry_safe(req, n, &ep->queue, queue) {
 		_nbu2ss_ep_done(ep, req, status);
 	}
 
-- 
2.30.2



