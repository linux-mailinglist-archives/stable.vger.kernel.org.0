Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B0B2F73AB
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 08:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbhAOHWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 02:22:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730752AbhAOHWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 02:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49733235F7;
        Fri, 15 Jan 2021 07:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610695272;
        bh=t6bsm3dj66JCfiLBroS4enLdk9jAAlpGroganagjz7s=;
        h=From:To:Cc:Subject:Date:From;
        b=Q5SFEGXz77cRcyn6xhNzxLqPBYPfvV5WsJT9/8Bzr2syrUNTY3OhMwTY6ggLF0Qq3
         iD9SMyLAKEHjq6xw7G84TqhaAvVxC+EYI9L5nSKvCU8mMJymOJjgR2L5Bflio/qc1o
         ZfAtvsg2PrOLtpfwvLlUkkQy2oegmRfIj174mTejSWSpB2vnQjFKQryajRy7k7/iAY
         Z2/as+lqrAwh3V3YPYoN/bdn3nTUHV2bgJZvEjGs4x+WnfnWWkFqjONK3clWSbSBEK
         d+m5M4IdpkTtPqxc60CmfHLEsijqhWwCFWhBw/ivGvk9IE+zwpqqsHJ2U5CGDTjy9n
         sciXfrnyF6BVg==
From:   jarkko@kernel.org
To:     dhowells@redhat.com
Cc:     andrew.zaborowski@intel.com, joeyli.kernel@gmail.com,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] keys: crypto: Replace BUG_ON() with WARN() in find_asymmetric_key()
Date:   Fri, 15 Jan 2021 09:21:08 +0200
Message-Id: <20210115072108.96163-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

BUG_ON() should not be used in the kernel code, unless there are
exceptional reasons to do so. Replace BUG_ON() with WARN() and
return.

Cc: stable@vger.kernel.org
Fixes: b3811d36a3e7 ("KEYS: checking the input id parameters before finding asymmetric key")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 crypto/asymmetric_keys/asymmetric_type.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 33e77d846caa..47cc88fa0fa7 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -54,7 +54,10 @@ struct key *find_asymmetric_key(struct key *keyring,
 	char *req, *p;
 	int len;
 
-	BUG_ON(!id_0 && !id_1);
+	if (!id_0 && !id_1) {
+		WARN(1, "All ID's are NULL\n");
+		return ERR_PTR(-EINVAL);
+	}
 
 	if (id_0) {
 		lookup = id_0->data;
-- 
2.29.2

