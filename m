Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5273035BDF9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbhDLI4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238517AbhDLIyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A9AC61354;
        Mon, 12 Apr 2021 08:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217529;
        bh=7L8ihJjyoN+excihidfyeAEtCVIR3IjTBqtFvEulNV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLQDcGtXVN8C6V4dsprUsFvfkTXpLjtkH37EcxzQzT6dvo0Nstd03htsEd9Z226bw
         l0KrdbFjPbdysZo9OBY8uh1nG9zf/L70NZ0ieH433vr1pAwjb7b1xHMfc4Xyr77Bme
         qhhcZWTaeqWyLNQDizNi43SJhcQwFqg1ZeWDogqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 047/188] ethernet/netronome/nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx
Date:   Mon, 12 Apr 2021 10:39:21 +0200
Message-Id: <20210412084015.206763778@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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


