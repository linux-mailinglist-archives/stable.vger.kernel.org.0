Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41CD2F1391
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbhAKNLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731303AbhAKNLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:11:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA9F3229CA;
        Mon, 11 Jan 2021 13:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370620;
        bh=Pnfm3O090tdqEk/5y0vw8aghyeCrZ2nPkZItlV8v2oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H59TAZEu5TqpJAq9sP3gnQr9nEFnDo58cTrAV+5mBPvGmQg+WKcfkctBESgvRvwFo
         el+WKMaOsKyWDTm9H8qaU/B4Zf/6aXmeY6Ow2qiJWh1jz5yCZ0xYDxlp7jg/M1j2Ni
         37arOCU5ZkHa2lfZjYPq8p7kLus2MSJVTYV2+KH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Wang <wangzhiqiang.bj@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 24/92] net/ncsi: Use real net-device for response handler
Date:   Mon, 11 Jan 2021 14:01:28 +0100
Message-Id: <20210111130040.309674134@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Wang <wangzhiqiang.bj@bytedance.com>

[ Upstream commit 427c940558560bff2583d07fc119a21094675982 ]

When aggregating ncsi interfaces and dedicated interfaces to bond
interfaces, the ncsi response handler will use the wrong net device to
find ncsi_dev, so that the ncsi interface will not work properly.
Here, we use the original net device to fix it.

Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
Signed-off-by: John Wang <wangzhiqiang.bj@bytedance.com>
Link: https://lore.kernel.org/r/20201223055523.2069-1-wangzhiqiang.bj@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/ncsi-rsp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1114,7 +1114,7 @@ int ncsi_rcv_rsp(struct sk_buff *skb, st
 	int payload, i, ret;
 
 	/* Find the NCSI device */
-	nd = ncsi_find_dev(dev);
+	nd = ncsi_find_dev(orig_dev);
 	ndp = nd ? TO_NCSI_DEV_PRIV(nd) : NULL;
 	if (!ndp)
 		return -ENODEV;


