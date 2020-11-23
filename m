Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB5A2C0773
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732568AbgKWMlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732622AbgKWMlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EF7D20732;
        Mon, 23 Nov 2020 12:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135271;
        bh=DAt5oMEL8wGO7kWrjuS7os4RE9HeZqc11z9UviTiBv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKcltgNIvHyqH18EZ01ZVOh4708u9X0SbXG7fvWzEFdyDvnSM5LYQZ2InWIHAFQlt
         VIceOb7T0heeSfeVE4Gvx5M4DwabN1dlVHxm/Hpgds1GTxd/wBjUrf1MbdSeKuj9a6
         XMzY02X4KWnqcUKO1+3X679hXuaKgBz6eyGaO6WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 001/252] ah6: fix error return code in ah6_input()
Date:   Mon, 23 Nov 2020 13:19:11 +0100
Message-Id: <20201123121835.658103891@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
@@ -588,7 +588,8 @@ static int ah6_input(struct xfrm_state *
 	memcpy(auth_data, ah->auth_data, ahp->icv_trunc_len);
 	memset(ah->auth_data, 0, ahp->icv_trunc_len);
 
-	if (ipv6_clear_mutable_options(ip6h, hdr_len, XFRM_POLICY_IN))
+	err = ipv6_clear_mutable_options(ip6h, hdr_len, XFRM_POLICY_IN);
+	if (err)
 		goto out_free;
 
 	ip6h->priority    = 0;


