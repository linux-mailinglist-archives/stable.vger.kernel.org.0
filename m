Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AAF50A654
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343907AbiDUQ6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390532AbiDUQ55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 12:57:57 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2F5B851
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:55:07 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t13so5138216pgn.8
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lWrMBaaG06Rl/KqlbUnN7jouLwLObU2X9LsSayAdIEY=;
        b=RG6zXViEotCrIPi+aqyunCe71vbxFhC/cyC2pcLO6Nnd/L7hctNT+nu9Wd/37midx4
         CBEdx7XQHXKUvhBVjHCgDXDtj03gb0gA/FT28uXFAZtrF6FxQCdcvqGjFgu2goVERUa1
         aBLVjrQlm+M+HHOBlhi69kBAheJbgTj97x2Ws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lWrMBaaG06Rl/KqlbUnN7jouLwLObU2X9LsSayAdIEY=;
        b=ErlPqhd3Um2lOjyOndB96aioK8jfOZZhCwWj1g/3BCtbXc9vhjuQPYHq5YptXzxJUe
         LtGwCdI55Q6vIL/q6dk+DbvDMS44Jvf+LuaIU+WaVlnbl+JnMPnvZ6N9UpcDJtEQEOUW
         yYe1fZuYaYIabAwBDdFMza3YKSisr9AF9lpl8bmQo3Z/uRzEYWgZ97MRhOx2/ovDSsWF
         oa5ZjhkeeRMdXzD8G5KgqLfWCweYdlCUFemsOFNdcb1GuXVM2ExuXFtOyXeRXuTiMRdO
         2Nso7lTTULxhOH0k9HkLzkxq52qCMlDTtTg9oRDP5dGzAY4gL8cn2jYvrlTc/DoBRrHl
         0M0Q==
X-Gm-Message-State: AOAM531yDgiwaXCPSB0O3zRRCaWpOP8pSPbgSztrHpfayDGg+hc6rMGc
        GpDdM3QYJcmGMuYaW05akT9suw==
X-Google-Smtp-Source: ABdhPJybFqT9+qbX/fmptKtwh1MKt6C6LFPPlumJnR7fijXXj4514Ft/yXS+m+y8hK+j9Rd4HJauww==
X-Received: by 2002:a05:6a00:298e:b0:50c:e384:3a16 with SMTP id cj14-20020a056a00298e00b0050ce3843a16mr610980pfb.71.1650560106692;
        Thu, 21 Apr 2022 09:55:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u3-20020a626003000000b00505a38fc90bsm24888533pfb.173.2022.04.21.09.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 09:55:06 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-pm@vger.kernel.org, Joao Moreira <joao@overdrivepizza.com>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] thermal: int340x: Fix attr.show callback prototype
Date:   Thu, 21 Apr 2022 09:55:04 -0700
Message-Id: <20220421165504.3173244-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1946; h=from:subject; bh=luGT7I33b2VPSU/hRTp4Bzm5YaRlLxElO2D/HiBCrCI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBiYYxnp8ng8BLmn3BJUCmqYDM28VV2nCxsOVm2zLy+ LJp8UgqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYmGMZwAKCRCJcvTf3G3AJlOCD/ 9lztboo9y2dy0mnMoOXHcJOcK/kpeyZf11lTux/iSdVIVqNAWXfmfzQBifo15Bq4PZa9jlNoHJIvpj 2/4/xqH0Wfyr9dMmzYCdUD/tXJMQN9xW61hBX1O+Fn6obddy6jvOEsbFKIlV6W2PmmYn2j3ph0JAvb BAhgnXMb7eLsLGarKzjO55yjay/yDwM176Q4VpOaAAc4+RFYUvZIGhW010OBdwM0ut+WQ4YKdbnest uY5+p44FLL35FwQPREFU1tfg0j0gfJStm6cKA9KnO1uamR7Ds6HSqM4OPzsuAz1MUTBQWgihe0JINA +yarzxWBPEP3/d3SueddXMFyle/JYx6g/NwXYfBTvZr1Amyqmt3hsXDQB+KXuR8JsAqxahrTKDc2pu f+y8bmT60daXrqKckbnxMBQ5HPxmIok8WWWfWw3aVGfoQjxqb2UFYbkPn6f9lWSm3ixb113DSXdNvU 5JF7v8Mm7xFlnb2IYCwTNQ7eojS1+ewl20o/vNJ5xXH7r3g9HVXIXIC08Rkoc0HayOEL+pDqLVQm1m 1hiTd32fHiIPownlJp0LdE+0YhyAJHYa9X2VFnlgsTc8WA87O43yGy2Q0nkD9SiAbaLmR1IAK/6sRv ciQKq7l3+RJse92bmT3I8A4kLndMMZlzjy8c+wTpTW6zKM7wJFMSpu0USUiw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Control Flow Integrity (CFI) instrumentation of the kernel noticed that
the caller, dev_attr_show(), and the callback, odvp_show(), did not have
matching function prototypes, which would cause a CFI exception to be
raised. Correct the prototype by using struct device_attribute instead
of struct kobj_attribute.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Amit Kucheria <amitk@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-pm@vger.kernel.org
Reported-and-tested-by: Joao Moreira <joao@overdrivepizza.com>
Link: https://lore.kernel.org/lkml/067ce8bd4c3968054509831fa2347f4f@overdrivepizza.com/
Fixes: 006f006f1e5c ("thermal/int340x_thermal: Export OEM vendor variables")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 4954800b9850..d97f496bab9b 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -68,7 +68,7 @@ static int evaluate_odvp(struct int3400_thermal_priv *priv);
 struct odvp_attr {
 	int odvp;
 	struct int3400_thermal_priv *priv;
-	struct kobj_attribute attr;
+	struct device_attribute attr;
 };
 
 static ssize_t data_vault_read(struct file *file, struct kobject *kobj,
@@ -311,7 +311,7 @@ static int int3400_thermal_get_uuids(struct int3400_thermal_priv *priv)
 	return result;
 }
 
-static ssize_t odvp_show(struct kobject *kobj, struct kobj_attribute *attr,
+static ssize_t odvp_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct odvp_attr *odvp_attr;
-- 
2.32.0

