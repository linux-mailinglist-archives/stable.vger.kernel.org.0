Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486F43A009D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhFHSp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235312AbhFHSmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:42:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 695E0613D3;
        Tue,  8 Jun 2021 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177353;
        bh=oy1FAr+NNpZ5MJWeJjxdg+OMHrQSZwNpVeFG4CAO12c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+R6eG8r34DAnWIi+1mQx1Sxx9n32dicYIE+BHq+vzEbJJc1Lz0fLIZB0+7dAthmP
         LC4Ua1KNgMvgcqOP68jsW4MqB7HR5wZpkZXUxuAoUTtHD8SuIMaCmhEJy2Ai3SIruC
         qTt/avG5ZOSvbrn1n28T9ou7VhuHZgXBeUn5EHI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/78] ieee802154: fix error return code in ieee802154_llsec_getparams()
Date:   Tue,  8 Jun 2021 20:26:50 +0200
Message-Id: <20210608175935.980593923@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
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
index d19c40c684e8..71be75112321 100644
--- a/net/ieee802154/nl-mac.c
+++ b/net/ieee802154/nl-mac.c
@@ -680,8 +680,10 @@ int ieee802154_llsec_getparams(struct sk_buff *skb, struct genl_info *info)
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



