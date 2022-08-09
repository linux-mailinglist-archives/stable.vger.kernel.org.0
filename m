Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1758DF20
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344804AbiHISdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347650AbiHIScu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:32:50 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C562AC59
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 11:11:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j15so15214845wrr.2
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 11:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=OA5rxybRJg7FBgf7LcP36+eMhTBI9ViMllg0iTpVE1U=;
        b=SqSKnyDHdAgOHQuINF02AaJ85ikEU0UhoXbIiaaa/2/Qn3OKfXZNE0rgBR2kEMrVlD
         AyF2/TSeV6w3v6RfEnNZH/rsFNRFuGORnIZkooXu7eK8kgB8A5PbPKFFCpiWVBjWLr4P
         NBYUbjBGWQ0urF7kbSjYa7rVdaPPFM8BdTlF+OI+yB/7Yjz/0X6I1mPzbeL/oYEcYAe4
         XtU1YFpttwrntLChhmV9VOU+SUMTtIC5eyzcOBGHgRnFq1ib2WAILut44zzwPgWqx+g4
         gUosOVhNqtAIGu7CJF0aC1f+2NfM9E7x9tmdYzPcDxtwWNcGWYjKMm1di3628JdvT/0m
         kYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=OA5rxybRJg7FBgf7LcP36+eMhTBI9ViMllg0iTpVE1U=;
        b=5kcSxlqE68hGrbcwoQcQLkw3vEVKKEYKWZ0Lx32g2Q5y3A4+v2gCCBTr0oTFNk3DWM
         8W9jrjc8EoXvwkw140s5+bLArIkP0a3AJ2kkTi5Y8hG7vtKvXuRZWFgZEIpa5Rz+CJr1
         a6WPNR6IOHwySKbbPOuPXD2salFWMt0Lh6AWeyS7GJWIBbhU7aQLKxCBLcyBJwejlkKA
         48tOsiot9RgqAjE+GraK5QMh/4JRIgBhU7hXA/+cxKuaEvMC/x2+S3kQEicKfAUT2dwr
         z6CdpBq+Q7tlgx3KoLaIZrhUvzndlSVH92XLekLorZLZChsc55CrTYPXVNfOfiq9i23D
         cQwA==
X-Gm-Message-State: ACgBeo3/nMh0RW7Vjxy+QbOcJB7CRaQSJSjJyon0yHnEvFlwQj+j2DID
        Qyoe4laMY/+cQ7QG6ALc68LDOJNBYbHO3cRk
X-Google-Smtp-Source: AA6agR6vnbD1A+vsI+ENBUzpnhSWi2++vwmooKAIs9TxHb37PIv0BB++vS506o+9jcFg2fxu3TkBew==
X-Received: by 2002:a5d:48c8:0:b0:21e:5134:c78c with SMTP id p8-20020a5d48c8000000b0021e5134c78cmr14828323wrs.233.1660068701544;
        Tue, 09 Aug 2022 11:11:41 -0700 (PDT)
Received: from kraken (109-178-233-54.pat.ren.cosmote.net. [109.178.233.54])
        by smtp.gmail.com with ESMTPSA id p1-20020a5d48c1000000b0021e6277bc50sm16900720wrs.36.2022.08.09.11.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 11:11:41 -0700 (PDT)
Date:   Tue, 9 Aug 2022 21:11:20 +0300
From:   Michael Bestas <mkbestas@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Message-ID: <20220809210520.7ea395c9@kraken>
In-Reply-To: <YvKVlhUZ2I1omy5S@kroah.com>
References: <20220809145624.1819905-1-mkbestas@gmail.com>
 <YvKVlhUZ2I1omy5S@kroah.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 9 Aug 2022 19:12:54 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> What about 4.14.y and newer?
> 
> thanks,
> 
> greg k-h

This patch should be required on all stable kernels that got commit
"fdt: add support for rng-seed", however I have not tested it.

A similar backport exists in android 4.19 kernel:
https://android-review.googlesource.com/c/kernel/common/+/1238592

Without this patch, Google Pixel 3/3a fails at a very early boot
stage after merging v4.9.320+ due to the random backport.

Thanks,

Michael Bestas
