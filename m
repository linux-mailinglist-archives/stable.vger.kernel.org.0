Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF55630BAA
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 05:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiKSEIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 23:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSEH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 23:07:59 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D3F8FB10;
        Fri, 18 Nov 2022 20:07:58 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id z24so9075373ljn.4;
        Fri, 18 Nov 2022 20:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dtRW27/VFkKfRExNy2R07fG81X6WC5yaz70q9JRBAiU=;
        b=TtXIVPnDZ2ShtyoirzVFHNKPh8oO5RxHmR1Jln/WpZ2R0mz/omA64Nc4xWIcdeB5KS
         EG/6ZdqTJ6+dzZnj4B1/ba0XEB+3LnlGUarb0AProNgXWuIkINRtF1oKz2sd/XUTZ2wf
         WSXRATcVyhcRzZ0Zy7r7KwlOfrdcCG3GHRylR1qxE9M3m6nq+s0ypORbYGRxhGHP8ktz
         kcqToSSYSeBQ3fgd+yysQis00CStwh08l95BpK7x3sbSIdAixGyMcdDiDcfNCNJG4qLF
         jwXBF+9GTdUV6bTVsYdfcloCX9DEHY+i3LkH2jF6IOcbDAccSmg3q9WQXn7wdKR0NbYM
         GTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dtRW27/VFkKfRExNy2R07fG81X6WC5yaz70q9JRBAiU=;
        b=29Vo+NKzMhMEu3uy8flqd3KicER8SonayyJpoV9XG8U+DW7LXqbeVaw6rwnbgPgTXQ
         vzTRsHSIpldch7V4oyig+RCrH8heFax3bxiXRaIG9y+H305bhqjkLXDwMhwL+wWsRRG0
         h5HzrAKsSBR0c8m99Rmx4hTKZY+8i82rULfTcuOGYjJbH4MSis8rr71FuDzS31n+ig0X
         X7pds3HPIPDwJQTcNmWsZRz+AaOjuoDsh/PJiPscv0gQjSrgcDyEwXeJ9JZXTuzJqw4o
         VVXg+v6oPb3EzPbk+IMX7rp3CRCmx4TcWLM6yPHI/ZSE8Ljd7GpNgJcIE4Pxq82/7ZDH
         /2iQ==
X-Gm-Message-State: ANoB5pn97QtlLu5fYuD6sH+oMr1Zv46mr0Njo+4avoXS1TcORILguuXD
        WsMT+Hk2f1AMLofgjTfWupiDbXlkXuA9dAYHCs0=
X-Google-Smtp-Source: AA0mqf6TtkhSfRQWsSRKkFVrN1K2vpE+3E7DbjrBZGD1HMn4Be7sA4L0VCgEG63L5y4r/HHwk2Mwiv1G7ZioFSoo96Q=
X-Received: by 2002:a05:651c:198f:b0:277:6a5:109b with SMTP id
 bx15-20020a05651c198f00b0027706a5109bmr3472454ljb.42.1668830876279; Fri, 18
 Nov 2022 20:07:56 -0800 (PST)
MIME-Version: 1.0
From:   Jorropo <jorropo.pgm@gmail.com>
Date:   Sat, 19 Nov 2022 05:07:45 +0100
Message-ID: <CAHWihb_EYWKXOqdN0iDBDygk+EGbhaxWHTKVRhtpm_TihbCjtw@mail.gmail.com>
Subject: [REGRESSION] XArray commit prevents booting with 6.0-rc1 or later
To:     willy@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, nborisov@suse.com,
        regressions@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

#regzbot introduced v5.19-rc6..1dd685c414a7b9fdb3d23aca3aedae84f0b998ae

Hi, I recently tried to upgrade to linux v6.0.x but when trying to
boot it fails with "error: out of memory" when or after loading
initramfs (which then kpanics because the vfs root is missing).
The latest releases I tested are v6.0.9 and v6.1-rc5 and it's broken there too.

I bisected the error to this patch:
1dd685c414a7b9fdb3d23aca3aedae84f0b998ae "XArray: Add calls to
might_alloc()" is the first bad commit.
I've confirmed this is not a side effect of a poor bitsect because
1dd685c414a7b9fdb3d23aca3aedae84f0b998ae~1 (v5.19-rc6) works.
I've tried reverting the failing commit on top of v6.0.9 and it didn't fixed it.

My system is:
CPU: Ryzen 3600
Motherboard: B550 AORUS ELITE V2
Ram: 48GB (16+32) of unmatched DDR4
GPU: AMD rx580
Various ssds, hdds and network cards plugged with various buses.

You can find a folder with my .config, bisect logs and screenshots of
the error messages there:
https://jorropo.net/ipfs/QmaWH84UPEen4E9n69KZiLjPDaTi2aJvizv3JYiL7Gfmnr/
https://ipfs.io/ipfs/QmaWH84UPEen4E9n69KZiLjPDaTi2aJvizv3JYiL7Gfmnr/

I'll be happy to assist you if you need help reproducing this issue
and or testing fixes.

Thx, Jorropo
