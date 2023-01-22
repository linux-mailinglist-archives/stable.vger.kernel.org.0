Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3514A676DBD
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjAVOkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVOkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:40:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB921B550;
        Sun, 22 Jan 2023 06:40:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB0A860B6C;
        Sun, 22 Jan 2023 14:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99D0C433EF;
        Sun, 22 Jan 2023 14:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674398405;
        bh=xIenJ33X4w53MIg59ADVQz0nngYpxFEhR87i6K9F56w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lOVKqCtxPk7DbYqUUFPTrAHT27mdlGP8cm5ul6MguYtcgSyC27XRDY8A02yyuY21W
         agbQfDGYRg6ECg3fSVxSxSbosvIHKSDEp2o+knLc2WABVMApTcTT3uw6WLM3hFRfNq
         3iWXhJI23y9Mo5cTvstJYYBDpw+Tos/nwg8CydYE=
Date:   Sun, 22 Jan 2023 15:40:02 +0100
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
Message-ID: <Y81KwtuMEDlWfWez@kroah.com>
References: <Y6M090tsVRIBNlNG@kroah.com>
 <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
 <Y6Pyp+7Udn6x/UVg@kroah.com>
 <20230109183615.zxe7o7fowdpeqlj3@oracle.com>
 <Y7/2ef+JWO6BXGfC@kroah.com>
 <20230112212006.rnrbaby2imjlej4q@oracle.com>
 <20230113150654.w4cbvtasoep5rscw@oracle.com>
 <Y8Kz8JwM/4GyN1um@kroah.com>
 <20230117235006.oishw5tlc3xnwwmd@oracle.com>
 <Y81Gdwg3GZ3W5bNz@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y81Gdwg3GZ3W5bNz@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 03:21:43PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 17, 2023 at 05:50:06PM -0600, Tom Saeger wrote:
> > On Sat, Jan 14, 2023 at 02:53:52PM +0100, Greg Kroah-Hartman wrote:
> > > On Fri, Jan 13, 2023 at 09:06:54AM -0600, Tom Saeger wrote:
> > > > On Thu, Jan 12, 2023 at 03:20:11PM -0600, Tom Saeger wrote:
> > > > > On Thu, Jan 12, 2023 at 01:00:57PM +0100, Greg Kroah-Hartman wrote:
> > > > > > On Mon, Jan 09, 2023 at 12:36:15PM -0600, Tom Saeger wrote:
> > > > > > > On Thu, Dec 22, 2022 at 07:01:11AM +0100, Greg Kroah-Hartman wrote:
> > > > > > > > On Wed, Dec 21, 2022 at 02:52:10PM -0600, Tom Saeger wrote:
> > > > > > > > > On Wed, Dec 21, 2022 at 05:31:51PM +0100, Greg Kroah-Hartman wrote:
> > > > > > > > > > On Thu, Dec 15, 2022 at 04:18:18PM -0700, Tom Saeger wrote:
> > > > > > > > > > > Backport of:
> > > > > > > > > > > commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > > > > > > > > > > breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> > > > > > > > > > > from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > > > > > > > until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > > > > > > > > > > 
> > > > > > > > > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > > > > > > > > after df202b452fe6 which included:
> > > > > > > > > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > > > > > > > > 
> > > > > > > > > > Why can't we add this one instead of a custom change?
> > > > > > > > > 
> > > > > > > > > I quickly abandoned that route - there are too many dependencies.
> > > > > > > > 
> > > > > > > > How many?  Why?  Whenever we add a "this is not upstream" patch, 90% of
> > > > > > > > the time it is incorrect and causes problems (merge issues included.)
> > > > > > > > So please please please let's try to keep in sync with what is in
> > > > > > > > Linus's tree.
> > > > > > > > 
> > > > > > > > thanks,
> > > > > > > > 
> > > > > > > > greg k-h
> > > > > > > 
> > > > > > > Ok - I spent some time on this.
> > > > > > > 
> > > > > > > The haystack I searched:
> > > > > > > 
> > > > > > >   git rev-list --grep="masahiroy/linux-kbuild" v5.15..v5.19-rc1 | while read -r CID ; do git rev-list "${CID}^-" ; done | wc -l
> > > > > > >   182
> > > > > > > 
> > > > > > > I have 54 of those 182 applied to 5.15.85, and this works in my
> > > > > > > limited build testing (x86_64 gcc, arm64 gcc, arm64 clang).
> > > > > > > 
> > > > > > > Specifically:
> > > > > > > 
> > > > > > > 
> > > > > > > cbfc9bf3223f genksyms: adjust the output format to modpost
> > > > > > > e7c9c2630e59 kbuild: stop merging *.symversions
> > > > > > > 1d788aa800c7 kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS
> > > > > > > 8a01c770955b modpost: extract symbol versions from *.cmd files
> > > > > > > a8ade6b33772 modpost: add sym_find_with_module() helper
> > > > > > > a9639fe6b516 modpost: change the license of EXPORT_SYMBOL to bool type
> > > > > > > 04804878f631 modpost: remove left-over cross_compile declaration
> > > > > > > 3388b8af9698 kbuild: record symbol versions in *.cmd files
> > > > > > > 4ff3946463a0 kbuild: generate a list of objects in vmlinux
> > > > > > > 074617e2ad6a modpost: move *.mod.c generation to write_mod_c_files()
> > > > > > > 81b78cb6e821 modpost: merge add_{intree_flag,retpoline,staging_flag} to add_header
> > > > > > > 9df4f00b53b4 modpost: split new_symbol() to symbol allocation and hash table addition
> > > > > > > 85728bcbc500 modpost: make sym_add_exported() always allocate a new symbol
> > > > > > > 82aa2b4d30af modpost: make multiple export error
> > > > > > > 6cc962f0a175 modpost: dump Module.symvers in the same order of modules.order
> > > > > > > 39db82cea373 modpost: traverse the namespace_list in order
> > > > > > > 45dc7b236dcb modpost: use doubly linked list for dump_lists
> > > > > > > 2a322506403a modpost: traverse unresolved symbols in order
> > > > > > > a85718443348 modpost: add sym_add_unresolved() helper
> > > > > > > 5c44b0f89c82 modpost: traverse modules in order
> > > > > > > a0b68f6655f2 modpost: import include/linux/list.h
> > > > > > > ce9f4d32be4e modpost: change mod->gpl_compatible to bool type
> > > > > > > f9fe36a515ca modpost: use bool type where appropriate
> > > > > > > 46f6334d7055 modpost: move struct namespace_list to modpost.c
> > > > > > > afa24c45af49 modpost: retrieve the module dependency and CRCs in check_exports()
> > > > > > > a8f687dc3ac2 modpost: add a separate error for exported symbols without definition
> > > > > > > f97f0e32b230 modpost: remove stale comment about sym_add_exported()
> > > > > > > 0af2ad9d11c3 modpost: do not write out any file when error occurred
> > > > > > > 09eac5681c02 modpost: use snprintf() instead of sprintf() for safety
> > > > > > > ee07380110f2 kbuild: read *.mod to get objects passed to $(LD) or $(AR)
> > > > > > > 97976e5c6d55 kbuild: make *.mod not depend on *.o
> > > > > > > 0d4368c8da07 kbuild: get rid of duplication in *.mod files
> > > > > > > 55f602f00903 kbuild: split the second line of *.mod into *.usyms
> > > > > > > ea9730eb0788 kbuild: reuse real-search to simplify cmd_mod
> > > > > > > 1eacf71f885a kbuild: make multi_depend work with targets in subdirectory
> > > > > > > 19c2b5b6f769 kbuild: reuse suffix-search to refactor multi_depend
> > > > > > > 75df07a9133d kbuild: refactor cmd_modversions_S
> > > > > > > 53257fbea174 kbuild: refactor cmd_modversions_c
> > > > > > > b6e50682c261 modpost: remove annoying namespace_from_kstrtabns()
> > > > > > > 1002d8f060b0 modpost: remove redundant initializes for static variables
> > > > > > > 921fbb7ab714 modpost: move export_from_secname() call to more relevant place
> > > > > > > f49c0989e01b modpost: remove useless export_from_sec()
> > > > > > > 7a98501a77db kbuild: do not remove empty *.symtypes explicitly
> > > > > > > 500f1b31c16f kbuild: factor out genksyms command from cmd_gensymtypes_{c,S}
> > > > > > > e04fcad29aa3 kallsyms: ignore all local labels prefixed by '.L'
> > > > > > > 9e01f7ef15d2 kbuild: drop $(size_append) from cmd_zstd
> > > > > > > 054133567480 kbuild: do not include include/config/auto.conf from shell scripts
> > > > > > > 34d14831eecb kbuild: stop using config_filename in scripts/Makefile.modsign
> > > > > > > 75155bda5498 kbuild: use more subdir- for visiting subdirectories while cleaning
> > > > > > > 1a3f00cd3be8 kbuild: reuse $(cmd_objtool) for cmd_cc_lto_link_modules
> > > > > > > 47704d10e997 kbuild: detect objtool update without using .SECONDEXPANSION
> > > > > > > 7a89d034ccc6 kbuild: factor out OBJECT_FILES_NON_STANDARD check into a macro
> > > > > > > 3cbbf4b9d188 kbuild: store the objtool command in *.cmd files
> > > > > > > 467f0d0aa6b4 kbuild: rename __objtool_obj and reuse it for cmd_cc_lto_link_modules
> > > > > > > 
> > > > > > > There may be a few more patches post v5.19-rc1 for Fixes.
> > > > > > > I haven't tried minimizing the 54.
> > > > > > > 
> > > > > > > Greg - is 54 too many?
> > > > > > 
> > > > > > Yes.
> > > > > > 
> > > > > > How about we just revert the original problem commit here to solve this
> > > > > > mess?  Wouldn't that be easier overall?
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > 
> > > > > What about a partial revert like:
> > > > > 
> > > > > diff --git a/Makefile b/Makefile
> > > > > index 9f5d2e87150e..aa0f7578653d 100644
> > > > > --- a/Makefile
> > > > > +++ b/Makefile
> > > > > @@ -1083,7 +1083,9 @@ KBUILD_CFLAGS   += $(KCFLAGS)
> > > > >  KBUILD_LDFLAGS_MODULE += --build-id=sha1
> > > > >  LDFLAGS_vmlinux += --build-id=sha1
> > > > > 
> > > > > +ifneq ($(ARCH),$(filter $(ARCH),arm64))
> > > > >  KBUILD_LDFLAGS += -z noexecstack
> > > > > +endif
> > > > >  ifeq ($(CONFIG_LD_IS_BFD),y)
> > > > >  KBUILD_LDFLAGS += $(call ld-option,--no-warn-rwx-segments)
> > > > >  endif
> > > > > 
> > > > > 
> > > > > Only arm64 gcc/ld builds would need to change (with the option of adding
> > > > > other architectures if anyone reports same issue).
> > > > > 
> > > > > With a full revert we lose --no-warn-rwx-segments and warnings show-up
> > > > > with later versions of ld.
> > > > > 
> > > > > 
> > > > > I did open a bug against 'ld' as Nick requested:
> > > > > https://sourceware.org/bugzilla/show_bug.cgi?id=29994
> > > > > 
> > > > > If this is this is a better way to go - I can form up a v3 patch.
> > > > > 
> > > > > --Tom
> > > > 
> > > > nevermind
> > > > 
> > > > The patch discussed here fixes arm64 Build ID for 5.15, 5.10, and 5.4:
> > > > 
> > > > https://lore.kernel.org/all/CAMj1kXHqQoqoys83nEp=Q6oT68+-GpCuMjfnYK9pMy-X_+jjKw@mail.gmail.com/
> > > 
> > > Great, please let me know when this hits Linus's tree and I will be glad
> > > to queue it up.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Hi Greg,
> > 
> >   Masahiroy's commit is already in Linus's tree.
> > 
> > ❯ git log -n1 --format=oneline 99cb0d917ffa
> > 99cb0d917ffa1ab628bb67364ca9b162c07699b1 arch: fix broken BuildID for arm64 and riscv
> > 
> > ❯ git tag --contains=99cb0d917ffa
> > v6.2-rc2
> > v6.2-rc3
> > v6.2-rc4
> > 
> > Needed to fix Build ID in 5.15, 5.10, and 5.4 
> > 
> > Build results on arm64:
> > PASS v4.19.269 c652c812211c ("Linux 4.19.269") Build ID: 3b638c635fb3f3241b3e7ad6a147cf69d931b5b7
> > PASS v4.19.269 00527d2a4998 ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 919b5ca1964776926bc6c8addc5b8af4fb15367b
> > FAIL v5.4.228  851c2b5fb793 ("Linux 5.4.228")
> > PASS v5.4.228  39bb8287bc08 ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 483ac60fe71545045e625e681f3d4ebae5d15cd1
> > FAIL v5.10.163 19ff2d645f7a ("Linux 5.10.163")
> > PASS v5.10.163 6136c3a732cf ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 4c0926311f96a031c0581d8136d09ca4f7ca77b6
> > FAIL v5.15.88  90bb4f8f399f ("Linux 5.15.88")
> > PASS v5.15.88  6cb364966c77 ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 623dab2f6bd78271e315493c232abf042af88036
> > PASS v6.1.6    38f3ee12661f ("Linux 6.1.6")    Build ID: 8b9e3e330b093ab6037a5dcffcaefca84a878d44
> > PASS v6.1.6    db1031af82be ("arch: fix broken BuildID for arm64 and riscv")     Build ID: 2d848c31fcc31414513fa33ff2990fe6c9afa88c
> 
> Now queued up everywhere, thanks!

Ick, there was lots of fix-up patches for this commit, please always be
aware of that when recommending a patch be backported...

thanks,

greg k-h
