Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A3C38922E
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 17:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhESPHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 11:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231128AbhESPHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 11:07:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1895610CD
        for <stable@vger.kernel.org>; Wed, 19 May 2021 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621436784;
        bh=5jEFJ7ggKEicyqCe7rS+Sp+ajcxY/hacncm8PNDuyyU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Sdb5A2st9XCTzYwY46/WjFk5QjpgEsiUMAa1KeQZz3sGYCyqdiJkXQxyCwP+gh+2b
         dCboCISpXpfmjBm4dMbuOUW/7wJl1J4sXlaeRUE34A1tcqDpboq6XyYt/bLUH7XP1m
         qjaBZ88Us+cG1WD8xXXJIyaX6JmIX+eYMT+EQ6CjdZlL0qaR3DtarfmHywEHlDRway
         +iLCmttTJyHy1LKwDm0pJo/BSYiYmeZsrbx9QFpLAt7dnyIkh7gJxJ7XQkTDPHRs7s
         KjryP9lKWco4XbG68MBTDdB18Al8SGXQ4nLOzVH1FlNRz1syBLR8hzNMi8Krrfz3G8
         wAaZ1Tb6oZP6w==
Received: by mail-ot1-f54.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so12005568oth.8
        for <stable@vger.kernel.org>; Wed, 19 May 2021 08:06:24 -0700 (PDT)
X-Gm-Message-State: AOAM532MTG8xQq22JDE/X8t0QNMBIjh2taSgm/RJJYbByCcOpvT4igIR
        RZ6oNz9TAUNFUeI2xLxSDBsntSgYeZPigvsOT5k=
X-Google-Smtp-Source: ABdhPJz7YjwLlgP6XDI/AIAJhBP9bxQFyyxjatMuY+lC1KTHOkBwbOjEn1xXEDHgqxmWuGRturRWH4/HgYsgbs5DAkc=
X-Received: by 2002:a05:6830:4da:: with SMTP id s26mr9240884otd.77.1621436784158;
 Wed, 19 May 2021 08:06:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210519074124.49890-1-ardb@kernel.org> <YKUnOBqGgfHPXX5F@sashalap>
In-Reply-To: <YKUnOBqGgfHPXX5F@sashalap>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 19 May 2021 17:06:12 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG2Wt25Uv_NnrKohuq3cGG3diZp=VmCEyPEj8PVG+trTw@mail.gmail.com>
Message-ID: <CAMj1kXG2Wt25Uv_NnrKohuq3cGG3diZp=VmCEyPEj8PVG+trTw@mail.gmail.com>
Subject: Re: [PATCH stable] dm ioctl: fix out of bounds array access when no devices
To:     Sasha Levin <sashal@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, agk@redhat.com,
        dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 May 2021 at 16:56, Sasha Levin <sashal@kernel.org> wrote:
>
> On Wed, May 19, 2021 at 09:41:24AM +0200, Ard Biesheuvel wrote:
> >From: Mikulas Patocka <mpatocka@redhat.com>
> >
> >commit 4edbe1d7bcffcd6269f3b5eb63f710393ff2ec7a upstream.
> >
> >If there are not any dm devices, we need to zero the "dev" argument in
> >the first structure dm_name_list. However, this can cause out of
> >bounds write, because the "needed" variable is zero and len may be
> >less than eight.
> >
> >Fix this bug by reporting DM_BUFFER_FULL_FLAG if the result buffer is
> >too small to hold the "nl->dev" value.
> >
> >Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >---
> >Please apply to 4.4.y and 4.9.y
>
> We already carry this patch via the backport provided in
> https://lore.kernel.org/stable/20210513094552.266451-1-nobuhiro1.iwamatsu@toshiba.co.jp/
>

Excellent, thanks.
