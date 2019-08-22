Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E1699C8A
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392380AbfHVRe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404350AbfHVRZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:13 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28956206DD;
        Thu, 22 Aug 2019 17:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494712;
        bh=DLmuBhNK9Dcz0gJkLrVZQJExgZwd70+g/iiwPS2uxVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjdeWyaGz4wtrgWFAJx1GuNJynqzDYqzpEFf0JDvoKFzTuST5JxiV4gR+Wx3vsOrE
         +rAQ5J6av+iaLhCRObhcUyJHAOY1A5tNUp0dUrRfIiAEnLmmeZPI3K3R/AG0am54Xo
         lzJO7JNiCpmCNe0IsYVVj8Gg5VC6py6fHK9GlnQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 68/71] team: Add vlan tx offload to hw_enc_features
Date:   Thu, 22 Aug 2019 10:19:43 -0700
Message-Id: <20190822171730.670700310@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 227f2f030e28d8783c3d10ce70ff4ba79cad653f ]

We should also enable team's vlan tx offload in hw_enc_features,
pass the vlan packets to the slave devices with vlan tci, let the
slave handle vlan tunneling offload implementation.

Fixes: 3268e5cb494d ("team: Advertise tunneling offload features")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1014,7 +1014,9 @@ static void __team_compute_features(stru
 	}
 
 	team->dev->vlan_features = vlan_features;
-	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
+	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
+				     NETIF_F_HW_VLAN_CTAG_TX |
+				     NETIF_F_HW_VLAN_STAG_TX;
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;


