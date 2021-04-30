Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620B336FD49
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhD3PFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 11:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhD3PFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 11:05:17 -0400
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F02C06138B;
        Fri, 30 Apr 2021 08:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=skogtun.org
        ; s=ds202012; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aPSY+RLSm4RP1U8eAbHWdB5pfF/zZR6OtXxIGIA9qsE=; b=rXxYWHtmgmn9o7WuMZIQuNuybH
        RtcgCifXfMD6EBO3Ww9covJ2KzZIPAraFwwuMDJA9bfQeW8w7ZPD1smaXqh8oOp90eY7d4TEwEjA4
        CeVDmI0ZW24M4+lbikG4SZTkxARRjd46gexpYxBeWz35U8VAZtPq7+uSFqKoBxTjeDYcrXx1HizOS
        XRtxNWK9+pSaLxdPlRqj9rUxGnF/55e0/NcB9u8ed+YFVmqMfK66pf8SMq8etDCfUhJ9ec4fjWhox
        akMzA/ZLQWNuu2Gu5IEMW05sImbN1RjHtrmThITjdS9WYbYJsh9iOeLXhq9yIe1WIyEQgd9A7Q/qT
        eid13bhg==;
Received: from [2a01:79c:cebf:7fb0::17] (port=50862)
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <harald@skogtun.org>)
        id 1lcUgr-00010V-Kg; Fri, 30 Apr 2021 17:04:25 +0200
Subject: Re: [PATCH 5.12 4/5] cfg80211: fix locking in netlink owner interface
 destruction
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20210430141910.899518186@linuxfoundation.org>
 <20210430141911.033571444@linuxfoundation.org>
From:   Harald Arnesen <harald@skogtun.org>
Message-ID: <1669b7da-173b-c5d5-efd3-72ca64a3e221@skogtun.org>
Date:   Fri, 30 Apr 2021 17:04:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210430141911.033571444@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman [30.04.2021 16:20]:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> commit ea6b2098dd02789f68770fd3d5a373732207be2f upstream.
> 
> Harald Arnesen reported [1] a deadlock at reboot time, and after
> he captured a stack trace a picture developed of what's going on:
> 
> The distribution he's using is using iwd (not wpa_supplicant) to
> manage wireless. iwd will usually use the "socket owner" option
> when it creates new interfaces, so that they're automatically
> destroyed when it quits (unexpectedly or otherwise). This is also
> done by wpa_supplicant, but it doesn't do it for the normal one,
> only for additional ones, which is different with iwd.

I just want to point out that the distribution (Void Linux) can use
either wpa_supplicant or iwd. I just happened to use iwd on this machine.
-- 
Hilsen Harald
