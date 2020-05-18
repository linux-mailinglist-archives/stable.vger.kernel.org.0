Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3281D8247
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgERRzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728825AbgERRy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:54:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C919207C4;
        Mon, 18 May 2020 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824497;
        bh=KONOyviHySfFCx8g+X0yBPg7f/PqbVDlYmS8u/zo1G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1MnLLuOQz9NJ1OTLW4b+y2vwn0bhxIPx9j0xYJ1cCoW2VUqE3R2jGbr0hkxvPg53
         ukK2cCYx01pfOnLx1OyAggy2Ezhih9Uwwqo3WGzHlR5681FcZmvnNzChLilxyWParw
         YQjLX0vfuwmvH7+stmiY3jt5JRlRLE2TSrZOm00k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 034/147] nfp: abm: fix error return code in nfp_abm_vnic_alloc()
Date:   Mon, 18 May 2020 19:35:57 +0200
Message-Id: <20200518173518.390245737@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 5099dea0a59f1c89525bb0ceac36689178a4c125 ]

Fix to return negative error code -ENOMEM from the kzalloc() error
handling case instead of 0, as done elsewhere in this function.

Fixes: 174ab544e3bc ("nfp: abm: add cls_u32 offload for simple band classification")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/abm/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/netronome/nfp/abm/main.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
@@ -333,8 +333,10 @@ nfp_abm_vnic_alloc(struct nfp_app *app,
 		goto err_free_alink;
 
 	alink->prio_map = kzalloc(abm->prio_map_len, GFP_KERNEL);
-	if (!alink->prio_map)
+	if (!alink->prio_map) {
+		err = -ENOMEM;
 		goto err_free_alink;
+	}
 
 	/* This is a multi-host app, make sure MAC/PHY is up, but don't
 	 * make the MAC/PHY state follow the state of any of the ports.


