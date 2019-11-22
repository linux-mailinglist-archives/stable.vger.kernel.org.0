Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A559106F73
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfKVLPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:15:38 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46089 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730003AbfKVKvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:51:42 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so4625307wrl.13
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xoswTEced0zgBg3f0q2Jl0pYmerTX2npX5p/p8vJwQY=;
        b=d0fRaHbGkO9SZLpmTd+orsxx3VQXbNb8pQVDFeYLwJxA6KQ0sZ9ND5lJ496yR59TAD
         FerJ3hEcnsr58Kx8f/Xe12ph4bqaMpDJk/8URPW4eNbzyqc43zUYqB5Pz3evcAOkbBdu
         aZglLxVtHNDLFvlNXxcqDkZmilVa4qkUcWj8tF2zFaE8l4k87e096b6/y9xj+bZVQED4
         6wv9xtQnUJQXRfDHp/I26rCOVvyEF1BWnf4pLuC7jix4pRb4eweZTN+M8E8UDOzST/eM
         rqbJZjrNRJ2vUbTkAbU901BTZeG/f4dNSojpWQso6CI1tZ123UQlULz3xPLaYeyGeTD+
         Mtxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xoswTEced0zgBg3f0q2Jl0pYmerTX2npX5p/p8vJwQY=;
        b=L79zT1WO6pyajvjSkYts7lRK6dURV0UxrSJWSK/zZROZBNQvLOCDQyHvs0L14yRAHg
         yTjV1haUrtXQZfn9uzvNdN7zMkG/OEEkm0iKyms458AZZAFTzsqKTWywmuWmiL3+vViB
         41h0GJwAlx+0rzXnuadinnvNcwbw+5dLWpkGqpgGEP3mU5ODcNGlYmiksjXbL9zUrkde
         WPy09jYCix6lczL/V0Gyfku+DjBTYo/euGFVI7OEHv2dCR4GS6YSqPgjuYn0YPwnZfft
         guc01+r4UTqeqwY3JULKOr3xJ3q7pAnIaDuGAK4429uxB34IiFiJwnXRwztm5y/2kGFW
         wfbA==
X-Gm-Message-State: APjAAAWaOLLDc+mRMhN/HVMgHxcC/GFRVU44bnLGfDlMU1QKtSjdBrIY
        ArA8xJ3L24fg4jQupmRNjjy+1Q==
X-Google-Smtp-Source: APXvYqyGZlyN+LaVE35VX7rDpmz0NGO/m6gGpoGvzr5ZpAAHYzUaHEl+gwNEATr5KgaRzO4kuUoEKw==
X-Received: by 2002:a5d:4b05:: with SMTP id v5mr16697880wrq.210.1574419900607;
        Fri, 22 Nov 2019 02:51:40 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id w4sm2894338wmk.29.2019.11.22.02.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:51:40 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.4 5/9] bcache: silence static checker warning
Date:   Fri, 22 Nov 2019 10:51:09 +0000
Message-Id: <20191122105113.11213-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105113.11213-1-lee.jones@linaro.org>
References: <20191122105113.11213-1-lee.jones@linaro.org>
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
index e42092146083..58e16a3fb3bd 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1395,9 +1395,6 @@ static void cache_set_flush(struct closure *cl)
 	struct btree *b;
 	unsigned i;
 
-	if (!c)
-		closure_return(cl);
-
 	bch_cache_accounting_destroy(&c->accounting);
 
 	kobject_put(&c->internal);
-- 
2.24.0

