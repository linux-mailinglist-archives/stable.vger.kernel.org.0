Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004F1694587
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 13:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBMMNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 07:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjBMMNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 07:13:38 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268371ADD9
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 04:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1676290381; x=1707826381;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=X5wowMEnuJOAuCyELS+uCp9GR7wXZI2zqSWBNFQMQuE=;
  b=AFHOtPJRp7qS5YEH+GONNnHn8LMQljMoRbceMdZ10iuPtaBDGQrJ3ArD
   piugoPwN8aP3jeosVxbXuGbYUFEu3zjX4oPRy90ZwOKF4G69RkxrnrW0H
   e0lxE+MjeZPfT6KO2XmhPJIFTct/78WPuYPLkJmLNE5Hr1W3ykI/hsyQC
   w=;
X-IronPort-AV: E=Sophos;i="5.97,294,1669075200"; 
   d="scan'208";a="262018278"
Subject: Re: [PATCH stable 5.10 0/7] Remove reader optimistic spinning
Thread-Topic: [PATCH stable 5.10 0/7] Remove reader optimistic spinning
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 12:12:00 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id 3857C81680;
        Mon, 13 Feb 2023 12:11:58 +0000 (UTC)
Received: from EX19D046UWA003.ant.amazon.com (10.13.139.18) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 13 Feb 2023 12:11:57 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D046UWA003.ant.amazon.com (10.13.139.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 13 Feb 2023 12:11:56 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d]) by
 EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d%3]) with mapi id
 15.02.1118.024; Mon, 13 Feb 2023 12:11:55 +0000
From:   "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Xu, Shaoying" <shaoyi@amazon.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "longman@redhat.com" <longman@redhat.com>
Thread-Index: AQHZOyam/A8sWjEdc0+KJLYLhkB4y67GboKAgAZj6wA=
Date:   Mon, 13 Feb 2023 12:11:55 +0000
Message-ID: <8E6E1FCA-620A-4556-87A5-1ABB4A936A33@amazon.com>
References: <20230207190135.25258-1-shaoyi@amazon.com>
 <Y+TMvcaArE0M/TnS@kroah.com>
In-Reply-To: <Y+TMvcaArE0M/TnS@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.83.32]
Content-Type: text/plain; charset="utf-8"
Content-ID: <37AF87A8FCF6E04B8C912A4ADC481ACF@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBUaGlzIGlzIGdyZWF0IHRoYXQgeW91IGRpZCB0aGlzIHdvcmsgYW5kIGZvdW5kIHRoaXMgb3V0
LCBidXQgcmVhbGx5LA0KPiBzaG91bGRuJ3QgeW91IGhhdmUgZG9uZSB0aGUgbGVzcyB3b3JrIGFu
ZCBqdXN0IG1vdmVkIHRvIDUuMTUueSBpbnN0ZWFkPw0KPiBZb3UncmUgZ29pbmcgdG8gaGF2ZSB0
byBkbyB0aGF0IGFueXdheSwgd2hhdCdzIHByZXZlbnRpbmcgdGhhdCBmcm9tDQo+IGhhcHBlbmlu
ZyBub3csIHdpdGggdGhlIEhVR0UganVzdGlmaWNhdGlvbiB0aGF0IHlvdSBnZXQgYSBiaWcgd29y
a2xvYWQNCj4gaW5jcmVhc2UgYW5kIHBvd2VyIHNhdmluZ3MgKGkuZS4gcmVhbCBtb25leSk/DQoN
Cg0KDQoNCg0KDQoNCg0KSGV5IEdyZWcsDQoNCg0KDQoNCg0KDQoNCg0KV2UgYXJlIGFjdHVhbGx5
IHNoaXBwaW5nIGtlcm5lbCA1LjE1IGFzIHBhcnQgb2YgQW1hem9uIExpbnV4IGtlcm5lbCByZWxl
YXNlcyBzbyB0aGVvcmV0aWNhbGx5IG1vdmluZyB0byA1LjE1IHNob3VsZCBiZSB0aGUgd2F5IHRv
IGdvIGhvd2V2ZXIgdXN1YWxseSB0aGUgcmVsZXZhbnQgdGVhbXMgdGFrZSBzb21lIHRpbWUgZm9y
IHdvcmtsb2FkIHNwZWNpZmljIHRlc3RpbmcgYW5kIGJlbmNobWFyayBiZWZvcmUgdGhleSBkbyBh
IG1ham9yIHVwZ3JhZGUgbGlrZSBtb3ZpbmcgZnJvbSA1LjEwIHRvIDUuMTUuIFdlIHVzdWFsbHkg
YXNrIHdob2V2ZXIgaXMgcmVwb3J0aW5nIGEgcmVncmVzc2lvbi9idWcva2VybmVsIGVuaGFuY2Vt
ZW50IHRvIHJ1biB3aXRoIHRoZSBsYXRlc3Qga2VybmVsIGFzIHlvdSBzYWlkIHdoaWxlIHNvbWV0
aW1lcyB3ZSBiYWNrcG9ydCBmaXhlcyBpZiB0aGUgcHJvZHVjdGlvbiBtaWdyYXRpb24gdG8gdGhl
IGxhdGVzdCBrZXJuZWwgaXMgc29tZXRoaW5nIHRoYXQgd2lsbCB0YWtlIHRpbWUgZm9yIHRoZSBy
ZWFzb25zIEkgbWVudGlvbmVkIGFib3ZlLiBXZSB0aG91Z2h0IHRoYXQgdGhpcyBwZXJmb3JtYW5j
ZSBpbXByb3ZlbWVudCB3aWxsIGFsc28gYmUgYmVuZWZpY2lhbCBmb3IgTGludXggNS4xMCB1c2Vy
cyBoZW5jZSB3ZSBwcmVmZXJyZWQgdGhlc2UgcGF0Y2hlcyB0byBiZSBtZXJnZWQgdG8gdGhlIHN0
YWJsZSA1LjEwIHJhdGhlciB0aGFuIHVzIGp1c3QgY29uc3VtZSB0aGVtIGFzIGRvd25zdHJlYW0g
cGF0Y2hlcy4gV2UgYXJlIGN1cnJlbnRseSB3b3JraW5nIHdpdGggdGhlIHJlbGV2YW50IHRlYW0g
b24gYSBwbGFuIGZvciB0aGUgcG9zc2libGUgNS4xNSBtaWdyYXRpb24gYXMgYSBsb25nIHRlcm0g
c29sdXRpb24uDQoNCg0KDQoNCg0KDQoNCg0KVGhhbmsgeW91Lg0KDQoNCg0KDQoNCg0KDQoNCkhh
emVtDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCu+7v09uIDA5LzAyLzIwMjMsIDEw
OjM3LCAiR3JlZyBLSCIgPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnIDxtYWlsdG86Z3JlZ2to
QGxpbnV4Zm91bmRhdGlvbi5vcmc+IDxtYWlsdG86Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmcg
PG1haWx0bzpncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4+IDxtYWlsdG86Z3JlZ2toQGxpbnV4
Zm91bmRhdGlvbi5vcmcgPG1haWx0bzpncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gPG1haWx0
bzpncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZyA8bWFpbHRvOmdyZWdraEBsaW51eGZvdW5kYXRp
b24ub3JnPj4+IDxtYWlsdG86Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmcgPG1haWx0bzpncmVn
a2hAbGludXhmb3VuZGF0aW9uLm9yZz4gPG1haWx0bzpncmVna2hAbGludXhmb3VuZGF0aW9uLm9y
ZyA8bWFpbHRvOmdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPj4gPG1haWx0bzpncmVna2hAbGlu
dXhmb3VuZGF0aW9uLm9yZyA8bWFpbHRvOmdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPiA8bWFp
bHRvOmdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnIDxtYWlsdG86Z3JlZ2toQGxpbnV4Zm91bmRh
dGlvbi5vcmc+Pj4+PiB3cm90ZToNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KQ0FV
VElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0
aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNh
biBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCg0KDQoN
Cg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0K
DQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCk9uIFR1ZSwgRmViIDA3LCAyMDIzIGF0
IDA3OjAxOjI4UE0gKzAwMDAsIFNoYW95aW5nIFh1IHdyb3RlOg0KPiBUaGlzIHBhdGNoIHNlcmll
cyBpcyB0byByZW1vdmUgcmVhZGVyIG9wdGltaXN0aWMgc3Bpbm5pbmcgaW4NCj4ga2VybmVsIDUu
MTAgdG8gaW1wcm92ZSB0aGUgTW9uZ29EQiBwZXJmb3JtYW5jZS4gUGVyZm9ybWFuY2UgbWVhc3Vy
ZW1lbnRzDQo+ICgxMCB0aW1lcyBydW5uaW5nIGF2ZXJhZ2Ugb2Ygb3ZlcmFsbCB0aHJvdWdocHV0
IG9wcy9zZWMpIGFyZSB1c2luZw0KPiBNb25nb0RCIDUuMC4xMSBhbmQgWUNTQiBbMV0gbWljcm9i
ZW5jaG1hcmsgd2l0aCB3b3JrbG9hZEEgWzJdIG9uIEFXUyBFQzINCj4gbTUuNHhsYXJnZS9tNmcu
NHhsYXJnZSAoMTYtdkNQVSA2NEdpQi1tZW1vcnkpIGluc3RhbmNlcyB3aXRoIGEgNTEyR0IgRUJT
DQo+IElPMSBkcml2ZSBkaXNrIHdpdGggNTAwMCBJT1BTIGFuZCBzZXBhcmF0aW5nIE1vbmdvREIg
YW5kIFlDU0IgbG9hZCBnZW5lcmF0b3INCj4gb24gMiBpbnN0YW5jZXMgYW5kIHNldHRpbmcgcmVj
b3JkY291bnQ9MjUwMDAwMDAgYW5kIG9wZXJhdGlvbmNvdW50PTEwMDAwMDAwDQo+IHRvIHNlZSB0
aGUgaW1wYWN0cyBvZiB0aGVzZSBjaGFuZ2VzOg0KPg0KPiBCZWZvcmUgLSB2NS4xMC4xNjUga2Vy
bmVsIGluIE9TIEFtYXpvbiBMaW51eCAyDQo+IEFmdGVyIC0gdjUuMTAuMTY1IGtlcm5lbCB3aXRo
IHJlYWRlciBzcGlubmluZyBkaXNhYmxlZCBpbiBPUyBBbWF6b24gTGludXggMg0KPg0KPiB8IEFy
Y2ggfCBJbnN0YW5jZSBUeXBlIHwgQmVmb3JlIHwgQWZ0ZXIgfA0KPiB8LS0tLS0tLS0tKy0tLS0t
LS0tLS0tLS0tLSstLS0tLS0tLS0rLS0tLS0tLS0tfA0KPiB8IHg4Nl82NCB8IG01LjR4bGFyZ2Ug
fCAzNzM2NS40IHwgNDIzNzMuOSB8DQo+IHwtLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tKy0tLS0t
LS0tLSstLS0tLS0tLS18DQo+IHwgYWFyY2g2NCB8IG02Zy40eGxhcmdlIHwgMzM4MjMuMSB8IDQz
MTEzLjcgfA0KPiB8LS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0rLS0tLS0tLS0t
fA0KPg0KPiBJdCBjYW4gYmUgc2VlbiB0aGF0IHRoZSBNb25nb0RCIHRocm91Z2hwdXQgY2FuIGJl
IGltcHJvdmVkIGFyb3VuZCAxMyUgaW4geDg2XzY0DQo+IGFuZCAyNyUgaW4gYWFyY2g2NCBhZnRl
ciBkaXNhYmxpbmcgcmVhZGVyIG9wdGltaXN0aWMgc3Bpbm5pbmcgYW5kIHRoZXNlIHBhdGNoZXMN
Cj4gY2FuIGJlIGFwcGxpZWQgdG8gNS4xMCB3aXRoIG5vIGNvbmZsaWN0IHNvIHdlIHdvbmRlciBp
ZiBpdCdzIHBvc3NpYmxlIHRvIGJhY2twb3J0DQo+IHRoZW0gdG8gc3RhYmxlIDUuMTA/DQoNCg0K
DQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNClRoaXMgaXMsIGZyYW5rbHksIGNyYXp5LiA6KQ0K
DQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQpUaGlzIGlzIGdyZWF0IHRoYXQgeW91IGRp
ZCB0aGlzIHdvcmsgYW5kIGZvdW5kIHRoaXMgb3V0LCBidXQgcmVhbGx5LA0Kc2hvdWxkbid0IHlv
dSBoYXZlIGRvbmUgdGhlIGxlc3Mgd29yayBhbmQganVzdCBtb3ZlZCB0byA1LjE1LnkgaW5zdGVh
ZD8NCllvdSdyZSBnb2luZyB0byBoYXZlIHRvIGRvIHRoYXQgYW55d2F5LCB3aGF0J3MgcHJldmVu
dGluZyB0aGF0IGZyb20NCmhhcHBlbmluZyBub3csIHdpdGggdGhlIEhVR0UganVzdGlmaWNhdGlv
biB0aGF0IHlvdSBnZXQgYSBiaWcgd29ya2xvYWQNCmluY3JlYXNlIGFuZCBwb3dlciBzYXZpbmdz
IChpLmUuIHJlYWwgbW9uZXkpPw0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQpTbyBu
b3cgeW91IGp1c3QgZGVsYXkgdGhlIGluZXZpdGFibGUgYW5kIHNwZW5kIG1vcmUgd29yayBvdmVy
YWxsIChpLmUuDQp0aGUgYmFja3BvcnQgd29yayBub3csIGFuZCB0aGUgNS4xNS55IG1vdmUgbGF0
ZXI/KSBUaGlzIGZlZWxzIGxpa2UgYQ0KYmFkIG1hbmFnZW1lbnQgZGVjaXNpb24gc29tZXdoZXJl
LCB3aG8gZG8gSSBuZWVkIHRvIHRhbGsgdG8gdG8gcmVzb2x2ZQ0KdGhpcz8NCg0KDQoNCg0KDQoN
Cg0KDQoNCg0KDQoNCg0KDQoNCg0KdGhhbmtzLA0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoN
Cg0KDQpncmVnIGstaA0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg0K
DQoNCg0KDQoNCg0KDQoNCg0KDQo=
