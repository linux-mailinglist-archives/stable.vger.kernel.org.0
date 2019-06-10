Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD81C3B9BB
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 18:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbfFJQiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 12:38:52 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:41678 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387699AbfFJQiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 12:38:52 -0400
Received: by mail-yb1-f196.google.com with SMTP id d2so4000843ybh.8
        for <stable@vger.kernel.org>; Mon, 10 Jun 2019 09:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FBMp7TmgEAndVg9ZGIumN5zqLiZweIyBFUM062p7dNA=;
        b=NdObCYDSBiujYyMQRNy4vTu5pt1yLzii9n+Sjkd5OecibtPnvSGSwk/YTEQ543BGBM
         q7X5M/anW3U9dA4KbMRdkN0IDFjiwV0OOe8UG0YViQJizI/FDZ0a+l9p71OMkufd2RBG
         5Jch31coJob6QwDiK7ZIt8PduXvBuyjuhHlHEyb3y8RhI3YzBXvkOTQQ805AcE2TSlUb
         IzvACvOIReU6ag+0GupvHgXJ9vNhxaHxpQEoPUQZlI2JThdiALf4REmQtNc+ce/Xso/y
         ZaBmdU0mSn0uBxNcEFz4nFWQaj9mmyzV96dcBisStvWzRom4O53ql3o9CWs9RNLynZ8M
         kLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FBMp7TmgEAndVg9ZGIumN5zqLiZweIyBFUM062p7dNA=;
        b=iCzew12XtBWi1CDKDNVB0MAH7GOn7p0LftdQHiRWbt/QOQ3xSlTjAejzZzjj8URVwb
         cyE9yzl1vKPnvK9M6nr7nY0XSV4f9if6x7zduG2Cs0qtRzSzoBZsrgrQAc9TNeMH3IdL
         y9MB9H9KbX0eJdGnd8Hmks3XXFDASkf9zxPqj5A0tBV/m5kJ3FvNah9gS+aV8ABhXtaE
         nY2eB8NL7jmPT2LAJmOQyy4i86dvBe4QmN7z+wycaqY6sRe/Ua6fVi290PXGCx2K/tuU
         sbyFB+dq70tr7ishnE/FpumLJo5o7wbyRhko3AOD3ISWAJAFSJeXVXw2zUgXbQw5VAsx
         A9ig==
X-Gm-Message-State: APjAAAWmdMY8HD4l3E/fgVLfrNEoGSXmjZ+hyeTolur3T951Jp9rrEFp
        juYBMgxhptriHKh0BVSDhm0C+mGKpZ5tWzTwt7SJ86t3
X-Google-Smtp-Source: APXvYqwFtid+Aiyknz+Yy3CSQoPUlKQnZfZXJzzFoAAMLnOp3V8dhJnlLsWsUAT7ktP1J00uLwfJ1nq7xn+9icDNkXE=
X-Received: by 2002:a25:86c1:: with SMTP id y1mr22277486ybm.45.1560184731139;
 Mon, 10 Jun 2019 09:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190608135717.8472-3-amir73il@gmail.com> <20190610151835.2FFC12089E@mail.kernel.org>
In-Reply-To: <20190610151835.2FFC12089E@mail.kernel.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 10 Jun 2019 19:38:40 +0300
Message-ID: <CAOQ4uxikmecWmOPzvuV6tU6fSNygitp856HRCG98rdxXKyhxVw@mail.gmail.com>
Subject: Re: [PATCH 2/2] locks: eliminate false positive conflicts for write lease
To:     Sasha Levin <sashal@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 6:18 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 4.19=
+
>
> The bot has tested the following trees: v5.1.7, v4.19.48.
>
> v5.1.7: Build failed! Errors:
>     fs/locks.c:1784:27: error: implicit declaration of function =E2=80=98=
i_readcount_read=E2=80=99; did you mean =E2=80=98i_readcount_dec=E2=80=99? =
[-Werror=3Dimplicit-function-declaration]
>
> v4.19.48: Failed to apply! Possible dependencies:
>     7bbd1fc0e9f1 ("fs/locks: remove unnecessary white space.")
>     d6367d624137 ("fs/locks: use properly initialized file_lock when unlo=
cking.")
>
>
> How should we proceed with this patch?
>

I will take care of backporting once patch is merged.

Thanks,
Amir.
