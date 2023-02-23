Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E946A10C9
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 20:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjBWTsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 14:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBWTsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 14:48:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD325DCE8;
        Thu, 23 Feb 2023 11:47:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 933E8B81A06;
        Thu, 23 Feb 2023 19:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587B8C433EF;
        Thu, 23 Feb 2023 19:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677181664;
        bh=ArTbrsEQrjxwTHDkqrozDwZAZ3OP1zYi7B3Y2K4PjsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Si274WhB6DwyX91J2yjORBqxmmcSZ0xmaTjWTpZb/9+YiMnFEqfqWRnc8fmu1svfh
         QWWLJsDsO4iXpuGo0yLjJJ7GtDFgyZP0RhX9hRv3oFV4RxgO92WFedVAmP/xg38YuG
         bwmDC8yKH8h9FGqtMhYhjaYeWqUMR9z+aeBWIlzsRXhrgRnazqZHdu4toca35ifz6+
         SBvkHOFDusV9o0z5fC+w+5dZlFCewOd0VXp1xIDThygxTKQopuTt+Tf3cul207MuC5
         S3kCBY3EHFV70WB73MmKfe2RVGCR467bMeZekS3LlmvF9pzMwg2MGBr6W0XcOWE+0r
         GZUjQGfxLQyEQ==
Date:   Thu, 23 Feb 2023 12:47:41 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Message-ID: <Y/fC3d3RqoeawG0Y@dev-arch.thelio-3990X>
References: <20230223141542.672463796@linuxfoundation.org>
 <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com>
 <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
 <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 10:03:43AM -0800, Linus Torvalds wrote:
> On Thu, Feb 23, 2023 at 9:31 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > This isn't the first time this happens. I seem to recall that you mentioned
> > some time ago that whatever you use to apply patches (quilt ?) doesn't
> > handle executable permission bits correctly.
> 
> Note that even though git itself does handle these things right, we've
> also always said that if some old fogey wants to use tar-balls and
> patches, that's supposed to still work.
> 
> I guess the same "old fogey" comment then covers quilt too.
> 
> End result: we should try to generally not execute our scripts
> directly, but to explicitly state which interpreter it should use,
> rather than then depend on the #! in the script itself to do it.
> 
> In fact, for shell scripting in particular, we go further than that,
> and use $(CONFIG_SHELL)
> 
> Of course, in this case, it's actually using the Makefile '$(shell
> ..)' format, so I guess it looks a bit odd to write it as
> 
>    $(shell $(CONFIG_SHELL) script..)
> 
> but I do think we should do it.

Right, we would also need CONFIG_SHELL within scripts/pahole-flags.sh
for scripts/pahole-version.sh, which is really what was blowing up here,
but the invocation of 'scripts/pahole-flags.sh' in Makefile needs it too
to avoid the same problem if it were added to an older kernel.

diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
index 0d99ef17e4a5..ca3c311a3855 100755
--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -7,7 +7,7 @@ if ! [ -x "$(command -v ${PAHOLE})" ]; then
 	exit 0
 fi
 
-pahole_ver=$($(dirname $0)/pahole-version.sh ${PAHOLE})
+pahole_ver=$(${CONFIG_SHELL} $(dirname $0)/pahole-version.sh ${PAHOLE})
 
 if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
 	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars

I can send a patch unless you want to take those changes directly, you
have half a commit message there already I think :)

Cheers,
Nathan
