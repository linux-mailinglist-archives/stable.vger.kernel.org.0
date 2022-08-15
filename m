Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830DF592F49
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 15:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiHONBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 09:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiHONBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 09:01:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7B9959E
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 06:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC956611D7
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 13:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DA3C433D6;
        Mon, 15 Aug 2022 13:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660568482;
        bh=Mg/1qP/smmuReRmSv6zSMQBGNxdqgLJmf0Xs/2CVdXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1M8E3L+AWPtiK6OVLc/ki8p6nrB3QZ0zJnx6XZxaJotHwpR3Mrt5/K0mc8tEQZkpw
         PAfe6xrRZ3bLt2IpMvTcSRlFjYHPFijCjGvkJBc8J8ynfUMtXEAgHnGB7Va5Tpy+Nk
         VEHD0Yr0+/pMUr++GWeEI2sJFpwpgCF+XDuSHcWs=
Date:   Mon, 15 Aug 2022 15:01:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Viacheslav Sablin <sablin@ispras.ru>
Cc:     stable@vger.kernel.org, Ahmed Zaki <anzaki@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 1/1] mac80211: fix a memory leak where sta_info is
 not freed
Message-ID: <YvpDn9qqS2wee4Ky@kroah.com>
References: <20220809160245.29232-1-sablin@ispras.ru>
 <20220809160245.29232-2-sablin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809160245.29232-2-sablin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 07:02:45PM +0300, Viacheslav Sablin wrote:
> From: Ahmed Zaki <anzaki@gmail.com>
> 
> commit 8f9dcc29566626f683843ccac6113a12208315ca upstream.
> 
> The following is from a system that went OOM due to a memory leak:
> 
> wlan0: Allocated STA 74:83:c2:64:0b:87
> wlan0: Allocated STA 74:83:c2:64:0b:87
> wlan0: IBSS finish 74:83:c2:64:0b:87 (---from ieee80211_ibss_add_sta)
> wlan0: Adding new IBSS station 74:83:c2:64:0b:87
> wlan0: moving STA 74:83:c2:64:0b:87 to state 2
> wlan0: moving STA 74:83:c2:64:0b:87 to state 3
> wlan0: Inserted STA 74:83:c2:64:0b:87
> wlan0: IBSS finish 74:83:c2:64:0b:87 (---from ieee80211_ibss_work)
> wlan0: Adding new IBSS station 74:83:c2:64:0b:87
> wlan0: moving STA 74:83:c2:64:0b:87 to state 2
> wlan0: moving STA 74:83:c2:64:0b:87 to state 3
> .
> .
> wlan0: expiring inactive not authorized STA 74:83:c2:64:0b:87
> wlan0: moving STA 74:83:c2:64:0b:87 to state 2
> wlan0: moving STA 74:83:c2:64:0b:87 to state 1
> wlan0: Removed STA 74:83:c2:64:0b:87
> wlan0: Destroyed STA 74:83:c2:64:0b:87
> 
> The ieee80211_ibss_finish_sta() is called twice on the same STA from 2
> different locations. On the second attempt, the allocated STA is not
> destroyed creating a kernel memory leak.
> 
> This is happening because sta_info_insert_finish() does not call
> sta_info_free() the second time when the STA already exists (returns
> -EEXIST). Note that the caller sta_info_insert_rcu() assumes STA is
> destroyed upon errors.
> 
> Same fix is applied to -ENOMEM.
> 
> Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
> Link: https://lore.kernel.org/r/20211002145329.3125293-1-anzaki@gmail.com
> [change the error path label to use the existing code]
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Viacheslav Sablin <sablin@ispras.ru>
> ---
>  net/mac80211/sta_info.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This is also needed in 5.15.y, so added there as well.  thanks,

greg k-h
