Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF541553C
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 23:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEFVH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 17:07:29 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38662 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfEFVH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 17:07:29 -0400
Received: by mail-qk1-f194.google.com with SMTP id a64so3003797qkg.5;
        Mon, 06 May 2019 14:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ndijvnNkt+c4ltTY2hyx/k7eCwa3nQG1K0KFz8eGCo=;
        b=JAHDSRCO6ityOJT6r/V3YG3CEWoALP5vVAl7YUsywrn7yNhxz3yPvabEMNsFojl17Z
         oYHQxvRY/w+V+OWH0hXUXcjrd+xNQvMif+q9dp/4rml5lzR9CwvnrhlecvAfqBp8HLpu
         RT7rQIf54ftUCcF41NCXUe+bKM4rpU3c+WV1vUAeSdwnsdh8NVLhrox1T1zRLujcsEiC
         zkqh1aBtlHmwR8/DMXYtU1SPEQP0kPvfNB2KPMT/NGsDh1exofQ+Wd9pYUaUn9CadJVe
         36k7EGEE6XE3w9OSafxCIqgo0zZLLl3zxS0gYAoqA2/ClGduUhcn3ep4GcZnaH2nk4Js
         LZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ndijvnNkt+c4ltTY2hyx/k7eCwa3nQG1K0KFz8eGCo=;
        b=UdF0Ujcf7AZB/UEtTdwgLD9qcBjzRvdA4XgR+sfRYkAChpdUz2eu0LVIq6RbMM9ngS
         z+NrDudHTv1zRYX9gOiJCqQ8+G1HmykAX5ypQX1Nv31sR94cPn2rUzkCcWC883+OPzLK
         zUFLKEUyAGhwlf7FI4M6YqWBXDOGIDYc/pSy+dQarzj2vU3W3lpo/KgcgjGiWS5V5wvb
         pPSdwIKaj5i+dCoudFVeGJr6STIzXv1BTvnieZ3PVOI/+UD5baYvJ+7bLyq+ZXOekSOQ
         l+nF9UjH1mBDCHG6Je4znSyDZKUZYtO/U1lNwleVKOtMruPRx8WEtkPHtJpgvSUpxMy9
         k8Fw==
X-Gm-Message-State: APjAAAWWPKhKKio8LgqjQ6k98neokg0gAiuF0R7UcOWjSdmLgiaAqIr8
        Y4I6DA8jg+5SP05Dn/kjuvwHXJZQg+Kx4TBkgbs=
X-Google-Smtp-Source: APXvYqy0cewLmOJ/voV9XvczblnnlIzNNvgjOehbgCWnmm79W69Rbb0K6eoBkS/uoxVXEVkLB/YMPNpGYFmWMBlj73o=
X-Received: by 2002:a05:620a:1423:: with SMTP id k3mr20774846qkj.120.1557176847994;
 Mon, 06 May 2019 14:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com> <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
In-Reply-To: <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 6 May 2019 17:07:16 -0400
Message-ID: <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>, kernel@gpiccoli.net,
        Ming Lei <ming.lei@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 6, 2019 at 2:48 PM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
> On 06/05/2019 13:50, Song Liu wrote:
> > [...]
> > IIUC, we need this for all raid types. Is it possible to fix that in md.c so
> > all types get the fix?
> >
> > Thanks,
> > Song
> >
>
> Hi Song, thanks again for reviewing my code and provide input, much
> appreciated!
>
> I understand this could in theory affects all the RAID levels, but in
> practice I don't think it'll happen. RAID0 is the only "blind" mode of
> RAID, in the sense it's the only one that doesn't care at all with
> failures. In fact, this was the origin of my other thread [0], regarding
> the change of raid0's behavior in error cases..because it currently does
> not care with members being removed and rely only in filesystem failures
> (after submitting many BIOs to the removed device).
>
> That said, in this change I've only took care of raid0, since in my
> understanding the other levels won't submit BIOs to dead devices; we can
> experiment that to see if it's true.

Could you please run a quick test with raid5? I am wondering whether
some race condition could get us into similar crash. If we cannot easily
trigger the bug, we can process with this version.

Thanks,
Song

>
> But I'd be happy to change all other levels also if you think it's
> appropriate (or a simple generic change to md.c if it is enough). Do you
> think we could go ahead with this change, and further improve that (to
> cover all raid cases if necessary)?
>
> Cheers,
>
>
> Guilherme
>
>
>
> [0] https://marc.info/?l=linux-raid&m=155562509905735
