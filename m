Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AFE25195
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 16:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfEUOKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 10:10:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43617 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbfEUOKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 10:10:46 -0400
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hT5TY-0000qJ-28
        for stable@vger.kernel.org; Tue, 21 May 2019 14:10:44 +0000
Received: by mail-wr1-f71.google.com with SMTP id s4so944741wrn.1
        for <stable@vger.kernel.org>; Tue, 21 May 2019 07:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3og88PFnyLDuGAX9qCeRLfhcIKeYUgXunXJTzgjv6aI=;
        b=ZjEyreCj8oPN/4cg1hUwcHwXkVlmNaHJ/Vgob5+5Vhe9sH0KFe5e16G2rxTtmMcJQ1
         sa2kwEksF7snIMSd+lxBf12PlGZQv4brrYyIFGaCQMWjKhUmD6lEzx+ixOwsSLrGon0W
         1bGOYMuVbMmCJgzdhMgTkEPkFxAyYiQdACzbBKDomsWYR+AIKu/23IFSnYmywtyYIVZM
         vciuM1Zt/ensZqNcRm6A2megQK5GtF0Iv3lTdBavfXjO6/Y0/6QGLyMeCd40VjseWd3z
         dLT+Us2B2DxYMkPRmWndTA9r7bHBINTt8wbqyLxBbcG9ziWonFhdax68PFMTV2oKxe1s
         ebcA==
X-Gm-Message-State: APjAAAXli1Vr+JmOAZRHK78ndonJ+FFCdDXJ7Wg/6I0oAZkkywe3O+OJ
        zokV/xXHJc1M7zdQSbstf4/L5Zsh8vSUMnfvflzj7AM08gAwxqH5NAuTYoYIEfO8fmFh/dQiOPP
        5my3ibeAX3dmsUP7pPDD8BB8QL4Esc7bHns7hc76nJFA8cRDxvg==
X-Received: by 2002:a7b:cd0e:: with SMTP id f14mr3465104wmj.127.1558447843750;
        Tue, 21 May 2019 07:10:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw8DBZ1IFI4I+4dRGP+NgpwHHDVqa+fRTuAL80nwVbzVmjyDmk52vwMf9qjuQHgGxBE3XVoFFNu9M/75ptmK9U=
X-Received: by 2002:a7b:cd0e:: with SMTP id f14mr3465016wmj.127.1558447842648;
 Tue, 21 May 2019 07:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <20190520220911.25192-2-gpiccoli@canonical.com> <20190521125634.GB16799@infradead.org>
In-Reply-To: <20190521125634.GB16799@infradead.org>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Tue, 21 May 2019 11:10:05 -0300
Message-ID: <CAHD1Q_z23AO+NRid1xYTeke_5GAe6hPianEZKBf5P30FrfZGFg@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 9:56 AM Christoph Hellwig <hch@infradead.org> wrote:
> > [1] https://lore.kernel.org/linux-block/20190515030310.20393-4-ming.lei@redhat.com/
>
> Actually - that series should also fix you problem and avoid the need
> for both patches in this series.  Can you please test it?

Hi Christoph, thanks for looking into this.
You're right, this series fixes both issues. The problem I see though
is that it relies
on legacy IO path removal - for v5.0 and beyond, all fine. But
backporting that to
v4.17-v4.20 stable series will be quite painful.

My fixes are mostly "oneliners". If we could get both approaches upstream,
that'd be perfect!
Cheers,


Guilherme
