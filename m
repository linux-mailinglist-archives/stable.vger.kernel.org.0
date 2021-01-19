Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7196F2FC152
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 21:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbhASUlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 15:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbhASUlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 15:41:18 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEEEC061575
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 12:40:33 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c127so920496wmf.5
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 12:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hqz5KkIUWAsMMr4Nkw2DHVorD8Rmr14UkHNWJhlYZr4=;
        b=jnv/+KO6i5GVy+raRH2CktGNmAyPW0kmZGHyjPRMIyNRYpsdPac9XA9MP5fazurmcq
         uCqt9zVEVQis/S9aVBLK7nY7cIsaz/HC6J+AP7AdKjkftzSD5cygQfazN6CZpkcl2NtD
         HYatepnZHhxbcuEELJSbkHVlDUDcnxBpnEIQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hqz5KkIUWAsMMr4Nkw2DHVorD8Rmr14UkHNWJhlYZr4=;
        b=S4b+weMSWrAPsBz6XbV4gQgTAF1IiP/n7OFMQ3AGPizZt62gU8fIYCHt6OQ2lk1msR
         jNxLn+JFS7B+rcJJ5rTaIxWvLjzFCNYcQgr7XRuWvvcR9FDwZ06+lNQFVRJpcrsUeBv8
         N/Uy9zpaMcZY0rMujsn7pngU50pcbaAP4Bx0Ra6+Mplokz68JzJC+zV4PLAiB2WTUeJ8
         jYEvpQTCBS1HE5ThYjOICWCv7a/qho7TRJPzfmpMFhpCXTSEie3IEpEY9LHxd9HeeY7r
         7BeJagnmss43fRYT7ho/Vd6XYO7P3GpzZF1MZj189ZiLze3JRhh6cqFrOsBWN03DNyHG
         GdeA==
X-Gm-Message-State: AOAM533iVm22zaWK9m5PpBRPYZ1uOLv4xAMZ9sYwE5YYRuTfT68e9R34
        oFXqf8lHf+DHGBw1jl0rbE13uQ==
X-Google-Smtp-Source: ABdhPJxhg7dmzxe2FdXAxsUXYiD0FnIa6AXlhUScb/esR/2HsvsfX6Iamf+TH80zY5689pHsjLT1lQ==
X-Received: by 2002:a7b:cbd5:: with SMTP id n21mr1280568wmi.5.1611088832105;
        Tue, 19 Jan 2021 12:40:32 -0800 (PST)
Received: from localhost.localdomain (29.177.200.146.dyn.plus.net. [146.200.177.29])
        by smtp.gmail.com with ESMTPSA id x128sm6642847wmb.29.2021.01.19.12.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 12:40:31 -0800 (PST)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org
Cc:     Ignat Korchagin <ignat@cloudflare.com>, kernel-team@cloudflare.com,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH] dm crypt: fix invalid copy paste in crypt_alloc_req_aead
Date:   Tue, 19 Jan 2021 20:40:15 +0000
Message-Id: <20210119204015.49516-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit d68b295 ("dm crypt: use GFP_ATOMIC when allocating crypto requests
from softirq") I wrongly copy pasted crypto request allocation code from
crypt_alloc_req_skcipher to crypt_alloc_req_aead. It is OK from runtime
perspective as both simple encryption request pointer and AEAD request pointer
are part of a union, but may confuse code reviewers.

Fixes: d68b295 ("dm crypt: use GFP_ATOMIC when allocating crypto requests from softirq")
Cc: stable@vger.kernel.org # v5.9+
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 drivers/md/dm-crypt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8c874710f0bc..5a55617a08e6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1481,9 +1481,9 @@ static int crypt_alloc_req_skcipher(struct crypt_config *cc,
 static int crypt_alloc_req_aead(struct crypt_config *cc,
 				 struct convert_context *ctx)
 {
-	if (!ctx->r.req) {
-		ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
-		if (!ctx->r.req)
+	if (!ctx->r.req_aead) {
+		ctx->r.req_aead = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
+		if (!ctx->r.req_aead)
 			return -ENOMEM;
 	}
 
-- 
2.20.1

