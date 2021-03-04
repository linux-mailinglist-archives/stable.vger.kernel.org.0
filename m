Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034AC32D363
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 13:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhCDMil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 07:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241046AbhCDMi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 07:38:26 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5515C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 04:37:45 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id l192so14476419vsd.5
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 04:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j8UaE9csxwrHB+GKIj9/WjJw8ugPbi9uDRrPYm3++N4=;
        b=VCeRywpRl9tthKy/YkqPn830EDBnJC9oKrV74b7ty4YGvaW1GCRK46/SMFmPOVOrHl
         7srY5qdFvGd8rC717zUCHbh8BVf50YSyBvSbvz1jNunMeatfGNvLTsea9IJXbXW4RTgI
         M5/aaz3+f+4SQ/ZLYAoUOotIQudlbpttEozeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j8UaE9csxwrHB+GKIj9/WjJw8ugPbi9uDRrPYm3++N4=;
        b=J0zE9AKYBlvLnXBUV9ZOkUMajjdf4Ttk9mOF2lAwiO/V0K/yPydJH4z70Gv1HFw/M+
         Ti8Id8Vfhpyu3OMSi8soRoEYeeHvPvsb8MGmNzQLEUP+55sdnv1/o6gHXzEpBTGRToMN
         60/NXmeF1baTbHSqR+onPPffyJAHrU3WefeiBPy0Z2APKxwdKcpuuAc+nGsvrtcb7btZ
         h0EGJVevFXYWJCykRIsJldhVmHnCU1OVqGGZozWCWCScG+hGSW35JGuQWu/Gtk9voice
         SaGRSmR5+Vtc7nQNKCfoFd87pUukeoZexNhS68eqiiIS4j/RHgvB7RRzvony7tRv0/dq
         nqFA==
X-Gm-Message-State: AOAM5335y5MNZDKZYfPB73wN1XLr0ILkmqsBXl+TsuMgfumX8f44sn7t
        jnRNcII8ZBOR/4vKc4i94WiUpCVgGFnlIRnUfARFag==
X-Google-Smtp-Source: ABdhPJzt3IbiwcOcZzChDNLGDZsDtMGvPNVxRuD3h93EJEoWW2BbIuBHe7pv2bYK7bCXN3TDqdBLB0haa+fISDzjxUE=
X-Received: by 2002:a67:c992:: with SMTP id y18mr2211514vsk.7.1614861464960;
 Thu, 04 Mar 2021 04:37:44 -0800 (PST)
MIME-Version: 1.0
References: <20210304090912.3936334-1-amir73il@gmail.com>
In-Reply-To: <20210304090912.3936334-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 4 Mar 2021 13:37:34 +0100
Message-ID: <CAJfpegu9E0qHyNuYnQncWowYjpB+W3ktmTr0_PT=AHVwKE1Dig@mail.gmail.com>
Subject: Re: [PATCH] fuse: fix live lock in fuse_iget()
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 4, 2021 at 10:09 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Commit 5d069dbe8aaf ("fuse: fix bad inode") replaced make_bad_inode()
> in fuse_iget() with a private implementation fuse_make_bad().
>
> The private implementation fails to remove the bad inode from inode
> cache, so the retry loop with iget5_locked() finds the same bad inode
> and marks it bad forever.

Thanks, applied.

Miklos
