Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0971D19C83C
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390107AbgDBRkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390003AbgDBRkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:40:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D14F20737;
        Thu,  2 Apr 2020 17:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585849254;
        bh=Zb29Kacv+GCHhMWMWS5OYVqzQGAI+0Pu3bS3HvKnJhM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HBElG/QpssIB7IpFqtCyWOh+gP2Pu0HhUDApjkiThGtYRsh560+bPFDhMZ1rvu/Ed
         EmLCKRofUpaCtttRy+4V1tg/P6PmCsRogRsjcHZCj7f3WEKsA9cUv8tw6+QzVponGn
         RQgT51rniWJYLf744RMRzm9elGs2LHB0RmsClhX4=
Date:   Thu, 2 Apr 2020 19:40:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Dirk =?iso-8859-1?Q?M=FCller?= <dmueller@suse.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 5.5 102/170] scripts/dtc: Remove redundant YYLOC global
 declaration
Message-ID: <20200402174052.GB3221004@kroah.com>
References: <20200331085423.990189598@linuxfoundation.org>
 <20200331085435.053942582@linuxfoundation.org>
 <20200331095323.GA32667@ubuntu-m2-xlarge-x86>
 <20200331100238.GA1204199@kroah.com>
 <5B6493BE-F9FE-41A4-A88A-5E4DF5BCE098@suse.com>
 <20200331120917.GA1617997@kroah.com>
 <20200331192515.GA39354@ubuntu-m2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200331192515.GA39354@ubuntu-m2-xlarge-x86>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 12:25:15PM -0700, Nathan Chancellor wrote:
> On Tue, Mar 31, 2020 at 02:09:17PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Mar 31, 2020 at 01:45:09PM +0200, Dirk Müller wrote:
> > > Hi Greg,
> > > 
> > > >> $ sed -i 's;scripts/dtc/dtc-lexer.l;scripts/dtc/dtc-lexer.lex.c_shipped;g' \
> > > >> queue-{4.4,4.9,4.14}/scripts-dtc-remove-redundant-yyloc-global-declaration.patch
> > > >> If you would prefer a set of patches, let me know.
> > > > Should I just drop the patch from 4.4, 4.9, and 4.14 instead?
> > > 
> > > as the original author of the patch, I am not sure why it was backported to the LTS releases (unless enablement for gcc 10.x or
> > > other new toolchains is a requirement, which I'm not aware of). 
> 
> The reason I am commenting on this is that Clang 11 is matching GCC's
> -fno-common change. Google will run into this when they do their
> toolchain uprev on Android (sooner rather than later) so it'd be good
> to deal with this now:
> 
> https://android.googlesource.com/kernel/build/+/refs/heads/master/build.sh#226
> 
> Their devices back to 4.4 see builds with newer and newer toolchains so
> we need this back to 4.4. I am sure Chrome OS will also run into this
> shortly as well.
> 
> > > However I think the sed above on the *patch* means that the patch will *only* modify the generated sources, not the input sources. I think
> > > it would be better to patch both *input* and *generated* sources, or backport the generate-at-runtime patch as well (which might be
> > > even further outside the stable policy). 
> > 
> > What do you mean by "input sources" here?
> 
> dtc-lexer.l is the input source for dtc-lexer.lex.c, which was then
> copied to dtc-lexer.lex.c_shipped prior to e039139be8c2 ("scripts/dtc:
> generate lexer and parser during build instead of shipping"). In other
> words, prior to 4.17, dtc-lexer.l is not used at all in the build
> system.
> 
> However, I agree with Dirk that it would be most proper to apply the fix
> to both dtc-lexer.l and dtc-lexer.lex.c_shipped so I have attached a
> backport for 4.4, 4.9, and 4.14 that has does just that.
> 
> > > Not knowing why it was backported, I would suggest to just dequeue the patch from the older trees. 
> > 
> > If I drop it for now, I'll have to add it back when gcc10 is pushed out
> > to my build systems and laptops :(
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hope this makes sense/isn't confusing.

Makes sense, thanks for the patches, I've now updated the tree with the
versions you provided.

greg k-h
