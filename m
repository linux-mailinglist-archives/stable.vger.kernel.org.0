Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DB47406B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfGXUuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:50:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35965 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfGXUuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 16:50:05 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so22465245plt.3;
        Wed, 24 Jul 2019 13:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ymGGbS98ERdMfSU8gNbxIJ/lF4ZtCUBVpDAVCCCGwbg=;
        b=bAZYZNsWrIl0bYTYn05vPRoKBNmyHE9oM2UQ+hQgZcpzTQGJdCPcSLKrdnriHi5xub
         1SgRRw+7XvsCodCgN30j03yRlu0E0b48wky9WLMoiymtlGmTajnELdl2B6GYm75od9Z8
         EjN/rKf3buqMh6gJNrBvScfkri3qThSeqp+ZUYHJgRVmN9WwFPvkJbv1meubDU0SVhRh
         Qxv3IejxYGQvR+YjFWqJmILHHnwu4WFUnDuc/QhBAwDEyfNvGQFL518BDRlkuCZQWMZF
         SNkAcGqy9e10bHXeODxxmspLLKMX6fbHqyquY/4Je49fr0uS3vYGnCsz3QmHf5l106PG
         WTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ymGGbS98ERdMfSU8gNbxIJ/lF4ZtCUBVpDAVCCCGwbg=;
        b=bQL0iyxGXN+SPzNPiVCOGOmN6SwU5A1to/nJlBLywI6LHn0z+O10OgmNvmcHMK1cuj
         VgTP5KKDNBp5eeMexUyFc/eL1aB+mkSVWrUPIEuPXGMuWUC6XDBS9JcZ02fRpylTb2kU
         7xVasRQROfMil9XWjP0N2Vcmii2FfJBRe27QT+shB6JsX4ppAXRlNjVgZcJeJDvaYzg5
         UsRLeCBi3+pc/MEJoO3k+K7Q9yEGRtT0GCwkBMiYVcTHivFTLy0TseRzpOhndJoju6YS
         r2MgD0/hoyGyMAUJbbwyUfUqQFNb8Rhm3zFEz35IT/CVaBWoTU9R6L6oRVGVYz+oF6d3
         2OIg==
X-Gm-Message-State: APjAAAXPutuLHjLXNy0F4MwD6D2d3jkHSa/E54bSUXRTm7NHBG3ZsVBp
        TiNR3vhK0j8SEATF8Pw8i0Kvsbjmp05yxSctTfc=
X-Google-Smtp-Source: APXvYqwgJb+yYMwsX+amXiOVRQfR+9jIBbfNU219WUpkMk25PJCWXnXsbXoNGuEoVmdKxguEri+WS+JZPUgzkjrJOdg=
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr88202510plb.46.1564001404855;
 Wed, 24 Jul 2019 13:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191724.382593077@linuxfoundation.org> <20190724191727.401169517@linuxfoundation.org>
In-Reply-To: <20190724191727.401169517@linuxfoundation.org>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Jul 2019 15:49:54 -0500
Message-ID: <CAH2r5msEhN2SJ+iNGPSqGJHEj4jswQK2xbV9S5xQ51E+wOcjUw@mail.gmail.com>
Subject: Re: [PATCH 5.1 038/371] signal/cifs: Fix cifs_put_tcp_session to call
 send_sig instead of force_sig
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Note that this patch causes a regression (removing cifs module fails,
due to unmount leaking a thread with this change).

We are testing a workaround to cifs.ko which would be needed if this
patch were to be backported.

On Wed, Jul 24, 2019 at 2:46 PM Greg Kroah-Hartman
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
> index e9507fba0b36..10851bb74253 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2625,7 +2625,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
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
