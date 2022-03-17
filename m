Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C85C4DBFC1
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 07:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiCQG6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 02:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiCQG6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 02:58:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DBE1F61E;
        Wed, 16 Mar 2022 23:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A90D3B81E18;
        Thu, 17 Mar 2022 06:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE12C340EC;
        Thu, 17 Mar 2022 06:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647500231;
        bh=LBnh580nwV0ltN6LoEu0IOp5RJOffix+8iZ+wiK40lI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pNazjWB0a0MpP27kfCeo+Ea0zYS4oeEHObXpPY6ngtu3PD76ftt7YkCgOP2/rUooJ
         vMipKNe32BEaaeHDQlSETUknW2GSv9zb1QSkdO/raX287zLLy196xeyeHxIXy8YAA1
         DYzvcbFDLZprTfFzafz6PzA1fxxT1hVYFqhnIAuc=
Date:   Thu, 17 Mar 2022 07:57:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: Add LINUX_VERSION_SUBLEVEL to linux/version.h in LTS
Message-ID: <YjLbvZq780tHNyjG@kroah.com>
References: <016f5ea6-f695-6994-c2ec-35cfef26058a@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <016f5ea6-f695-6994-c2ec-35cfef26058a@hauke-m.de>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 12:15:02AM +0100, Hauke Mehrtens wrote:
> Hi,
> 
> Upstream kernel commit 88a686728b37 ("kbuild: simplify access to the
> kernel's version") [0] extended the Makefile to add the following defines to
> the linux/version.h file:
> #define LINUX_VERSION_MAJOR $(VERSION)
> #define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL)
> #define LINUX_VERSION_SUBLEVEL $(SUBLEVEL)
> 
> I would like to have these defines especially LINUX_VERSION_SUBLEVEL also in
> older stable kernel versions to make it easier for out of tree kernel code
> to detect which version it is compiling against.
> 
> In the Linux drivers backports project [1] we backport the current wifi
> driver to older Linux versions, so someone with an old kernel can use
> current wifi drivers. To make this work we have to know which kernel version
> it is being compiled against. The Makefile has access to the SUBLEVEL
> variable and can also forward it to the C code, but this does not work when
> someone compiles some other driver against the mac80211 subsystem provided
> by backports for example.
> 
> I tried to cherry-pick commit 88a686728b37 to kernel 4.9, but it did not
> apply cleanly. Would it get accepted when I just port the changes in the
> main Makefile to the currently supported LTS kernel versions?
> 
> Hauke
> 
> [0]: https://git.kernel.org/linus/88a686728b3739d3598851e729c0e81f194e5c53
> [1]: https://backports.wiki.kernel.org/index.php/Main_Page
> 
> 
> Here would be my suggestion for kernel 4.9, I haven't tested this yet:
> --- a/Makefile
> +++ b/Makefile
> @@ -1142,7 +1142,10 @@ endef
>  define filechk_version.h
>  	(echo \#define LINUX_VERSION_CODE $(shell                         \
>  	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
> -	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
> +	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) \
> +	echo \#define LINUX_VERSION_MAJOR $(VERSION);                    \
> +	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL);            \
> +	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL)
>  endef
> 
>  $(version_h): $(srctree)/Makefile FORCE

We have been through this before, it is not needed.  See the archives
for the correct solution you should do in your out-of-tree code instead.

thanks,

greg k-h
