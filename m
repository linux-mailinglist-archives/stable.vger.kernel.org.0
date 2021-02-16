Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C9131D299
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 23:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhBPW0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 17:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhBPW0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 17:26:17 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C02C061786;
        Tue, 16 Feb 2021 14:25:36 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id f1so18500379lfu.3;
        Tue, 16 Feb 2021 14:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a3fR6Ve9ApfA3U9S3BpD3B/5uX3W9BFd2HZqD0/PdZ8=;
        b=CcBmOTWx4rOfOO2ml/nx0N0ujuOh1Je+9ZyiWKlffqIiTEcwTwAbuvhiwMh9QOxfxE
         l/jJOrtMsJVKBJR9yj4J/FAIUsOixXDYcZDBPWCKWe85ongnmwwd7HdtSIyY6y8O2BF0
         SJ0L9v5A7f93RRY3oshaAlXeLf6PSHX/uIxdjHp56A8/S903ylOhKu6AFyJ7ATWtUjO3
         Gvalg23YbKGdSE1RDy8GgVswZ1FMvDvqbGeFaE0v+YsR4s3NlOjT75dTDlsczowqkMuP
         WQdXDOfrwFCr9qj1oA9+IDq2Z8tdqFKmJNi1TMgoO/odVmefA6HqbiYcUiv39BU1WUcl
         wM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a3fR6Ve9ApfA3U9S3BpD3B/5uX3W9BFd2HZqD0/PdZ8=;
        b=ICKs0CM7kL9Ve2o4Whrj4nmuUeymCwPohFBJzN1OPH67OK+HclVfZO1edQmONu3eCQ
         slCndE8aWJfKEukDziBP0e2ix0jLkn44LbETQOCqwoQFJvjES9hnt/IOlWaOgIREPJ6y
         G9zkWSRK8Yo39+pjJzuYjuyviFerMcRlAukuTbwySGf44ulZilOaS37EMxqOcbr6JXmK
         XUiyTpuJbxsBa5CmbOp9x8wFiWnswaoAfN7Iz3m034Z2YR5xbRiCH4qRmVVt2O5Lg/TZ
         nZ/bDyb/LlgYuOfN7NHtMYZS2gEhAG1l6fTjCAO/4NYv5gajzfWwt4YYGw8gAo6Be0vJ
         wE0g==
X-Gm-Message-State: AOAM532DEqwS/p6a/RVP8cBEJj5xEjboJAzpGv3sUusv0gjdk9YEoj3u
        6eNpexjY+zneadurQhRxDpo=
X-Google-Smtp-Source: ABdhPJzjojN33CXGc02zMNdLELDHamwSH8r6REBZbOciEeRZ8HwwODGWc+lHqfms29I7Rz7j9l4kiQ==
X-Received: by 2002:a05:6512:a8e:: with SMTP id m14mr13116313lfu.641.1613514334570;
        Tue, 16 Feb 2021 14:25:34 -0800 (PST)
Received: from localhost (crossness-hoof.volia.net. [93.72.107.198])
        by smtp.gmail.com with ESMTPSA id m14sm22593lfb.43.2021.02.16.14.25.32
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 16 Feb 2021 14:25:33 -0800 (PST)
From:   Ruslan Bilovol <ruslan.bilovol@gmail.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Chen <peter.chen@freescale.com>,
        Daniel Mack <zonque@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/5] usb: gadget: f_uac1: stop playback on function disable
Date:   Wed, 17 Feb 2021 00:24:56 +0200
Message-Id: <1613514299-20668-3-git-send-email-ruslan.bilovol@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1613514299-20668-1-git-send-email-ruslan.bilovol@gmail.com>
References: <1613514299-20668-1-git-send-email-ruslan.bilovol@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is missing playback stop/cleanup in case of
gadget's ->disable callback that happens on
events like USB host resetting or gadget disconnection

Fixes: 0591bc236015 ("usb: gadget: add f_uac1 variant based on a new u_audio api")

Cc: <stable@vger.kernel.org> # 4.13+
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
---
 drivers/usb/gadget/function/f_uac1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/function/f_uac1.c
index 00d3469..560382e 100644
--- a/drivers/usb/gadget/function/f_uac1.c
+++ b/drivers/usb/gadget/function/f_uac1.c
@@ -499,6 +499,7 @@ static void f_audio_disable(struct usb_function *f)
 	uac1->as_out_alt = 0;
 	uac1->as_in_alt = 0;
 
+	u_audio_stop_playback(&uac1->g_audio);
 	u_audio_stop_capture(&uac1->g_audio);
 }
 
-- 
1.9.1

