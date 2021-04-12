Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D0335BD0A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbhDLIrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237794AbhDLIqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:46:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E20561241;
        Mon, 12 Apr 2021 08:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217160;
        bh=7L8ihJjyoN+excihidfyeAEtCVIR3IjTBqtFvEulNV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIfrQet8vBTEKUqs/ru+3+m4TD4HjkLYuy9x5Mogb/eBWXv3Gozm9+QrNqoVA4oqz
         z+wRnhkAd6izH1tnWCVf8Fmi0Zm8Zj8VR2rDwto2mjgeTrlaHImtCWWhjKYWNjuS5v
         9lcBuUBJ9hgNxE/Mok1bhublhlPlGvXI/bpwb+nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 026/111] ethernet/netronome/nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx
Date:   Mon, 12 Apr 2021 10:40:04 +0200
Message-Id: <20210412084005.097775011@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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


