Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CD460CC65
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 14:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiJYMto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 08:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiJYMtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 08:49:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913FD193762;
        Tue, 25 Oct 2022 05:47:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8155B61919;
        Tue, 25 Oct 2022 12:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60931C433D6;
        Tue, 25 Oct 2022 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666702037;
        bh=PRmqS5H+nCp9dplF7lCxZ/svls2XGbTUgDWMeIMlsbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O16r+C8HYrEgaR0P0z3/hFYuLy0xAnu9sEbIfGlOOfQCoSWHULDzBxmppvxU7hE8j
         lVYQXCmknfIwBbCNw3vBkg5PV5+lZgKV/yNUhkExYtevIQjjb1NDTJrfemJS++jSnA
         hwV2PWwEAX3vTqQG9BkfOPcOL976KoEVpzlxurmY=
Date:   Tue, 25 Oct 2022 14:47:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, xen-devel@lists.xenproject.org,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 174/229] x86/entry: Work around Clang __bdos() bug
Message-ID: <Y1fa082Vhar2x1DM@kroah.com>
References: <20221024112959.085534368@linuxfoundation.org>
 <20221024113004.718917343@linuxfoundation.org>
 <20221024174127.GC25198@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024174127.GC25198@duo.ucw.cz>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 07:41:27PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Kees Cook <keescook@chromium.org>
> > 
> > [ Upstream commit 3e1730842f142add55dc658929221521a9ea62b6 ]
> > 
> > Clang produces a false positive when building with CONFIG_FORTIFY_SOURCE=y
> > and CONFIG_UBSAN_BOUNDS=y when operating on an array with a dynamic
> > offset. Work around this by using a direct assignment of an empty
> > instance. Avoids this warning:
> > 
> > ../include/linux/fortify-string.h:309:4: warning: call to __write_overflow_field declared with 'warn
> > ing' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wat
> > tribute-warning]
> >                         __write_overflow_field(p_size_field, size);
> >                         ^
> > 
> > which was isolated to the memset() call in xen_load_idt().
> > 
> > Note that this looks very much like another bug that was worked around:
> > https://github.com/ClangBuiltLinux/linux/issues/1592
> 
> We don't have CONFIG_UBSAN_BOUNDS in 4.19, so maybe we don't need this
> one?

Good point, I'll drop this from 5.4.y and older now, thanks.

greg k-h
