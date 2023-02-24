Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221DD6A188F
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 10:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjBXJNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 04:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBXJNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 04:13:52 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78446BF
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 01:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=bTAbu8/kNNfHLCD2W2JIAltGDm8o876KTwkjPAmY/6o=; b=fyFF+S/yGDEzuik7wFtxdzg1n8
        tIwtUV7LO9O5pJRZS3xgB4umIgu/HNC3oYlwkKGoIunIoeROTp530Km9Rk9rBTSKTFVi5u/yZivYz
        gfGdZINEu+KsViSc7PAwDD1hhAjOfY54ZKIPI+hrHgfjzdJrAIemwNRilR1rnMiXpR2Jgs4N4SFOx
        jZOW1GVUNtqCmbs2OBXWNJN2CCWDkTDE32dFgshB1rfq4p8ti2e4cUWQKfMbuNXo9Hg8o49UdNXJr
        +gwlAKXQre60w2lONfGm7REZ2KxoNY4SPMorutEkI24xSpbj8dz4h8wlUXJ558MMZ5LitV42dj392
        RJARJtKg==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pVU9C-0002Jq-Te; Fri, 24 Feb 2023 10:13:47 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pVU9C-000TjM-JS; Fri, 24 Feb 2023 10:13:46 +0100
Subject: Re: [PATCH 4.14 6/7] uaccess: Add speculation barrier to
 copy_from_user()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Jordy Zomer <jordyzomer@google.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20230223130423.369876969@linuxfoundation.org>
 <20230223130423.662749238@linuxfoundation.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dfcc6afe-0400-44f9-42b0-005a60c9162e@iogearbox.net>
Date:   Fri, 24 Feb 2023 10:13:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230223130423.662749238@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26821/Thu Feb 23 09:40:35 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 2:04 PM, Greg Kroah-Hartman wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> commit 74e19ef0ff8061ef55957c3abd71614ef0f42f47 upstream.
> 
> The results of "access_ok()" can be mis-speculated.  The result is that
> you can end speculatively:
> 
> 	if (access_ok(from, size))
> 		// Right here
> 
> even for bad from/size combinations.  On first glance, it would be ideal
> to just add a speculation barrier to "access_ok()" so that its results
> can never be mis-speculated.

Keep in mind this also needs commit f3dd0c53370e ("bpf: add missing header file include")
as follow-up everywhere you queue this one.

Thanks,
Daniel
