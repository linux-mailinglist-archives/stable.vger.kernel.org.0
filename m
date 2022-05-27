Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD7053678F
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 21:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354480AbiE0Tjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 15:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352079AbiE0Tjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 15:39:41 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7251AEE10
        for <stable@vger.kernel.org>; Fri, 27 May 2022 12:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1653680379; x=1685216379;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=uK2jGjuC5lJCm7bWN8nmrDtBxPbhq/d3eZUMRov723A=;
  b=K0EEH7Yb0Tu/xMu/yi3CI8H0/p+4M6ktGNzu1EdYlV+T5nKoOuNfSATg
   5tolkOrIvEDbTGW65dMV+FQKRCyTtj9IY7S0wxJ2yyZ5klydDqUej64J5
   KU5HtsUBTFOdzpeCTx8Erwd0vMrSkVscpm1gocodP+RAT45BMuFRRubIC
   8=;
X-IronPort-AV: E=Sophos;i="5.91,256,1647302400"; 
   d="scan'208";a="1019619774"
Subject: Re: [PATCH] nfsd: destroy percpu stats counters after reply cache #5.11.0-rc5
Thread-Topic: [PATCH] nfsd: destroy percpu stats counters after reply cache #5.11.0-rc5
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 27 May 2022 19:39:37 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id 5B74A81000;
        Fri, 27 May 2022 19:39:37 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 27 May 2022 19:39:36 +0000
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13d01UWA002.ant.amazon.com (10.43.160.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 27 May 2022 19:39:36 +0000
Received: from EX13D01UWA002.ant.amazon.com ([10.43.160.74]) by
 EX13d01UWA002.ant.amazon.com ([10.43.160.74]) with mapi id 15.00.1497.036;
 Fri, 27 May 2022 19:39:36 +0000
From:   "Schroeder, Julian" <jumaco@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Thread-Index: AQHYcPmYYwP7PR5610ygZphXVCOQwK0yzTiA
Date:   Fri, 27 May 2022 19:39:36 +0000
Message-ID: <08D60925-9EF7-4A3A-852F-5F6B8FF23AE6@amazon.com>
References: <20220523211152.GB23843@dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com>
 <Yo9t7Whg/XGa/jmb@kroah.com>
In-Reply-To: <Yo9t7Whg/XGa/jmb@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.26]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5C9756F7DED82409A08D827B5784E85@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-12.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlIHBhdGNoIG1hZGUgaXQgaW50byBsaW51eCBuZXh0LiBjb21taXQgZmQ1ZTM2M2VhYzc3ZS4N
Ckkgc2VudCB0aGUgcGF0Y2ggdG8gc3RhYmxlIGFnYWluIHZpYSBnaXQgc2VuZC1lbWFpbC4NClRo
YW5rcywNCmp1bGlhbg0KDQoNCg==
