Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA9F6C5973
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 23:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjCVWcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 18:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVWcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 18:32:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F038109;
        Wed, 22 Mar 2023 15:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y18HpSiK9r4CIVZcGz/4BaB0bggYzqBPYlKsvJvl+es=; b=IifB+OzpXgXxmiuDlLET67Z3UM
        1QM6QUa0h8F2sLCSGjfa0acgk4Tyy8jfxBbAY6LliDeFrIgiFHwzr1EqZlE/WjfSPHoEJz0MhQalb
        d4AwwtLlgnOQmfKYcFyIrExrIg/ArPkZ9O+FuL9bzsMM3gHj6sg+deubfTmQbUINIqmzOfjelV2zI
        HZ/BZwsQhlQ9iSL7KHINbvtWZ+CenTjwJySoA0DHPtcGXS3R2l7KcjhK5ChINU/7DoBdHMnJDc5v7
        0cu1lMNL03MXloC6aWoerjuFyi7LjsIfEn0s9XTqIY+bbyR50a7CiW+IXWYNt2XRicuuc2UmHjGcN
        qxYYAg7Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pf6zv-00018h-11;
        Wed, 22 Mar 2023 22:31:59 +0000
Date:   Wed, 22 Mar 2023 15:31:59 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Lucas De Marchi <lucas.demarchi@intel.com>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc:     Petr Mladek <pmladek@suse.com>, Petr Pavlu <petr.pavlu@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Ben Hutchings <benh@debian.org>,
        Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <ZBuB3+cN4BK6woKZ@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley>
 <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
 <Y8nnTXi1Jqy1YARi@bombadil.infradead.org>
 <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
 <20230312062505.man5h4oo6mjbiov6@ldmartin-desk2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312062505.man5h4oo6mjbiov6@ldmartin-desk2.lan>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 10:25:05PM -0800, Lucas De Marchi wrote:
> On Sat, Jan 21, 2023 at 02:40:20PM -0800, Luis Chamberlain wrote:
> > On Thu, Jan 19, 2023 at 04:58:53PM -0800, Luis Chamberlain wrote:
> > > On Thu, Jan 19, 2023 at 04:51:27PM -0800, Luis Chamberlain wrote:
> > > > On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
> > > > > Yes, the -EINVAL error is strange. It is returned also in
> > > > > kernel/module/main.c on few locations. But neither of them
> > > > > looks like a good candidate.
> > > >
> > > > OK I updated to next-20230119 and I don't see the issue now.
> > > > Odd. It could have been an issue with next-20221207 which I was
> > > > on before.
> > > >
> > > > I'll run some more test and if nothing fails I'll send the fix
> > > > to Linux for rc5.
> > > 
> > > Jeesh it just occured to me the difference, which I'll have to
> > > test next, for next-20221207 I had enabled module compression
> > > on kdevops with zstd.
> > > 
> > > You can see the issues on kdevops git log with that... and I finally
> > > disabled it and the kmod test issue is gone. So it could be that
> > > but I just am ending my day so will check tomorrow if that was it.
> > > But if someone else beats me then great.
> > > 
> > > With kdevops it should be a matter of just enabling zstd as I
> > > just bumped support for next-20230119 and that has module decompression
> > > disabled.
> > 
> > So indeed, my suspcions were correct. There is one bug with
> > compression on debian:
> > 
> > - gzip compressed modules don't end up in the initramfs
> > 
> > There is a generic upstream kmod bug:
> > 
> >  - modprobe --show-depends won't grok compressed modules so initramfs
> >    tools that use this as Debian likely are not getting module dependencies
> >    installed in their initramfs
> 
> are you sure you have the relevant compression setting enabled
> in kmod?
> 
> $ kmod --version
> kmod version 30
> +ZSTD +XZ +ZLIB +LIBCRYPTO -EXPERIMENTAL

Debian has:

kmod version 30
+ZSTD +XZ -ZLIB +LIBCRYPTO -EXPERIMENTAL

> $ modprobe --show-depends ext4
> insmod /lib/modules/6.1.12-1-MANJARO/kernel/fs/jbd2/jbd2.ko.zst insmod
> /lib/modules/6.1.12-1-MANJARO/kernel/fs/mbcache.ko.zst insmod
> /lib/modules/6.1.12-1-MANJARO/kernel/lib/crc16.ko.zst insmod
> /lib/modules/6.1.12-1-MANJARO/kernel/arch/x86/crypto/crc32c-intel.ko.zst
> insmod /lib/modules/6.1.12-1-MANJARO/kernel/crypto/crc32c_generic.ko.zst
> insmod /lib/modules/6.1.12-1-MANJARO/kernel/fs/ext4/ext4.ko.zst

Perhaps this was related to the above gzip issue in debian then.

I'm hoping will have a bit more time than me to verify.

  Luis
