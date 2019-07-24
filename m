Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17E37406D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbfGXUvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:51:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38226 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387468AbfGXUvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 16:51:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so21525515pfn.5;
        Wed, 24 Jul 2019 13:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ds6DoMC8+Sm3L+5TDki5vxC1QfgRywL0wnVBt6Olylo=;
        b=fCnsLvZSkH7Xrin8sHs9P8Nbx7ZrzJMc3/mRQkJ5SbeEHt0Ql1cnLmpplGFrQUpL3x
         z6yiMlKRqVQWdo9kc8+tZ5tgF+oW0cGGcu5nlUh6a85GS5LaAR7Wxu5XVEzu8Bp4AvHK
         J/uiPKZpK0IfD83moh3gfjf8qbDayiv0vF15ZeHIyxRMPnNdf6IU6UJdiolEefiL3kLm
         WmcEKzfLvhcyIt1FmOeh1gAFFjOlICPE+oXOsgyduPLwUjMzhTvWnmOGnIeodbcAc5/D
         G/spncq7NtH/D+zmJKf0d9fUJ/DAdRZGEQDIBDGjhGXLV7GMMBLbmdC8QC97XDZVMZ65
         x7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ds6DoMC8+Sm3L+5TDki5vxC1QfgRywL0wnVBt6Olylo=;
        b=QR1LBLbmJ4ZGU/0AIvGeYZp9Y5ZDMSOVexWF0R0Owm7tN4GFJS6PAqWufXwB3tMmlq
         yuwFU3jaaQGP14uSK5cTtYkexBpatGbO4TuHQyAavEaM8yCa3vT2z6KvU5ud7ulkdLuE
         gvk7MzVIDThf0CeHhS2ufrbuSTOJb9O+A/iddp4hXI+DCxDONWEKjSL+N4+Qx2FWpke2
         GLy2UJ27MmZAHTVmE6qUsk4uzM9EMlo4l00gav3gUuYHiNHWF9K8wTh6AR17/GQLsL6u
         njNGZB5aG5qehpUOP3xwRGGu9eJcgyNBeN/GlfNDW1hXzVCALqfzJjAp/wUjEfv4Uica
         neSQ==
X-Gm-Message-State: APjAAAUJ1rZ+vjUfkuIF7tbld3M5xFLScYvNoaIo639MjGnIkdBm43hm
        Nah9MkVpL9XuOFMOGcBiLrx8TyGbu87H3vfwdYwwjtXWLVU=
X-Google-Smtp-Source: APXvYqydGZ+58IEZV9P9Wh19Vs31nSeY4KKzrqDPI1rB995ISm8d68W0C99qy8qdBJbaeTksTQ7irwQRG6dfUn4Cuwg=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr86827880pjb.138.1564001474948;
 Wed, 24 Jul 2019 13:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191655.268628197@linuxfoundation.org> <20190724191657.444120528@linuxfoundation.org>
In-Reply-To: <20190724191657.444120528@linuxfoundation.org>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Jul 2019 15:51:04 -0500
Message-ID: <CAH2r5msdLOSZ7W-PmbasQR8GfxPn2_ZjAJf6DwEX3GKsUbGkgQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 026/271] signal/cifs: Fix cifs_put_tcp_session to
 call send_sig instead of force_sig
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Note that this patch causes a regression (removing cifs module fails,
due to unmount leaking a thread with this change).

We are testing a workaround to cifs.ko which would be needed if this
patch were to be backported.

On Wed, Jul 24, 2019 at 3:02 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> [ Upstream commit 72abe3bcf0911d69b46c1e8bdb5612675e0ac42c ]
>
> The locking in force_sig_info is not prepared to deal with a task that
> exits or execs (as sighand may change).  The is not a locking problem
> in force_sig as force_sig is only built to handle synchronous
> exceptions.
>
> Further the function force_sig_info changes the signal state if the
> signal is ignored, or blocked or if SIGNAL_UNKILLABLE will prevent the
> delivery of the signal.  The signal SIGKILL can not be ignored and can
> not be blocked and SIGNAL_UNKILLABLE won't prevent it from being
> delivered.
>
> So using force_sig rather than send_sig for SIGKILL is confusing
> and pointless.
>
> Because it won't impact the sending of the signal and and because
> using force_sig is wrong, replace force_sig with send_sig.
>
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: Jeff Layton <jlayton@primarydata.com>
> Cc: Steve French <smfrench@gmail.com>
> Fixes: a5c3e1c725af ("Revert "cifs: No need to send SIGKILL to demux_thread during umount"")
> Fixes: e7ddee9037e7 ("cifs: disable sharing session and tcon and add new TCP sharing code")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/cifs/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f31339db45fd..82b3af47bce3 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2428,7 +2428,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
>
>         task = xchg(&server->tsk, NULL);
>         if (task)
> -               force_sig(SIGKILL, task);
> +               send_sig(SIGKILL, task, 1);
>  }
>
>  static struct TCP_Server_Info *
> --
> 2.20.1
>
>
>


-- 
Thanks,

Steve
