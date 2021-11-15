Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E00345091E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 17:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhKOQFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 11:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbhKOQFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 11:05:09 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5B5C061746
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 08:02:13 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id p17so14955902pgj.2
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 08:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tivrXntTWIbCkVzZC4y1HIyO4FqKtX6bYEAzYxt9B4c=;
        b=oWCc1n4tm5zCJxae3xkGIvL4qNO5jJQK2PhsxaekoUCUdhsyS7fg9L2yaSfdbujV6o
         Nxst2ng8GqpnJQDUI63bIJ9xF+qaMBDWS8GZZ6aPcOTldEZM5rehKQwQnphbJz2UsHyt
         VEiEBBs85fhJgJd4r6lseabO8YMZjqRaKncMOBiOVwBIu1Mujam77+cBPU1X303T/eNA
         f4jYM1hLklyJnwCD4BJBnhFX1rkPuAGRZkO/m4okbBL/i6/JnjpAP82/ZWWkSfaFR+xY
         r1NWO0EsdOZt6G/ek3HGZRAaKGon42iM9vQaiXnB8LBn52A3DXSZYYIzW1UCu3zHOHp0
         GLBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tivrXntTWIbCkVzZC4y1HIyO4FqKtX6bYEAzYxt9B4c=;
        b=x0/hXX6muUBrzNHhUt+vQB96Yr7WE+U72ckomIErM4vYpFGyUC7fWNxiB2HMMy5/AU
         50Pw2IG1To/xfZ15nBCfKjhq6JGizleh9CrCNv5BXyoLYY6pTSbtGkzG7Yo5ESvZzeEn
         8Ek1oFjBrOe1N3gD9J+sJNwSmaTmSjZ2/dvLvJ9d5VLt32nG5kPFFM6wgN2/PKXVuAEY
         tHeHS9UH1h8jujhHmCut4Q95eHw/1jc4fZbby4OjgSuhXiFQu1zaE7MsU7UhTFaTQaaY
         yFsksRlaM2umP+GpJjLBjdpELZ26eaCfwBN45TxGqPp0hUs4eYCb3Nw5by9qerlwkS/w
         ZGpA==
X-Gm-Message-State: AOAM532mtJ40uyc1w+u2zA5/pNtFGP2ZHC74yEmND4x32aMCa4HH79TO
        C3JM0Lk7i2lzdySWYanfF6s+wCjXTAp5xBOz
X-Google-Smtp-Source: ABdhPJzwcqJ6KzoH1s6JCM7i7hqtm/wv2VNT0LxCOTZuK4dKTRSpry+DXx0j2CMmYHa146COp1uoBw==
X-Received: by 2002:a63:bf45:: with SMTP id i5mr25148151pgo.161.1636992133191;
        Mon, 15 Nov 2021 08:02:13 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id o2sm16331383pfu.206.2021.11.15.08.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 08:02:12 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     davem@davemloft.net
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v2] tipc: check for null after calling kmemdup
Date:   Mon, 15 Nov 2021 08:01:43 -0800
Message-Id: <20211115160143.5099-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kmemdup can return a null pointer so need to check for it, otherwise
the null key will be dereferenced later in tipc_crypto_key_xmit as
can be seen in the trace [1].

Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 5.15, 5.14, 5.10

[1] https://syzkaller.appspot.com/bug?id=bca180abb29567b189efdbdb34cbf7ba851c2a58

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
Changed in v2:
- use tipc_aead_free() to free all crytpo tfm instances
  that might have been allocated before the fail.
---
 net/tipc/crypto.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index dc60c32bb70d..d293614d5fc6 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -597,6 +597,10 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
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
-- 
2.33.1

