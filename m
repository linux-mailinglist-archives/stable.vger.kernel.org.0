Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726363CC2DE
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 14:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhGQMDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 08:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhGQMDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 08:03:23 -0400
X-Greylist: delayed 341 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 17 Jul 2021 05:00:26 PDT
Received: from icts-p-cavspool-1.kulnet.kuleuven.be (icts-p-cavspool-1.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9C8C06175F
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 05:00:26 -0700 (PDT)
Received: from icts-p-cavuit-1.kulnet.kuleuven.be (icts-p-cavuit-1.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:132])
        by icts-p-cavspool-1.kulnet.kuleuven.be (Postfix) with ESMTP id 0233BE98
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 13:54:48 +0200 (CEST)
X-KULeuven-Envelope-From: mathy.vanhoef@kuleuven.be
X-Spam-Status: not spam, SpamAssassin (not cached, score=-51, required 5,
        autolearn=disabled, ALL_TRUSTED -1.00, NICE_REPLY_A -0.00,
        RCVD_SMTPS -50.00, URIBL_BLOCKED 0.00)
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: CA425207EA.A3860
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-0.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:131:242:ac11:33])
        by icts-p-cavuit-1.kulnet.kuleuven.be (Postfix) with ESMTP id CA425207EA
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 13:54:40 +0200 (CEST)
X-CAV-Cluster: smtps
Received: from [192.168.1.16] (unknown [31.215.40.104])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by icts-p-ceifnet-smtps-0.kuleuven.be (Postfix) with ESMTPSA id 570D6D4F0B803;
        Sat, 17 Jul 2021 13:54:39 +0200 (CEST)
Subject: Re: [RFC PATCH 4.4] mac80211: fix handling A-MSDUs that start with an
 RFC 1042 header
To:     Zheng Yejian <zhengyejian1@huawei.com>, gregkh@linuxfoundation.org,
        johannes.berg@intel.com
Cc:     stable@vger.kernel.org, yuehaibing@huawei.com,
        zhangjinhao2@huawei.com
References: <20210716071126.672549-1-zhengyejian1@huawei.com>
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Message-ID: <7272a9da-8cff-a815-963c-a36fc025eda5@kuleuven.be>
Date:   Sat, 17 Jul 2021 15:54:36 +0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716071126.672549-1-zhengyejian1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/16/21 11:11 AM, Zheng Yejian wrote:
> In v4.4, commit e76511a6fbb5 ("mac80211: properly handle A-MSDUs that
> start with an RFC 1042 header") looks like an incomplete backport.
> 
> There is no functional changes in the commit, since
> __ieee80211_data_to_8023() which defined in net/wireless/util.c is
> only called by ieee80211_data_to_8023() and parameter 'is_amsdu' is
> always input as false.

I don't think there's a problem here. The core commit that prevents the
A-MSDU attack is "[PATCH 04/18] cfg80211: mitigate A-MSDU aggregation
attacks":
https://lore.kernel.org/linux-wireless/20210511200110.25d93176ddaf.I9e265b597f2cd23eb44573f35b625947b386a9de@changeid/

That commit states: "for kernel 4.9 and above this patch depends on
"mac80211: properly handle A-MSDUs that start with a rfc1042 header".
Otherwise this patch has no impact and attacks will remain possible."

Put differently, when patching v4.4 there was in fact no need to
backport the patch that we're discussing here. So it makes sense that
the "backported" patches causes no functional changes.

Section 3.6 of https://papers.mathyvanhoef.com/usenix2021.pdf briefly
discusses the wrong behavior of Linux 4.9+ that this patch tries to fix:
"Linux 4.9 and above .. strip away the first 8 bytes of an A-MSDU frame
if these bytes look like a valid LLC/SNAP header, and then further
process the frame. This behavior is not compliant with the 802.11 standard."

That said, I didn't yet run the test tool against a patched 4.4 kernel,
so I hope my understanding of this code in this version is correct.

Best regards,
Mathy
