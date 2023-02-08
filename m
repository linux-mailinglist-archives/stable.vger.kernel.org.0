Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233FA68FB6A
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 00:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjBHXpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 18:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjBHXpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 18:45:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6511C7CA;
        Wed,  8 Feb 2023 15:44:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75EC0B81F03;
        Wed,  8 Feb 2023 23:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E726C4339B;
        Wed,  8 Feb 2023 23:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675899889;
        bh=wmdQGi6I1E4TE+uI0vAiKz1QSS8xLr9SPQkt5zLF8Hw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ux/jCOP/36fwAvLodxcYwMlbM9OhO0Bxt2pViZWmsKR7S6gV9Hz5MkVsPwhA6CWXM
         OJIhrg1c5cv39DhnpJyx2/xI7RtYX5v2NILh7MVOlmy6OC3MKzIcGwu/lyopqXsIB+
         89v8E6L57qV/VTB5+JMi6HP+vcd76XNEb6gL51aoNWQ+/nVP49dy7R7iiKoZrAKMBW
         WAprmilomQMz2s/MyqW9k/o+TDJglIAHlROHc23lo0xLgPEC2mk0DUiG+Q+OxqB2ck
         pY9MXAquxDpAg8doqJUXuLfK9bTu9x2xMAw8FtF+wRsJPFJKl99QYRb7xqjTY5J1mF
         xqmQgm2ASj6Bw==
Received: by mail-lj1-f175.google.com with SMTP id b13so210226ljf.8;
        Wed, 08 Feb 2023 15:44:49 -0800 (PST)
X-Gm-Message-State: AO0yUKW5LOEGZHdIHOuqnN21aBDf6krpvu9WvJ+jNjxh5JOSEqTrskOR
        k5+9Ic4yRFNQJ1rOzTiAdz09/XHuz4tBVfjbkIg=
X-Google-Smtp-Source: AK7set+u+WRz5oSbcI+fKd9Termy9/rjPDIxdxZ0DKHyxC3UxdZdfGKfkVey0eGhPYzA2LAkJH2tli3YRA/vNbs5Z+8=
X-Received: by 2002:a2e:b4b2:0:b0:290:66b3:53e5 with SMTP id
 q18-20020a2eb4b2000000b0029066b353e5mr1689358ljm.57.1675899887149; Wed, 08
 Feb 2023 15:44:47 -0800 (PST)
MIME-Version: 1.0
References: <a968c446bde75bf019580366854349bf94e6c961.1675897882.git.darren@os.amperecomputing.com>
 <CAMj1kXF2Bi_iyjzUK2zie_pt6Vnm4QwvarHicJoRzUiX7nU0Kw@mail.gmail.com> <Y+QztBs1uHnTRyyu@fedora>
In-Reply-To: <Y+QztBs1uHnTRyyu@fedora>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 9 Feb 2023 00:44:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEZMGSMh7uEx5_7vQ=dWeq=4nERspkxKDGAkoBvYL4X0Q@mail.gmail.com>
Message-ID: <CAMj1kXEZMGSMh7uEx5_7vQ=dWeq=4nERspkxKDGAkoBvYL4X0Q@mail.gmail.com>
Subject: Re: [PATCH] arm64: efi: Force the use of SetVirtualAddressMap() on
 Altra Max machines
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        linux-efi@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 9 Feb 2023 at 00:43, Darren Hart <darren@os.amperecomputing.com> wrote:
>
> On Thu, Feb 09, 2023 at 12:16:46AM +0100, Ard Biesheuvel wrote:
> > Hello Darren,
> >
> > On Thu, 9 Feb 2023 at 00:14, Darren Hart <darren@os.amperecomputing.com> wrote:
> > >
> > > Commit 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()
> > > on Altra machines") identifies the Altra family via the family field in
> > > the type#1 SMBIOS record. Altra Max machines are similarly affected but
> > > not detected with the strict strcmp test.
> > >
> > > Rather than risk greedy matching with strncmp, add a second test for
> > > Altra Max. Do not refactor to handle multiple tests as these should be
> > > the only two needed.
> > >
> >
> > Famous last words ...
>
> Indeed, I nearly included that myself...
>
> >
> > Unfortunately, I just had a report the other day that 'eMAG' and
> > 'Server' (!) are also being used.
> >
> > https://lore.kernel.org/all/20230131040355.3116-1-justin.he@arm.com/
> >
>
> OK, so in order to workaround this in the kernel, we need a better way to match.
> Unfortunately, this is specific to the oem platform, and the oem controls those
> strings.
>
> Thanks for the pointer, will go mull this over and see if I can come up with
> something better.
>
> In the meantime, would you consider matching on:
> Altra
> Altra Max
> eMAG
>
> to capture the bulk of the systems until we have a better solution?
>

Yeah that's fine.
