Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B126367F07D
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 22:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjA0ViJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 16:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjA0ViH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 16:38:07 -0500
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5873C1C5AB;
        Fri, 27 Jan 2023 13:38:07 -0800 (PST)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1636eae256cso3956315fac.0;
        Fri, 27 Jan 2023 13:38:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DjLB1n7BfkYGT4DAfuO2w1qwaXNy9ZaZZ251T77AFo=;
        b=KYcvAv5aQIuHHpJjKnabOdL2uHAphAsRlpbK/kXTOzPPqPTYWg0aLrnxr3mblXdsjK
         6qd7BLJ/4RxI6N5neCAEuvtV3LDphTmOcvg4rlho0ege5sONSEticY4jwxIFfwYYGG+R
         Ej8NwPP346J6E7CAfvBGn8ov/Bn08ZlRLIoFvwEreG0TdEsv74VRbdJU/qIIU6osjRgf
         NwcP8X5n8ZUmMOpC3kjim9QwS4opEC5ys3OHZYXgx9afSQq13nahT5UQvv+Hp8IvCcHO
         mVp76gJ8hFXsd5W1/iRkCeYQ6FALaCfaZX7nv+cbNtm0OCuduKVnUqDMhGUocEh5HHmT
         7d9w==
X-Gm-Message-State: AO0yUKWQou4vVh1rUxh+upGnhrsTV9NkQG8zmQ66/sMXhEY4s8PcfJ7q
        Um+YhRu5nnLXhyfnEf3mHw==
X-Google-Smtp-Source: AK7set8Ql8o8EiWbybmvdsqxzp7LPFPJQ09kTHa1AGoCvt1jMJz/kWH1nsV19uepUDh5cb28oze3dQ==
X-Received: by 2002:a05:6870:f10c:b0:163:50ff:ba11 with SMTP id k12-20020a056870f10c00b0016350ffba11mr4283145oac.21.1674855486495;
        Fri, 27 Jan 2023 13:38:06 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b36-20020a056870472400b001600797d1b5sm2406214oaq.41.2023.01.27.13.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 13:38:06 -0800 (PST)
Received: (nullmailer pid 727006 invoked by uid 1000);
        Fri, 27 Jan 2023 21:38:05 -0000
Date:   Fri, 27 Jan 2023 15:38:05 -0600
From:   Rob Herring <robh@kernel.org>
To:     "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc:     Frank Rowand <frowand.list@gmail.com>, stable@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Calvin Zhang <calvinzhang.cool@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] Revert "mm: kmemleak: alloc gray object for reserved
 region with direct map"
Message-ID: <167485548359.726924.14589412750691974893.robh@kernel.org>
References: <20230124230254.295589-1-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124230254.295589-1-isaacmanjarres@google.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Tue, 24 Jan 2023 15:02:54 -0800, Isaac J. Manjarres wrote:
> This reverts commit 972fa3a7c17c9d60212e32ecc0205dc585b1e769.
> 
> Kmemleak operates by periodically scanning memory regions for pointers
> to allocated memory blocks to determine if they are leaked or not.
> However, reserved memory regions can be used for DMA transactions
> between a device and a CPU, and thus, wouldn't contain pointers to
> allocated memory blocks, making them inappropriate for kmemleak to
> scan. Thus, revert this commit.
> 
> Cc: stable@vger.kernel.org # 5.17+
> Cc: Calvin Zhang <calvinzhang.cool@gmail.com>
> Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
> ---
>  drivers/of/fdt.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 

Applied, thanks!
