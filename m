Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4785034CADA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhC2IkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232209AbhC2IjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:39:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1D0F61581;
        Mon, 29 Mar 2021 08:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007163;
        bh=bS4+beM0gjYbF2SjpdZWi6VIB/2TjZ6R3yOTixRSw0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKP3yjvCxF1zc05gsrFW6vlSsC2IRFoxCUSuvpvR/LuZkG5WBhcCapLwtsleZbwg4
         35Rz9Pf9tx9PJ13QP3G+qZSfzdUZ/EtiMVJGRUEQ1FR3fQyXN6lc/ogTaW4vYBmRoL
         Yh59mE3QtJ0bt1wgV7N0QhLT9HxzXXK71yCGwBj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 244/254] ch_ktls: fix enum-conversion warning
Date:   Mon, 29 Mar 2021 09:59:20 +0200
Message-Id: <20210329075641.090296821@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 6f235a69e59484e382dc31952025b0308efedc17 upstream.

gcc points out an incorrect enum assignment:

drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c: In function 'chcr_ktls_cpl_set_tcb_rpl':
drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:684:22: warning: implicit conversion from 'enum <anonymous>' to 'enum ch_ktls_open_state' [-Wenum-conversion]

This appears harmless, and should apparently use 'CH_KTLS_OPEN_SUCCESS'
instead of 'false', with the same value '0'.

Fixes: efca3878a5fb ("ch_ktls: Issue if connection offload fails")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -727,7 +727,7 @@ static int chcr_ktls_cpl_set_tcb_rpl(str
 		kvfree(tx_info);
 		return 0;
 	}
-	tx_info->open_state = false;
+	tx_info->open_state = CH_KTLS_OPEN_SUCCESS;
 	spin_unlock(&tx_info->lock);
 
 	complete(&tx_info->completion);


