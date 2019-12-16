Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7418311FF0C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 08:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfLPHmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 02:42:18 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38645 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfLPHmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 02:42:18 -0500
Received: by mail-lf1-f66.google.com with SMTP id r14so3477198lfm.5;
        Sun, 15 Dec 2019 23:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3egxwMwga6UFYch5YI3LoO9s5j8RKuYvIFyVqKjFbHc=;
        b=XcIaOuKgzAK4T54SciiXzu3n3no0IapLoDyrwwlXiUnYhWu2AgbaDqWbvPpt4ULqJf
         dDaAcFqii/Dt1Uu7K8qfMI+aEOPUfw2sMsDayaKgb23VSK+HMN//+YVVDNWmPpY6ux0c
         Na7QbXwsa/mOsZRRD0Qcr+o5rQs0COvCVEJZUCxYu0ydYEAgkqR32O2wd4Mbs3Xj9xPr
         sd/68lRPKNfU2rjCPPcHr5xyXKDUC6OOUQjh8gfMJyZbdTTVRi812+U+rW6zVwmmsQ+N
         JPmzTdaeZ+TGE4RkRf4VCD7+sNogbmBLbD+eca1uoH//kiBWzBtmoEUn0R9HEyhYbCXc
         WTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3egxwMwga6UFYch5YI3LoO9s5j8RKuYvIFyVqKjFbHc=;
        b=gCJBQ5eeT9c0XTirX+urun8mric2niUDMWpf7DgqQR3hmNdMwTL6eFCzW40aCcN+r6
         62GNp52l6nHijIq1GPNhze7bg1Db0r6zmx+gQTW0blGYdSHK6q35MB/TosKOUo91/Dbn
         Ke+vrA5tCEeYMrI/UAbSiSplKQpEVmK3aAOX3zi3vuFq6ZSfI+WfTm7DYJqs8CLNxCgG
         p7mZdJvthv95etSV8DVS1DZrJEVysP3LKk5xwaGuyD1Xx7jjjYbdQR+PFCpRnmXP7LUA
         uqvQ9DCJnaGj19wKiy4C3VUyYHGYNcvjvB06mQzVPvIr1hW4q4VrNZG5e6Ad1tR/0ITd
         JBbA==
X-Gm-Message-State: APjAAAUdLvyzhoRHoXKf4mzyEfZFscC6RC2BK09UCVG/rZCNXlCgxM2p
        feVELn2QPrSIEOdMerZqbsBwX+Izva/i3KqI9VU=
X-Google-Smtp-Source: APXvYqx1Tn8HoNK4r9jpk8El0bbPjrMeB0Np1KRGCyC4ji0R2JH+cMcTIvAF2N38OAUnOQb2KXoiBUPjNf8CkLefPlM=
X-Received: by 2002:ac2:4422:: with SMTP id w2mr15976292lfl.178.1576482136228;
 Sun, 15 Dec 2019 23:42:16 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <20191127203126.845809286@linuxfoundation.org>
 <aabbc521-b263-2d5f-efc6-72d500ab5c71@tomt.net>
In-Reply-To: <aabbc521-b263-2d5f-efc6-72d500ab5c71@tomt.net>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 16 Dec 2019 08:42:05 +0100
Message-ID: <CA+res+RtrAOfiVLeg1QE7V1Xjs6029y3tVmh0vfy+B71_bhsUw@mail.gmail.com>
Subject: Re: [PATCH 4.19 153/306] block: fix the DISCARD request merge
 (4.19.87+ crash)
To:     Andre Tomt <andre@tomt.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andre Tomt <andre@tomt.net> =E4=BA=8E2019=E5=B9=B412=E6=9C=8814=E6=97=A5=E5=
=91=A8=E5=85=AD =E4=B8=8B=E5=8D=883:24=E5=86=99=E9=81=93=EF=BC=9A
>
> On 27.11.2019 21:30, Greg Kroah-Hartman wrote:
> > From: Jianchao Wang <jianchao.w.wang@oracle.com>
> >
> > [ Upstream commit 69840466086d2248898020a08dda52732686c4e6 ]
> >
> > There are two cases when handle DISCARD merge.
> > If max_discard_segments =3D=3D 1, the bios/requests need to be contiguo=
us
> > to merge. If max_discard_segments > 1, it takes every bio as a range
> > and different range needn't to be contiguous.
> >
> > But now, attempt_merge screws this up. It always consider contiguity
> > for DISCARD for the case max_discard_segments > 1 and cannot merge
> > contiguous DISCARD for the case max_discard_segments =3D=3D 1, because
> > rq_attempt_discard_merge always returns false in this case.
> > This patch fixes both of the two cases above.
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Ming Lei <ming.lei@redhat.com>
> > Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> 4.19.87, 4.19.88, 4.19.89 all lock up frequently on some of my systems.
> The same systems run 5.4.3 fine, so the newer trees are probably OK.
> Reverting this commit on top of 4.19.87 makes everything stable.
>
> To trigger it all I have to do is re-rsyncing a directory tree with some
> changed files churn, it will usually crash in 10 to 30 minutes.
>
> The systems crashing has ext4 filesystem on a two ssd md raid1 mounted
> with the mount option discard. If mounting it without discard, the
> crashes no longer seem to occur.
>
> No oops/panic made it to the ipmi console. I suspect the console is just
> misbehaving and it didnt really livelock. At one point one line of the
> crash made it to the console (kernel BUG at block/blk-core.c:1776), and
> it was enough to pinpoint this commit. Note that the line number might
> be off, as I was attempting a bisect at the time.
>
> This commit also made it to 4.14.x, but I have not tested it.
Hi Andre,

I noticed one fix is missing for discard merge in 4.19.y
2a5cf35cd6c5 ("block: fix single range discard merge")

Can you try if it helps? just "git cherry-pick 2a5cf35cd6c5"

Thanks
Jack Wang
