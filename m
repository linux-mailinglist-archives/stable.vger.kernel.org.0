Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88DB5306F4
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 03:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiEWBEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 May 2022 21:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbiEWBEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 May 2022 21:04:54 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ECE33369
        for <stable@vger.kernel.org>; Sun, 22 May 2022 18:04:53 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 137so12377422pgb.5
        for <stable@vger.kernel.org>; Sun, 22 May 2022 18:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=yOqshecnhz24HCPFL8R9k+rQYjlgSiMh0TAar9utw7U=;
        b=c3kHhbCHF1+pOhGqIxGe425To7JHa/Jp//N2OIGPKEew8HwwngyI1IO0ViTFnN7Rz1
         iyxsHvjvdZXojQ3ZEbK3/6kczlqvoiDe8rhQ1inY1dZziYRUlj/Blo4kHEGakWVdr+KE
         pBnBANwBI2fE6fPzzTJYB/TPmXV2fKKizOixivB1BtjLOTvSk6Llxa4Cc0MyKZnogNrH
         ggw0R84eB6CxctpQNPT3n8LMNbPwDi15j5MhKRo3QllD0rOku3AjOYJj9JFbPBgETqdh
         2cOzFMuofNy2wXT/fWCC9h60Dia7gfk+1gmb3knzqbs7/CNVaFMr7oOXr9eWBuS5V8vm
         zbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=yOqshecnhz24HCPFL8R9k+rQYjlgSiMh0TAar9utw7U=;
        b=R8wGd87KjZbnkaOR3u7cnUX1nD19yaFd+Trf7At1prr62rZu1waNwhGiMjfZTOpmpU
         k8UtH98BY4ImG+dx1XCqLOHLiwRsDJIEiU18W33VIcvm443hFWI1b4SJwNIvuaZXzdYM
         DXf3OK1lmvpK9nKTTu4rA21gaOc0GWHFnLWBDC3VeezJ7uE2batwhxoymBxIciPUGQBN
         YvNcXMNZZhIiVe4ock62XikB/GgXkFvxiMfW6xEbSxk8WZSZXYWWCoAOOOAbLJMwKDbp
         JKO9TziVguaaB0R+YwHBWfU3rwqFgmrjmtNl19pyH7ibae7nbcH/ri14UKDRkTww9a/U
         L36A==
X-Gm-Message-State: AOAM530RMC+pO7EeQ2RW24XIOOcLNFAmuS8ubTQVZUHw5NRgNhQVu5Zj
        V3texZzbdXwmk4ghWr0Ry5OePg==
X-Google-Smtp-Source: ABdhPJy/Pe9GcQRNtkgNe7XJEsRhFmPKGUbP4E3sj0Z1g4bwfFHnHxEOftK0lWDSkInAUU5Q7dw6oQ==
X-Received: by 2002:a05:6a00:1348:b0:518:7a03:1682 with SMTP id k8-20020a056a00134800b005187a031682mr11290564pfu.6.1653267892703;
        Sun, 22 May 2022 18:04:52 -0700 (PDT)
Received: from [2620:15c:29:204:fa22:6f61:557f:9cd2] ([2620:15c:29:204:fa22:6f61:557f:9cd2])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902d70200b0015e8d4eb2aesm3691018ply.248.2022.05.22.18.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 May 2022 18:04:52 -0700 (PDT)
Date:   Sun, 22 May 2022 18:04:51 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
To:     Robin Murphy <robin.murphy@arm.com>
cc:     hch@lst.de, m.szyprowski@samsung.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        thomas.lendacky@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH] dma-direct: Don't over-decrypt memory
In-Reply-To: <796ddc256b8a3054cb0b2f43363613463fcf0d61.1653066613.git.robin.murphy@arm.com>
Message-ID: <22439fa1-5f9b-1e54-3f39-649b116574e@google.com>
References: <796ddc256b8a3054cb0b2f43363613463fcf0d61.1653066613.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 May 2022, Robin Murphy wrote:

> The original x86 sev_alloc() only called set_memory_decrypted() on
> memory returned by alloc_pages_node(), so the page order calculation
> fell out of that logic. However, the common dma-direct code has several
> potential allocators, not all of which are guaranteed to round up the
> underlying allocation to a power-of-two size, so carrying over that
> calculation for the encryption/decryption size was a mistake. Fix it by
> rounding to a *number* of pages, rather than an order.
> 
> Until recently there was an even worse interaction with DMA_DIRECT_REMAP
> where we could have ended up decrypting part of the next adjacent
> vmalloc area, only averted by no architecture actually supporting both
> configs at once. Don't ask how I found that one out...
> 
> CC: stable@vger.kernel.org
> Fixes: c10f07aa27da ("dma/direct: Handle force decryption for DMA coherent buffers in common code")
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Acked-by: David Rientjes <rientjes@google.com>
