Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B24D4EF8BE
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 19:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349643AbiDARQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 13:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349666AbiDARQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 13:16:17 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2F818116B
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 10:14:27 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id p10so6042956lfa.12
        for <stable@vger.kernel.org>; Fri, 01 Apr 2022 10:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=utfv8DeU9QsQM5/Vhd4xkBU7PeKTZq1L4vDvZwcxU/A=;
        b=RnYrwK0OqKnAVMAa4S1NjLBhVOO5o1T9pT3+R/Z0DJQ7ZgcmyVh1fGfFWydC77Dqk6
         hTO+1etbZAy6rFIPVfziiLYn8Bbd9Z/nyH1w1uyvvh+s3For3BVIs9E5KDS2UJIJ/4fI
         s8CBuVIr9splx36gLjUC3J3QaGOu8QUc2VPlA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=utfv8DeU9QsQM5/Vhd4xkBU7PeKTZq1L4vDvZwcxU/A=;
        b=n9KBnZ386ABZ3TOjaYOEDVUsQDNnuAEkjFheZyd79oPL8j5L6lCbYFCqfBqyECBYlh
         9mW9rvDLBProyhO1b73EZdIkxA04wkjCiyjXRrknLaFdU/vPDCPwyuDK+TkmxAVu0Wl1
         LGMVb0drCao2Uq6x4F/zVNClrDE8/pfPtLgWSEPQA4vWrxqIXDkyUIJ7311JD1qgc+iv
         GXJ1PtMLcutinRE9C2K4hHyhnsU1v63tmmosZafsETYBDiZ5cgqau8Y62MDp6sX4O5ki
         Kti6o0/xBtDofr4uEBhnju6SO1zmd3tBusgKCCy8A80Z4dDlDKopNs+xjOu4ao0Qn4A7
         bdeA==
X-Gm-Message-State: AOAM532Mrx6P/6w5sFVTxuUQSPwvgr3VYmBaVsjM6A1tXf/4Rwf7LncZ
        emIcpGqHi9KSc0t1r2T+DFyeoTw+UVvvXc9ImrE=
X-Google-Smtp-Source: ABdhPJwj6MMejqTOishhLCIGA5x5NoqL6y73SyVw2Q9yc0zj3h55KHygPyVLY94KhPjRKJuW/6dySA==
X-Received: by 2002:a05:6512:2385:b0:44a:7f61:af2 with SMTP id c5-20020a056512238500b0044a7f610af2mr15051235lfv.100.1648833265010;
        Fri, 01 Apr 2022 10:14:25 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id m24-20020a197118000000b00448bb0df9ffsm291269lfc.140.2022.04.01.10.14.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 10:14:22 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id a30so4717024ljq.13
        for <stable@vger.kernel.org>; Fri, 01 Apr 2022 10:14:20 -0700 (PDT)
X-Received: by 2002:a2e:9041:0:b0:24a:ce83:dcb4 with SMTP id
 n1-20020a2e9041000000b0024ace83dcb4mr14079887ljg.291.1648833259843; Fri, 01
 Apr 2022 10:14:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220126171442.1338740-1-aurelien@aurel32.net>
 <20220331103247.y33wvkxk5vfbqohf@pengutronix.de> <20220331103913.2vlneq6clnheuty6@pengutronix.de>
 <20220331105112.7t3qgtilhortkiq4@pengutronix.de> <CAHk-=wjnuMD091mNbY=fRm-qFyhMjbtfiwkAFKyFehyR8bPB5A@mail.gmail.com>
 <20220401065309.dizbkleyw44auhbo@pengutronix.de>
In-Reply-To: <20220401065309.dizbkleyw44auhbo@pengutronix.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 1 Apr 2022 10:14:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgv6rXFjTdaumFgDC4ixg6QMOL83sQ2XOqvJC0h5fLX2g@mail.gmail.com>
Message-ID: <CAHk-=wgv6rXFjTdaumFgDC4ixg6QMOL83sQ2XOqvJC0h5fLX2g@mail.gmail.com>
Subject: Re: [PATCH] riscv: fix build with binutils 2.38
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>,
        ukl@pengutronix.de,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 11:53 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> | WARNING: invalid argument to '-march': 'zicsr_zifencei'

Gaah, it works but still warns because I cut-and-pasted those
zicsr/zifencei options from some random source that had them
capitalized and I didn't look closely enough at the reports.

Anyway, hopefully somebody can bother to fix up that. Possibly by
changing the strncmp to a strnicmp - but I don't know what the rules
for lower-case vs capitals are for the other options. I'm still busy
with the kernel merge window, so this gets archived on my side..

             Linus
