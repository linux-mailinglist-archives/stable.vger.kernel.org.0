Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46873C5401
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349405AbhGLH4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351513AbhGLHvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F423961154;
        Mon, 12 Jul 2021 07:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076144;
        bh=zs3+Ss61RQ/gdx1D7TAgTvrtI2/KFlM1F2A1G8MJiKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCpHK/hVDH3cM0UN/yOAVrY49JSpntrbGulKnWbgoBSzdyV5ghZFIsNq4bx4cQS7y
         sFGuy/arRfAfTnqTl6WKACaA2xOTkKA7XI6YiElrRYOy+ktp7ctzPNHfHJn004WX5S
         0m3HDF1x+adI2Ok75zpgmdVp1005GcBgylMQweRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 515/800] skmsg: Fix a memory leak in sk_psock_verdict_apply()
Date:   Mon, 12 Jul 2021 08:08:58 +0200
Message-Id: <20210712061022.005787543@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 0cf6672b23c8aa9d9274798dd63cbf6ede77ef90 ]

If the dest psock does not set SK_PSOCK_TX_ENABLED,
the skb can't be queued anywhere so must be dropped.

This one is found during code review.

Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210615021342.7416-6-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index df545748cd6a..dd22ca838754 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -947,8 +947,13 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 				skb_queue_tail(&psock->ingress_skb, skb);
 				schedule_work(&psock->work);
+				err = 0;
 			}
 			spin_unlock_bh(&psock->ingress_lock);
+			if (err < 0) {
+				skb_bpf_redirect_clear(skb);
+				goto out_free;
+			}
 		}
 		break;
 	case __SK_REDIRECT:
-- 
2.30.2



