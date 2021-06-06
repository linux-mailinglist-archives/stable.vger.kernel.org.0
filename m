Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4C839CF5A
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 15:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFFNnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 09:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbhFFNnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 09:43:03 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4A2C061766;
        Sun,  6 Jun 2021 06:41:13 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so3393427wmq.5;
        Sun, 06 Jun 2021 06:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=K/BommlWMPKscL8eOATJT+GKm2n8M7OIw/NGyaEKOIg=;
        b=Bi7Bs/UcnhaErbR2w9utGtknJEt20Ksf2gTejYDAuxzhhs20woYdv3fca94o2K0ZB8
         VXG9Vkwbng82oL5djc6HrtUIa8slRo+iYx1ayaJK7glftlSngRpCHwaQvk3A9VF0KyOO
         TsEVzynb5UgvJWQntrgTPaeCh5SyPEUWgV99tDUsU83ePu30HM91KXrtjfrKcnSY1joD
         edfaE6+emgpbTXZ52GUioJyLwqtw16LuEqGszN81nyWqs6SNQOFh6GgIO/XNFx8P8i7l
         vx49lUyL5EvseJV/dJkLCf3tazfRjC2pqPSP/wi1YG6d05yvDYDBzUifENlPAAuf040e
         Av9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=K/BommlWMPKscL8eOATJT+GKm2n8M7OIw/NGyaEKOIg=;
        b=LdCi5/lkAOQp+KZSffr4NWUXZ5WZf0UDrgP40m/LjdyyEad3WU9dXUVZnyejpEKmaJ
         W92dN/aFMQzOvsIPfMBcVi+vCcCrAb9VuhCdbVpJYlmm+IEfovDcz0xU8UDqXTCQZn4x
         9YertRNGo1Eq9sTePLJHWkWHtNEMSEQ3g2OMZJXU0WcnHraG1CLpZJJJeZ2ON105gxq/
         qVcGVdTTbRJUU45DnYAMJ/YlLc5PwIb6cNIoMwtv4tkZyN0bKmpjP+YWgr/avpE6Qia0
         /JwzPBvvI/YYGLe4/Vrex2PpQZ3qsH6Ws9fe9VD7BFsql8Oh2GJcnL5u/k10ZOkhHAvQ
         KK1A==
X-Gm-Message-State: AOAM532XADv5XDbkhloGPbYlvyfqq4Q66p7GXX0lWd1UwBfmpg/0mO1A
        b96QdKi4lBj+7cCHLEUk5bYxGCJMfOI=
X-Google-Smtp-Source: ABdhPJymeaYhwC80Zrv8C3/eqI/0X8deIJyOfjz7MldsNCuVqAuStVI1ONBQYNTQmyZM32VldU1DIQ==
X-Received: by 2002:a05:600c:1d1b:: with SMTP id l27mr1863510wms.62.1622986871183;
        Sun, 06 Jun 2021 06:41:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:49c:cca9:867d:9b13? (p200300ea8f2f0c00049ccca9867d9b13.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:49c:cca9:867d:9b13])
        by smtp.googlemail.com with ESMTPSA id c7sm13988783wrc.42.2021.06.06.06.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 06:41:10 -0700 (PDT)
To:     Jean Delvare <jdelvare@suse.de>, Hector Martin <marcan@marcan.st>
Cc:     "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] i2c: i801: Ensure that SMBHSTSTS_INUSE_STS is cleared when
 leaving i801_access
Message-ID: <d012221b-9a44-eb77-f7c2-4e498ef5f933@gmail.com>
Date:   Sun, 6 Jun 2021 15:41:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As explained in [0] currently we may leave SMBHSTSTS_INUSE_STS set,
thus potentially breaking ACPI/BIOS usage of the SMBUS device.

Seems patch [0] needs a little bit more of review effort, therefore
I'd suggest to apply a part of it as quick win. Just clearing
SMBHSTSTS_INUSE_STS when leaving i801_access() should fix the
referenced issue and leaves more time for discussing a more
sophisticated locking handling.

[0] https://www.spinics.net/lists/linux-i2c/msg51558.html

Fixes: 01590f361e94 ("i2c: i801: Instantiate SPD EEPROMs automatically")
Suggested-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/i2c/busses/i2c-i801.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index c7d96cf5e..ab3470e77 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -948,6 +948,9 @@ static s32 i801_access(struct i2c_adapter *adap, u16 addr,
 	}
 
 out:
+	/* Unlock the SMBus device for use by BIOS/ACPI */
+	outb_p(SMBHSTSTS_INUSE_STS, SMBHSTSTS(priv));
+
 	pm_runtime_mark_last_busy(&priv->pci_dev->dev);
 	pm_runtime_put_autosuspend(&priv->pci_dev->dev);
 	mutex_unlock(&priv->acpi_lock);
-- 
2.31.1

