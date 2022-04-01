Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1A54EF933
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 19:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349073AbiDAR4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 13:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244105AbiDAR4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 13:56:51 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC515419D
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 10:55:02 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t13so2939790pgn.8
        for <stable@vger.kernel.org>; Fri, 01 Apr 2022 10:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=iongRgn393jDScHsMFqxrfWy25+LUVsFTFfMXZy7tcs=;
        b=5DHzn4/4Gak55kwk9hNdkaIdBJXQSuh4T7djtDJzEyVrT2bs/etMzwCF9gb2kfNEul
         9abqnu9KEtppYl4M+gl+0S68ffL7FliVVzDB1GoFjkYJOSHBLGHXOKZ/PuVRGbUYLTI1
         T3zkvLghNRE7gM/4+Z7JwQRmRvmMSz+eOqa7Mzrt1vYFEnbdLTa4sdVm9m07qdPQSJ2y
         KfsGbVlqcsdnpZmkuHYhDzaNI19ybF4dyu7UvVLo5JrOjFBJ11ahz2VKexnPKOps8pAc
         JH2qWWmgdW80vC1zACuYuPpYPBuAUrx8ZY8Bmq3FiGr0NYigWvONSc/lDx6nh+sPWE5g
         XrmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=iongRgn393jDScHsMFqxrfWy25+LUVsFTFfMXZy7tcs=;
        b=Wgmf5D220Jkwj4L5XtURwUrB8uPxW/URtVNUMdMXzijWHH57V7tFbHT8MG34S4W3vb
         D2uvNyyZayVz90lVVqpkRrg6y9jk7K4uzPtXWvVK2hpUtPsTsmVJ0yRGJ0tzgx0tHcGt
         pdY6Er1w0SNYHruawtGbEWgtyHRRUQwRjlUGgmlKu5WZ3r2bfit4bNWwgLpsGPP0mbWE
         Heqg5Cc+nHr5jlzb2kRjV1sGGfQKDv5LUzGb0tOKarlXc0QFq8E3PCDs3+JCcB0/BjdT
         GMZcgwqleL9v2N5YrfOaVXDD8rSar+QHWQQgrmmyd1bxnD2ABe6pmJ1y7Ood2VBWXJC7
         i1Mg==
X-Gm-Message-State: AOAM531JlHBZ13F31JJEZTV2tZ5ToLEd7SlQkih4tStNpa7F59Sq2cFN
        l/Jm0xjQaa3M99mkE0OBUUDd9iwINnVnRw==
X-Google-Smtp-Source: ABdhPJwppucEmP01bI+aWljh4lysCOjDeGg0qSPNzu3mMPX4N67PpZVKiJX3L9pbyN5EHAHvjjmBRA==
X-Received: by 2002:a63:e716:0:b0:380:85d1:656c with SMTP id b22-20020a63e716000000b0038085d1656cmr16301723pgi.321.1648835701412;
        Fri, 01 Apr 2022 10:55:01 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id hk16-20020a17090b225000b001ca00b81a95sm9533169pjb.22.2022.04.01.10.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 10:55:00 -0700 (PDT)
Date:   Fri, 01 Apr 2022 10:55:00 -0700 (PDT)
X-Google-Original-Date: Fri, 01 Apr 2022 10:54:57 PDT (-0700)
Subject:     Re: [PATCH] riscv: fix build with binutils 2.38
In-Reply-To: <CAHk-=wgv6rXFjTdaumFgDC4ixg6QMOL83sQ2XOqvJC0h5fLX2g@mail.gmail.com>
CC:     mkl@pengutronix.de, aurelien@aurel32.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
        linux-sparse@vger.kernel.org, ukl@pengutronix.de,
        luc.vanoostenryck@gmail.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <mhng-c280d48c-477d-4589-baee-255c774b5a51@palmer-mbp2014>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 01 Apr 2022 10:14:03 PDT (-0700), Linus Torvalds wrote:
> On Thu, Mar 31, 2022 at 11:53 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>>
>> | WARNING: invalid argument to '-march': 'zicsr_zifencei'
>
> Gaah, it works but still warns because I cut-and-pasted those
> zicsr/zifencei options from some random source that had them
> capitalized and I didn't look closely enough at the reports.
>
> Anyway, hopefully somebody can bother to fix up that. Possibly by
> changing the strncmp to a strnicmp - but I don't know what the rules
> for lower-case vs capitals are for the other options. I'm still busy
> with the kernel merge window, so this gets archived on my side..

I'm gluing sparse to my build tests now, so I'll sort it out (that'll 
also make sure a failure doesn't leak again).  Might not be today, but 
shouldn't take too long.
