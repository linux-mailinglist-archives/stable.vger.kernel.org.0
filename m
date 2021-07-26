Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD1F3D65A8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 19:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240698AbhGZQo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 12:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235904AbhGZQor (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 12:44:47 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BD7C061798
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 10:08:28 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id s48so7423609ybi.7
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 10:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TPP4WeVTPReKGm8FyUyDCeHx5Kvp57KdUvp1dPsPnoA=;
        b=p95Zaoo5vuoVqDLGkrElXhsAJbf6jJdQYpp7M0HSbUbIZW/XF9Jzuwi4xRzJhn9a/w
         3Ar8j4SIVTR6BMIRteZ9Ggw/hRDcXalyopEVjbfWyIrURO80WaVGoVSY1sOzI6svn31P
         qSq4OAuKMwmn/6nW+St4AK3LtejqayAq9aDYvPCJABLMwvzR88nYgtGuznepzW65rkhK
         KB6KTIvbrpYNKAo8+usB/Jl/LQIh+tb3mSIrfr3viXn5+vAKQNlO2VIrfsJ2dZJRXTOU
         EX5mZlDJFcXRh5q+dw+Jfh3BIi83ZoaZmTucUTa7YjrEiXF7K+HLQ3dffoeoX8DPZx9U
         rJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TPP4WeVTPReKGm8FyUyDCeHx5Kvp57KdUvp1dPsPnoA=;
        b=JXEK5+VNJmMrw2XeS+S8ZQzzzf7yqHlxldD4yoKC3Kb70HnLxuszIq1ogdAICTpnnv
         Gm5NN0lDcUz+U7Zs+rL9kvddhF+82gXe9cKASSGJZc7ROj46rupMhP0RDbo9PewtRwAa
         dvjYG9UvnzGW9/uVL8n5JDl2ELGxhPL2pd1lIF076keKKQB1Cfyh4kioKpveputclR8w
         qYerXj2w8WRrrTOGAl9Ir7GFCDleMYiUS8eYlgcukkZS+/GZuIjEWfu2n9hnHLakrSw6
         SiNMBZdWkQapW283R3+p/OSrHm5RIU4DNsA6iW/7OLZSjPGyLvQefhRDz7RPXgQDW0Ic
         IBnw==
X-Gm-Message-State: AOAM5318jA+F/U8wsWYcgaeLoaz14J0xRtp+4YJgLs5APY26iTPP0eJA
        RtkEPmGjovjNEkzO25PRh+TLNfKk5m0HaCTujTA=
X-Google-Smtp-Source: ABdhPJwhAqj6ef+HKfPlM2SOu76Od0MgdByBYSTuqn4cA9DEP9zP+KGJYrwwQPMeA8i59HV/29aPpYi/JAuGBHWzEeM=
X-Received: by 2002:a05:6902:1109:: with SMTP id o9mr27313692ybu.448.1627319308158;
 Mon, 26 Jul 2021 10:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <caf9dc2dc29367bb38fee4064b7d562d9837e441.1627312513.git.asml.silence@gmail.com>
 <6564af0e-72b0-5308-4561-706ec4026385@gmail.com>
In-Reply-To: <6564af0e-72b0-5308-4561-706ec4026385@gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 26 Jul 2021 18:07:52 +0100
Message-ID: <CADVatmOa91JbMME8XpiN5ChFM_qUm5gNzPFfLaNxW4R1UZD1Sg@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix link timeout refs
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Stable <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 4:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 7/26/21 4:17 PM, Pavel Begunkov wrote:
> > [ Upstream commit a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 ]
>
> Looking at it, it just reverts the backported patch,
> i.e. 0b2a990e5d2f76d020cb840c456e6ec5f0c27530.
> Wasn't needed in 5.10 in the first place.
>
> Sudip, would be great if you can try it out

Applied on top of v5.10.54-rc2 and tested, issue not reproduced. Thanks Pavel.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


-- 
Regards
Sudip
