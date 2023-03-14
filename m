Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A30D6B93FD
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCNMht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCNMhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:37:48 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C4E9CBCA;
        Tue, 14 Mar 2023 05:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c6ugp8yk90qBFBOURZEX0FVuUoJkue3VYE/5pPyUCFM=; b=FAeJDphW8DKr1sqBJZlirX+YBP
        p0VmtHZqNSr2rUshav7wUohYDkKbeA5qFHbdAo9qsjaKEdc90GUXDIu2HbnAHrIVEIqCBUdj2yxk5
        njxYmFHftlEvq643tNhdsOqGP96NEwKnYkwKwgwGVPbOpQMKkm0z7mWMKWO1imZFA5jA=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pc3sw-001s0y-Jt; Tue, 14 Mar 2023 13:36:10 +0100
Message-ID: <4b72607d-6db1-5e53-4ee2-30a829cd12c4@nbd.name>
Date:   Tue, 14 Mar 2023 13:36:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH] wifi: mac80211: Serialize calls to drv_wake_tx_queue()
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, Thomas Mann <rauchwolke@gmx.net>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <20230313201542.72325-1-alexander@wetzel-home.de>
 <130d44bccb317cc82d57caf5b8ca1471fe0faed4.camel@sipsolutions.net>
 <55ede120-b055-e834-e617-fe3069227652@wetzel-home.de>
 <519b5bb9-8899-ae7c-4eff-f3116cdfdb56@nbd.name>
 <067780600cd56014c3c820117d139ddb1c352b28.camel@sipsolutions.net>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <067780600cd56014c3c820117d139ddb1c352b28.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.03.23 13:32, Johannes Berg wrote:
> On Tue, 2023-03-14 at 13:28 +0100, Felix Fietkau wrote:
>> If you want to address this in the least invasive way, add [...],
>> a global lock to iwlwifi
>> 
> 
> I'm already fixing this, see
> https://lore.kernel.org/r/5674c40151267fea1333f0eda1701b141bbaa170.camel@sipsolutions.net
> 
>> , and a 
>> per-AC lock inside ieee80211_handle_wake_tx_queue().
> 
> I'm not *entirely* sure per AC is sufficient given that you could
> technically map two ACs to the same HW queue with vif->hw_queue[]?
> 
> But again, not really sure all that complexity is still worth it.
Per AC should be sufficient even in that case, because scheduling 
happens per AC regardless of vif hw queue mapping.

- Felix

