Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA146679842
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjAXMnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbjAXMnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:43:20 -0500
Received: from ns2.wdyn.eu (ns2.wdyn.eu [IPv6:2a03:4000:40:5b2::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CED0244BF1;
        Tue, 24 Jan 2023 04:43:18 -0800 (PST)
Message-ID: <b277fe42-4241-9000-17e7-8be7f65680b2@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1674564197;
        bh=7NVmxZ1R+2ahOVxfbhqsdoAG0FsdNmcjeYS6okXWCQ0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=f+tjETaoyttT4Qc1fvn2n0nF/9jHVFugqO1WL+ag/e8RLKytS1u5d9pGMqVPo4CgQ
         fJmFRcX6M+3TfHKhtwr+BvawlcfXI0lH4NBdQXQKnWLIZPQZSPvIDq0yj6AwENvh75
         zlDbEhGpG/497UHBAkeDcJ88ajPLz7M/piCGpNTk=
Date:   Tue, 24 Jan 2023 13:43:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] wifi: cfg80211: Fix use after free for wext
Content-Language: en-US
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
References: <20230124114515.186771-1-alexander@wetzel-home.de>
From:   Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <20230124114515.186771-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.01.23 12:45, Alexander Wetzel wrote:
> Key information in wext.connect is not reset on (re)connect and can hold
> data from a previous connection.
> 
> Reset key data to avoid that drivers or mac80211 incorrectly detect a
> WEP connection request and access the freed or already reused memory.
> 
> Additionally optimize cfg80211_sme_connect() and avoid an useless
> schedule of conn_work.
> 
> Fixes: fffd0934b939 ("cfg80211: rework key operation")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/c80f04d2-8159-a02a-9287-26e5ec838826@wetzel-home.de
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>

Send out an outdated version. Still does the job but I'll send a v2.
Which will reset more key data and updates the comment.

Alexander

