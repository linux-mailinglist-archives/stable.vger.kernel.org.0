Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC9A168C4E
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 05:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgBVEXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 23:23:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37624 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgBVEXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 23:23:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id a6so3959224wme.2
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 20:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dX3cgkRvFAI8AVtMOAUQjcXHfSQoUwJ0PPyH1g7HEjM=;
        b=ZkfmO8pUiOB7YtQvX3N6QzeYxpXdw5QjE5vXdiX2vUbnwm87WPcp89q59HcGKMQuPN
         rlTVRNRcxi4opz7W4nfmZ6+mNqHb8fANckCQDUENQL2yjNyFWIj4BDbuEf24nVhqGWRK
         l5fCjCPi7xgW6tmRBFM6loSdsFicUiz3iuWlou/FGabpmFO4KI2ipVkzQp/Zvx4FpXsU
         Os5cSiR44alyBEUrslVofTO0N4ye/vNcp25RYime7gHMOXL8H76d3qZMdJ8+PkpKHVlZ
         ZATMXu3we8362p6pnQw5uYZAqYuVuhFILnBOlkQ3YarckJ+XY3b06fvOLySTqVMXTk9h
         VoMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dX3cgkRvFAI8AVtMOAUQjcXHfSQoUwJ0PPyH1g7HEjM=;
        b=tNzSwUutM864GEuh3ICFYDbA8tT0TCrlNKwoMzAYFzuls6L+Ue3Q+7nzFKLlZwYmJw
         pUE7VvO+PMFVmTinuR+rGKgWfsL1qMGuUXcsq1wmktmg3tFcbqWLhd2xbP6d3TZmFvEJ
         vncadgZaCWYepy019NCTmNmiBEFJ+ZUtxMvOyZ+3wR/czOFZvzBtXhPDomWnxztdtzCr
         rhPlG8i5rM7j8L921hYyUENgGdA6lbxxsvP0WnqMUMPr7rrDHjxT7bims0pwj7oJ0s1j
         XwGDWEx89rVR+zcRAryDr3CP00lmtAxu0oSpHPJwnoYEd9YbdZVGhKvXMB2z/0fSQAwW
         tSEg==
X-Gm-Message-State: APjAAAVk4C3AhGNyy3b0DOkkXrThjSnig064CWrKiIMLkf4wTh8PmQrL
        GFpf2YohGfkDATcknsZBhof7iA8CrIPBEJMvNgc=
X-Google-Smtp-Source: APXvYqyTrLqkRAbB96a9YDdcxoi5qOt9c1k7359ODlgvtRpDbIau+jhm/oCqZ/S9GKZQACtqZhS/QxMZG/xgpgLX18k=
X-Received: by 2002:a05:600c:3d1:: with SMTP id z17mr7942849wmd.90.1582345384179;
 Fri, 21 Feb 2020 20:23:04 -0800 (PST)
MIME-Version: 1.0
References: <1581992882-22134-1-git-send-email-pkushwaha@marvell.com> <20200218044136.GB2046752@kroah.com>
In-Reply-To: <20200218044136.GB2046752@kroah.com>
From:   Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
Date:   Sat, 22 Feb 2020 09:52:27 +0530
Message-ID: <CAJ2QiJLOqAFGN9UPWb0jGBE8mRvTsY3RufTt3fu2H_au6iA77A@mail.gmail.com>
Subject: Re: [RESEND][PATCH] ata: ahci: Add shutdown to freeze hardware
 resources of ahci
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Prabhakar Kushwaha <pkushwaha@marvell.com>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Ganapatrao Prabhakerrao Kulkarni <gkulkarni@marvell.com>,
        Kamlakant Patel <kamlakantp@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 10:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Feb 17, 2020 at 06:28:02PM -0800, Prabhakar Kushwaha wrote:
> > device_shutdown() called from reboot or power_shutdown expect
> > all devices to be shutdown. Same is true for even ahci pci driver.
> > As no ahci shutdown function is implemented, the ata subsystem
> > always remains alive with DMA & interrupt support. File system
> > related calls should not be honored after device_shutdown().
> >
> > So defining ahci pci driver shutdown to freeze hardware (mask
> > interrupt, stop DMA engine and free DMA resources).
> >
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > ---
> >
> > This problem has also been seen on older kernel. So sending to stable@vger.kernel.org
> > Note: It is already applied to git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > with commit id: 10a663a1b151 ("ata: ahci: Add shutdown to freeze hardware resources of ahci")
>
> So what kernel(s) do you wish to have this commit backported to?
>

Sorry for the late reply.  This patch should be back-ported to
following kernels versions
4.9, 4.14, 4.19, 5.4 and 5.5

--pk
