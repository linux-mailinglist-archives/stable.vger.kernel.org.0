Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F8565CAFD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 01:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjADAlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 19:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbjADAlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 19:41:08 -0500
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02839DEE2;
        Tue,  3 Jan 2023 16:41:06 -0800 (PST)
Received: by mail-il1-f170.google.com with SMTP id p15so7901647ilg.9;
        Tue, 03 Jan 2023 16:41:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0OnDnO+Scf4Eq7m34XnPlJQdfz1ctr+/kVqfeVptYbI=;
        b=w5i8ySdzVVsgf06XsVVyeNABn/Tir0Rm8Slbu+sB7BRWmzfvBbzDQkIPqNluiBcfZy
         zEVC95qKyXFOd1NrAZAwDTKymca/uCQfbh/RGxQglXfXiSqyhywdCpSDtxiVUXymTQHu
         geuoazDxRW5bQePlYDl95t3qn3RF6wugt1/EkUEzYRzZidlJz/c332LhcGWMfl4F2Ii3
         cq9JDUXKRGBAkqTCxUbgm9sTaDiDopI8dD6F6fpfD6p/hhEstLnOut9pAzAVyuYZaScQ
         bfiIvEWq7TwILcpTwKgo+0coXGUfry1SwM0LGPxtNufvR4uhYWxJzXyhzwETtcqWVAKW
         KVxQ==
X-Gm-Message-State: AFqh2kpbWc+47Z+YaW67RD2wT29O8uqDJYHHEI3aap2Df6Wz7DvXwU5U
        OKwqs3FdKY9p5qlfa2CJ5Al9wvYrdA==
X-Google-Smtp-Source: AMrXdXucfQ1h0mlf8D9SnrkgUMGn0Nj5EHYHbNmrDg5Q8wfDlDKtKcdBfklctbTUhVENsupZPJe3KA==
X-Received: by 2002:a92:cf06:0:b0:30c:39e9:7962 with SMTP id c6-20020a92cf06000000b0030c39e97962mr11082284ilo.9.1672792865191;
        Tue, 03 Jan 2023 16:41:05 -0800 (PST)
Received: from robh_at_kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id e22-20020a02cab6000000b003711ce0dc15sm10628564jap.68.2023.01.03.16.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 16:41:04 -0800 (PST)
Received: (nullmailer pid 159624 invoked by uid 1000);
        Wed, 04 Jan 2023 00:41:03 -0000
Date:   Tue, 3 Jan 2023 18:41:03 -0600
From:   Rob Herring <robh@kernel.org>
To:     andreas@rammhold.de
Cc:     devicetree@vger.kernel.org, stable@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        Frank Rowand <frowand.list@gmail.com>,
        linux-kernel@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH] of/fdt: run soc memory setup when
 early_init_dt_scan_memory fails
Message-ID: <167279286226.159538.13769216021607958062.robh@kernel.org>
References: <20221223112748.2935235-1-andreas@rammhold.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223112748.2935235-1-andreas@rammhold.de>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Fri, 23 Dec 2022 12:27:47 +0100, andreas@rammhold.de wrote:
> From: Andreas Rammhold <andreas@rammhold.de>
> 
> If memory has been found early_init_dt_scan_memory now returns 1. If
> it hasn't found any memory it will return 0, allowing other memory
> setup mechanisms to carry on.
> 
> Previously early_init_dt_scan_memory always returned 0 without
> distinguishing between any kind of memory setup being done or not. Any
> code path after the early_init_dt_scan memory call in the ramips
> plat_mem_setup code wouldn't be executed anymore. Making
> early_init_dt_scan_memory the only way to initialize the memory.
> 
> Some boards, including my mt7621 based Cudy X6 board, depend on memory
> initialization being done via the soc_info.mem_detect function
> pointer. Those wouldn't be able to obtain memory and panic the kernel
> during early bootup with the message "early_init_dt_alloc_memory_arch:
> Failed to allocate 12416 bytes align=0x40".
> 
> Fixes: 1f012283e936 ("of/fdt: Rework early_init_dt_scan_memory() to call directly")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andreas Rammhold <andreas@rammhold.de>
> ---
>  arch/mips/ralink/of.c | 2 +-
>  drivers/of/fdt.c      | 6 ++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 

Applied, thanks!
