Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1AE119C9DA
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389517AbgDBTSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37886 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389486AbgDBTSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id j19so4955565wmi.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3YC6pyybi6G5bn9vYupqc8C2qtwqHiQkVZLXEFbQNI4=;
        b=rJfCbCFdbFqzecni9aO2BDtQI/fulqzylzjIYsLe7jg9GzHQCwaSRESbfYokU2ifsP
         k60CYztjeLn9p7XEmdEbGWnCQxITJlCSBUE9FF/+vaQg4OAd8QfwE9830ce5o/LsBpky
         9YdxaQJeV7E1eXbza8qhecZpKwUTIcZZHgKFGWuiqYxJWzEajtUi57hsGq6qo5TtP2GD
         TDxSzJd3lgMNsBWks049EGriDURYyESALxmi44TIdyPN0DdTn6FCSdy/K1nMpmy7s4lX
         sUuwjBJ03oxdKdm+RUO246duf6/m+RpEKLvs3Y+vfKwQuP1DYwgqqxWhhR4iTS9igzLk
         UEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3YC6pyybi6G5bn9vYupqc8C2qtwqHiQkVZLXEFbQNI4=;
        b=A4wH8P/x+/bOAN/yBNCJVfJnNk/rZJ76Z1neqqutzYQAxcEQrGeAHsDSIoRLcsIQsR
         oXjMoUZD0xelUuhv9/83Ye008DojE3vXkrsVp/XGzIN950/+A2QuOer1vDwmnhjOQLKF
         ut57qPC4X7XUwvxRiSNlR0PbG3KjPwBfLsiys/Yc/O9rq8wB7XPIK3eYmwhzyTQ/NlXN
         EsslOEmecmiAaFcsiy8lRzxApUje5iD/0/ebh3c5G5XYH9pJCcGFUG29EgF60A8ala+9
         AQQ2QAeEAQEOc7PN08QkJF5ljISTRei1x0C2O+vgohx39eLvO/f8Ii8QbGZtajqYcRS2
         SPLQ==
X-Gm-Message-State: AGi0PuZowejbdeC4gPwBeHRQg+vqj+xL6oI7UKtGUFFcUQjZCFqsazKJ
        458LGBYK8ymEfUDYagYKLRbx+bz3PAEcBA==
X-Google-Smtp-Source: APiQypLKtQTxLS1KnPE6mLnAevfsv+jhM6jWZgGJ8jmQmQVhhxnJg6D0d1CAmEP/H+azpSa6AhkQAw==
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr5093098wmj.156.1585855092580;
        Thu, 02 Apr 2020 12:18:12 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 10/20] serial/sunsu: add missing of_node_put()
Date:   Thu,  2 Apr 2020 20:18:46 +0100
Message-Id: <20200402191856.789622-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 20d8e8611eb0596047fd4389be7a7203a883b9bf ]

of_find_node_by_path() acquires a reference to the node
returned by it and that reference needs to be dropped by its caller.
This place is not doing this, so fix it.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/tty/serial/sunsu.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index e124d2e88996f..8db64282260fb 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -1393,22 +1393,32 @@ static inline struct console *SUNSU_CONSOLE(void)
 static enum su_type su_get_type(struct device_node *dp)
 {
 	struct device_node *ap = of_find_node_by_path("/aliases");
+	enum su_type rc = SU_PORT_PORT;
 
 	if (ap) {
+		struct device_node *tmp;
 		const char *keyb = of_get_property(ap, "keyboard", NULL);
 		const char *ms = of_get_property(ap, "mouse", NULL);
 
 		if (keyb) {
-			if (dp == of_find_node_by_path(keyb))
-				return SU_PORT_KBD;
+			tmp = of_find_node_by_path(keyb);
+			if (tmp && dp == tmp){
+				rc = SU_PORT_KBD;
+				goto out;
+			}
 		}
 		if (ms) {
-			if (dp == of_find_node_by_path(ms))
-				return SU_PORT_MS;
+			tmp = of_find_node_by_path(ms);
+			if (tmp && dp == tmp){
+				rc = SU_PORT_MS;
+				goto out;
+			}
 		}
 	}
 
-	return SU_PORT_PORT;
+out:
+	of_node_put(ap);
+	return rc;
 }
 
 static int su_probe(struct platform_device *op)
-- 
2.25.1

