Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C715D549
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 19:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfGBRdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 13:33:03 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:55281 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfGBRdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 13:33:03 -0400
Received: by mail-pg1-f201.google.com with SMTP id t2so9988575pgs.21
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 10:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=owFzYWSiBQ36MNNsLRQ1/NX8lTAESlyxM0Stn+FRyAw=;
        b=Pqlvgy1xgR+IalADZQrC2d+jhjOW0aS0kwR02OkncMdn9aPTkF4X54v4YuIj8BVAch
         ty/DBW3mdGQnMCyrclkoz/mNkqvP+tiW7rx1p8mQoo2k3OqYgFA+9iflsan5jNUVCOZM
         gTjaHqFJkLnyRRtnABIMYkMCw2K4MBY6eeW5xNQwDoU5xp/MGurWlwlHPbN7WvLfGwdO
         bo/0y/ON4BFaYKtuMVNDzc/fjp9QE3VM4KnfEER2uoPG4SKVnR/g8ZPLkjXK+jd/CdGm
         2XwYtNDe4Y3RDA7yLGvVVkLWmuGjNcelhQ9XwX9AmxF4oFDVLKKI9tMR3ZRpcrDe4hBm
         TwiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=owFzYWSiBQ36MNNsLRQ1/NX8lTAESlyxM0Stn+FRyAw=;
        b=GkD34oD77s2ryDc0j3v6I+1ighMkS9U9KvbzViNvpYyn69+5HELDziEOr8MlrCmBoK
         dphPag9iqYsDa5z8Odh6jXwREngQvzHeYBYKUod1rI+utsc9oKuauhwj2x98GYdXbRcD
         t/QMGjKTJZBS4rNsTUT4yrFv3H2xKYX3savobNztROarbo54Mi2QwtgVTCOm6QeY6t8g
         Ra41OTGrAjtPs3TkD0g/z5yZ6flIZ/Va8ipBGyMm3ENZwsQoa43qwdnlQYQr/B0HiIkg
         zJY1uAM9OM96yjtBd0ZAo7uHixIw1MX5jbdkgC2caNZb/Ka99Fr6q3nfemPBq2YyBHyl
         MCQw==
X-Gm-Message-State: APjAAAVajV9z+VTbMW/H+8SN/oyt3Y7vQZ33hWqpA9Tp+H+sVkaswuvA
        GPkwsXNaDZHFG1dyqaCL2UWTzQDq
X-Google-Smtp-Source: APXvYqziFk7LQkhgENWbUatXtwaWbEKJ1pBu2us5QWs62+RjkrPO+tDfe3Dq131vOGL2aeWV0d6B7y+q
X-Received: by 2002:a65:5a44:: with SMTP id z4mr18488037pgs.41.1562088782664;
 Tue, 02 Jul 2019 10:33:02 -0700 (PDT)
Date:   Tue,  2 Jul 2019 10:32:56 -0700
Message-Id: <20190702173256.50485-1-cfir@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v2] crypto: ccp/gcm - use const time tag comparison.
From:   Cfir Cohen <cfir@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Cfir Cohen <cfir@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Avoid leaking GCM tag through timing side channel.

Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Cfir Cohen <cfir@google.com>
---
 drivers/crypto/ccp/ccp-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index db8de89d990f..633670220f6c 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -840,7 +840,8 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 		if (ret)
 			goto e_tag;
 
-		ret = memcmp(tag.address, final_wa.address, AES_BLOCK_SIZE);
+		ret = crypto_memneq(tag.address, final_wa.address,
+				    AES_BLOCK_SIZE) ? -EBADMSG : 0;
 		ccp_dm_free(&tag);
 	}
 
-- 
2.22.0.410.gd8fdbe21b5-goog

