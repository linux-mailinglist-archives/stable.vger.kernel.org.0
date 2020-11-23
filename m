Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4355E2C0678
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgKWMbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730834AbgKWMbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:31:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DDB820728;
        Mon, 23 Nov 2020 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134674;
        bh=/HOmZJjee+Umd/rtcD6KTjsut/JQ7cP3EzaAh1Vt1RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1yHfxJ4lZunyBC8RFPDKcbiNNVfKaqeE//k+xQjkqvLoDFgEHhxxF9ZM4yCXYJ+a
         LtojQTt/i+saQcYkHkznf3HJ5dH1geb19siOv2iNwVbS/XEj/cTfBP06D2wWXztFE2
         vwam/A2c68WeiRmheEFlvm55P1aFq7S1woE5vxC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 01/91] ah6: fix error return code in ah6_input()
Date:   Mon, 23 Nov 2020 13:21:21 +0100
Message-Id: <20201123121809.364368880@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit a5ebcbdf34b65fcc07f38eaf2d60563b42619a59 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1605581105-35295-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ah6.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -600,7 +600,8 @@ static int ah6_input(struct xfrm_state *
 	memcpy(auth_data, ah->auth_data, ahp->icv_trunc_len);
 	memset(ah->auth_data, 0, ahp->icv_trunc_len);
 
-	if (ipv6_clear_mutable_options(ip6h, hdr_len, XFRM_POLICY_IN))
+	err = ipv6_clear_mutable_options(ip6h, hdr_len, XFRM_POLICY_IN);
+	if (err)
 		goto out_free;
 
 	ip6h->priority    = 0;


