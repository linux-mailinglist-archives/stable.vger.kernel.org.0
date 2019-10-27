Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BBBE652A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 20:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfJ0T7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 15:59:30 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40513 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfJ0T7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 15:59:30 -0400
Received: by mail-io1-f65.google.com with SMTP id p6so8155166iod.7;
        Sun, 27 Oct 2019 12:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1JDSmw4J3XoscIws3mjSmVtK+pmmPNy7/Yi1UQKGYyc=;
        b=IfnIIUZpwalkn0FyuXzidd6QbzoB/pizIfsG7Kq/pLUDKe0/r/6k5nl+T0L9VY9LHc
         UeGyRrDWobnZWk772raunkKmfuhcIGE0AxgzD2dJP6FhRnJ6GuSMv1pGLWkfMZYMy/H7
         gmrvOpgA6virUieOFyZq+NtEsOHCSy5RIthtjfuhEqqcQlUNlp9uRgEqZLrPsIhnF0aQ
         WJMee5yNIYIexo27dVyCe79v5SIirCLDi2mjXncXVZHBNrqfrRQMzDiU7PJstoHNi4E7
         tOpDpcnmFi1b1YL1x447NeM2Eg6QcyQkSmKwLZOWmD/c9Ef4G0j+UosEKCForP5i5Tfl
         +fug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1JDSmw4J3XoscIws3mjSmVtK+pmmPNy7/Yi1UQKGYyc=;
        b=UHC+7r/tVMnU2bCSoVjkNQPD8htHZLJv5NgenJlwrRPslDuG5hGWhQ8tBJllAq90JP
         x2tg9dgHX3i2Fyc091QJDudWlO8S1uBznpDa1hQhRDM7hWRchDV3UXX4z/lDRAasK1G1
         jECDGd+dRBIqpPSm3wcVdmETKimVas+YC3sfEVxlnEqb3p4fWfXwWCs97xfpLKa5wsi8
         Ow9/U4/4lImng6fWyXinSn19SWOKW7pXRcbqfx5AZBUy0YL+Xtnrsyc3x9jBHZ/BWkNt
         Nxpewsq0LmaA+D83kgkeH2vwK7yOpG8m1mg3GathPYdOEobRGk6JL3tL31czyy9n8oxV
         ep2Q==
X-Gm-Message-State: APjAAAUu/RSrtjyS2nBsWuC2e1U0IfIVtKtP7WlZFUey5tcd+xUcgDaD
        lMnAWIqG83tOOylm8k9wdDQWesjAAMNL00v8VCo=
X-Google-Smtp-Source: APXvYqzQBpwMNIT2dG22laDowix/1mJWw64mvlIHL9mvLhX8iaqPbYdgarAGvzKHfXWihZYw3Fy20QQ5B1mKqGkyQ3M=
X-Received: by 2002:a02:1c41:: with SMTP id c62mr12041847jac.132.1572206367691;
 Sun, 27 Oct 2019 12:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com> <1571259116-102015-7-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1571259116-102015-7-git-send-email-longli@linuxonhyperv.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 27 Oct 2019 14:59:16 -0500
Message-ID: <CAH2r5mto-Jbp1_yoLsFuiCWiFd-HA8TFVFB91CjDaBABq9PiuQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] cifs: smbd: Only queue work for error recovery on
 memory registration
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, longli@linuxonhyperv.com,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I cleaned up minor cosmetic nit spotted by checkpatch

$ scripts/checkpatch.pl
0001-cifs-smbd-Only-queue-work-for-error-recovery-on-memo.patch
WARNING: Possible unwrapped commit description (prefer a maximum 75
chars per line)
#7:
It's not necessary to queue invalidated memory registration to work queue, as

WARNING: Block comments use a trailing */ on a separate line
#58: FILE: fs/cifs/smbdirect.c:2614:
+ * current I/O */

total: 0 errors, 2 warnings, 38 lines checked

On Wed, Oct 16, 2019 at 4:11 PM longli--- via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> It's not necessary to queue invalidated memory registration to work queue, as
> all we need to do is to unmap the SG and make it usable again. This can save
> CPU cycles in normal data paths as memory registration errors are rare and
> normally only happens during reconnection.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/cifs/smbdirect.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index cf001f10d555..c00629a41d81 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -2269,12 +2269,7 @@ static void smbd_mr_recovery_work(struct work_struct *work)
>         int rc;
>
>         list_for_each_entry(smbdirect_mr, &info->mr_list, list) {
> -               if (smbdirect_mr->state == MR_INVALIDATED)
> -                       ib_dma_unmap_sg(
> -                               info->id->device, smbdirect_mr->sgl,
> -                               smbdirect_mr->sgl_count,
> -                               smbdirect_mr->dir);
> -               else if (smbdirect_mr->state == MR_ERROR) {
> +               if (smbdirect_mr->state == MR_ERROR) {
>
>                         /* recover this MR entry */
>                         rc = ib_dereg_mr(smbdirect_mr->mr);
> @@ -2602,11 +2597,20 @@ int smbd_deregister_mr(struct smbd_mr *smbdirect_mr)
>                  */
>                 smbdirect_mr->state = MR_INVALIDATED;
>
> -       /*
> -        * Schedule the work to do MR recovery for future I/Os
> -        * MR recovery is slow and we don't want it to block the current I/O
> -        */
> -       queue_work(info->workqueue, &info->mr_recovery_work);
> +       if (smbdirect_mr->state == MR_INVALIDATED) {
> +               ib_dma_unmap_sg(
> +                       info->id->device, smbdirect_mr->sgl,
> +                       smbdirect_mr->sgl_count,
> +                       smbdirect_mr->dir);
> +               smbdirect_mr->state = MR_READY;
> +               if (atomic_inc_return(&info->mr_ready_count) == 1)
> +                       wake_up_interruptible(&info->wait_mr);
> +       } else
> +               /*
> +                * Schedule the work to do MR recovery for future I/Os
> +                * MR recovery is slow and we don't want it to block the
> +                * current I/O */
> +               queue_work(info->workqueue, &info->mr_recovery_work);
>
>  done:
>         if (atomic_dec_and_test(&info->mr_used_count))
> --
> 2.17.1
>
>


-- 
Thanks,

Steve
