Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B754667328
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbjALN2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjALN2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:28:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CADD1869C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673530039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5SwCX7Huvx8oV/VYW9LER1EPQspAcx1PfzypYxIzJto=;
        b=T4czuQ6gvQLZ+C5fy+SDvTWIoi9+NBVqrbnAKKUgDszZIcA6zbvesHiYz3KIxcH5XRtG8d
        HvMBdpk7o4xqeDIDqwZdoM+Tvh99GdxVi7Bh6VBn7rsCqAvU0EXm6EdPUK1UDBPljNLZhI
        GsfmTe3lucumkIdKagD63rEt/aAuxh0=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-Z04FxHyvPly6cn5pg8vhMQ-1; Thu, 12 Jan 2023 08:27:18 -0500
X-MC-Unique: Z04FxHyvPly6cn5pg8vhMQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-4ad7a1bd6f4so195886307b3.21
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:27:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5SwCX7Huvx8oV/VYW9LER1EPQspAcx1PfzypYxIzJto=;
        b=72dOKmCQVANC4FcJVR5g+EmQPlEgZAgIWG1KnEu+CcbdhDh68oojhRYgyJn0DiTYgG
         NhWxB+CyuFjkoETvcL3aeVYO/WV7tjrv8mgiEzfOWt0zSjDmoCtOAzp6quXWOA/TpKrC
         OjZQz6XDErjeY3QRkUclvZUtGVi5vbkVC7LFSfjBn9zeC9gjR6r9U5+LO25QFxDQ+x5B
         yQaa1F0U4Syjs0a0R43opmUPCpgKQYW80EPIcvjA2b0dYKPsJT3PecIukF+ijeFjH8tj
         1Vy6iayyMh4AVxK5h62fTATadTtx7fUOplt++CtlBqhS9Iiv45225ErvF9g7R66HU77/
         Yzew==
X-Gm-Message-State: AFqh2kqdrnRKbPrZ5H4HidtuFI5knbzp3uVEsOL8/2nyru0FIzclEeHt
        qHofoaebg29QilbtIQVf9SnMWBIevYqFXYjq1SA3Rv7bu/hiu+qeqPPCBNL4Y8tp5oFgZdLBQSV
        54B/HbqV5CD6dFT7zJvcPQa6ooSpzoYuE
X-Received: by 2002:a5b:786:0:b0:6ea:e952:4d4a with SMTP id b6-20020a5b0786000000b006eae9524d4amr6296895ybq.120.1673530037566;
        Thu, 12 Jan 2023 05:27:17 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtyOluOky0VeYg6LB6YQwZwMb0OVdTOzhBlpfKzH0UseRfHNA97+68mSuoqnzkDPCWFly5dk2mXj+jGqmluQZU=
X-Received: by 2002:a5b:786:0:b0:6ea:e952:4d4a with SMTP id
 b6-20020a5b0786000000b006eae9524d4amr6296892ybq.120.1673530037385; Thu, 12
 Jan 2023 05:27:17 -0800 (PST)
MIME-Version: 1.0
References: <CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com>
 <Y7/xwk9lmaNwrDwo@kroah.com>
In-Reply-To: <Y7/xwk9lmaNwrDwo@kroah.com>
From:   Paul Holzinger <pholzing@redhat.com>
Date:   Thu, 12 Jan 2023 14:27:06 +0100
Message-ID: <CAFsF8vJ3wS-Yoy9tNZD2ZESevGenvYKqieD4F8+UztRsrJ=png@mail.gmail.com>
Subject: Re: [Regression] 6.0.16-6.0.18 kernel no longer return EADDRINUSE
 from bind
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Nothing particular is keeping me on this kernel, it is currently
shipped in fedora.
I assume fedora will update to 6.1 as usual so updating is not a problem for me.

I wasn't sure how long the 6.0 series gets updates so I decided to
report it here. If it is EOL that is fine for me.

Thanks,
Paul


On Thu, Jan 12, 2023 at 12:50 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jan 11, 2023 at 04:52:21PM +0100, Paul Holzinger wrote:
> > Hi all,
> >
> > Since updating to 6.0.16 the bind() system call no longer fails with
> > EADDRINUSE when the address is already in use.
> > Instead bind() returns 1 in such a case, which is not a valid return
> > value for this system call.
> >
> > It works with the 6.0.15 kernel and earlier, 6.1.4 and 6.2-rc3 also
> > seem to work.
> >
> > Fedora bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2159066
> >
> > To reproduce you can just run `ncat -l 5000` two times, the second one
> > should fail. However it just uses a random port instead.
> >
> > As far as I can tell this problem is caused by
> > https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/
> > which did not backport commit 7a7160edf1bf properly.
> > The line `int ret = -EADDRINUSE, port = snum, l3mdev;` is missing in
> > net/ipv4/inet_connection_sock.c.
> > This is the working 6.1 patch:
> > https://lore.kernel.org/all/20221228144339.969733443@linuxfoundation.org/
>
> As 6.0.y is now end-of-life, is there anything keeping you on that
> kernel tree?  If you send a fix-up patch for this, I'll gladly apply it
> and push out one more 6.0 release with it.
>
> thanks,
> g
> reg k-h
>

