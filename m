Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E809241547F
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 02:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhIWAQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 20:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhIWAQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 20:16:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F5BC061574;
        Wed, 22 Sep 2021 17:14:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso3608816pjb.3;
        Wed, 22 Sep 2021 17:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M419tx9qbN6UyXQusgJi5ma7tnyBkMa/xyVjWd0AjKs=;
        b=FYrhaM3Wle0ET5ZjzF9KA8vMYqQ4uCCqyrlFaGudSc9FXrJPWIzIIoV7w2c4BwHxDN
         XPHbzfoiECIRsaPLTY7XyQaLgDP5xpXlNDrKMH14LZAxAUVMFSnD+OG9HIeZ+lsK2sOI
         iPF17L2fUK+oD994nnXHM5qbrTz6bLLM2l3UJxBB/Lb6AId0cJ4LaVGghVISS+XDlTei
         H3FkKFubuHbia9u/MvvhMKagHJKJkRSJizS0Cij+y9XNEmlR0g3SDg+e0e6f5+L3oMGg
         PgcH7yqokTRBG+FHOu+C0Cg8Fjwlgii05B4vW8yykRzTYib9jBrUsSCzeX7kwZdY28Ne
         nJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M419tx9qbN6UyXQusgJi5ma7tnyBkMa/xyVjWd0AjKs=;
        b=c/eeUhEyzmlaBYS0llxGHB01YMKK8wqMkUhF/2dz54nS13kEofBNCMtQDrRqlssF/Q
         wFxvxUwGAULWQjYGNh6pWU2fwXfyv/MSFNVxtDu6Xzq+LdhTIk5WBfzt/ELCUy/3prNf
         ng2pDPNnNGXLeZp2pYmbRSnCKaQOaLG6+/62XP06MZ8Y+XP7v2LOwPtWUq6+hyik3o6S
         3ENMjgCaiaqf+WbVKlCUixsJ+YIJ0ZSvW956VHRBsfj8YMVEpnC+VzHxCUEoP/HHphiE
         pL5qWa1yBfG5A759sEV/b9ocxMpGxRMzggxvbQwJrN8/eHx8HjeNrWN6wQogO792xp04
         Wgsg==
X-Gm-Message-State: AOAM532XwF6QYVanuoL2Rc+sp9C8FvFFfS3mt/98GW0/Tj234yu81Tu/
        Bi7tTBqlz8w5guR+O19Nb6XWmevXzUo=
X-Google-Smtp-Source: ABdhPJx64rbQwadQ7CvJCPSG7vl0Z/DZcFYRFaKJ7clwipFuO7X+n7QWRpSRgk43U+4o7ZLRBdxuZg==
X-Received: by 2002:a17:90b:383:: with SMTP id ga3mr1974925pjb.72.1632356072892;
        Wed, 22 Sep 2021 17:14:32 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p26sm2789734pfw.137.2021.09.22.17.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 17:14:32 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Russell King <linux@armlinux.org.uk>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 5.10] ARM: Qualify enabling of swiotlb_init()
Date:   Wed, 22 Sep 2021 17:14:24 -0700
Message-Id: <20210923001425.414046-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fcf044891c84e38fc90eb736b818781bccf94e38 upstream

We do not need a SWIOTLB unless we have DRAM that is addressable beyond
the arm_dma_limit. Compare max_pfn with arm_dma_pfn_limit to determine
whether we do need a SWIOTLB to be initialized.

Fixes: ad3c7b18c5b3 ("arm: use swiotlb for bounce buffering on LPAE configs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/mm/init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index d54d69cf1732..75f3ab531bdf 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -378,7 +378,11 @@ static void __init free_highpages(void)
 void __init mem_init(void)
 {
 #ifdef CONFIG_ARM_LPAE
-	swiotlb_init(1);
+	if (swiotlb_force == SWIOTLB_FORCE ||
+	    max_pfn > arm_dma_pfn_limit)
+		swiotlb_init(1);
+	else
+		swiotlb_force = SWIOTLB_NO_FORCE;
 #endif
 
 	set_max_mapnr(pfn_to_page(max_pfn) - mem_map);
-- 
2.25.1

