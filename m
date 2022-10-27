Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F64B60F840
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbiJ0M6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbiJ0M6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:58:52 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A816173FF3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 05:58:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k8so2055401wrh.1
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 05:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYNXPH6Lg1r8RyczXNcqWGALjI428njb4JBn9/6KypM=;
        b=F40oHwFY8hMggXBVURESxn75I+lBRn69nXfIulwIE/jDreQ5oj+NiPb2palpc2vECy
         2r9pBHP7M+xHUsRoD6cQ6rl2nrZ/65x2/BoyQcHaJWgBQS8STkujoRw0aM52llKd0AiO
         68xsizWDna8exfxw9K4FHl2yskZJWDdwHhpdKyXQmCgpVZbpkF6M3e/neHD6j0MMMl8m
         +4ufjlYJSxMJBtRqg1DsV1XVy8jwOZ8d3/xntxMV1Ehcp4HQthNwKdzw9XuBiXvliFLS
         /JcMWOgDmaAE56w4KneOKwsLscQTv+3f7K3CBLaKl6TPQl/bPuh9VL6ry4OGlLKezh9K
         HAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYNXPH6Lg1r8RyczXNcqWGALjI428njb4JBn9/6KypM=;
        b=mVCnKRQoyIj8K3qyfPDyBaCSlNSME7BeJD+V0ye3nhpytq04c+m5JR7ODuuApfsj9M
         Cc17dy//5xd6sfzAIf9wWBie4sGbMT3QelO3Olt4E5fP8tZWHlr7rIx5j1CPK1EzE6pn
         7mv7lYcfWkzNOyAXrI6DRVr9ofc/U7WiBOBF5Hw3qs4wGPkDaby7Vi9gNoLjksxKqxwP
         u4WAFWxAFSqYr49zFsf+P1NGjdjw7UuIGn8G5DMe+q1wElHkbMyivu+Be1trfWxeDRK0
         5BytjEe486d8QItzBmP0jvJFcc2VmAs1JxCByFzw5U9CPcO1HedGIvLQWVR910EM3ApA
         l4LA==
X-Gm-Message-State: ACrzQf2kDOvMo78c9geR82549kzaOLrguDrU3J6B6MDVZTV56foooJ9d
        8bGThzbp2BP4l5a67ymkSIc=
X-Google-Smtp-Source: AMsMyM7MvmVgGarwGMGQSLgaKDpEERHiNV4fuPRMW5RYKNIzE5n2/1nPcZNkmKw0pDrK0GCx+5ksWQ==
X-Received: by 2002:a05:6000:1a8d:b0:236:4810:9966 with SMTP id f13-20020a0560001a8d00b0023648109966mr24219025wry.366.1666875529854;
        Thu, 27 Oct 2022 05:58:49 -0700 (PDT)
Received: from krava (2001-1ae9-1c2-4c00-8b88-53b7-c55c-8535.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:8b88:53b7:c55c:8535])
        by smtp.gmail.com with ESMTPSA id n15-20020a056000170f00b0022cd0c8c696sm1186255wrc.103.2022.10.27.05.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:58:49 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 27 Oct 2022 14:58:47 +0200
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH 5.10] kbuild: fix BTF build with pahole 1.24
Message-ID: <Y1qAh6TzBw4b3+TQ@krava>
References: <20221027120158.2791406-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027120158.2791406-1-asmadeus@codewreck.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 09:01:58PM +0900, Dominique Martinet wrote:
> pahole 1.24 broke builds on kernel <6.0 which do not have the
> new BTF_KIND_ENUM64 BTF tag.
> The 5.15 branch fixed this in commit b775fbf532dc01ae53a6fc56168fd30cb4b0c658
> ("kbuild: Add skip_encoding_btf_enum64 option to pahole"), which
> we cannot use directly for 5.10 because 5.10 does not have the
> pahole-flags.sh script, itself introduced in upstream commit
> 0baced0e0938f2895ceba54038eaf15ed91032e7 ("kbuild: Unify options
> for BTF generation for vmlinux and modules")
> 
> that last commit is difficult to backport as 5.10 does not have BTF
> for modules support: work around the problem by just copying the
> pahole-flags.sh script and calling it directly in link-vmlinux.sh,
> which is hopefully acceptable as the flags are not shared in this tree.
> 
> Note that compared to 5.15 the flags script does not have
> --btf_gen_floats as linux 5.10 did not have that BTF tag yet;
> but any new flag added to 5.15 will not be able to be added to 5.10 in
> an identical way for any future breakage.
> 
> Cc: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> CC: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

hi,
I sent this backport just recently:
  https://lore.kernel.org/bpf/Y1lkASXgeW0jfP8o@kroah.com/T/#t

it's split into several patches, hopefuly fixing the issue for you

jirka

> ---
> 
> This came up after updating nixpkgs to pahole 1.24.
> https://github.com/NixOS/nixpkgs/pull/194551
> Their 5.15's kernel built just fine as it already got some special
> handling added, but since that handling was not added to other stable
> kernels it started breaking builds after merging...
> 
> This shouldn't break anything, and should also as a byproduct fix some
> builds with pahole 1.18 through 1.21 although I'm not sure if it never
> has been backported to 5.10 because it's not a problem there or because
> nobody cared (I probably only started caring after the 1.22 release)
> 
> Anyway, if more can be shared I think it'll make things simpler for
> everyone going forward :)
> 
> 
>  scripts/link-vmlinux.sh |  2 +-
>  scripts/pahole-flags.sh | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+), 1 deletion(-)
>  create mode 100755 scripts/pahole-flags.sh
> 
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index d0b44bee9286..c24da7b68619 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -161,7 +161,7 @@ gen_btf()
>  	vmlinux_link ${1}
>  
>  	info "BTF" ${2}
> -	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> +	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J $("${srctree}/scripts/pahole_flags.sh") ${1}
>  
>  	# Create ${2} which contains just .BTF section but no symbols. Add
>  	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
> diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
> new file mode 100755
> index 000000000000..8c82173e42e5
> --- /dev/null
> +++ b/scripts/pahole-flags.sh
> @@ -0,0 +1,21 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +extra_paholeopt=
> +
> +if ! [ -x "$(command -v ${PAHOLE})" ]; then
> +	exit 0
> +fi
> +
> +pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
> +
> +if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
> +	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
> +	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
> +fi
> +
> +if [ "${pahole_ver}" -ge "124" ]; then
> +	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
> +fi
> +
> +echo ${extra_paholeopt}
> -- 
> 2.37.3
> 
