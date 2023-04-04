Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F0E6D5916
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjDDHCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjDDHCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:02:40 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABB21BEB;
        Tue,  4 Apr 2023 00:02:39 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id d22so19022287pgw.2;
        Tue, 04 Apr 2023 00:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680591759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zu1/4ofEiUpEr/nAZ126vJD9LVR8thpY1qUm9I5vgVo=;
        b=kJxouxIrSPXmym/6d+rodZfz0ak6JgSQio5etru4EHlJOlC837ebiCDoJ8ysW3uk/2
         MGagPJdRWdpE90Xl9VwPV/+vlcI4sUXarRuETDoUPcEERavtzp5kXj3dapgnYXL0+XsD
         a1AMDW3xVFnQe+dHw3gLQKzqnQU97jgVCfMHv5XfhLyqLvRMx4XpVGb6yHp+oblKIZO1
         krqniqdv0H4NbdhQzPEh2uh1Z/hU6bFxBC66ZJ6gu9r/5dopJGHf+cSHaD01nqWRdFT2
         4poZc+AF00Bd/bcL1w4qYdVSXf77EfqvX9e0l+whZjOAUcP4HWPC9ueO/D8qiYbutwbU
         RjpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680591759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zu1/4ofEiUpEr/nAZ126vJD9LVR8thpY1qUm9I5vgVo=;
        b=G9CFo/4usS8kyskj1kj05mSr7bpzQaceBRJVX+x4QWmKmO3Vg5KamfBfyu6zZ1Zahm
         u90zjPEm+bDrZgY9usINQZ78eedYoQ4rim6Z0a7XGHQ9U4pxdlpVyiDpe4atprIjCzHg
         NNpO4UJxIJYpiuHtycW6S5y9cTpcTucvuXyeq9xS0DHOxDf8wYGVXq6y4cf3Te+0Zl4M
         aIo9Dvrvb3P7d+J+MrfOleh8S4N8sgZAU1mg3TPNkH86O3kQ6GaYfuybZ+19DqUfSvmi
         hBeYlFruw6S696Ub59+yWaVtXw/ZP8KG31w8i2+eiBfZMHRANNH9sruA+6QW3MGG2tk0
         xRaw==
X-Gm-Message-State: AAQBX9ey7CMg05rvLYSeno9eng0NtvPDLCDqcvD9YuXnMVk4jV2L88nJ
        7s+W+ZplPhc6Pcf6s3wDPdET46CRVw51/UvPkIU9kpWJJGsCTg==
X-Google-Smtp-Source: AKy350ZNRj0xjX8FoXDbKXqut6Jzs3vhi8ZFnTBOtNbW5V4SpV4JWOoels8/aM6vlwaYr8dwDBVCN2qIxbLq5H4AoEM=
X-Received: by 2002:a05:6a00:cc3:b0:626:1eb8:31d7 with SMTP id
 b3-20020a056a000cc300b006261eb831d7mr683117pfv.1.1680591758362; Tue, 04 Apr
 2023 00:02:38 -0700 (PDT)
MIME-Version: 1.0
References: <1679019847-1401-1-git-send-email-caelli@tencent.com>
 <ZCuQO3A6FX305KTJ@debian.me> <3d994c05-492d-f9f4-161d-123a68d4e87a@gmail.com>
In-Reply-To: <3d994c05-492d-f9f4-161d-123a68d4e87a@gmail.com>
From:   caelli <juanfengpy@gmail.com>
Date:   Tue, 4 Apr 2023 15:02:27 +0800
Message-ID: <CAPmgiUJhocwGweOYmJcYY47CONwJAqgLA7AdDzD=Quepd6u5cw@mail.gmail.com>
Subject: Re: [PATCH v7] tty: fix hang on tty device with no_room set
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Hui Li <caelli@tencent.com>, stable@vger.kernel.org,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Where do you find this hanging pty? Seems like the wording makes me
> confused. Maybe you mean "It is possible to hang pty device. In that
> case, ..."

Thanks for your reply, I will correct messages like this:

"It is possible to hang pty devices in this case, the reader
was blocking at epoll on master side, the writer was ..."

Bagas Sanjaya <bagasdotme@gmail.com> =E4=BA=8E2023=E5=B9=B44=E6=9C=884=E6=
=97=A5=E5=91=A8=E4=BA=8C 10:55=E5=86=99=E9=81=93=EF=BC=9A
>
> On 4/4/23 09:49, Bagas Sanjaya wrote:
> > On Fri, Mar 17, 2023 at 10:24:07AM +0800, juanfengpy@gmail.com wrote:
> >> We have met a hang on pty device, the reader was blocking
> >> at epoll on master side, the writer was sleeping at wait_woken
> >> inside n_tty_write on slave side, and the write buffer on
> >> tty_port was full, we found that the reader and writer would
> >> never be woken again and blocked forever.
> >
> > Where do you find this hanging pty? Seems like the wording makes me
> > confused. Maybe you mean "It is possible to hang pty device. In that
> > case, ..."
> >
>
> Oops, I forgot to Cc: LKML.
>
> --
> An old man doll... just what I always wanted! - Clara
>
