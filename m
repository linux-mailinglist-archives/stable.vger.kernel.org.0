Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DB96EED79
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 07:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbjDZFQ6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 26 Apr 2023 01:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDZFQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 01:16:57 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7257AE77;
        Tue, 25 Apr 2023 22:16:56 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33Q5GeAS2024798, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33Q5GeAS2024798
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 26 Apr 2023 13:16:40 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 26 Apr 2023 13:16:42 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 26 Apr 2023 13:16:42 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Wed, 26 Apr 2023 13:16:42 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Kalle Valo <kvalo@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtw89: 8852b: adjust quota to avoid SER L1 caused by access null page
Thread-Topic: [PATCH v2] wifi: rtw89: 8852b: adjust quota to avoid SER L1
 caused by access null page
Thread-Index: AQHZd/Hz8jfIqQlRsk2YCNNYFfVAca89Cv/9gAAArBA=
Date:   Wed, 26 Apr 2023 05:16:41 +0000
Message-ID: <b1c5e4f89ba843cd958f569547caa8e5@realtek.com>
References: <20230426034737.24870-1-pkshih@realtek.com>
 <87r0s7teik.fsf@kernel.org>
In-Reply-To: <87r0s7teik.fsf@kernel.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Kalle Valo <kvalo@kernel.org>
> Sent: Wednesday, April 26, 2023 1:10 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: stable@vger.kernel.org; Larry.Finger@lwfinger.net; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH v2] wifi: rtw89: 8852b: adjust quota to avoid SER L1 caused by access null page
> 
> Ping-Ke Shih <pkshih@realtek.com> writes:
> 
> > Though SER can recover this case, traffic can get stuck for a while. Fix it
> > by adjusting page quota to avoid hardware access null page of CMAC/DMAC.
> >
> > Fixes: a1cb097168fa ("wifi: rtw89: 8852b: configure DLE mem")
> > Fixes: 3e870b481733 ("wifi: rtw89: 8852b: add HFC quota arrays")
> > Cc: stable@vger.kernel.org
> > Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Link: https://github.com/lwfinger/rtw89/issues/226#issuecomment-1520776761
> > Link: https://github.com/lwfinger/rtw89/issues/240
> > Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> > ---
> > v2: add Fixes, Cc and Tested-by tags suggested by Larry.
> 
> Should this go to wireless tree for v6.4?
> 

Yes, please take it to v6.4. People can get stable connection with this fix.

Thank you
Ping-Ke

