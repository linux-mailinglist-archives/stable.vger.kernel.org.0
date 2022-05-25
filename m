Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EAF5342A7
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 20:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343630AbiEYSET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 14:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343627AbiEYSER (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 14:04:17 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4109D4E3;
        Wed, 25 May 2022 11:04:15 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id bo5so19884198pfb.4;
        Wed, 25 May 2022 11:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h1TzB6zXHOqKMcJg/Znm0cPLJ3T5vb+uHY7kgpQJECw=;
        b=eeuP43yZFEXFZNcbgSIVZCLPVZvBoHO+43zuKmEWHeY2uYb7hyM10eQ6yX0ME4TQlH
         jiezxETkzQdMOFfgQqO9YwxX5MVyJ14DHFiG7b2bxoUQpfT392P4HbaDM8qyTJkRCv3Y
         JhKBHR9wuWkk35jYgJVYw/lhxCDgc68OvL9fIQ7L0v9oi8bYFf7G648QdEjwPszsUDY7
         fWxMzRje4vILYRkr2E/edNWfsLFlaxeF0CsncBGH/0lMHxexdQcsOYCzG8ygvvF75vs3
         ZO61VhCWq82/9PNjPRFUB3BfzeD9viiZ6nM+mN1i2jonymC5b44WuhwrBIXxYBh3SuAO
         T/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h1TzB6zXHOqKMcJg/Znm0cPLJ3T5vb+uHY7kgpQJECw=;
        b=GzO5tV97m58bzedj6mZUprpj2dROMvPFDjOexqXZZvL1Rlb6eNtLb8iPNnB07+vwx3
         Z34SP+RixF2KuSEcCvF6sja4CHPnPZHOeM+jXtxuu1EfOkwFXMJXioad1nQ4YAYfcP9N
         Z3a7L4JZ6N0FdHniqXtP2mme3vUORV2/SjsXjcqVqZzuKpqO2tS8IoCYBEmxKHuz5xvT
         yUSU1vEFbBbSIFAISkXzwGKVfiGXrzRIyvF5WdPu+QkhMlMg8JsFAcyL4n/ybM5zVyTU
         fPQUU3ESixlqNEpDO3vWFJPcvKwSDxkqty0Sozn+R5FBdstHVgPQFSlQ7R5EJnganrYx
         pwJQ==
X-Gm-Message-State: AOAM530chzwVFhCMZZNYsnemSQJ9VZYC/oNjTdELgZAHPJNvzgl+wYCg
        necIbDpqgYALbLrHNAcIPnzoq+vn12Y=
X-Google-Smtp-Source: ABdhPJwU8NvQlKhpXt6N/mFMMSnIztUWJDhbhyelzS2GIK0RpPcXNYOeEdq2m+c1gA4DoeCW8vFXeQ==
X-Received: by 2002:a63:ef01:0:b0:3fb:4d0:6b62 with SMTP id u1-20020a63ef01000000b003fb04d06b62mr704946pgh.148.1653501855045;
        Wed, 25 May 2022 11:04:15 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:150:a0bd:a968:f6a2])
        by smtp.gmail.com with ESMTPSA id h11-20020a65518b000000b003c644b2180asm8826933pgq.77.2022.05.25.11.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 11:04:13 -0700 (PDT)
Date:   Wed, 25 May 2022 11:04:11 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 04/33] Input: stmfts - fix reference leak in
 stmfts_input_open
Message-ID: <Yo5vmwfaJKhg9fzF@google.com>
References: <20220523165746.957506211@linuxfoundation.org>
 <20220523165747.818755611@linuxfoundation.org>
 <20220525105248.GA31002@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525105248.GA31002@duo.ucw.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 25, 2022 at 12:52:48PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Zheng Yongjun <zhengyongjun3@huawei.com>
> > 
> > [ Upstream commit 26623eea0da3476446909af96c980768df07bbd9 ]
> > 
> > pm_runtime_get_sync() will increment pm usage counter even it
> > failed. Forgetting to call pm_runtime_put_noidle will result
> > in reference leak in stmfts_input_open, so we should fix it.
> 
> This is wrong, AFAICT.

Yes, I think you are right. How about below?

Thanks.

-- 
Dmitry


Input: stmfts - do not leave device disabled in stmfts_input_open

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

The commit 26623eea0da3 attempted to deal with potential leak of runtime
PM counter when opening the touchscreen device, however it ended up
erroneously dropping the counter in the case of successfully enabling the
device.

Let's address this by using pm_runtime_resume_and_get() and then executing
pm_runtime_put_sync() only when we fail to send "sense on" command to the
device.

Fixes: 26623eea0da3 ("Input: stmfts - fix reference leak in stmfts_input_open")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/stmfts.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/stmfts.c b/drivers/input/touchscreen/stmfts.c
index 72e0b767e1ba..c175d44c52f3 100644
--- a/drivers/input/touchscreen/stmfts.c
+++ b/drivers/input/touchscreen/stmfts.c
@@ -337,13 +337,15 @@ static int stmfts_input_open(struct input_dev *dev)
 	struct stmfts_data *sdata = input_get_drvdata(dev);
 	int err;
 
-	err = pm_runtime_get_sync(&sdata->client->dev);
-	if (err < 0)
-		goto out;
+	err = pm_runtime_resume_and_get(&sdata->client->dev);
+	if (err)
+		return err;
 
 	err = i2c_smbus_write_byte(sdata->client, STMFTS_MS_MT_SENSE_ON);
-	if (err)
-		goto out;
+	if (err) {
+		pm_runtime_put_sync(&sdata->client->dev);
+		return err;
+	}
 
 	mutex_lock(&sdata->mutex);
 	sdata->running = true;
@@ -366,9 +368,7 @@ static int stmfts_input_open(struct input_dev *dev)
 				 "failed to enable touchkey\n");
 	}
 
-out:
-	pm_runtime_put_noidle(&sdata->client->dev);
-	return err;
+	return 0;
 }
 
 static void stmfts_input_close(struct input_dev *dev)
