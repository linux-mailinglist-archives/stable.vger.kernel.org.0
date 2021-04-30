Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EB1370281
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 22:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhD3U5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 16:57:31 -0400
Received: from mx.cjr.nz ([51.158.111.142]:30690 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231254AbhD3U5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 16:57:30 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 640D77FC03;
        Fri, 30 Apr 2021 20:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1619816200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vBlTc3TkkjhpCS7e/W2WUZyC+UGGeAMft128OcehXiY=;
        b=09wQo376/u1L4aIq4N1rnWXbiHTz3ENgc/kp6ZyrcEzh7M80V3mzKGbK6ZZrUHCVm/NgWv
        C5SwGyjq/J+5EGdZhuhcXaJFRCXCFjRT/G/ncSfroMvLxXbXi/Y3wqbw6wjQrRupLzp0Hd
        k9PTrbnuNWSRBZduzQMqe0fw9EBEAjBfsu0pyomGFKQDsay+uvDq/imgvGpkNQahS2slab
        7KT9hZjvemxdYfy4eTMMCcstjBP5Wd7NOIpZiaUS1K+f3OHnAa8xMyPW8cZ/zficDKWx8G
        D46Rv+Wn4eMKm6QrR86Vq+idX04ZYKjmPSp7Rb+To4UGh8f8/cCnH2J2WCp2bA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     ddiss@suse.de, aaptel@suse.com, stable@vger.kernel.org
Subject: Re: [PATCH] cifs: fix automount regression of dfs links
In-Reply-To: <20210430180843.16920-1-pc@cjr.nz>
References: <20210430180843.16920-1-pc@cjr.nz>
Date:   Fri, 30 Apr 2021 17:56:35 -0300
Message-ID: <8735v7qynw.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paulo Alcantara <pc@cjr.nz> writes:

> Unfortunately we can't kfree() the UNC and prefix paths in
> cifs_smb3_do_mount() because they could have come from a chased DFS
> referral (automount) and we rely on the new values set in cifs_sb->ctx
> prior to calling cifs_mount().
>
> Instead, fix smb3_parse_devname() to not leak the UNC and prefix paths
> when parsing new share paths.
>
> Cc: <stable@vger.kernel.org> # v5.11+
> Fixes: 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsfs.c     |  6 ------
>  fs/cifs/connect.c    | 10 +++++++---
>  fs/cifs/fs_context.c |  2 ++
>  3 files changed, 9 insertions(+), 9 deletions(-)

Please ignore this patch.  The commit msg is also misleading.

I'll post another one soon.
