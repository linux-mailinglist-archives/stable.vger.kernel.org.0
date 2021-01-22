Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2C4300558
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbhAVO0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:26:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbhAVOZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:25:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D617023B09;
        Fri, 22 Jan 2021 14:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325193;
        bh=I/9p1OzeQA0INv+403TFpmE984l0xVl+zZ/j/WXI/Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3gIRJn9i7W2fS7DGfXHmkPDMbVGdQF9var43HhiNswT8khoHr4K7UK8ZuWgnJDoJ
         PdRN64R7gwr1bZzuxT/iIlqLEWNVc+uC3rvt1KtCiYtIDra1ZKdIdxxYNkF3ma+moa
         wCEEISJ4Tfcn0f9/RJCJo+kuY3WYugwIKdz1kmyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Dumitrescu <cristian.dumitrescu@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 25/43] i40e: fix potential NULL pointer dereferencing
Date:   Fri, 22 Jan 2021 15:12:41 +0100
Message-Id: <20210122135736.666730336@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Dumitrescu <cristian.dumitrescu@intel.com>

[ Upstream commit 7128c834d30e6b2cf649f14d8fc274941786d0e1 ]

Currently, the function i40e_construct_skb_zc only frees the input xdp
buffer when the output skb is successfully built. On error, the
function i40e_clean_rx_irq_zc does not commit anything for the current
packet descriptor and simply exits the packet descriptor processing
loop, with the plan to restart the processing of this descriptor on
the next invocation. Therefore, on error the ring next-to-clean
pointer should not advance, the xdp i.e. *bi buffer should not be
freed and the current buffer info should not be invalidated by setting
*bi to NULL. Therefore, the *bi should only be set to NULL when the
function i40e_construct_skb_zc is successful, otherwise a NULL *bi
will be dereferenced when the work for the current descriptor is
eventually restarted.

Fixes: 3b4f0b66c2b3 ("i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/r/20210111181138.49757-1-cristian.dumitrescu@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -348,12 +348,12 @@ int i40e_clean_rx_irq_zc(struct i40e_rin
 		 * SBP is *not* set in PRT_SBPVSI (default not set).
 		 */
 		skb = i40e_construct_skb_zc(rx_ring, *bi);
-		*bi = NULL;
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
 			break;
 		}
 
+		*bi = NULL;
 		cleaned_count++;
 		i40e_inc_ntc(rx_ring);
 


