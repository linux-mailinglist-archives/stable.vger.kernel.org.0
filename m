Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DE7653412
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbiLUQcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbiLUQcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:32:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDAB29A;
        Wed, 21 Dec 2022 08:31:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F3D2B81983;
        Wed, 21 Dec 2022 16:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1273C433D2;
        Wed, 21 Dec 2022 16:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671640314;
        bh=HFYvcmPWabYXSMf59FdoWUiXvzlOf270/CXQcNkZpe0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sGeVcsvm/Z8phgeOOkw7I+7MlIrnrOQ2llMbk60Ib4f9nvruhsGIVhJ7t9ngktTwA
         +CiRhLXaiDLk8XOCCIZJNzmHc8ehxyRNLDXlcTR+ss3RHFJG2nO+Cw2l8isqJLiLJD
         tAD5UpJYIgJPtypU2UZ+SQ5sfHO9n25M77o6nzow=
Date:   Wed, 21 Dec 2022 17:31:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <Y6M090tsVRIBNlNG@kroah.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 04:18:18PM -0700, Tom Saeger wrote:
> Backport of:
> commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> 
> Linus's tree doesn't have this issue since 0d362be5b142 was merged
> after df202b452fe6 which included:
> commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")

Why can't we add this one instead of a custom change?

> 
> This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
> with relocatable (-r) and now (-z noexecstack)
> which results in ld adding a .note.GNU-stack section to .o files.
> Final linking of vmlinux should add a .NOTES segment containing the
> Build ID, but does NOT (on some architectures like arm64) if a
> .note.GNU-stack section is found in .o's supplied during link
> of vmlinux.
> 
> DISCARD .note.GNU-stack sections of .S targets.  Final link of
> vmlinux then properly adds .NOTES segment containing Build ID that can
> be read using tools like 'readelf -n'.
> 
> Fixes: 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> Cc: <stable@vger.kernel.org> # 5.15, 5.10, 5.4
> Cc: <linux-kbuild@vger.kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Michal Marek <michal.lkml@markovi.net>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> ---
> 
> v2:
>   - Changed approach to append DISCARD section to generated linker script.
>     - ld no longer emits warning (which was intent of 0d362b35b142) this
>       addresses Nick's v1 feedback.
>     - this is applied to all arches, not just arm64
>   - added commit refs and notes why this doesn't occur in Linus's tree
>     to address Greg's v1 feedback.
>   - added Fixes: 0d362b35b142 requested by Nick
>   - added note to changelog for 7b4537199a4a requested by Nick
>   - build tested on arm64 and x86
>    
>    version           works(vmlinux contains Build ID)
>    v4.14.302         x86, arm64
>    v4.14.302.patched x86, arm64
>    v4.19.269         x86, arm64
>    v4.19.269.patched x86, arm64
>    v5.4.227          x86
>    v5.4.227.patched  x86, arm64
>    v5.10.159         x86
>    v5.10.159.patched x86, arm64
>    v5.15.83          x86
>    v5.15.83.patched  x86, arm64
> 
> v1: https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/
> 
> 
>  scripts/Makefile.build | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 17aa8ef2d52a..e3939676eeb5 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -379,6 +379,8 @@ cmd_modversions_S =								\
>  	if $(OBJDUMP) -h $@ | grep -q __ksymtab; then				\
>  		$(call cmd_gensymtypes_S,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))	\
>  		    > $(@D)/.tmp_$(@F:.o=.ver);					\
> +		echo "SECTIONS { /DISCARD/ : { *(.note.GNU-stack) } }"		\
> +		>> $(@D)/.tmp_$(@F:.o=.ver); 					\
>  										\
>  		$(LD) $(KBUILD_LDFLAGS) -r -o $(@D)/.tmp_$(@F) $@ 		\
>  			-T $(@D)/.tmp_$(@F:.o=.ver);				\
> 
> base-commit: fd6d66840b4269da4e90e1ea807ae3197433bc66
> -- 
> 2.38.1
> 


I need some acks from some developers/maintainers before I can take
this... {hint}

thanks,

greg k-h
