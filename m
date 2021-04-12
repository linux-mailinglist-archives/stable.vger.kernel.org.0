Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7AD35BFD9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbhDLJHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240259AbhDLJFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E75856135F;
        Mon, 12 Apr 2021 09:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218148;
        bh=7L8ihJjyoN+excihidfyeAEtCVIR3IjTBqtFvEulNV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikBFLjYbH5M7mB5yVN5gU6d2CRVjyEKH4z2+T+wtnXWAaDEYRyGfuFiP9IAmNeZA9
         8at6JKF8Zcnac7jgG2+kZ4ixGeGX9a4hyVmRri9IdhjbrPyxHkyFSEOgZVOA4yk7ws
         wGzdrGhIQQDo/OOqIGBzgb7aTUqMRzblPqzCoOhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 054/210] ethernet/netronome/nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx
Date:   Mon, 12 Apr 2021 10:39:19 +0200
Message-Id: <20210412084017.804570989@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

commit 6e5a03bcba44e080a6bf300194a68ce9bb1e5184 upstream.

In nfp_bpf_ctrl_msg_rx, if
nfp_ccm_get_type(skb) == NFP_CCM_TYPE_BPF_BPF_EVENT is true, the skb
will be freed. But the skb is still used by nfp_ccm_rx(&bpf->ccm, skb).

My patch adds a return when the skb was freed.

Fixes: bcf0cafab44fd ("nfp: split out common control message handling code")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/cmsg.c
@@ -454,6 +454,7 @@ void nfp_bpf_ctrl_msg_rx(struct nfp_app
 			dev_consume_skb_any(skb);
 		else
 			dev_kfree_skb_any(skb);
+		return;
 	}
 
 	nfp_ccm_rx(&bpf->ccm, skb);


