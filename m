Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC8D6D0BE0
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 18:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjC3QxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 12:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjC3QxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 12:53:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A7EB68
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 09:52:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j11-20020a25230b000000b00b6871c296bdso19140021ybj.5
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 09:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680195170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mQYDmK2JgUqCpCRVA2d0KYhO6AxXou2BaS+5pOIMpjU=;
        b=Qhwvho/jSCzD962UhSp8uw5ox5R2LCORWuT38KhF1g8kOlUAdKNLzt4oWIseQg7qy5
         w7ssDt5UoFmaEOfi2vxsVKdWffZwOyk9SvIH1DtxV7SaetvZLdGPBi9lKWgf7qUPSVtH
         ASeXYWr/h3EdvlTVN8GZhAr+KU6of6ZeHB90/1jZ1BKAUXAHr1F1ZCDoZ935l51aeNBu
         N0E1aGMWwpTJOL0st3TggxhzN+bz+EYaXjh7GBoidWRNNGBfmlCvx4E8vijMA/M8+sdk
         7fB1TBG+FcXSIh1nNwyzmJq53L1X/KhAKwwh8/ctLfsGGCD1QCGM2Iki1y+qZLDOPx3p
         E0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680195170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQYDmK2JgUqCpCRVA2d0KYhO6AxXou2BaS+5pOIMpjU=;
        b=GrnKem8dCsfRJp+W4Y8hz3f9uFTdg21YGSMdOLfs23jfFeUxC0mgtmTrkvy/2jFE5E
         HmSbRkTJnCTkPcUviXKQtg0sNaQNw93khWNki84SoJftDep4moLS+Buulwkx2lqRiA07
         DlSFV4MVtCfuEWaEqLFvyPmw/7NXq0C+ra3bLe4p/lRuzs2B1GeXr9ry6L7OlBsRBiPH
         1AmMPT4URvlVk47lFQ/pKOJi8clbC9CBmiwCUaVlb9+DVQD7quby6udqFc4BfcVgRa8r
         g+j7CrqlOCmL7gr2N+DbGNyyHrf+2G6NKGczhbVHWhaXrkUL7hbiTMfhKp/ANZVDOQCg
         qxCA==
X-Gm-Message-State: AAQBX9c1ES7LsutzluRizAiYrAteeBE8NPrjPHv2gRHVVxgL2EgIYQ96
        swqLDxH39DNKz80vmQCsJcs31VvelX/rlg==
X-Google-Smtp-Source: AKy350ZKQUPsiA6P7BhOGzirXB+KdSmGZo7ozykgr9T5Dtqy7WkMW7GodFAWWOkH7jqts/4Tipe33E5WWOFTow==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a05:6902:1004:b0:b75:968e:f282 with SMTP
 id w4-20020a056902100400b00b75968ef282mr15755101ybt.11.1680195170260; Thu, 30
 Mar 2023 09:52:50 -0700 (PDT)
Date:   Thu, 30 Mar 2023 16:52:48 +0000
In-Reply-To: <20230330133822.66271-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
References: <20230330133822.66271-1-mathieu.desnoyers@efficios.com>
Message-ID: <20230330165248.rv7bssd6ys6m33od@google.com>
Subject: Re: [PATCH 1/1] mm: Fix memory leak on mm_init error handling
From:   Shakeel Butt <shakeelb@google.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 09:38:22AM -0400, Mathieu Desnoyers wrote:
> commit f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
> introduces a memory leak by missing a call to destroy_context() when a
> percpu_counter fails to allocate.
> 
> Before introducing the per-cpu counter allocations, init_new_context()
> was the last call that could fail in mm_init(), and thus there was no
> need to ever invoke destroy_context() in the error paths. Adding the
> following percpu counter allocations adds error paths after
> init_new_context(), which means its associated destroy_context() needs
> to be called when percpu counters fail to allocate.
> 

Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org # 6.2

Acked-by: Shakeel Butt <shakeelb@google.com>
