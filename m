Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F433F1642
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 11:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbhHSJdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 05:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhHSJdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 05:33:21 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DB8C061575;
        Thu, 19 Aug 2021 02:32:45 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f10so3441637wml.2;
        Thu, 19 Aug 2021 02:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9E+b7yEFyl2AwVZRyoTJe5CWMWvjWa59eGiPsrwe3Mo=;
        b=tFZEIbDlHNE+xia5g8/hRiyMaPYwdmhyoL9uigWW2I+3GMS/h/BxVaRI9BRlTGzgaM
         3zq8mZmaYkg06Bzc3/TM511P0YOg3YD1FH3toNrTY6xq9402Ndrn1a94K+2KS97AXIWE
         mGWS0oqr6BMMhPZYeBiCgjJXEhU0ZmyxrFbs43wvT9T85E51DqlAAqlwLK2nmNOO3OlR
         nSj2sPa1theke08K4vpuohL7HrOo9KM4O8YPLajfW5v1bKri3BvP3P3c/8Fnv1hcv8qp
         wAGePiin/nEJY8Q0Gvz9YdAF4Jd+JJKnLjHU4QIsFLLXrBz2sdnxW2h2H1l4NS5Ny6qd
         Gq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9E+b7yEFyl2AwVZRyoTJe5CWMWvjWa59eGiPsrwe3Mo=;
        b=b39KZq11/ad+v5oNNQ/T+zXUOGN/0H51K8gt+WYEFvOKLwADlersWWxB1RJROEk5q5
         oOHJKwYOg65KNTbe/RKTmmggTcMMLORotbRH1/IPuHvqfyagy1hqh9VJdUFPA1rl+vss
         h9eo1tm+MMpyU1C9pjYjsLezl0gaSP/fdDDNnFhNSLsjPQfkR2I8U/EB9lN3dUnJUudB
         HxGq2qttG3evuhpBCs/qm4h499gR0glfrYY4JUqWX4U36Xgcvh4fUcBtmywNKaem4fgy
         kCVCKrKbpP47YmSg22lUPRuIADsUNAY+x9dD3Z630GyBRpzVoNe1XYE+qt6u20fAmSTq
         hmDA==
X-Gm-Message-State: AOAM532QA4wBA62v0xoflaWIWRjhwXjC8VXYmEH3lNj/GySbP3TzfStw
        qYhY1aWLc5v9YgLJJepfZ2M=
X-Google-Smtp-Source: ABdhPJwIwVlI9d/xhjmdxG9trJ2BKi+LKFHcS50VjOHOgZfRQ86q4w2s4Ld6XT/GuXYT9nWNu28yFQ==
X-Received: by 2002:a7b:cf37:: with SMTP id m23mr894890wmg.147.1629365564031;
        Thu, 19 Aug 2021 02:32:44 -0700 (PDT)
Received: from localhost.localdomain (arl-84-90-178-246.netvisao.pt. [84.90.178.246])
        by smtp.gmail.com with ESMTPSA id h11sm8485061wmc.23.2021.08.19.02.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 02:32:43 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 1/2] powerpc: kvm: rectify selection to PPC_DAWR
Date:   Thu, 19 Aug 2021 11:32:25 +0200
Message-Id: <20210819093226.13955-2-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210819093226.13955-1-lukas.bulwahn@gmail.com>
References: <20210819093226.13955-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a278e7ea608b ("powerpc: Fix compile issue with force DAWR")
selects the non-existing config PPC_DAWR_FORCE_ENABLE for config
KVM_BOOK3S_64_HANDLER. As this commit also introduces a config PPC_DAWR,
it probably intends to select PPC_DAWR instead.

Rectify the selection in config KVM_BOOK3S_64_HANDLER to PPC_DAWR.

The issue was identified with ./scripts/checkkconfigsymbols.py.

Fixes: a278e7ea608b ("powerpc: Fix compile issue with force DAWR")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 arch/powerpc/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index e45644657d49..aa29ea56c80a 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -38,7 +38,7 @@ config KVM_BOOK3S_32_HANDLER
 config KVM_BOOK3S_64_HANDLER
 	bool
 	select KVM_BOOK3S_HANDLER
-	select PPC_DAWR_FORCE_ENABLE
+	select PPC_DAWR
 
 config KVM_BOOK3S_PR_POSSIBLE
 	bool
-- 
2.26.2

