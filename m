Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6E3618859
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 20:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiKCTMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 15:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiKCTMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 15:12:12 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDDF1E3C1
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 12:12:10 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z18so4522005edb.9
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 12:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f/uQDfkK2fUmucYfX1Ucf/NpEisb9X/K5BNzLRcbNjk=;
        b=eo4aBmsyG+UGDjjhp9wAYAA+8+Qu8opXzwXo5CWtTljOkJVb/P8ecj+xE+UxJ37lU5
         YlmhZVx/5EOsCvfLzlLhh/eLXaEJ4vntWDavSok5uhr2/K3IHPoWx2oy5uFd/knc+qfz
         kXTO0VO9jHOelgutoziifaqvazkEKEWXTsjm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f/uQDfkK2fUmucYfX1Ucf/NpEisb9X/K5BNzLRcbNjk=;
        b=MSvF/q3HAmGuen5nmYue2Ba73zzilClaCyl0v3YUmeFkk4LI32GZ8eo7N21KiTDwp3
         6oOVmKIjAE+SBAP3PvnlrZAQnKNmwU5KJsE5CoRcK7huK5n9NB5gMAuR7GgE60gD7OHb
         0BnyUsA0o7bClZaNyKqP2M7EZsuF/eODAs1MnI6jIdTMGrQYs1CC1N4Iv1EDyoyE+nv1
         HhXxkK3r6aEumgfP8lumM+6D/srp3yIYzmXyxbDgNTii7mrchz9cYH9FCcy/jCoGKTqW
         8P8uv4c/GqvKlpxWCRH1P5i1xoT0gs12KuLhUtG54voRnMK7CzeOXd6oE7x/F+wOTUMy
         T6eQ==
X-Gm-Message-State: ACrzQf1ZMawDYnqoCplfIcMOian4A6vj2VREzG/e/A3J1R9Pw40eYbpT
        xDnAaexeu0LeRNAQhydyfWSUy2BSywDo1u1y7Uis+w==
X-Google-Smtp-Source: AMsMyM7XaG7kq78SnG4DtqdigmQ8lNHOJIdJd5tJXByjpS2m+rHHAT1RW5vhP4BjzKNeraL/dsseYgZ9FBmwwLAch/w=
X-Received: by 2002:a05:6402:370c:b0:453:9fab:1b53 with SMTP id
 ek12-20020a056402370c00b004539fab1b53mr32536090edb.28.1667502728713; Thu, 03
 Nov 2022 12:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221103170210.464155-1-peter.griffin@linaro.org>
In-Reply-To: <20221103170210.464155-1-peter.griffin@linaro.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 3 Nov 2022 20:11:57 +0100
Message-ID: <CAJfpeguUEb++huEOdtVMgC2hbqh4f5+7iOomJ=fin-RE=pu8jQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: vfs_tmpfile: ensure O_EXCL flag is enforced
To:     Peter Griffin <peter.griffin@linaro.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>,
        Peter Griffin <gpeter@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 3 Nov 2022 at 18:04, Peter Griffin <peter.griffin@linaro.org> wrote:
>
> If O_EXCL is *not* specified, then linkat() can be
> used to link the temporary file into the filesystem.
> If O_EXCL is specified then linkat() should fail (-1).
>
> After commit 863f144f12ad ("vfs: open inside ->tmpfile()")
> the O_EXCL flag is no longer honored by the vfs layer for
> tmpfile, which means the file can be linked even if O_EXCL
> flag is specified, which is a change in behaviour for
> userspace!
>
> The open flags was previously passed as a parameter, so it
> was uneffected by the changes to file->f_flags caused by
> finish_open(). This patch fixes the issue by storing
> file->f_flags in a local variable so the O_EXCL test
> logic is restored.
>
> This regression was detected by Android CTS Bionic fcntl()
> tests running on android-mainline [1].
>
> [1] https://android.googlesource.com/platform/bionic/+/
>     refs/heads/master/tests/fcntl_test.cpp#352

Looks good.

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
>
