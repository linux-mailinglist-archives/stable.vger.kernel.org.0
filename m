Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80714E26D8
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 13:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347546AbiCUMsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 08:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347557AbiCUMsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 08:48:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D412299EF6;
        Mon, 21 Mar 2022 05:46:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C9A86111E;
        Mon, 21 Mar 2022 12:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76986C340ED;
        Mon, 21 Mar 2022 12:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647866810;
        bh=5xsO5PlOKsuwyyH0hMupPEGOh1Go9RYj9LF0uAQGAM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OIa9XeUNP8p6CzXNF5So9Lmi/AIc0Lbc+McDHJpq7slJtWGjmQZ0M13NVeh0mWumc
         Ap+z3AY/YITQtPsGNvb9EYjsZxGamAUJlLqc5+7aOUaekxHaKfYMa42z9monbTT2Hn
         t2T39y+R2pC/IBQubOgVum/4cJhzqRDfkxYPSTWc=
Date:   Mon, 21 Mar 2022 13:46:40 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "memxor@gmail.com" <memxor@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>
Subject: Re: [PATCH 5.4 21/43] selftests/bpf: Add test for bpf_timer
 overwriting crash
Message-ID: <YjhzsKYWXw0/Zy0z@kroah.com>
References: <20220314112734.415677317@linuxfoundation.org>
 <20220314112735.013019647@linuxfoundation.org>
 <a0a7298ca5c64b3d0ecfcc8821c2de79186fa9f7.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0a7298ca5c64b3d0ecfcc8821c2de79186fa9f7.camel@nokia.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 07:27:07AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> On Mon, 2022-03-14 at 12:53 +0100, Greg Kroah-Hartman wrote:
> > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > 
> > [ Upstream commit a7e75016a0753c24d6c995bc02501ae35368e333 ]
> > 
> > Add a test that validates that timer value is not overwritten when doing
> > a copy_map_value call in the kernel. Without the prior fix, this test
> > triggers a crash.
> > 
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > Link: https://lore.kernel.org/bpf/20220209070324.1093182-3-memxor@gmail.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hi, this patch in 5.4.185 breaks bpf selftests build for me:
> 
>   progs/timer_crash.c:3:10: fatal error: 'vmlinux.h' file not found
>   #include <vmlinux.h>
>            ^~~~~~~~~~~
> 
> Based on quick look, vmlinux.h generation was added to selftests in v5.7,
> so drop this patch in v5.4?

Now reverted, thanks!

greg k-h
