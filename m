Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F69D2C05AB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgKWMY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:24:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbgKWMY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:24:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D71320781;
        Mon, 23 Nov 2020 12:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134266;
        bh=TsyKRqeEiUfVB1QJLHB9L0mRfZmCsoOQYx/SHr9lDac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iopezTsbmfwF5HcOpm5ccv7+tXfZI6X+gMF4DiDhNr6nyphEsMF8CPalYvqyiUq9
         7yRxN0jt9HErEWHtjMlwVfO2n7xZWY/buF3flv5//tZAAxEEGiUaB81xkUMRB6N1y3
         mQN0JPi5VuQ7ook5dvG0qptDWy+5/ipA/2JkBLbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 01/47] ah6: fix error return code in ah6_input()
Date:   Mon, 23 Nov 2020 13:21:47 +0100
Message-Id: <20201123121805.609839169@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
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
@@ -595,7 +595,8 @@ static int ah6_input(struct xfrm_state *
 	memcpy(auth_data, ah->auth_data, ahp->icv_trunc_len);
 	memset(ah->auth_data, 0, ahp->icv_trunc_len);
 
-	if (ipv6_clear_mutable_options(ip6h, hdr_len, XFRM_POLICY_IN))
+	err = ipv6_clear_mutable_options(ip6h, hdr_len, XFRM_POLICY_IN);
+	if (err)
 		goto out_free;
 
 	ip6h->priority    = 0;


