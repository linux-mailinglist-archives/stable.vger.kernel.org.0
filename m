Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BECD1B65A4
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgDWUki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUki (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:38 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C967C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:38 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s10so8268250wrr.0
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5ViWoK06xQspHTq5fSoOq1VehibGSMcOWc3+p1ggF7w=;
        b=gvZqUvhvfqz9yGJKJnVOeNgS9ry0T3tqkZJFzm909zIfrnMTd3BMkh+F9Q+ZYHyW6Q
         Oq3PKxfhz4PtgaLnVRcPsvhBzXh08ynlKgUL2Jhx8OqTvOdH/KeeVkZ8kJ1LtKuG+FNh
         4u3JhCcDkY7ZNZf1N+riIYEOoTjxXt6BBDW4H7aFglk7UbG3S1362+ksRdB0bwRN9fZq
         kd0QDJfIVjoOl58g7CcaZrmvpCL/yaP1XA0kAzsU+riKA1CzmBE322caxthr2C0c1eab
         QJ9bhYyO/Q//pPqXcPavkU8c2wFE8zHm4vh61XVfZHyd9Uys4rlxdOG6kTNUehARSD50
         qrNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ViWoK06xQspHTq5fSoOq1VehibGSMcOWc3+p1ggF7w=;
        b=JeQqch0P06EujHzKSkwbaf5d5f6rxmwFx1pU4X6HpeIfS4TriuVEUN+XweOManKbA0
         5rQf/rkrUeNJqD79D183HmnlE0sfx7yR1xIHVUKaflrxSg1pgitspJS9+DSi2lm3uOj7
         8/dCFP3UGL0pE3eSG8KJ0dqUfmNGs0tOvLuxOxpYUr1q54EO7cBuiXud543BkLSUbHY5
         9HSqxHOOgSInLwnGOLD2CmVjhcyLcQliexgKbc6iAiT9sXFX1GSf1Z0qkBa3woTefOC/
         4V3UWOrw9wf8CMAOc6CqV4ms7kQSaJ3skNadPgAItB9Wp2fbRznwKkBiX3+9LepYnF4V
         uaVA==
X-Gm-Message-State: AGi0PuaxtGmyOObh2NU/jkGwbW3D727egU5V4LBCv9N0Qw/Z96tRrt38
        s5helF4dxfAad5haW74zHIDan75Xd3g=
X-Google-Smtp-Source: APiQypL+hxtqfxZVXTq6JAXtXRNErg9Blyw9cAHdqojYvyTItHwNUfjXa6Kxh607TQBl5kVOzM/jRQ==
X-Received: by 2002:adf:f604:: with SMTP id t4mr7024438wrp.399.1587674436753;
        Thu, 23 Apr 2020 13:40:36 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:36 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Nicolas Pitre <nico@linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 15/16] of: fix missing kobject init for !SYSFS && OF_DYNAMIC config
Date:   Thu, 23 Apr 2020 21:40:13 +0100
Message-Id: <20200423204014.784944-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit bd82bbf38cbe27f2c65660da801900d71bcc5cc8 ]

The ref counting is broken for OF_DYNAMIC when sysfs is disabled because
the kobject initialization is skipped. Only the properties
add/remove/update should be skipped for !SYSFS config.

Tested-by: Nicolas Pitre <nico@linaro.org>
Reviewed-by: Frank Rowand <frowand.list@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/of/base.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 27783223ca5cd..8adffecd710b8 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -167,9 +167,6 @@ int __of_attach_node_sysfs(struct device_node *np)
 	struct property *pp;
 	int rc;
 
-	if (!IS_ENABLED(CONFIG_SYSFS))
-		return 0;
-
 	if (!of_kset)
 		return 0;
 
-- 
2.25.1

