Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1942DEF19
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgLSM64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbgLSM6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:55 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Chris Mi <cmi@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH 5.9 24/49] net: flow_offload: Fix memory leak for indirect flow block
Date:   Sat, 19 Dec 2020 13:58:28 +0100
Message-Id: <20201219125345.861105375@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 5137d303659d8c324e67814b1cc2e1bc0c0d9836 ]

The offending commit introduces a cleanup callback that is invoked
when the driver module is removed to clean up the tunnel device
flow block. But it returns on the first iteration of the for loop.
The remaining indirect flow blocks will never be freed.

Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
CC: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow_offload.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -381,10 +381,8 @@ static void __flow_block_indr_cleanup(vo
 
 	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
 		if (this->release == release &&
-		    this->indr.cb_priv == cb_priv) {
+		    this->indr.cb_priv == cb_priv)
 			list_move(&this->indr.list, cleanup_list);
-			return;
-		}
 	}
 }
 


