Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69F121F4AE
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgGNOlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbgGNOk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 10:40:26 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742AEC061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 07:40:26 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id by13so17403542edb.11
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 07:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z7A9vQIVLwY0tZtoyisUsydZRRwbT0bClzByRGulRPs=;
        b=eOru8yDOkF2g1HiS7lSTVJrIirGDUi7d1x52eo9YMeKyLSQmCESff9cYKevP1dQmHr
         FUMk4Lo0fJ+bIMgWDmqveVKA3vk6A/Cwk9bsWEuoj3dPj2x8HAQAeos+OUdCykwYaXe4
         uWaCHPz+77JVDRNxNYqvnGZAtHXNYg3L26hjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z7A9vQIVLwY0tZtoyisUsydZRRwbT0bClzByRGulRPs=;
        b=l+5woeKYZh7D3Up3JuBvzFob2MQXcJGd4jSHHqyXrMkWp95eP5JFYXG8saepkQik+N
         bBlhOoSsFoqMS312lRK7GRhl5uSSC1EIPzQMEVwDfg02geqcxMnbtKG/UwnUZgJ+EJ0r
         UnV5UmYOE6vGUvcJRYBTmCQf/oH3kULyc4nfIfHA46MB9c3O5H2uuu+AlyKWGCSr6Qk2
         gnX5bPltdc57opiEmFPYrSgEtFDvJ837iQAzWmiYhNtrJ+Up+WCtHAY0SWUaDsJmlbxz
         7sFbId1+t9Har1yoq3PFgfP9fWLLt3lO5GcNnUNd7mMeTkd699xp1dy9gbCJoAizNoUl
         RRjg==
X-Gm-Message-State: AOAM530UKuNFeo9jb1/LeyMsGer2gHCIJv1zhaauw9LhMa2Fle/GfPEv
        ZbSpmBa1HbYk/Jhsf1iLqrqodPoDnCnfFeD/etZEnQ==
X-Google-Smtp-Source: ABdhPJxRW7ScQPf0l1p8YcA3osL3zkHi4LlZjbYe64NPD2vJ7vja6HREwugMHdPA7USX7mCJCN6/KjvC2ZwMOpWt1T0=
X-Received: by 2002:a05:6402:1687:: with SMTP id a7mr4814114edv.358.1594737625204;
 Tue, 14 Jul 2020 07:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200615155645.32939-1-her0gyugyu@gmail.com> <20200616083043.25801-1-her0gyugyu@gmail.com>
In-Reply-To: <20200616083043.25801-1-her0gyugyu@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 14 Jul 2020 16:40:13 +0200
Message-ID: <CAJfpegteUDwfN0HHNw__5Eua7cJyQTnU9V9Jw9TNQ=VmL9u09g@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: inode reference leak in ovl_is_inuse true case.
To:     youngjun <her0gyugyu@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 10:30 AM youngjun <her0gyugyu@gmail.com> wrote:
>
> When "ovl_is_inuse" true case, trap inode reference not put.
> plus adding the comment explaining sequence of
> ovl_is_inuse after ovl_setup_trap.
>
> Fixes: 0be0bfd2de9d ("ovl: fix regression caused by overlapping layers..")
> Cc: <stable@vger.kernel.org> # v4.19+
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: youngjun <her0gyugyu@gmail.com>

Thanks, applied.

Miklos
