Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B46466E7C
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 01:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244390AbhLCAdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 19:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhLCAdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 19:33:11 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75232C06174A
        for <stable@vger.kernel.org>; Thu,  2 Dec 2021 16:29:48 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id j18so2830350ljc.12
        for <stable@vger.kernel.org>; Thu, 02 Dec 2021 16:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=O2muo1Ch2KGFYgo2qH1asrLGIwea+ljuD5YO72dacSA=;
        b=I7qCeZeLdsJXtthxIr2lusNNV0BiGQB2oX8Vgjsubew66BVvVj/qAkm80aGblh6X2l
         O3YU/2Dja/56a0Z4NeOtbMXTGgSbmgnbTBhcOK1Tv2KI5+iJuvAWEkx8RyM3kICDR0Fw
         1SVuBc/Ah/bZpNiViZvIWqrNG/Z4AuQXzi8ZjsFW4cqWsGME2vflQXDYeJtTb9ez7+T8
         2AQTumzIeU8TMC0Yr/nnS/Nw+NXWZz7geD+7Q3okK9gfE/huRLRHgXNBbmhrn/RYBE3J
         TEryq/HjWcOYFcz0HRbZ5HRZCpKmwfNsIKyNnGSzsvLY5dTPq8MYPnIUNe/ThXUc8yMn
         us4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=O2muo1Ch2KGFYgo2qH1asrLGIwea+ljuD5YO72dacSA=;
        b=y3l02OSjtpaTwaNEZ4R9LMPLPMkfWjMXlXmSjDUwP9YE88eqteJBboe2bA5Q/16+pI
         2octpkzCZ6htfhtIn8z3yR1UW6m8PpdxF18jvSakT4ADZxLXwilENu73m4kxM16Wo3z3
         43rCunCHXwHzsF46mcUJpiuy84Ubqp088qoPOdEkM7HECaK+3WIBTDgOHcp79+fallPa
         7/tpzI2XIH6eSJ2o4BBdfAXt63xoWO/zuVEoYSw1nKsJeMY3p84YjqTsxXq+c02KZSai
         a8Uey6/Qp7n/yve+fWFMciTrm19naq9rPUFSkILekbne7/bvnHjfLG0GwS6SWWppIbSV
         bAbw==
X-Gm-Message-State: AOAM530rEswhX14axGL3l6GbGEXJRubC/JOqvoPTifr3CHm50od+6/Kv
        R5UwPkncqHsG8srtU0CVmmGoO8T5mlz0YKQUQW50nl04TJc=
X-Google-Smtp-Source: ABdhPJwjIzQ9X1BM1bkUNCyvGRHpS56R/KUE3as5MR4MtKlj2rQ9C8jH+ZkQ3o9HAoAvVL6uOCtm56pfQU3JTVBLVbg=
X-Received: by 2002:a2e:b894:: with SMTP id r20mr15691386ljp.304.1638491385631;
 Thu, 02 Dec 2021 16:29:45 -0800 (PST)
MIME-Version: 1.0
From:   Stan Hu <stanhu@gmail.com>
Date:   Thu, 2 Dec 2021 16:29:34 -0800
Message-ID: <CAMBWrQ=1MKxnMT_6Jnqp_xxr7psVywPBJc6p1qCy9ENY8RF2Qw@mail.gmail.com>
Subject: Request for cherry-picking overlayfs fixes in 5.10.x stable
To:     stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A number of users have reported that under certain conditions using
the overlay filesystem, copy_file_range() can unexpectedly create a
0-byte file. [0]

This bug can cause significant problems because applications that copy
files expect the target file to match the source immediately after the
copy. After upgrading from Linux 5.4 to Linux 5.10, our Docker-based
CI tests started failing due to this bug, since Ruby's IO.copy_stream
uses this system call. We have worked around the problem by touching
the target file before using it, but this shouldn't be necessary.
Other projects, such as Rust, have added similar workarounds. [1]

As discussed in the linux-fsdevel mailing list [2], the bug appears to
be present in Linux 5.6 to 5.10, but not in Linux 5.11. We should be
able to cherry-pick the following upstream patches to fix this. Could
you cherry-pick them to 5.10.x stable? I've confirmed that these
patches, applied from top to bottom to that branch, pass the
reproduction test [3]:

82a763e61e2b601309d696d4fa514c77d64ee1be
9b91b6b019fda817eb52f728eb9c79b3579760bc

The diffstat:

 fs/overlayfs/file.c | 59
+++++++++++++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

Note that these patches do not pick cleanly into 5.6.x - 5.9.x stable.

[0] https://github.com/docker/for-linux/issues/1015
[1] https://github.com/rust-lang/rust/blob/342db70ae4ecc3cd17e4fa6497f0a8d9534ccfeb/library/std/src/sys/unix/kernel_copy.rs#L565-L569
[2] https://marc.info/?l=linux-fsdevel&m=163847383311699&w=2
[3] https://github.com/docker/for-linux/issues/1015#issuecomment-841915668
