Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7582C18FD78
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 20:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbgCWTSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 15:18:31 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35043 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbgCWTSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 15:18:31 -0400
Received: by mail-oi1-f193.google.com with SMTP id k8so16018757oik.2
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 12:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SZKG7fTNBsJ3BzEdzcdQdFxvXUKeTmJw8ex6iL6EOq4=;
        b=qREfsk+dXDKglyer4a2qeACjwrid7zU0l/gOaRByTH9Ll2wZjiqzwJ6cbpU5YIjJt/
         TD3Na1To9Dp/0jC9Nwn1Z36a41fldefYxufKaHR5nj+haoYtUv/oTgk6/FXVTEF8SSQH
         xlcCupPEeBXWhFTEUDFdXuU1yHTnF3y4mOvUTnYzGp1A99sbPLA8b6lCLmIrV1fxCTWg
         9uOBIHhMe0B0DIJ7AMYdxhnmOrNcIiBk9iTQVgXpNhohhg1nxXrKKoID9jHaM2g9v0/R
         JUdKFHBPydw5lYwSIparAdsWVMpNSPx65T/dtks/uSBjLqIwV5Xc6L6a72AvpbKr92Sb
         gsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SZKG7fTNBsJ3BzEdzcdQdFxvXUKeTmJw8ex6iL6EOq4=;
        b=jc+y5fDed/DdpDdmNkDbuo4pLNd1QQR2wrDN5TnRTu7B13+B04oGOEExuBgETo4MgE
         6kgHtEB0COWCjcbytBEIeDuplenGyETKwcc1MEtNSnKn0CJnKvLgvIobW7yA48dNHEx2
         7v3owfAsXwb9/OtpkZl9Gnz6ZQdg6zfmTmpqaN2zXyq0JoRux/B5KuiRiIFliUfMrCVE
         Le5PUPC4Ynm1STmaoeWqDfK+4doZwPVjItDi4FY8oXr6SOSZhAcibvQWWCir9DeoiJI0
         TmYm/Gl7CcOldL8wxhexLYvaiCOaZMc9m8vY/0yTFUp2qAv+Xymt3uO82sj246r8HVWR
         9HOw==
X-Gm-Message-State: ANhLgQ31LqCoEHnpZa/8YJ/Z6BN/dO97Mka6ITml5Tb0MH/QPjVPJeuP
        ryxV6yPdoSx0IxkotLJMy80LXQsLOYwoyhExnwyQzg==
X-Google-Smtp-Source: ADFU+vvtp101BmSbeYLakx7Wvp+wzVb723oqWR/Id6j79lBhJDMmBLI8QD1mYj4E7HSrHOtRmJDVPLQ/QzaoSrn5hUI=
X-Received: by 2002:a05:6808:8db:: with SMTP id k27mr675696oij.175.1584991110176;
 Mon, 23 Mar 2020 12:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200318205337.16279-1-sashal@kernel.org> <20200318205337.16279-30-sashal@kernel.org>
In-Reply-To: <20200318205337.16279-30-sashal@kernel.org>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 23 Mar 2020 20:18:04 +0100
Message-ID: <CAG48ez1pzF76DpPWoAwDkXLJ01w8Swe=obBrNoBWr=iGTbH7-g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 30/73] futex: Fix inode life-time issue
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 9:54 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Peter Zijlstra <peterz@infradead.org>
>
> [ Upstream commit 8019ad13ef7f64be44d4f892af9c840179009254 ]
>
> As reported by Jann, ihold() does not in fact guarantee inode
> persistence. And instead of making it so, replace the usage of inode
> pointers with a per boot, machine wide, unique inode identifier.
>
> This sequence number is global, but shared (file backed) futexes are
> rare enough that this should not become a performance issue.

Please also take this patch, together with
8d67743653dce5a0e7aa500fcccb237cde7ad88e "futex: Unbreak futex
hashing", into the older stable branches. This has to go all the way
back; as far as I can tell, the bug already existed at the beginning
of git history.
