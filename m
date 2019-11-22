Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADDC106F46
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfKVLOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:14:36 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34057 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbfKVKx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:53:29 -0500
Received: by mail-wm1-f66.google.com with SMTP id j18so9950944wmk.1
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7eQ77p+yZoA07vPJ5MQhHwgPGskB4qfhyE5XsEtx6sE=;
        b=his3mcjnfWoBpqB2zVQxlSl8g0l8Wx1tuGrDrGxy54p0d5QN1DRbW768D9pe7ifTba
         PM4qEQ98qx9/qRxJz65ZMDowBTAF4Gyy605grLq8F4li20M6QlZCINDWhjOzq0SdR44G
         TZbKOrlqWLKgdLLeIq6Lt7yO6VLPGcLlDpZLnkxaxKukjckK6nR6uf9DNbpHCyJUSWTU
         txBZji6jk6ozACvcK6upKCIFg3XwIhWllnRSm/kWX+WUUaoHwHNS/JHaTiYv2AzAd81v
         YDeB0ydCR5OmkI5SLcWMLD/XDUXpyEyzHapMInbTkgKNff1/S2Rz01v26Ks9VWEZARnD
         VJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7eQ77p+yZoA07vPJ5MQhHwgPGskB4qfhyE5XsEtx6sE=;
        b=ajF46L01l5yZnT2Y+FYZxYqw6QXZbCQNEvH8eSleL0Dz1mrz3eoITFO9IeREsCQ8W2
         Soh7aqqC6UrYUnNUAkkNsYZquuF3V48P0D2ZR8Y5lAWZwWoghv7wAhZZXxFxn3gx/G6J
         CXwM+nHOiZz5YhM5eh40aiJ7JigalId86DfRDKlpvi7a39j9kn3/pBXnkbacwfa22PUY
         EjkvrIwzd4uFJ1cgugiZBCCygOz4D6ucm/kH21euRV2LOVEVAAhvv35VGe4tPDLXcO9G
         V+zzABOr2sXdVvR3MKqSNMnb1gPtQ9c7yOnhNUusEnu+lzxVw1aIm7kLhajoBOtmF6hm
         4nbw==
X-Gm-Message-State: APjAAAWnp3tFyD0pFpqIlweIQZ/koH29vJXkt+J8d2cfO3h3J0mc1q75
        VajuWeUdWxldwvzeD1Gbb+B2uPjqUpE=
X-Google-Smtp-Source: APXvYqxtANnXCgoewwZBgXvW3lwp73oVb+r+2mop3CQh3bNVhLr5VHeKuknwxYi6TKJacHtNUB6jOQ==
X-Received: by 2002:a1c:a347:: with SMTP id m68mr504530wme.129.1574420008411;
        Fri, 22 Nov 2019 02:53:28 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id o1sm7444087wrs.50.2019.11.22.02.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:53:27 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.9 5/8] bcache: silence static checker warning
Date:   Fri, 22 Nov 2019 10:52:50 +0000
Message-Id: <20191122105253.11375-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105253.11375-1-lee.jones@linaro.org>
References: <20191122105253.11375-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit da22f0eea555baf9b0a84b52afe56db2052cfe8d ]

In olden times, closure_return() used to have a hidden return built in.
We removed the hidden return but forgot to add a new return here.  If
"c" were NULL we would oops on the next line, but fortunately "c" is
never NULL.  Let's just remove the if statement.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/md/bcache/super.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c5bc3e5e921e..3e113be966fe 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1397,9 +1397,6 @@ static void cache_set_flush(struct closure *cl)
 	struct btree *b;
 	unsigned i;
 
-	if (!c)
-		closure_return(cl);
-
 	bch_cache_accounting_destroy(&c->accounting);
 
 	kobject_put(&c->internal);
-- 
2.24.0

