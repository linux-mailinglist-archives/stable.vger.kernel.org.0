Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE578722E7
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 01:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfGWXUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 19:20:42 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35090 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfGWXUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 19:20:42 -0400
Received: by mail-io1-f68.google.com with SMTP id m24so85588406ioo.2;
        Tue, 23 Jul 2019 16:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m3Q8+/v4CM0L4GwsZxs2WcaoeWxYZYbtWw39haCd4u4=;
        b=HR+P+4NkI6L7xuD6IE3T1KWAmh6kZwbsXgyOklLsxPmo6ukom2a/0fQXytbFNr/D8Y
         lqDWzURxoTxIBYaITAU3s2JrgP8s2H0TxjUGCtnXhTaz5B0F1mPDpCyPdYj7wGRJe3H6
         27g/1DKaisc3vBoa03E10uywQjzC165RHakPdpik58AMl3WL50Q04qmaiUUJHRiotKWp
         PkNKBSjAD70BKAX07FpKLGsv2x3YZ8K0A1FdeuYs4vb2B9s5lbJdX0+OrwHbDJ7iJthF
         ZYsbjPbnVljeFJcKDRvOdN00/9abfdn1vFASucIyavUanKm7UfmC6hamnHITNYT2Pgbo
         69YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m3Q8+/v4CM0L4GwsZxs2WcaoeWxYZYbtWw39haCd4u4=;
        b=jAwI7VnPN/Z4q5e/CFTfGZTIEHOJebcPVlBbvZv8YfC3FeiX/IU2VZfd7kVxXjH2ab
         OM9xoCnlnz9/5FdtkMr82wZvVTU20/Y7nEZvuIKfXuGkhO/j1vlX2xpYoC/ha4dYlTig
         +n1D1DX1RFhJplpYHBHhCMmSlGPwR53+Cf9jYfeJZahxTr15OATltpCJViGFXk+9/GZ9
         kLx4mUWBsrmPaarA+ytj80VNHxv9Ztv089NPPSrBhRy1qS1eHBpKjjqXV2iBhIDgxbSk
         WTbOku/d5820CpNZxfGUkrlCABcBONjSSH+YRCYnXwMRhRjS04Aqvx/w7mNGJJS7cz87
         DZpQ==
X-Gm-Message-State: APjAAAVb2HR9Ux7FR6FAiRrj8ExjQ27o9F8SlVD5Rmu49nNoTE/JSUdt
        sQQJIrZDdDcTScNxlywvtaMjvQUEbsdRUtBoF0XPKg==
X-Google-Smtp-Source: APXvYqx+aFEZ60goSLlOoXFdJx5XHU9KXkvx2zZrHm2ejE2YNuYySG/3ZoSv5C9NRtEed2Swx18zzZXwGdFFDjtnMAE=
X-Received: by 2002:a5e:9506:: with SMTP id r6mr8685534ioj.219.1563924041597;
 Tue, 23 Jul 2019 16:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190715134655.4076-1-sashal@kernel.org> <20190715134655.4076-39-sashal@kernel.org>
In-Reply-To: <20190715134655.4076-39-sashal@kernel.org>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 24 Jul 2019 09:20:29 +1000
Message-ID: <CAN05THSdj8m5g-xG5abYAZ=_PE2xT-RwLtVhKrtxPevJGCSxag@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.2 039/249] signal/cifs: Fix cifs_put_tcp_session
 to call send_sig instead of force_sig
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Jeff Layton <jlayton@primarydata.com>,
        Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 1:15 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: "Eric W. Biederman" <ebiederm@xmission.com>
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

I think this patch broke the cifs module.
The issue is that the use count is now not updated properly and thus
it is no longer possible to
rmmod the module.


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
