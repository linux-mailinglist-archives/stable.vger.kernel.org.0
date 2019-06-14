Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29C14532E
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbfFND53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:57:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38109 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfFND53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:57:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id f97so418060plb.5;
        Thu, 13 Jun 2019 20:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iQIVUk3bfsiavLaM5moit5SC5FDbKdgZUvhRhTy634I=;
        b=u8HRlxDQd1/UJ6Vrp9GrE00qHjWwlU44pNZ3PShZPJDybnOlrmiuTG2fjQA3MbXsKg
         SGZNwVb/dCr+nZLojrPx7Q1c4d+iv81rRUnd6TOFV3mvjNFYdoMHCoDBTp7i5/v011QI
         3TUwaTb0gjpIy0N9F6P0JwmYm1w8EzwyWlGS88Scmfb87GLOjOghUBGEudjvxn+mVTmN
         3ipt7xjxaYY2F00v6EJdrryz4loQ1K7HuDQLJLAVNpCc7pA5CmtwT4eUu/BHarHFp1jK
         u297NwjwhvEykgydWiBA2Idd5kjo0kY9nPeHG9ZygJDg5BPOrALxSohbQpwvSj/rk/3/
         U2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iQIVUk3bfsiavLaM5moit5SC5FDbKdgZUvhRhTy634I=;
        b=TD6cNZU79oiUEzc8EcUQzHto0KNmDL9njj0MtdQ2LrN0miqjL7d8UQKnfCvK5/gY2M
         4KldRhga3uny7i+trJcFmrxZADl4EC2K28Jq1ojgsS2WXRzZ2Iy5QPGtZVWyb0IuY8FL
         5/RwwygkKNlkJkh9/MA4WGVw3fwjA954O7mbkNIeUC166uOzT3aTvJTWa/JGuzO9oq06
         fc6uYYg2nbdbMLAwvBTOgamg+rvm8K97VeOVIXGJmOzdUJ8+RUlEc36+ZimC7ZHAfLR8
         cxb+D/GhTPljGlJZzrMdskZ1GrPQ1Rj9McJNMDms4OTHm2ft/QKU8QPikxmrod2yq/1b
         AICg==
X-Gm-Message-State: APjAAAVSnLVsNJAnVhLmadoZTul9X4i9yzx7N/N5v+BdK2pTMD9/bWj+
        npeLsP4OF0RYjyN3fvFzeGuh6I5dvUdMlxDHvUM=
X-Google-Smtp-Source: APXvYqy+PeSDZqlTWDeemOs4xs4sRtcP/b2zMCd9yXRyhS5OuFlF/jqVr54dLK1Nnt05kzmI19GhJPp9EF5jIyp+jbc=
X-Received: by 2002:a17:902:728b:: with SMTP id d11mr61864885pll.78.1560484648000;
 Thu, 13 Jun 2019 20:57:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190614030229.22375-1-lsahlber@redhat.com>
In-Reply-To: <20190614030229.22375-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 13 Jun 2019 22:57:16 -0500
Message-ID: <CAH2r5muLjnEer+6Fn2ikLRF6BuK2F2qCzXTHS5Kakhbk7mS4Lg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix GlobalMid_Lock bug in cifs_reconnect
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tentatively merged into cifs-2.6.git for-next and to the github tree

On Thu, Jun 13, 2019 at 10:02 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> We can not hold the GlobalMid_Lock spinlock during the
> dfs processing in cifs_reconnect since it invokes things that may sleep
> and thus trigger :
>
> BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:23
>
> Thus we need to drop the spinlock during this code block.
>
> RHBZ: 1716743
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8c4121da624e..8dd6637a3cbb 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -476,6 +476,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         spin_lock(&GlobalMid_Lock);
>         server->nr_targets = 1;
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> +       spin_unlock(&GlobalMid_Lock);
>         cifs_sb = find_super_by_tcp(server);
>         if (IS_ERR(cifs_sb)) {
>                 rc = PTR_ERR(cifs_sb);
> @@ -493,6 +494,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         }
>         cifs_dbg(FYI, "%s: will retry %d target(s)\n", __func__,
>                  server->nr_targets);
> +       spin_lock(&GlobalMid_Lock);
>  #endif
>         if (server->tcpStatus == CifsExiting) {
>                 /* the demux thread will exit normally
> --
> 2.13.6
>


-- 
Thanks,

Steve
