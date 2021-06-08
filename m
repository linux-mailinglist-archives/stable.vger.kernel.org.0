Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8533A0012
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbhFHSkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhFHShI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:37:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E3F361352;
        Tue,  8 Jun 2021 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177179;
        bh=/Kk5XFC71RKixZ0KeWmKO2J/s1lNjqmgXRxjBCww5eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXpdJl4scheyFt0vA1iFYKSon7+kF6UxxuLub0QaI5AJB7LDsb0ek38PFFQ5fVzJM
         dA2MQXJadfz8buvOJqp+MGRsCyvMEMH4csHpTELKbvYSWRkzWxCBJW/d436LovmawG
         KXjc15/qKbdY7mPS6D13OAvBeRuUisqZEzNwdP4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/58] ieee802154: fix error return code in ieee802154_llsec_getparams()
Date:   Tue,  8 Jun 2021 20:26:56 +0200
Message-Id: <20210608175932.789923710@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 373e864cf52403b0974c2f23ca8faf9104234555 ]

Fix to return negative error code -ENOBUFS from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 3e9c156e2c21 ("ieee802154: add netlink interfaces for llsec")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210519141614.3040055-1-weiyongjun1@huawei.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl-mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl-mac.c b/net/ieee802154/nl-mac.c
index c0930b9fe848..7531cb1665d2 100644
--- a/net/ieee802154/nl-mac.c
+++ b/net/ieee802154/nl-mac.c
@@ -688,8 +688,10 @@ int ieee802154_llsec_getparams(struct sk_buff *skb, struct genl_info *info)
 	    nla_put_u8(msg, IEEE802154_ATTR_LLSEC_SECLEVEL, params.out_level) ||
 	    nla_put_u32(msg, IEEE802154_ATTR_LLSEC_FRAME_COUNTER,
 			be32_to_cpu(params.frame_counter)) ||
-	    ieee802154_llsec_fill_key_id(msg, &params.out_key))
+	    ieee802154_llsec_fill_key_id(msg, &params.out_key)) {
+		rc = -ENOBUFS;
 		goto out_free;
+	}
 
 	dev_put(dev);
 
-- 
2.30.2



