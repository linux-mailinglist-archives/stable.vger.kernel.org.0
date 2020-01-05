Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7800E1309A2
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 20:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgAETgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 14:36:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59476 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726092AbgAETgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 14:36:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578252960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p5vCJL6aL9jwnv5SBFBs9IIkdRwMfIy4H5GAApYwEkI=;
        b=hYmefbIXOGLP9M5B/Wlo2LLO08Y0nKTFKieW0Nugk2uuFg4cAWDfVgH9XeQIOi8/Tha1bo
        pRfqBg4T/CA2Xd4+K92RP3lrIHZrfpvHKk502T6dfw0hTbjpZaBzZ0O+UfXEh44Z6CjBLM
        Owhy8CHO7kX5nMRts0N+Cso8eWKmaXY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-sP97CD3oPQywAtg-zRWmxQ-1; Sun, 05 Jan 2020 14:35:57 -0500
X-MC-Unique: sP97CD3oPQywAtg-zRWmxQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A873010054E3;
        Sun,  5 Jan 2020 19:35:55 +0000 (UTC)
Received: from krava (ovpn-204-44.brq.redhat.com [10.40.204.44])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 279F810840FF;
        Sun,  5 Jan 2020 19:35:52 +0000 (UTC)
Date:   Sun, 5 Jan 2020 20:35:50 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Akemi Yagi <toracat@elrepo.org>
Cc:     Gordan Bobic <gordan@redsleeve.org>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ElRepo <contact@elrepo.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: 4.9.208 regression in perf building
Message-ID: <20200105193550.GA177781@krava>
References: <CAMx4oe38RytiyqWfYb=So8iC6N=8nebqy3DsekiT7A5DGjpe+w@mail.gmail.com>
 <CAMx4oe2JKTsOKg3P324PYRH=0ajOVDaXTLa7p=16Fo9fGiQSpQ@mail.gmail.com>
 <CABA31DrtCwUj-wzPP+dwUP+=jTOHnt8eoS+d+N2yfAn22W19vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABA31DrtCwUj-wzPP+dwUP+=jTOHnt8eoS+d+N2yfAn22W19vA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 05, 2020 at 10:21:25AM -0800, Akemi Yagi wrote:
> Adding Arnaldo and Jiri to the CC list.
>=20
> On Sun, Jan 5, 2020 at 9:01 AM Gordan Bobic <gordan@redsleeve.org> wrot=
e:
> >
> > It looks like 4.9.208 introduces a build regression for perf:
> >
> > make -f /builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_=
64/tools/build/Makefile.build
> > dir=3D. obj=3Dperf
>=20
> >  -c -o builtin-report.o builtin-report.c
> > builtin-report.c: In function =E2=80=98report__setup_sample_type=E2=80=
=99:
> > builtin-report.c:296:6: error: =E2=80=98dwarf_callchain_users=E2=80=99=
 undeclared
> > (first use in this function)
> >   if (dwarf_callchain_users) {
> >       ^
> > builtin-report.c:296:6: note: each undeclared identifier is reported
> > only once for each function it appears in
> > mv: cannot stat =E2=80=98./.builtin-report.o.tmp=E2=80=99: No such fi=
le or directory
> > make[3]: *** [builtin-report.o] Error 1
> > make[2]: *** [perf-in.o] Error 2
> > make[1]: *** [sub-make] Error 2
> > make: *** [all] Error 2
> >
> > 4,9.207 works fine.
>=20
> The regression was caused by the following patch:
>=20
> https://lore.kernel.org/lkml/20191021133834.25998-7-acme@kernel.org/
>=20
> To fix this, 'dwarf_callchain_users' needs to be declared.

hum, I see it's declared in callchain.h which is included in builtin-repo=
rt.c
also I can't see that same stuff like you have on line 296.. what sources=
 are you on?

could you please check with latest Arnaldo's perf/core?
  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git

thanks,
jirka

