Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE285F48E5
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 19:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJDRrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 13:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiJDRrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 13:47:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6373F5E657;
        Tue,  4 Oct 2022 10:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C81B8614ED;
        Tue,  4 Oct 2022 17:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FCDC433D6;
        Tue,  4 Oct 2022 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664905655;
        bh=OrF+jIdMNl7pzKQlx9UGWocOLxVij3glu98n2BYZiCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zbqYD1BWSTfEEBZl21YNZ65FXfxCuaMRVfdJyY4PuBsuP7Vwd18wQ48WPoQ4elcNI
         /wUOfhpZFW3+qTkf6ygyUf7vz/TXSezL5m/3eJ477FBh46h6t+v/CwMJHuxS6Uqfd4
         qGemcTy5yO3uY/fBaz2XJbbFPofUkB3M1lvmTBRk=
Date:   Tue, 4 Oct 2022 19:47:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 089/101] dont use __kernel_write() on
 kmap_local_page()
Message-ID: <YzxxtFSCEsycgXSK@kroah.com>
References: <20221003070724.490989164@linuxfoundation.org>
 <20221003070726.658463729@linuxfoundation.org>
 <CAMuHMdXqjz2BbPX3TGd40o=A-gDx6ZEYEe1rf3AadqOf_E4V_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXqjz2BbPX3TGd40o=A-gDx6ZEYEe1rf3AadqOf_E4V_A@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 11:09:12AM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Mon, Oct 3, 2022 at 9:28 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > From: Al Viro <viro@zeniv.linux.org.uk>
> >
> > [ Upstream commit 06bbaa6dc53cb72040db952053432541acb9adc7 ]
> >
> > passing kmap_local_page() result to __kernel_write() is unsafe -
> > random ->write_iter() might (and 9p one does) get unhappy when
> > passed ITER_KVEC with pointer that came from kmap_local_page().
> >
> > Fix by providing a variant of __kernel_write() that takes an iov_iter
> > from caller (__kernel_write() becomes a trivial wrapper) and adding
> > dump_emit_page() that parallels dump_emit(), except that instead of
> > __kernel_write() it uses __kernel_write_iter() with ITER_BVEC source.
> >
> > Fixes: 3159ed57792b "fs/coredump: use kmap_local_page()"
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This will need a follow-up patch, which I have just posted[1], to
> not break the build if CONFIG_ELF_CORE is not set.
> 
> [1] https://lore.kernel.org/20221003090657.2053236-1-geert@linux-m68k.org

Thanks, now dropped from 5.19 and 5.15 queues.  When this gets merged,
can you ping stable@kernel.org to add them both back?

thanks,

greg k-h
