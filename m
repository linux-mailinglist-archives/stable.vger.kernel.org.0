Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EE85AFBD3
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 07:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiIGFk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 01:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiIGFkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 01:40:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3411172EDE;
        Tue,  6 Sep 2022 22:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD2A7B81A3A;
        Wed,  7 Sep 2022 05:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E172C433C1;
        Wed,  7 Sep 2022 05:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662529220;
        bh=UqXCQrAW++a67zSQmPX5bfVF+csV35Hce2WmFZzNGrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PPbba7SQh/HbpZc2pTcde0XInlM5HbbjFU3jWpyOG2IL5T1mOwECyP8nrKEUmZ40S
         dlHVd0Sc9ee9fgpJomI9TsGb2ec2PkkxW2TNKaIuT7pGcV8UoAfRYiwQepcIF/B+jR
         fd1JyWtXUcxxhbxD5vZ8DUF/dv2OuPH7ohjF+t1M=
Date:   Wed, 7 Sep 2022 07:40:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH 5.15 101/107] kbuild: Unify options for BTF generation
 for vmlinux and modules
Message-ID: <YxguwCpBEKAJJDU6@kroah.com>
References: <20220906132821.713989422@linuxfoundation.org>
 <20220906132826.130642856@linuxfoundation.org>
 <291d739c-752f-ead3-1974-a136b986afb7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <291d739c-752f-ead3-1974-a136b986afb7@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 11:45:00AM -0700, Florian Fainelli wrote:
> 
> 
> On 9/6/2022 6:31 AM, Greg Kroah-Hartman wrote:
> > From: Jiri Olsa <jolsa@redhat.com>
> > 
> > commit e27f05147bff21408c1b8410ad8e90cd286e7952 upstream.
> > 
> > Using new PAHOLE_FLAGS variable to pass extra arguments to
> > pahole for both vmlinux and modules BTF data generation.
> > 
> > Adding new scripts/pahole-flags.sh script that detect and
> > prints pahole options.
> > 
> > [ fixed issues found by kernel test robot ]
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Link: https://lore.kernel.org/bpf/20211029125729.70002-1-jolsa@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   Makefile                  |    3 +++
> >   scripts/Makefile.modfinal |    2 +-
> >   scripts/link-vmlinux.sh   |   11 +----------
> >   scripts/pahole-flags.sh   |   20 ++++++++++++++++++++
> >   4 files changed, 25 insertions(+), 11 deletions(-)
> >   create mode 100755 scripts/pahole-flags.sh
> 
> My linux-stable-rc/linux-5.15.y checkout shows that scripts/pahole-flags.sh
> does not have an executable permission and commit
> 128e3cc0beffc92154d9af6bd8c107f46e830000 ("kbuild: Unify options for BTF
> generation for vmlinux and modules") does have:
> 
> diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
> new file mode 100644
> index 000000000000..e6093adf4c06
> 
> whereas your email does have the proper 100755 permission set on the file,
> any idea what happened here?

Yeah, quilt does not like dealing with file permissions at all :(

We have over time, not required executable permissions on kernel files
because of this issue.  Is it required here?  If so, I'll try to
remember to fix it up "by hand".

thanks,

greg k-h
