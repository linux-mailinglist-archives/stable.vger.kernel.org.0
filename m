Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E0A595364
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiHPHH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiHPHHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:07:15 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74517119A71
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 19:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1660617376; x=1692153376;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=ND2gbam0alTuXJxlB5+57LYsyz/5Y7ujBg78TrfdOWY=;
  b=qTw1wHQ13wXD8Px+a+KLeRt6z6G/4GIW/PZiWzEzGqM5uJThO3E5Th1f
   h4gd1PY1Iq8uyAvhEvntsVaBOcIiyHUVaZ/JbfFiiS+8g18Ni2bjUf7Dl
   Stg52imJmRvfKxkxcI3OT9H2RaPVIBQKVzrt5y6pu7pgFLsZDiqGxp1ZZ
   M=;
X-IronPort-AV: E=Sophos;i="5.93,240,1654560000"; 
   d="scan'208";a="1044568585"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 02:36:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com (Postfix) with ESMTPS id 7A148A2774;
        Tue, 16 Aug 2022 02:36:15 +0000 (UTC)
Received: from EX19D004ANA002.ant.amazon.com (10.37.240.153) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 02:36:14 +0000
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19D004ANA002.ant.amazon.com (10.37.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 02:36:13 +0000
Received: from EX19D004ANA001.ant.amazon.com ([fe80::643d:967a:f5ca:396]) by
 EX19D004ANA001.ant.amazon.com ([fe80::643d:967a:f5ca:396%5]) with mapi id
 15.02.1118.012; Tue, 16 Aug 2022 02:36:13 +0000
From:   "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wei Wang <weiwan@google.com>, LemmyHuang <hlm3280@163.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
Subject: Re: [PATCH stable 5.4] Revert "tcp: change pingpong threshold to 3"
Thread-Topic: [PATCH stable 5.4] Revert "tcp: change pingpong threshold to 3"
Thread-Index: AQHYsRjzGl6kf4HprUSAoTvsyc9RsQ==
Date:   Tue, 16 Aug 2022 02:36:13 +0000
Message-ID: <7C2541FE-1DA9-474A-B887-EF434F8EC53F@amazon.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.88.141.180]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DCBF1D692916B44A754CE9E4A66666D@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCkRhdGU6IE1vbiwgMTUgQXVn
IDIwMjIgMTg6NDU6MTIgLTA3MDANCj4gT24gTW9uLCAxNSBBdWcgMjAyMiAyMDo1MToyOSArMDAw
MCBLdW5peXVraSBJd2FzaGltYSB3cm90ZToNCj4gPiBGcm9tOiBXZWkgV2FuZyA8d2Vpd2FuQGdv
b2dsZS5jb20+DQo+ID4NCj4gPiBjb21taXQgNGQ4ZjI0ZWVlZGM1OGQ1Zjg3YjY1MGRkZGE3M2Mx
NmU4YmE1NjU1OSB1cHN0cmVhbS4NCj4gPg0KPiA+IFRoaXMgcmV2ZXJ0cyBjb21taXQgNGE0MWY0
NTNiZWRmZDVlOWNkMDQwYmFkNTA5ZDlkYTQ5ZmViM2UyYy4NCj4gPg0KPiA+IFRoaXMgdG8tYmUt
cmV2ZXJ0ZWQgY29tbWl0IHdhcyBtZWFudCB0byBhcHBseSBhIHN0cmljdGVyIHJ1bGUgZm9yIHRo
ZQ0KPiA+IHN0YWNrIHRvIGVudGVyIHBpbmdwb25nIG1vZGUuIEhvd2V2ZXIsIHRoZSBjb25kaXRp
b24gdXNlZCB0byBjaGVjayBmb3INCj4gPiBpbnRlcmFjdGl2ZSBzZXNzaW9uICJiZWZvcmUodHAt
PmxzbmR0aW1lLCBpY3NrLT5pY3NrX2Fjay5scmN2dGltZSkiIGlzDQo+ID4gamlmZnkgYmFzZWQg
YW5kIG1pZ2h0IGJlIHRvbyBjb2Fyc2UsIHdoaWNoIGRlbGF5cyB0aGUgc3RhY2sgZW50ZXJpbmcN
Cj4gPiBwaW5ncG9uZyBtb2RlLg0KPiA+IFdlIHJldmVydCB0aGlzIHBhdGNoIHNvIHRoYXQgd2Ug
bm8gbG9uZ2VyIHVzZSB0aGUgYWJvdmUgY29uZGl0aW9uIHRvDQo+ID4gZGV0ZXJtaW5lIGludGVy
YWN0aXZlIHNlc3Npb24sIGFuZCBhbHNvIHJlZHVjZSBwaW5ncG9uZyB0aHJlc2hvbGQgdG8gMS4N
Cj4gPg0KPiA+IEZpeGVzOiA0YTQxZjQ1M2JlZGYgKCJ0Y3A6IGNoYW5nZSBwaW5ncG9uZyB0aHJl
c2hvbGQgdG8gMyIpDQo+ID4gUmVwb3J0ZWQtYnk6IExlbW15SHVhbmcgPGhsbTMyODBAMTYzLmNv
bT4NCj4gPiBTdWdnZXN0ZWQtYnk6IE5lYWwgQ2FyZHdlbGwgPG5jYXJkd2VsbEBnb29nbGUuY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFdlaSBXYW5nIDx3ZWl3YW5AZ29vZ2xlLmNvbT4NCj4gPiBB
Y2tlZC1ieTogTmVhbCBDYXJkd2VsbCA8bmNhcmR3ZWxsQGdvb2dsZS5jb20+DQo+ID4gUmV2aWV3
ZWQtYnk6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gPiBMaW5rOiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9yLzIwMjIwNzIxMjA0NDA0LjM4ODM5Ni0xLXdlaXdhbkBnb29n
bGUuY29tDQo+ID4gU2lnbmVkLW9mZi1ieTogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz4NCj4gDQo+IFNob3VsZCB3ZSB3YWl0IGZvciB0aGUgcmVzb2x1dGlvbiBpbiB0aGUgb3JpZ2lu
YWwgdGhyZWFkIGZpcnN0Pw0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2NhNDA4
MjcxLTg3MzAtZWIyYi1mMTJlLTNmNjZkZjJlNjQzYUBrZXJuZWwub3JnLw0KDQpPaCwgSSBtaXNz
ZWQgdGhhdCB0aHJlYWQgYmVpbmcgYWN0aXZlLg0KSSdsbCBrZWVwIGV5ZXMgb24gaXQuDQpUaGFu
ayB5b3UhDQoNCg==
