Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570C3130962
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 19:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgAESVh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 5 Jan 2020 13:21:37 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35127 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgAESVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 13:21:37 -0500
Received: by mail-yw1-f67.google.com with SMTP id i190so21004086ywc.2;
        Sun, 05 Jan 2020 10:21:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jNzJ3vYZFDDHXr/kiJxYUtm1zXNuNEkJhwKO6m42Q6s=;
        b=YPlPhytVCs9Ft/5LaBV3aNAetAJSiiyZCbWPVuvdr+SueGolrf4XbcivcT13PpcrLO
         DEgYEwkAmZ7oZkvGwShfhdz5Kohk02Yj4DAquIvu6/dt+tVrUPUtIWcAnWxkDkBIXOZk
         z1RDG4NKpVl0KjEmgoB6RgiyxpBsk51AxPbeOCa0YeH8rjRYiv7s9i/XlTJopcH4xp9s
         Y007i0YF6cEjfmZsTFLkr3Y9q65c5vP7y6m14Nw82bFznYrnTRapjg4tNVhj+cv0mHoX
         mj02ycMpe1VcgWAYtv4/8e9HRRN3iVspKXVRs2FXXOOuAVNljf5DTcs7Vh9WitY6m3G3
         1NOg==
X-Gm-Message-State: APjAAAWt8wPguPRP0Ck6TGvRO5LXkBkE3v+CfQbNmRR+VMTzLSleA+ua
        j5ZzlNiBaQfylOsmgsOhxBiiIqK6iAlLzjCgJoU=
X-Google-Smtp-Source: APXvYqxH6E81jEUbngs/X8LErBL0R80Bko2OwV/g14TkQXsl6AskiJkCagXqI9aFnmfxjhV2K2rsGZj7zbN4V6dajdo=
X-Received: by 2002:a81:bb41:: with SMTP id a1mr71418542ywl.253.1578248495867;
 Sun, 05 Jan 2020 10:21:35 -0800 (PST)
MIME-Version: 1.0
References: <CAMx4oe38RytiyqWfYb=So8iC6N=8nebqy3DsekiT7A5DGjpe+w@mail.gmail.com>
 <CAMx4oe2JKTsOKg3P324PYRH=0ajOVDaXTLa7p=16Fo9fGiQSpQ@mail.gmail.com>
In-Reply-To: <CAMx4oe2JKTsOKg3P324PYRH=0ajOVDaXTLa7p=16Fo9fGiQSpQ@mail.gmail.com>
From:   Akemi Yagi <toracat@elrepo.org>
Date:   Sun, 5 Jan 2020 10:21:25 -0800
Message-ID: <CABA31DrtCwUj-wzPP+dwUP+=jTOHnt8eoS+d+N2yfAn22W19vA@mail.gmail.com>
Subject: Re: 4.9.208 regression in perf building
To:     Gordan Bobic <gordan@redsleeve.org>
Cc:     stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ElRepo <contact@elrepo.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adding Arnaldo and Jiri to the CC list.

On Sun, Jan 5, 2020 at 9:01 AM Gordan Bobic <gordan@redsleeve.org> wrote:
>
> It looks like 4.9.208 introduces a build regression for perf:
>
> make -f /builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/build/Makefile.build
> dir=. obj=perf

>  -c -o builtin-report.o builtin-report.c
> builtin-report.c: In function ‘report__setup_sample_type’:
> builtin-report.c:296:6: error: ‘dwarf_callchain_users’ undeclared
> (first use in this function)
>   if (dwarf_callchain_users) {
>       ^
> builtin-report.c:296:6: note: each undeclared identifier is reported
> only once for each function it appears in
> mv: cannot stat ‘./.builtin-report.o.tmp’: No such file or directory
> make[3]: *** [builtin-report.o] Error 1
> make[2]: *** [perf-in.o] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
>
> 4,9.207 works fine.

The regression was caused by the following patch:

https://lore.kernel.org/lkml/20191021133834.25998-7-acme@kernel.org/

To fix this, 'dwarf_callchain_users' needs to be declared.

Akemi
