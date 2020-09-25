Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF00278E3F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgIYQUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:29 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF216C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:29 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 135so2735304pfu.9
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=5SM5TmKsAWQhROcANL8D19uf0SuS6x3YGGq5qumuyIU=;
        b=ijY3MWsRzvkbTwBAa50zLEfIBrHlJH9wJfUAPXOfje1yUSg4nMSDwxTPyp3stABUY9
         RAxvjynCqmYjZqSJZN9B3GZdnI2gVVxPI1/vX3u3JOS8DYWjfDlBO+M08WxmZAjw+Hdj
         J0+KbbydtmcIk8YVMLa2JdpFedCAuUPV+76KbzpnRysRNEeKhn809wtZ0xBgEzkEp2tj
         H3iXxWDcCjBfffrfNMot+SoWzzUOWDRAXDT9gnXERnU9MNBH+kRRsNzyyOxP92yMYCgV
         brcwwfNmu4gSeGnB+T6+trjNeUx4rpf52kclQiy1ARWg45ARGGJSbW4TK02lpn861Ukg
         ik5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5SM5TmKsAWQhROcANL8D19uf0SuS6x3YGGq5qumuyIU=;
        b=WplyF0/gtzb5BehqAuIQN2EjdQhhOWsvrW6B7eof8AtMgq92v4ahHo/Uawbp2/T0q5
         RYA6aXybtNOk9BEo9n77YFTvybOaDBoeH3iDhR6WSma+fBZhNu2lHeg23S+3AJ0HMyt6
         0mUCBUGMV2AcRvBWpquqe367b0eWowJs0HPORJjeFE96jpVQv1XP2CU+yicYpGDFKG45
         tj7wD4WgWI5d9WUuJoj5Wwz2TsjgmRdTLrn6N12Rik5lSSqAGnU8e5Jl6CMhdgGI1VNe
         K8dscnis52eKNNLYA/kUagT+nPqgp56FEcvWsVJM0BROEuzrC3E0ADGFhauEeF07sD/W
         U1Cg==
X-Gm-Message-State: AOAM531aWH0iG9u4p2nsR7sTEw9+hIUxIR2S9GOEVKq9yIOR75+wFrdu
        apkgzKUhL39smkXdihKT3TTTe6yGJ5V3RKGpoie8p2FFMBuY32Er+G2BzHgB3cdOJSMNLI82Wcv
        cE5+VpUHGoA4rLxvM4ukMEdoDkbzW6j4DcHxU4ZWu64nzdmgsjn28sXR6ZdpvvQ==
X-Google-Smtp-Source: ABdhPJxzx5SuUu1JW/eCW8csbc32M+KXLf5ef4fR5UaGQwUHxwFHE9h56ee+YWWGrDywXIOB83W/d/xme20=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a17:90b:a0a:: with SMTP id
 gg10mr385148pjb.20.1601050829179; Fri, 25 Sep 2020 09:20:29 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:08 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-23-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 22/30 for 5.4] dma-mapping: DMA_COHERENT_POOL should select GENERIC_ALLOCATOR
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, kernel test robot <lkp@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

upstream d07ae4c486908615ab336b987c7c367d132fd844 commit.

The dma coherent pool code needs genalloc.  Move the select over
from DMA_REMAP, which doesn't actually need it.

Fixes: dbed452a078d ("dma-pool: decouple DMA_REMAP from DMA_COHERENT_POOL")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index a0ce3c1494fd..6ad16b7c9652 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -74,12 +74,12 @@ config DMA_NONCOHERENT_MMAP
 	bool
 
 config DMA_COHERENT_POOL
+	select GENERIC_ALLOCATOR
 	bool
 
 config DMA_REMAP
 	bool
 	depends on MMU
-	select GENERIC_ALLOCATOR
 	select DMA_NONCOHERENT_MMAP
 
 config DMA_DIRECT_REMAP
-- 
2.28.0.618.gf4bc123cb7-goog

