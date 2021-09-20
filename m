Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3977341208B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245724AbhITRz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355186AbhITRyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:54:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 538FE619E8;
        Mon, 20 Sep 2021 17:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158005;
        bh=fvQgCBKYGisPejRhGEFl2aUh1j1YdbWQOp0Ga5d9CN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSBk2X9e6n0mg4DpvSIQ7+wJUgnJShlbEsIDMYf0q45Y5kDz/7fna1eX5SXlVUnp7
         hCvHMU1dSDEnDk1RXoeyTpFqWgDNigQ5E/GB9OKOVLANBYiG57tJBBBq64oHBKVWBQ
         Bfamg7lG3YSpcEVftfQiEetJPKhnRaenB7MfR5XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
        YunQiang Su <wzssyqa@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 252/293] bnx2x: Fix enabling network interfaces without VFs
Date:   Mon, 20 Sep 2021 18:43:34 +0200
Message-Id: <20210920163942.014499180@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -1245,7 +1245,7 @@ int bnx2x_iov_init_one(struct bnx2x *bp,
 
 	/* SR-IOV capability was enabled but there are no VFs*/
 	if (iov->total == 0) {
-		err = -EINVAL;
+		err = 0;
 		goto failed;
 	}
 


