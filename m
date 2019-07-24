Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6475B74068
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfGXUto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:49:44 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38128 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfGXUto (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 16:49:44 -0400
Received: by mail-pf1-f194.google.com with SMTP id y15so21523887pfn.5;
        Wed, 24 Jul 2019 13:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qbKIkUXIXrIytrczug4c72/hmec9O4Z30VHncYck5j0=;
        b=P4Dj7QpEMF7iqI8Aa3kTdushdCQaM+toq1EVo24AvXPwTwXZgunQFxRMfSzG1SXnyE
         k5h764QplEFYUDboUYQD4DFv8p9eFc/JZ19FLLhyHKdrgqYSFm1FSxJy2CYBdfQvQUz2
         Dr29kwlq7w3wqLMD0ftXn6DxvwuKQPeRf0xRaC46mHHXylRSgq0xfXlt05PFbiDUDGTc
         sLtDxUV10dbkU1nnxlOg5KjaMzVK5Jy4mXVa+aQeTq2YAdb1EMdP3pEt+vReSRRLkSRw
         NUsEK0JiwmNsoKkPdsG53TpnCVBhSm14VxsBWsD2K9x1kRv3q1wDFAaaQArUf5Wwg3n9
         Agqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qbKIkUXIXrIytrczug4c72/hmec9O4Z30VHncYck5j0=;
        b=JKvbdZUfacuCLjQG0MkdJEEC9VAYo/U1DHTCZhPbnLQxG6V7o9B75W1dut8kGOo0fo
         oFcjdaXrzmxJlIRDZRdZs/KYroSV7YUY5GboiuauMR3qVcA800FQ0fs3XaJCUiyyyYG3
         1KN7GZk8ZgnhQbaiwcBaJBuHlEqjIxr3hyHWJT0rhLD5Nu+8rQNKAeFI9z6H3L27+8iN
         SfMZ+UYOkO1FzDQ3ph0+7Ny+HF46TxH24Qo7iLH1cUE142f7FVM/y7JjFjXIPe1u06e2
         ykn4f9PvWkCMl8eV/ei+JY70nBaaErzBIUl2BMKtmnw+pbp8loAruO5LkteFDkVR2kSV
         GOSw==
X-Gm-Message-State: APjAAAX0iuXVmAS+HsCRTOqsD0pNjESxQW+L9b7IZbQ4FuVVb/bDLQ63
        3rM/g10V/s15Jh1/HvhxIVlePFAqbhiyX9XWJnI=
X-Google-Smtp-Source: APXvYqyiiXNMl4u63emYSupcBStxAultLjAIT4xIJ8f6+xqyLGhEr94UfVo/+QNj6ThewJnWA/M11ul6p5lnMKEDpH0=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr86823936pjb.138.1564001383415;
 Wed, 24 Jul 2019 13:49:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191735.096702571@linuxfoundation.org> <20190724191738.345725184@linuxfoundation.org>
In-Reply-To: <20190724191738.345725184@linuxfoundation.org>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Jul 2019 15:49:32 -0500
Message-ID: <CAH2r5msp4h4+gR6MC0ciO7X9w8cTWh5DD_W1teWpxHfooc5tsA@mail.gmail.com>
Subject: Re: [PATCH 5.2 038/413] signal/cifs: Fix cifs_put_tcp_session to call
 send_sig instead of force_sig
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>,
        Jeff Layton <jlayton@poochiereds.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Note that this patch causes a regression (removing cifs module fails,
due to unmount leaking a thread with this change).

We are testing a workaround to cifs.ko which would be needed if this
patch were to be backported.

On Wed, Jul 24, 2019 at 2:26 PM Greg Kroah-Hartman
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
> index 8dd6637a3cbb..714a359c7c8d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2631,7 +2631,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
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
