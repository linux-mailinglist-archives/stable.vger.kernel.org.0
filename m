Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F083545C3B0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350413AbhKXNlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:41:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350022AbhKXNji (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:39:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF00D63226;
        Wed, 24 Nov 2021 12:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758600;
        bh=DRAHDbdfxPjqId3pYeecJWs4QZ0k8cGONr5rd/JxIas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDL94DX7l+wLECHqhQ6XfYKWJZQ24pCErOBTOPVAwOpA9A36CBUweEANwlKByZqya
         wxcUpirqvMnKn03nLHlSdZS8Td5/oBpegjEMCVYUmui+wMYYOjSWGkIIwzcHQkiQaN
         vENtSCqL73xaTVjifM90ayDLN41KMQO1r2cqpTJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        Dmitry Vyukov <dvyukov@google.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 123/154] tipc: check for null after calling kmemdup
Date:   Wed, 24 Nov 2021 12:58:39 +0100
Message-Id: <20211124115706.265820102@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit 3e6db079751afd527bf3db32314ae938dc571916 upstream.

kmemdup can return a null pointer so need to check for it, otherwise
the null key will be dereferenced later in tipc_crypto_key_xmit as
can be seen in the trace [1].

Cc: tipc-discussion@lists.sourceforge.net
Cc: stable@vger.kernel.org # 5.15, 5.14, 5.10

[1] https://syzkaller.appspot.com/bug?id=bca180abb29567b189efdbdb34cbf7ba851c2a58

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Link: https://lore.kernel.org/r/20211115160143.5099-1-tadeusz.struk@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/crypto.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -590,6 +590,10 @@ static int tipc_aead_init(struct tipc_ae
 	tmp->cloned = NULL;
 	tmp->authsize = TIPC_AES_GCM_TAG_SIZE;
 	tmp->key = kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
+	if (!tmp->key) {
+		tipc_aead_free(&tmp->rcu);
+		return -ENOMEM;
+	}
 	memcpy(&tmp->salt, ukey->key + keylen, TIPC_AES_GCM_SALT_SIZE);
 	atomic_set(&tmp->users, 0);
 	atomic64_set(&tmp->seqno, 0);


