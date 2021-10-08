Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B664268DD
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbhJHLcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240881AbhJHLb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A8061177;
        Fri,  8 Oct 2021 11:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692556;
        bh=T2Tcuj8VAWUyj+yoBtJd13+Cxw5kOSrslGVhstBZGlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bmhhyZn7F1rQDCKM8n7s2l6RV5KNOsDNckv4zadXaKKjC106U90vRa6D0qhYuJNjy
         DGy6NRi9kPmgTdlPkIu6itMexzXvn0dfVCE5BCWiUTy+pqM2GiXs8NuTtJeWw0+pYv
         kmohARobqAb0ecnHFTa7sOe7hcc/7JnEPFecoKv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/10] xen-netback: correct success/error reporting for the SKB-with-fraglist case
Date:   Fri,  8 Oct 2021 13:27:43 +0200
Message-Id: <20211008112714.526377516@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112714.445637990@linuxfoundation.org>
References: <20211008112714.445637990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 3ede7f84c7c21f93c5eac611d60eba3f2c765e0f ]

When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
special considerations for the head of the SKB no longer apply. Don't
mistakenly report ERROR to the frontend for the first entry in the list,
even if - from all I can tell - this shouldn't matter much as the overall
transmit will need to be considered failed anyway.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index ad555a9a3eca..e1d6dbb4b770 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -492,7 +492,7 @@ check_frags:
 				 * the header's copy failed, and they are
 				 * sharing a slot, send an error
 				 */
-				if (i == 0 && sharedslot)
+				if (i == 0 && !first_shinfo && sharedslot)
 					xenvif_idx_release(queue, pending_idx,
 							   XEN_NETIF_RSP_ERROR);
 				else
-- 
2.33.0



