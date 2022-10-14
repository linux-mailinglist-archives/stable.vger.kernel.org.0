Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D811B5FEA8B
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 10:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJNIaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 04:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJNIaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 04:30:16 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AAD80F61
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GKG45tWTkHdVISELWImwP/L34oAs2dIEUpLDKpMX+rc=; b=SLIdSm3jvrnGVVv5RRixEEn/D9
        fNDnFm/HqZ7+Nr7vuoYJ/GMGahVTVp+otpTraueJkQ5WHCRQOhWuwilvljSHHQ2FTZM/MKMa/qvCT
        AhDHZ0w0pTM07t3UgIDf+6eZjSA7dL34o5Z/g2HukhBgqEgoMKYNb/Daqaz/7p2Gf2x4=;
Received: from p200300daa7301d009c33fd838a6b0e7b.dip0.t-ipconnect.de ([2003:da:a730:1d00:9c33:fd83:8a6b:e7b] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ojG51-00CdVr-Tm; Fri, 14 Oct 2022 10:30:07 +0200
Message-ID: <6a188f0a-f1e9-9974-e8d7-85717f6fa407@nbd.name>
Date:   Fri, 14 Oct 2022 10:30:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 5.15 1/6] mac80211: mesh: clean up rx_bcn_presp API
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, johannes@sipsolutions.net
References: <20221013181601.5712-1-nbd@nbd.name> <Y0kLsThZoDPPENhI@kroah.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <Y0kLsThZoDPPENhI@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.10.22 09:11, Greg KH wrote:
> On Thu, Oct 13, 2022 at 08:15:56PM +0200, Felix Fietkau wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>> 
>> commit a5b983c6073140b624f64e79fea6d33c3e4315a0 upstream.
>> 
>> We currently pass the entire elements to the rx_bcn_presp()
>> method, but only need mesh_config. Additionally, we use the
>> length of the elements to calculate back the entire frame's
>> length, but that's confusing - just pass the length of the
>> frame instead.
>> 
>> Link: https://lore.kernel.org/r/20210920154009.a18ed3d2da6c.I1824b773a0fbae4453e1433c184678ca14e8df45@changeid
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> ---
>>  net/mac80211/ieee80211_i.h |  7 +++----
>>  net/mac80211/mesh.c        |  4 ++--
>>  net/mac80211/mesh_sync.c   | 26 ++++++++++++--------------
>>  3 files changed, 17 insertions(+), 20 deletions(-)
> 
> Many thanks for this series.  Will this also work in 5.4.y and 5.10.y?
No idea. I don't have an environment to test that at the moment.

- Felix

