Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71465E98F3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 07:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbiIZFqh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 26 Sep 2022 01:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbiIZFqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 01:46:37 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EB3FBB9;
        Sun, 25 Sep 2022 22:46:33 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 28Q5jmGS3024315, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 28Q5jmGS3024315
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 26 Sep 2022 13:45:48 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 26 Sep 2022 13:45:42 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 26 Sep 2022 13:45:42 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2]) by
 RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2%5]) with mapi id
 15.01.2375.007; Mon, 26 Sep 2022 13:45:42 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Kalle Valo <kvalo@kernel.org>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Bernie Huang <phhuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v6.0-rc] wifi: rtw89: free unused skb to prevent memory leak
Thread-Topic: [PATCH v6.0-rc] wifi: rtw89: free unused skb to prevent memory
 leak
Thread-Index: AQHY0U4EOim9sNze6EW8zSbMJWZSDq3xLqbDgAAEtTA=
Date:   Mon, 26 Sep 2022 05:45:42 +0000
Message-ID: <a72c494ad56c44d0a2a4219d0a671ab5@realtek.com>
References: <20220926021513.5029-1-pkshih@realtek.com>
 <87illa7lkb.fsf@kernel.org>
In-Reply-To: <87illa7lkb.fsf@kernel.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/9/26_=3F=3F_03:21:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> -----Original Message-----
> From: Kalle Valo <kvalo@kernel.org>
> Sent: Monday, September 26, 2022 1:27 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Larry.Finger@lwfinger.net; stable@vger.kernel.org; Bernie Huang <phhuang@realtek.com>;
> linux-wireless@vger.kernel.org
> Subject: Re: [PATCH v6.0-rc] wifi: rtw89: free unused skb to prevent memory leak
> 
> Ping-Ke Shih <pkshih@realtek.com> writes:
> 
> > From: Po-Hao Huang <phhuang@realtek.com>
> >
> > This avoid potential memory leak under power saving mode.
> >
> > Fixes: fc5f311fce74 ("rtw89: don't flush hci queues and send h2c if power is off")
> > Cc: stable@vger.kernel.org
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
> > Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> > Signed-off-by: Kalle Valo <kvalo@kernel.org>
> > Link: https://lore.kernel.org/r/20220916033811.13862-6-pkshih@realtek.com
> > ---
> > Hi Kalle,
> >
> > We want this patch go to v6.0-rc, because it can fix memleak caused by another
> > patch. For users, this driver eats memory and could lead out-of-memory
> > finally.
> >
> > This patch has been merged into wireless-next, but I forget to add "Fixes"
> > tag and Cc stable, so I add them to commit messages. If this works, I will
> > prepare another patch for v5.19.
> 
> -rc7 is already released, so we are quite late in the cycle, and I'm not
> planning to submit another pull request for v6.0 unless something really
> major happens. So I think it's better that you wait for the -next commit
> to reach Linus' tree (should happen in next two weeks or so) and then
> submit a patch to stable releases.
> 

Got it. I will do it weeks later. Thanks.

Ping-Ke

