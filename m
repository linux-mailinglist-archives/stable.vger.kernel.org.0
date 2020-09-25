Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789F52788CB
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgIYM6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728951AbgIYMtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 109C021741;
        Fri, 25 Sep 2020 12:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038187;
        bh=IVhxxjkyCwp0Kcn8Rl7vIe6uy1bQQKhwMpGCiEwFruw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktRDDqnNDLqXbm2PGtzWgdVA61YfPqgdCR144eGjVfiMpa/qGdFbhUOPzIVuhUTdN
         3Js9mwgqJEfSdZ04aPQXITmlvAvHqQ0QoGgY9ArE7RdYvf2J6W0XJMvTKLyi2epl4v
         jc6H+qdHxEPmaAcTHso05hSuEOO0NWidBnA7NaUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 06/56] cxgb4: fix memory leak during module unload
Date:   Fri, 25 Sep 2020 14:47:56 +0200
Message-Id: <20200925124728.808796966@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit f4a26a9b311d7ff9db461278faf2869d06496ef8 ]

Fix the memory leak in mps during module unload
path by freeing mps reference entries if the list
adpter->mps_ref is not already empty

Fixes: 28b3870578ef ("cxgb4: Re-work the logic for mps refcounting")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
@@ -229,7 +229,7 @@ void cxgb4_free_mps_ref_entries(struct a
 {
 	struct mps_entries_ref *mps_entry, *tmp;
 
-	if (!list_empty(&adap->mps_ref))
+	if (list_empty(&adap->mps_ref))
 		return;
 
 	spin_lock(&adap->mps_ref_lock);


