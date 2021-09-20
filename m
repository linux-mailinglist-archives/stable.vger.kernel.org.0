Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075E7412313
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377802AbhITSU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351318AbhITSS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B460632A6;
        Mon, 20 Sep 2021 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158590;
        bh=Yj1TZDy2FUjXAXfIjbZskgaCeCbx9tYsqXQSQSi/SP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwSOinp8VshhZTIwtKnL9bjjWOgk++XT9Wbcvy3b6AJoHnuz7TRJB3DGAKGLFc77O
         KHLHCbRcil/uYsAFS2P6IOXjO6gFYCO2OEljaRQEVhWa+iFc22ECEdvoJ4IikydJza
         7UwfU4bSbYWwuF5v1TxBquzom4gK9G1Em6MWTiMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
        YunQiang Su <wzssyqa@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 194/260] bnx2x: Fix enabling network interfaces without VFs
Date:   Mon, 20 Sep 2021 18:43:32 +0200
Message-Id: <20210920163937.704556034@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

commit 52ce14c134a003fee03d8fc57442c05a55b53715 upstream.

This function is called to enable SR-IOV when available,
not enabling interfaces without VFs was a regression.

Fixes: 65161c35554f ("bnx2x: Fix missing error code in bnx2x_iov_init_one()")
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Reported-by: YunQiang Su <wzssyqa@gmail.com>
Tested-by: YunQiang Su <wzssyqa@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Shai Malin <smalin@marvell.com>
Link: https://lore.kernel.org/r/20210912190523.27991-1-bunk@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1246,7 +1246,7 @@ int bnx2x_iov_init_one(struct bnx2x *bp,
 
 	/* SR-IOV capability was enabled but there are no VFs*/
 	if (iov->total == 0) {
-		err = -EINVAL;
+		err = 0;
 		goto failed;
 	}
 


