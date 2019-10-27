Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F37E6532
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 21:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfJ0UCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 16:02:45 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:42986 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfJ0UCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 16:02:45 -0400
Received: by mail-il1-f195.google.com with SMTP id o16so6193911ilq.9;
        Sun, 27 Oct 2019 13:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mL2/uY8sNZ32Rr7//p8MD1BFGfeEFAqFolzQ51gp8xY=;
        b=EN/R/SDwszFb6hccaqaQb7G4qhXpmMD5YOUtOkQ7NjDj6vdMM+09pkphi9tg4T863/
         JpKIGi81NeF8cO7oIlwng3w2FgUOrG4jy1q/DgK+ziMzA3kE0PM/UQ2nCGxAaiVpaljo
         RBqEg8bcjeAvsHvTdcxaaiAsAjsFgc3YX04mbwjFpeGZ9IV9Atu9gQX743phd6wMfvOb
         36V/GLbH2F+9NgJ9Qfq93P1LnrU7CE2vDTBni0gOVNO480ag3wk+TxYUKxGNbBn8nEbi
         RbaVkF/7eJCOsX5U2QKc7W0aAhdBOBNGVAh84v1a7ecOhKb/OUf1zNF9wOwrScdhhpMP
         DXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mL2/uY8sNZ32Rr7//p8MD1BFGfeEFAqFolzQ51gp8xY=;
        b=UJK1Mr8+MR7qcKfHQXQ1MbHDhNhFY2MNY5EFNNuaZMFojGmen7E8jx2mbWSxIMcDFq
         eO3K6X0/+Qx5TzfXiarnDg+wxf6q+aii3oKhKVXvqu4b0zCyhEqC9VAtMzk9jz7r3qzp
         hLsAJQt7DFSsDdtwpIey+JoQTmEIrS/J286RC4xXVLY9tRl6ZmoPGud/drBbT4fZQjRS
         AFH/qj2b+OvhFbH37xMDTJz4mje88wAz0PtTqvbBd0AD82gk+F0A2URYYDg9SKJ8coQg
         8Po+mWZnEMXDf6QePkl25ByFmDUgHv+E2OI3viECY+allqkBVeDavOi/YoNmbv4Qw30V
         LFbg==
X-Gm-Message-State: APjAAAVfGTd5V2b83x3KYIqiug9b3Sv40AgWA6iAJfnaCRm3Ue78cmTX
        AoligjGhsHGwSNcwJ4VYqfewJrwPZ2h1bETH8fM=
X-Google-Smtp-Source: APXvYqxNjKxlIi5unG0uD7UP+ivcHGeLfqrhGORTFOvQRmgbmvSnID6uJuhwO+QRbphdQnDOM0AEc6oprVcW+x+HbCg=
X-Received: by 2002:a92:48d8:: with SMTP id j85mr16121970ilg.272.1572206564433;
 Sun, 27 Oct 2019 13:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com> <1571259116-102015-8-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1571259116-102015-8-git-send-email-longli@linuxonhyperv.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 27 Oct 2019 15:02:33 -0500
Message-ID: <CAH2r5mtx9OaQ6tdXPEh5rsB=fVjMfNBFf+xBLdSrjNR9PhMruw@mail.gmail.com>
Subject: Re: [PATCH 7/7] cifs: smbd: Return -EAGAIN when transport is reconnecting
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

Tentatively merged the 7 patch series into cifs-2.6.git for-next
pending more reviews and xfstests regression testing runs

On Wed, Oct 16, 2019 at 4:11 PM longli--- via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> During reconnecting, the transport may have already been destroyed and is in
> the process being reconnected. In this case, return -EAGAIN to not fail and
> to retry this I/O.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/cifs/transport.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index afe66f9cb15e..66fde7bfec4f 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -318,8 +318,11 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>         int val = 1;
>         __be32 rfc1002_marker;
>
> -       if (cifs_rdma_enabled(server) && server->smbd_conn) {
> -               rc = smbd_send(server, num_rqst, rqst);
> +       if (cifs_rdma_enabled(server)) {
> +               /* return -EAGAIN when connecting or reconnecting */
> +               rc = -EAGAIN;
> +               if (server->smbd_conn)
> +                       rc = smbd_send(server, num_rqst, rqst);
>                 goto smbd_done;
>         }
>
> --
> 2.17.1
>
>


-- 
Thanks,

Steve
