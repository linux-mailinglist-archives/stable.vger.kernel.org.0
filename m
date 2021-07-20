Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50903CF4F0
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 08:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbhGTGSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 02:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238298AbhGTGSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 02:18:40 -0400
Received: from icts-p-cavuit-4.kulnet.kuleuven.be (icts-p-cavuit-4.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0F8C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 23:59:18 -0700 (PDT)
X-KULeuven-Envelope-From: mathy.vanhoef@kuleuven.be
X-Spam-Status: not spam, SpamAssassin (cached, score=-51, required 5,
        autolearn=disabled, ALL_TRUSTED -1.00, NICE_REPLY_A -0.00,
        RCVD_SMTPS -50.00, URIBL_BLOCKED 0.00)
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: AF10AF0.A6521
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-0.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:131:242:ac11:33])
        by icts-p-cavuit-4.kulnet.kuleuven.be (Postfix) with ESMTP id AF10AF0
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 08:59:13 +0200 (CEST)
X-CAV-Cluster: smtps
Received: from [192.168.1.17] (unknown [31.215.40.104])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by icts-p-ceifnet-smtps-0.kuleuven.be (Postfix) with ESMTPSA id 426AFD4F0B804;
        Tue, 20 Jul 2021 08:59:12 +0200 (CEST)
Subject: Re: [RFC PATCH 4.4] mac80211: fix handling A-MSDUs that start with an
 RFC 1042 header
To:     "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        yuehaibing <yuehaibing@huawei.com>,
        Zhangjinhao <zhangjinhao2@huawei.com>
References: <dafba7c92a8b434fb5f1644d379af4fd@huawei.com>
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Message-ID: <5a21bfc5-bd36-e1d5-533a-6f3a12bdb1d0@kuleuven.be>
Date:   Tue, 20 Jul 2021 10:59:10 +0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <dafba7c92a8b434fb5f1644d379af4fd@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> Section 3.6 of https://papers.mathyvanhoef.com/usenix2021.pdf briefly
>> discusses the wrong behavior of Linux 4.9+ that this patch tries to fix:
>> "Linux 4.9 and above .. strip away the first 8 bytes of an A-MSDU frame
>> if these bytes look like a valid LLC/SNAP header, and then further
>> process the frame. This behavior is not compliant with the 802.11 standard."
>>
> 
> How about linux 4.9 below, are they compliant  with 802.11 standard or not?

They are compliant.

> Would they need additional patches to mitigate the aggregation attack?

They need the backport of "[PATCH 04/18] cfg80211: mitigate A-MSDU
aggregation attacks" to mitigate attacks. This patch has been backported
to 4.4:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.4.275&id=daea7ff51861cec93ff7f561095d9048b673b51f

So if you take all the patches that have been backported to 4.4 you
should be OK.

Cheers,
Mathy
