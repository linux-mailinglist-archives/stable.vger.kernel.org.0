Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D1C450CFE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbhKORrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:47:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238599AbhKORpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:45:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ADF863292;
        Mon, 15 Nov 2021 17:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997339;
        bh=q7+JKYDf1EkjcTGs/fYYm4TFB1FQ5QmnRQ3y6LFG1LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4BUz+sBMHVPytQW8u3TMzXsB6+xaXbZcQYjQjdHcQNZ60rlWltmcazlC/ZWwHhIW
         xxLnkvLcHNIaXEMSNhadsN8daBT2Kk6btIrYqf8ABJUz9tkEc0mXAtJhVSBBlOobeA
         q7Y/mOd1vq6HbFis/vG0VcEd7dc94T1y9Q5F8tTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/575] net/smc: Fix smc_link->llc_testlink_time overflow
Date:   Mon, 15 Nov 2021 17:56:45 +0100
Message-Id: <20211115165346.410766548@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

[ Upstream commit c4a146c7cf5e8ad76231523b174d161bf152c6e7 ]

The value of llc_testlink_time is set to the value stored in
net->ipv4.sysctl_tcp_keepalive_time when linkgroup init. The value of
sysctl_tcp_keepalive_time is already jiffies, so we don't need to
multiply by HZ, which would cause smc_link->llc_testlink_time overflow,
and test_link send flood.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_llc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 2e7560eba9812..d8fe4e1f24d1f 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1787,7 +1787,7 @@ void smc_llc_link_active(struct smc_link *link)
 			    link->smcibdev->ibdev->name, link->ibport);
 	link->state = SMC_LNK_ACTIVE;
 	if (link->lgr->llc_testlink_time) {
-		link->llc_testlink_time = link->lgr->llc_testlink_time * HZ;
+		link->llc_testlink_time = link->lgr->llc_testlink_time;
 		schedule_delayed_work(&link->llc_testlink_wrk,
 				      link->llc_testlink_time);
 	}
-- 
2.33.0



