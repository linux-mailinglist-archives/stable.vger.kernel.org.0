Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3991200F7
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 10:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfLPJ0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 04:26:04 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45734 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfLPJ0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 04:26:04 -0500
Received: by mail-lj1-f195.google.com with SMTP id d20so5954458ljc.12;
        Mon, 16 Dec 2019 01:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eHc/7A2caZDhQBjoUT0EKqLg4aWV7NiZT6Jvfet3oeo=;
        b=ggFyP2/pULJ/iiAP04glRh9PTS/tfPk5TuxVxeIY1s8n+v8g6S3HBTB4oXpVXJzWeg
         em9brWrXIP95010KBsvsbCVD3ua26Nc0d5PIYe66so5T8ImJJyEQB/Hs0vP8lkarmmbr
         OYGZcSwHPeyBmBFszW8oaglBKVHoY6VXfdrkTEk3YQgKA6n+rgbb48hba3H2pruaW4bL
         1Q/Y0M8zj/n3Xc1ov7izM2OLluU5dALSqMds7HD7l+63hdZUP1RdH8++DG6OPf1Khc+X
         tMTFoZfvFD7zy3lVH2YcYdcAuWq6j+58h3irlufxDRyz3AWfFfmTlsMtPabVSKcn9cH+
         Eo2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eHc/7A2caZDhQBjoUT0EKqLg4aWV7NiZT6Jvfet3oeo=;
        b=OBhPz6SolPQdU/LAD073jl8EHmUvffciQ/vZRbuyf6OZ9KydfWa9JeHtTkFyJLj5fw
         lc5lG2k8qFaRljNYWpv+VRMmKtpVpiZenhQTqG0VE3AxC3bycSQx+Zv8zURZAkBFCWHU
         b8ZubNxathcB8Nc9Mu4lPijih1dvqkclPmPKlIw5nSHVoa0vFicyKudPN47fgaKJ7wGW
         Rd4tY4MSdBEMivBGRws6j3vQg4GHbkkLU5F+XTVC+ixtYkortuKGOO4FDC8evf0zl90Q
         UKkXrw83vBnbZYZhlb/EZqqMM9OTjGF4WYPL6m/mfa9rPToJpzeLBjVP86O5DYdB/RDX
         vpWg==
X-Gm-Message-State: APjAAAU/P/rfqQvoEG6mTWH8KdYSVn2FpTV6sKws6PTecS6gu3cmIN1+
        tBiBcNL9rRkMTfnOsRua0zgwz7IRnxSes852SNQ=
X-Google-Smtp-Source: APXvYqzN4C2wQu8qUMf+pbjDAwUrfVb3mkjJnfsQRGgnyXLnssYlkRAryAusa/rftZit09x9DkmOr9J1hnld0Mawfhw=
X-Received: by 2002:a2e:824a:: with SMTP id j10mr19295811ljh.209.1576488362388;
 Mon, 16 Dec 2019 01:26:02 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <20191127203126.845809286@linuxfoundation.org>
 <aabbc521-b263-2d5f-efc6-72d500ab5c71@tomt.net> <CA+res+RtrAOfiVLeg1QE7V1Xjs6029y3tVmh0vfy+B71_bhsUw@mail.gmail.com>
 <4d8343e0-f38a-3e08-edf6-3346b3011ddf@tomt.net>
In-Reply-To: <4d8343e0-f38a-3e08-edf6-3346b3011ddf@tomt.net>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 16 Dec 2019 10:25:51 +0100
Message-ID: <CA+res+TE8VaDSOfX_wbnW0fxhUmwain83U6pVbT2pFYYuyuQMQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 153/306] block: fix the DISCARD request merge
 (4.19.87+ crash)
To:     Andre Tomt <andre@tomt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andre Tomt <andre@tomt.net> =E4=BA=8E2019=E5=B9=B412=E6=9C=8816=E6=97=A5=E5=
=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8810:18=E5=86=99=E9=81=93=EF=BC=9A
>
> On 16.12.2019 08:42, Jack Wang wrote:
> > Andre Tomt <andre@tomt.net> =E4=BA=8E2019=E5=B9=B412=E6=9C=8814=E6=97=
=A5=E5=91=A8=E5=85=AD =E4=B8=8B=E5=8D=883:24=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> 4.19.87, 4.19.88, 4.19.89 all lock up frequently on some of my systems=
.
> >> The same systems run 5.4.3 fine, so the newer trees are probably OK.
> >> Reverting this commit on top of 4.19.87 makes everything stable.
> >>
> >> To trigger it all I have to do is re-rsyncing a directory tree with so=
me
> >> changed files churn, it will usually crash in 10 to 30 minutes.
> >>
> >> The systems crashing has ext4 filesystem on a two ssd md raid1 mounted
> >> with the mount option discard. If mounting it without discard, the
> >> crashes no longer seem to occur.
> >>
> >> No oops/panic made it to the ipmi console. I suspect the console is ju=
st
> >> misbehaving and it didnt really livelock. At one point one line of the
> >> crash made it to the console (kernel BUG at block/blk-core.c:1776), an=
d
> >> it was enough to pinpoint this commit. Note that the line number might
> >> be off, as I was attempting a bisect at the time.
> >>
> >> This commit also made it to 4.14.x, but I have not tested it.
> > Hi Andre,
> >
> > I noticed one fix is missing for discard merge in 4.19.y
> > 2a5cf35cd6c5 ("block: fix single range discard merge")
> >
> > Can you try if it helps? just "git cherry-pick 2a5cf35cd6c5"
>
> Indeed, adding this commit on top a clean 4.19.89 fixes the issue. So
> far survived about an hour of rsyncing file churn.
>
Glad to hear it!

Greg, Sasha,

Can you apply the fix 2a5cf35cd6c5 ("block: fix single range discard
merge") for 4.19 tree.

Regards,
Jack Wang
