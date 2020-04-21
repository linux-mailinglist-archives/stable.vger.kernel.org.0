Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAB71B265C
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgDUMk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728898AbgDUMkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:55 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37023C061A41
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:55 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 188so3393216wmc.2
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GiktMIoV1OYAqlxtIDqvHy2UdqWYzp89wwK6vhfs1Yk=;
        b=k6ZfrlSYeP4ex/U5u0dtLCo39z1l0m812h9TjU8lb9PuhbvMh/WGM7i3NOINDBpB89
         p8cHS2WEvetVqB4sfftW+eKTU8D+jq+aVHrgFQ0X3vC3bFaU6Zv4TSKpXjhWVjasBgrL
         dCjxI2me2G8nMNLN66x34ZHRiYDReY4UdCOk832Eq6yHtC2BfYpNmTmeJ4xWwRWWMh7T
         R7lnKmDCXOP+nen91Omz5LE3waRk2+otV5MOG9Gwnk7CF2W4ZDtZXEpGx3rsw8YDx6Jn
         1tCzM/rbSqoqO1Iqrvq8FDO9ZLTtiVhg4VG1er3y01UN4Lymx/6J4CZQo4E9l+c7RvBF
         WHVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GiktMIoV1OYAqlxtIDqvHy2UdqWYzp89wwK6vhfs1Yk=;
        b=Zve/yQ5M9RZioquhF/rsPZOJgLjfOExc+kG4XTJcqlU8FCqJE40aaxZjJtKTt7GeXc
         lJRryHgp6WG1NZyTIiCtMU++3s4+FU8YlPVGBtDSrB/Qlj3KykzJhUGiLQTP6/wu4xFK
         His72xE5/d2nkfz+lbDEXTunyUFx+K+Mc4i5dM47bux8e+Q07t7MU/AfCQsnQ3jxpy0P
         SzSCQTXCRHu1WYc4zSXnzCz0v8dnGL2/Ueeoq2gVKe8DXtxYHlFUCPUDkfTQzsUfA+iF
         TtMeJmhNS0N/XEL5LJ7V4B9hRWjRUg5SfrkbtHdFlKgQ2T8uHved3ThPfMTB3IR6CfD0
         oZvA==
X-Gm-Message-State: AGi0Pubgao6WXkTivD+cLi8tYuW267wrKKYdeojMtWHGfINVlYVyksM5
        DbTqPDAjQviH447AICPvhwBSKMnAIIY=
X-Google-Smtp-Source: APiQypLdJXL3FgvBAN2DJvX9BRvsbxCsSHJjpGsWViLVIvXwx2oyQ0cNn19lHkdhd6eJupZA/IzXbg==
X-Received: by 2002:a05:600c:29c2:: with SMTP id s2mr4629912wmd.111.1587472853691;
        Tue, 21 Apr 2020 05:40:53 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:52 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Prasad Sodagudi <psodagud@codeaurora.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 07/24] arch_topology: Fix section miss match warning due to free_raw_capacity()
Date:   Tue, 21 Apr 2020 13:40:00 +0100
Message-Id: <20200421124017.272694-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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

