Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F815A4627
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 11:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiH2Jd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 05:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiH2Jdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 05:33:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407775C94C;
        Mon, 29 Aug 2022 02:33:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC37B60FC6;
        Mon, 29 Aug 2022 09:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9350BC433C1;
        Mon, 29 Aug 2022 09:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661765632;
        bh=lT0Gv6sCfp7Xa8kCHxUOI7Yq9QfRd2TNlO/WqA0gGLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OUKJCmW4/I+GLUy1XFmCpQh8lII1juX35mwZ+5ttPVDgD70Ie4Xo6rUYqpGZhZvHh
         orS7Bnm+NSLdNJMPN2Onn2EEhvdScPiWgVwlI1RlR8TbGIQCl67TtA+TgjUMqdyQ2u
         nt2fGjIl0Lvob4E7wvH6UIfupSM4E1bWQmI0cgtc=
Date:   Mon, 29 Aug 2022 11:33:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 5.19 145/365] kbuild: dummy-tools: avoid tmpdir leak in
 dummy gcc
Message-ID: <YwyH/M+PO8CyRvpM@kroah.com>
References: <20220823080118.128342613@linuxfoundation.org>
 <20220823080124.294570326@linuxfoundation.org>
 <9996285f-5a50-e56a-eb1c-645598381a20@kernel.org>
 <CAFqZXNv2OvNu7BctW=csNLevgGWyoT1R81ypH8pGoAeo3vd4=w@mail.gmail.com>
 <71dbe196-a3d4-41f4-a00c-24f8b0222288@kernel.org>
 <YwxzOTljOcasjqfg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwxzOTljOcasjqfg@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 10:05:13AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Aug 29, 2022 at 09:12:39AM +0200, Jiri Slaby wrote:
> > On 27. 08. 22, 10:34, Ondrej Mosnacek wrote:
> > > On Sat, Aug 27, 2022 at 9:51 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> > > > On 23. 08. 22, 10:00, Greg Kroah-Hartman wrote:
> > > > > From: Ondrej Mosnacek <omosnace@redhat.com>
> > > > > 
> > > > > commit aac289653fa5adf9e9985e4912c1d24a3e8cbab2 upstream.
> > > > > 
> > > > > When passed -print-file-name=plugin, the dummy gcc script creates a
> > > > > temporary directory that is never cleaned up. To avoid cluttering
> > > > > $TMPDIR, instead use a static directory included in the source tree.
> > > > 
> > > > This breaks our (SUSE) use of dummy tools (GCC_PLUGINS became =n). I
> > > > will investigate whether this is stable-only and the root cause later.
> > > 
> > > It looks like both the Greg's generated patch and the final stable
> > > commit (d7e676b7dc6a) are missing the addition of the empty
> > > plugin-version.h file. It appears in the patch's diffstat, but not in
> > > the actual diff. The mainline commit does include the empty file
> > > correctly, so it's likely a bug in the stable cherry pick automation.
> > 
> > Right, this fixed the issue for me:
> > --- a/patches.kernel.org/5.19.4-144-kbuild-dummy-tools-avoid-tmpdir-leak-in-dummy-.patch
> > +++ b/patches.kernel.org/5.19.4-144-kbuild-dummy-tools-avoid-tmpdir-leak-in-dummy-.patch
> > @@ -20,6 +20,8 @@ Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> >   scripts/dummy-tools/gcc | 8 ++------
> >   1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > +diff --git a/scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h
> > b/scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h
> > +new file mode 100644
> >  diff --git a/scripts/dummy-tools/gcc b/scripts/dummy-tools/gcc
> >  index b2483149bbe5..7db825843435 100755
> >  --- a/scripts/dummy-tools/gcc
> 
> Ick, looks like a bad interaction between git and quilt, and then back
> to git.  I'll manually fix this up and push out a new stable release
> with it.

Odd, 5.15.y worked just fine, but 5.10.y and 5.19.y did not.

I've done a new 5.10 and 5.19 release with this fixed up.  If there are
still any issues here, please let me know.

thanks,

greg k-h
