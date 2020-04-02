Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD2F19C992
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbgDBTNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46051 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388499AbgDBTNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id t7so5538951wrw.12
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GiktMIoV1OYAqlxtIDqvHy2UdqWYzp89wwK6vhfs1Yk=;
        b=sHCHHP8vEmXQa57TIUQASiZPyBmaU0WLGVSvOXYtIhZmcz9R6AWUloarislUechL7I
         2XZgU30Blgw6rfjo2qfLAaiEfh9jGXnVUPUd8jy/mMf7trujS8ubz9Uqv5duDLue4LHF
         CxuYEYbfRaYLMkdPKQazc92vsC5+Z0nfmMX5gCmHT8gKFxPZuSUPX03H2Q3wMXABLpsr
         x2uyN0wpA/Z2DuBC9+hRiRutQybvOPRxyhUii/KFPgDbatLT9OIcnTLV4yeLC636r9o6
         RTCBb+1OKMOH/ih3Tq6JDNODVRFC9dr99zgywGGgsU9mOzl/reamPq52cQrhTXgK14lZ
         fU9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GiktMIoV1OYAqlxtIDqvHy2UdqWYzp89wwK6vhfs1Yk=;
        b=tCMNUX+6igTCgo/yf9cic8aqzpljmgmIVWoWiRk903+CQBZ/UaSn+VAsIkUcl7n2qU
         FUgyoMguZYoLx+NvnTwFACkoEWi09XrYH0fjqa47CtwbRaQGnNx5eZvSM12XNzuPynAr
         wXE7ldt6QsiG8a42fKFd4ogU+rXjR/wpiHbgj3DPdMBhfImxnQP6Y2IaSLlhVCNvbtuP
         8XZzEhiYoNuY0oDVjFUgeqxuB+m3Ksx4lpgBoQdxmg1kf1IHCuyAF2mF8JjIUH4Fg/u/
         CN8/Qn3+MSvjddEhQTgsXThHynplqPUa6x8PDBqIXj9qnCI1bNj/XtEuhBNnY3Z5uDXi
         byWA==
X-Gm-Message-State: AGi0PuYGAFWBLM+BPIt9G+tDGzUjY/Sh7HmPowCaEGSpbB492MlY+H8f
        VXpeWyLdrJbxyJ5F7U/ZwM8SSx7wTyop3A==
X-Google-Smtp-Source: APiQypJOGKtHwasPMrTdVL0En2bH3nAVTdQX3XTjfmYuklRwd8VxRbH+chuEVXN36iXL9M/WeT7HSQ==
X-Received: by 2002:a5d:518b:: with SMTP id k11mr4862704wrv.256.1585854790228;
        Thu, 02 Apr 2020 12:13:10 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 11/33] arch_topology: Fix section miss match warning due to free_raw_capacity()
Date:   Thu,  2 Apr 2020 20:13:31 +0100
Message-Id: <20200402191353.787836-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prasad Sodagudi <psodagud@codeaurora.org>

[ Upstream commit 82d8ba717ccb54dd803624db044f351b2a54d000 ]

Remove the __init annotation from free_raw_capacity() to avoid
the following warning.

The function init_cpu_capacity_callback() references the
function __init free_raw_capacity().
WARNING: vmlinux.o(.text+0x425cc0): Section mismatch in reference
from the function init_cpu_capacity_callback() to the function
.init.text:free_raw_capacity().

Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/base/arch_topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 41be9ff7d70a9..3da53cc6cf2be 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -96,7 +96,7 @@ subsys_initcall(register_cpu_capacity_sysctl);
 static u32 capacity_scale;
 static u32 *raw_capacity;
 
-static int __init free_raw_capacity(void)
+static int free_raw_capacity(void)
 {
 	kfree(raw_capacity);
 	raw_capacity = NULL;
-- 
2.25.1

