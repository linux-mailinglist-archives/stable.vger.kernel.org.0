Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4790E4E3B66
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 10:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiCVJFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 05:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiCVJFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 05:05:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB20424A3
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 02:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 357F2B81C16
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 09:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D110C340EC;
        Tue, 22 Mar 2022 09:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647939849;
        bh=rAdir3hSuMDDc4NWjkYfnX62NouGOIG2yE0MKoFz5Oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rdX6ydgmt4Em9QQOJCc8NxdRdHgsjE8xsGEISkAXs46iN0faEGgCWy+sisawMpMRx
         aAqu5QjrvmGHvTjFE4izI/enqr2HBO61mocARwcBGycbya9osViENDQje3/JyUY1yZ
         L60SjSdlWgTAIktRIXz2ceQUeW1uCBtiQjaMSuJs=
Date:   Tue, 22 Mar 2022 09:02:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>, steffen.klassert@secunet.com
Subject: Re: Cherry-pick request to fix CVE-2022-0886 in v5.10 and v5.4
Message-ID: <YjmCh1SPUOJjM7Rf@kroah.com>
References: <CAMVonLjSP4cxtfahDORXG-b6K=ps+wN652hcrxgo70YU+eP5iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVonLjSP4cxtfahDORXG-b6K=ps+wN652hcrxgo70YU+eP5iA@mail.gmail.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 06:49:02PM -0700, Vaibhav Rustagi wrote:
> Hi Greg,
> 
> To fix CVE-2022-0886 in v5.10 and v5.4, we need to cherry-pick the
> commit "esp: Fix possible buffer overflow in ESP transformation"
> (ebe48d368e97d007bfeb76fcb065d6cfc4c96645). The commit didn't apply
> cleanly in v5.10 and v5.4 and therefore, patches for both the kernel
> versions are attached.
> 
> In order to backport the original commit, following changes are done:
> 
>  - v5.10:
>     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> "net/core/sock.c" to "include/net/sock.c"

Did you see that this is already in the 5.10 queue and out for review
right now?  Can you verify that the backport there matches yours?

>  - v5.4:
>     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> "net/core/sock.c" to "include/net/sock.c"
>     - Ignore changes introduced due to `xfrm: add support for UDPv6
> encapsulation of ESP` in esp6_output_head()

Thanks for this one, I'll queue it up after this next round of releases.
What about 4.14 and 4.19?  Will this backport work there?  If not, can
you provide a working one?

thanks,

greg k-h
