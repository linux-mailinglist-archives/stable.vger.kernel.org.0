Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31ABB86F8
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391578AbfISWL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393587AbfISWLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:11:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D5BA21907;
        Thu, 19 Sep 2019 22:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931084;
        bh=HaJIQUt1q4yjUOn3fBZcxEDzdsuOckbpaxjgOjv2+7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQTUqJb1ys9BOABweHm2WY89EHZpVgZfnQkgU2kyf2mN3Z9hp13zloI42CZQ/zhwa
         kZT9ICgT9FQeEE3k0pd4NTlInonOQatwXjkVYdN5FCdK7jmkHakznS2li+5B/LKO0Z
         a67O85HOy/wieQCKkKZRJ5Jre6ffOvw64wIia1wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Russkikh <igor.russkikh@aquantia.com>,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 105/124] net: aquantia: fix out of memory condition on rx side
Date:   Fri, 20 Sep 2019 00:03:13 +0200
Message-Id: <20190919214823.020732439@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit be6cef69ba570ebb327eba1ef6438f7af49aaf86 ]

On embedded environments with hard memory limits it is a normal although
rare case when skb can't be allocated on rx part under high traffic.

In such OOM cases napi_complete_done() was not called.
So the napi object became in an invalid state like it is "scheduled".
Kernel do not re-schedules the poll of that napi object.

Consequently, kernel can not remove that object the system hangs on
`ifconfig down` waiting for a poll.

We are fixing this by gracefully closing napi poll routine with correct
invocation of napi_complete_done.

This was reproduced with artificially failing the allocation of skb to
simulate an "out of memory" error case and check that traffic does
not get stuck.

Fixes: 970a2e9864b0 ("net: ethernet: aquantia: Vector operations")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 715685aa48c39..28892b8acd0e1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -86,6 +86,7 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 			}
 		}
 
+err_exit:
 		if (!was_tx_cleaned)
 			work_done = budget;
 
@@ -95,7 +96,7 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 					1U << self->aq_ring_param.vec_idx);
 		}
 	}
-err_exit:
+
 	return work_done;
 }
 
-- 
2.20.1



