Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A0C5BFD7D
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 14:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiIUMGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 08:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIUMGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 08:06:33 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F058317A9F;
        Wed, 21 Sep 2022 05:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1663761993; x=1695297993;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=V6DlBSbH7XOlORE4UOwtzqczAWp/nXOw2cK/A0hojOE=;
  b=gb5kY59XUoo2WOoOQeDPLUCgdLKCy9fj4mYDW5wvdNO4MPuDmE895+1y
   V7Zma1IUOII9WebiLk3LkUV8fSe8ouhZhiCCHAjZsDxfJ2yXG2B0or+4r
   9D4L/cbfI5aoSTZ6MoO9QkJA1f/b6EGathSoQZZFL4WB4QsNCKi0/p54r
   0=;
X-IronPort-AV: E=Sophos;i="5.93,333,1654560000"; 
   d="scan'208";a="1056595854"
Subject: Re: Ext4: Buffered random writes performance regression with dioread_nolock
 enabled
Thread-Topic: Ext4: Buffered random writes performance regression with dioread_nolock
 enabled
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-7dac3c4d.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 12:06:15 +0000
Received: from EX13D48EUA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-7dac3c4d.us-east-1.amazon.com (Postfix) with ESMTPS id F12EBE00A9;
        Wed, 21 Sep 2022 12:06:13 +0000 (UTC)
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX13D48EUA002.ant.amazon.com (10.43.165.27) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 21 Sep 2022 12:06:12 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Wed, 21 Sep 2022 12:06:12 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::fd00:35b8:2b90:a79e]) by
 EX19D018EUA004.ant.amazon.com ([fe80::fd00:35b8:2b90:a79e%3]) with mapi id
 15.02.1118.012; Wed, 21 Sep 2022 12:06:12 +0000
From:   "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
To:     Theodore Ts'o <tytso@mit.edu>
CC:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Thread-Index: AQHYzDlvwgCnQNAEFUqstLBpn2SKKq3pJWSAgAC4AQA=
Date:   Wed, 21 Sep 2022 12:06:12 +0000
Message-ID: <5446FC9B-92E6-4423-8BF8-AA1C138B178B@amazon.com>
References: <28460B7B-F66E-4BDC-9F6E-B7E77A3FEE83@amazon.com>
 <Yypx6VQRbl3bFP2v@mit.edu>
In-Reply-To: <Yypx6VQRbl3bFP2v@mit.edu>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.43.166.36]
Content-Type: text/plain; charset="utf-8"
Content-ID: <77F904BBE5213F46AA6BD94F957AFAF9@amazon.com>
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

ICAgPiBTaW5jZSAyMDE2LCB0aGUgY29tbWl0IGJiZDJmNzhjZjYzYSAoImxpYmV4dDJmczogYWxs
b3cgdGhlIGRlZmF1bHQNCiAgICA+IGpvdXJuYWwgc2l6ZSB0byBnbyBhcyBsYXJnZSBhcyBhIGdp
Z2FieXRlIikgaGFzIGJlZW4gaW4gZTJmc3Byb2dzDQogICAgPiB2MS40My4yIGFuZCBuZXdlciAo
dGhlIGN1cnJlbnQgdmVyc2lvbiBvZiBlMmZzcHJvZ3MgdjEuNDYuNTsgdjEuNDMuMg0KICAgID4g
d2FzIHJlbGVhc2VkIGluIFNlcHRlbWJlciAyMDE2LCBzaXggeWVhcnMgYWdvKS4gIA0KICAgDQoN
ClRoYW5rcyBUaGVvIGZvciBzaGFyaW5nIHRoYXQgSSB3aWxsIGxvb2tzIGludG8gdXBkYXRpbmcg
dGhlIGUyZnNwcm9ncyBwYWNrYWdlIEkgYW0gdXNpbmcgdG8gaW5jbHVkZSB0aGF0IGNvbW1pdC4N
Cg0KICA+IFAuUy4gIEknbSBwdXp6bGVkIGJ5IHlvdXIgY29tbWVudCwgIndlIGhhdmUgdG8gbm90
ZSB0aGF0IHRoaXMgc2hvdWxkDQogID4gIGJlIG9ubHkgYmVuZWZpY2lhbCB3aXRoIGV4dGVudC1i
YXNlZCBmaWxlcyIgLS0tIHdoaWxlIHRoaXMgaXMgdHJ1ZSwNCiAgPiB3aHkgZG9lcyB0aGlzIG1h
dHRlcj8gIFVubGVzcyB5b3UncmUgZGVhbGluZyB3aXRoIGFuIGFuY2llbnQgZmlsZQ0KICA+ICBz
eXN0ZW0gdGhhdCB3YXMgb3JpZ2luYWxseSBjcmVhdGVkIGFzIGV4dDIgb3IgZXh0MyBhbmQgdGhl
biBjb252ZXJ0ZWQNCiAgPiB0byBleHQ0LCAqYWxsKiBleHQ0IGZpbGVzIHNob3VsZCBiZSBleHRl
bnQtYmFzZWQuLi4NCg0KWWVzIEkgYW0gdXNpbmcgZXh0NCBGUyBzbyB0aGF0IHNob3VsZG4ndCBi
ZSByZWxldmFudCBpbiBteSBjYXNlIGhlcmUsIEkganVzdCBtZW50aW9uZWQgdGhhdCBiZWNhdXNl
IHRoYXQncyBhbHNvIG1lbnRpb25lZCBpbiBleHQ0IG1vdW50IG9wdGlvbnMgbWFuIHBhZ2UgYXMg
anVzdGlmaWNhdGlvbiBvbiB3aHkgZGlvcmVhZF9sb2NrIGlzIHRoZSBkZWZhdWx0IHNvIHdlIGxp
a2VseSBuZWVkIHRvIHVwZGF0ZSB0aGUgZG9jdW1lbnRhdGlvbnMgYXMgd2VsbC4gaHR0cHM6Ly93
d3cua2VybmVsLm9yZy9kb2MvRG9jdW1lbnRhdGlvbi9maWxlc3lzdGVtcy9leHQ0LnR4dCANCg0K
PiBOb3RlIHRoYXQgZGlvcmVhZF9ub2xvY2sgY29kZSBwYXRoIGlzIG9ubHkgdXNlZCBmb3IgZXh0
ZW50LWJhc2VkIGZpbGVzLg0KPiBCZWNhdXNlIG9mIHRoZSByZXN0cmljdGlvbnMgdGhpcyBvcHRp
b25zIGNvbXByaXNlcyBpdCBpcyBvZmYgYnkgZGVmYXVsdCAoZS5nLiBkaW9yZWFkX2xvY2spLg0K
DQpNeSBsYXN0IHF1ZXN0aW9uIHdvdWxkIGJlIGlzIHRoZSBoaWdoZXIgam91cm5hbGluZyAgb3Zl
cmhlYWQgaXMganVzdGlmaWVkIG9yIGF0IGxlYXN0IGV4cGVjdGVkIHdpdGggZGlvcmVhZF9ub2xv
Y2sgZW5hYmxlZD8gSXMgdGhhdCBjYXVzZWQgYnkgdGhlIGZhY3QgdGhhdCB3ZSBuZWVkIHRvIGFs
bG9jYXRlIHVuaW5pdGlhbGl6ZWQgZXh0ZW50IGJlZm9yZSBidWZmZXIgd3JpdGUgPw0KDQpUaGFu
ayB5b3UuDQoNCkhhemVtDQoNCg0K77u/T24gMjEvMDkvMjAyMiwgMDM6MDgsICJUaGVvZG9yZSBU
cydvIiA8dHl0c29AbWl0LmVkdT4gd3JvdGU6DQoNCiAgICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9y
aWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBs
aW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRl
ciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KDQoNCg0KICAgIE9uIE1vbiwgU2VwIDE5
LCAyMDIyIGF0IDAzOjA2OjQ2UE0gKzAwMDAsIE1vaGFtZWQgQWJ1ZWxmb3RvaCwgSGF6ZW0gd3Jv
dGU6DQogICAgPiBIZXkgVGVhbSwNCiAgICA+DQogICAgPg0KICAgID4gICAqICAgSSBhbSBzZW5k
aW5nIHRoaXMgZS1tYWlsIHRvIHJlcG9ydCBhIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24gdGhhdOKA
mXMgY2F1c2VkIGJ5IGNvbW1pdCAyNDRhZGY2NDI2KGV4dDQ6IG1ha2UgZGlvcmVhZF9ub2xvY2sg
dGhlIGRlZmF1bHQpICwgSSBhbSBsaXN0aW5nIHRoZSBwZXJmb3JtYW5jZSByZWdyZXNzaW9uIHN5
bXB0b21zIGJlbG93ICYgb3VyIGFuYWx5c2lzIGZvciB0aGUgcmVwb3J0ZWQgcmVncmVzc2lvbi4N
Cg0KICAgIFBlcmZvcm1hbmNlIHJlZ3Jlc3Npb25zIGFyZSBhbHdheXMgdHJpY2t5OyBkaW9yZWFk
X25vbG9jayBpbXByb3ZlcyBvbg0KICAgIHNvbWUgd29ya2xvYWRzLCBhbmQgY2FuIGNhdXNlIHJl
Z3Jlc3Npb25zIGZvciBvdGhlcnMuICBJbiB0aGlzDQogICAgcGFydGljdWxhciBjYXNlLCB0aGUg
Y2hvaWNlIHRvIG1ha2UgaXQgdGhlIGRlZmF1bHQgd2FzIHRvIGFsc28gZml4IGENCiAgICBkaXJl
Y3QgSS9PIHZzLiB3cml0ZWJhY2sgcmFjZSB3aGljaCBjYW4gcmVzdWx0IGluIHN0YWxlIGRhdGEg
YmVpbmcNCiAgICByZXZlYWxlZCAod2hpY2ggaXMgYSBzZWN1cml0eSBpc3N1ZSkuDQoNCiAgICBU
aGF0IGJlaW5nIHNhaWQuLi4NCg0KICAgIDEpICBhcyB5b3UndmUgbm90ZWQsIHRoaXMgY29tbWl0
IGhhcyBiZWVuIGFyb3VuZCBzaW5jZSA1LjYuDQoNCiAgICAyKSAgYXMgeW91IG5vdGVkLA0KDQog
ICAgICAgIEluY3JlYXNpbmcgdGhlIGpvdXJuYWwgc2l6ZSBmcm9tIGV4dDQgMTI4IE1pQiB0byAx
R2lCIHdpbGwgYWxzbw0KICAgICAgICBmaXggdGhlIHByb2JsZW0gLg0KDQogICAgU2luY2UgMjAx
NiwgdGhlIGNvbW1pdCBiYmQyZjc4Y2Y2M2EgKCJsaWJleHQyZnM6IGFsbG93IHRoZSBkZWZhdWx0
DQogICAgam91cm5hbCBzaXplIHRvIGdvIGFzIGxhcmdlIGFzIGEgZ2lnYWJ5dGUiKSBoYXMgYmVl
biBpbiBlMmZzcHJvZ3MNCiAgICB2MS40My4yIGFuZCBuZXdlciAodGhlIGN1cnJlbnQgdmVyc2lv
biBvZiBlMmZzcHJvZ3MgdjEuNDYuNTsgdjEuNDMuMg0KICAgIHdhcyByZWxlYXNlZCBpbiBTZXB0
ZW1iZXIgMjAxNiwgc2l4IHllYXJzIGFnbykuICBRdW90aW5nIHRoZSBjb21taXQNCiAgICBkZXNj
cmlwdGlvbjoNCg0KICAgICAgICBSZWNlbnQgcmVzZWFyY2ggaGFzIHNob3duIHRoYXQgZm9yIGEg
bWV0YWRhdGEtaGVhdnkgd29ya2xvYWQsIGEgMTI4IE1CDQogICAgICAgIGlzIGpvdXJuYWwgYmUg
YSBib3R0bGVuZWNrIG9uIEhERCdzLCBhbmQgdGhhdCB0aGUgb3B0aW1hbCBqb3VybmFsIHNpemUN
CiAgICAgICAgaXMgcHJvcG9ydGlvbmFsIHRvIG51bWJlciBvZiB1bmlxdWUgbWV0YWRhdGEgYmxv
Y2tzIHRoYXQgY2FuIGJlDQogICAgICAgIG1vZGlmaWVkIChhbmQgd3JpdHRlbiBpbnRvIHRoZSBq
b3VybmFsKSBpbiBhIDMwIHNlY29uZCB3aW5kb3cuICBPbmUNCiAgICAgICAgZ2lnYWJ5dGUgc2hv
dWxkIGJlIHN1ZmZpY2llbnQgZm9yIG1vc3Qgd29ya2xvYWRzLCB3aGljaCB3aWxsIGJlIHVzZWQN
CiAgICAgICAgZm9yIGZpbGUgc3lzdGVtcyBsYXJnZXIgdGhhbiAxMjggZ2lnYWJ5dGVzLg0KDQog
ICAgU28gdGhpcyBzaG91bGQgbm90IGJlIGEgcHJvYmxlbSBpbiBwcmFjdGljZSwgYW5kIGlmIHRo
ZXJlIGFyZSB1c2Vycw0KICAgIHdobyBhcmUgdXNpbmcgYW50ZWRlbHV2aWFuIHZlcnNpb25zIG9m
IGUyZnNwcm9ncywgb3Igd2hvIGhhdmUgb2xkIGZpbGUNCiAgICBzeXN0ZW1zIHdoaWNoIHdlcmUg
Y3JlYXRlZCBtYW55IHllYXJzIGFnbywgaXQncyBxdWl0ZSBlYXN5IHRvIGFkanVzdA0KICAgIHRo
ZSBqb3VybmFsIHNpemUuICBGb3IgZXhhbXBsZSwgdG8gYWRqdXN0IHRoZSBqb3VybmFsIHRvIGJl
IDJHaUIgKDIwNDgNCiAgICBNaUIpLCBqdXN0IHJ1biB0aGUgY29tbWFuZHM6DQoNCiAgICAgICB0
dW5lMmZzIC1PIF5oYXNfam91cm5hbCAvZGV2L3NkWFgNCiAgICAgICB0dW5lMmZzIC1PIGhhc19q
b3VybmFsIC1KIHNpemU9MjA0OCAvdG1wL3NkWFgNCg0KICAgIEhlbmNlLCBJIGRpc2FncmVlIHRo
YXQgd2Ugc2hvdWxkIHJldmVydCBjb21taXQgMjQ0YWRmNjQyNi4gIEl0IG1heSBiZQ0KICAgIHRo
YXQgZm9yIHlvdXIgd29ya2xvYWQgYW5kIHlvdXIgZmlsZSBzeXN0ZW0gY29uZmlndXJhdGlvbiwg
dXNpbmcgdGhlDQogICAgbW91bnQgb3B0aW9uIG5vZGlvcmVhZF9ub2xvY2sgKG9yIGRpb3JlYWRf
bG9jayksIG1heSBtYWtlIHNlbnNlLiAgQnV0DQogICAgdGhlcmUgd2VyZSBhbHNvIHdvcmtsb2Fk
cyBmb3Igd2hpY2ggdXNpbmcgZGlvcmVhZF9ub2xvY2sgaW1wcm92ZWQNCiAgICBiZW5jaG1hcmsg
bnVtYmVycywgc28gdGhlIHF1ZXN0aW9uIG9mIHdoaWNoIGlzIHRoZSBiZXR0ZXIgZGVmYXVsdCBp
cw0KICAgIG5vdCBhdCBhbGwgb2J2aW91cy4NCg0KICAgIFRoYXQgYmVpbmcgc2FpZCwgSSBkbyBo
YXZlIHBsYW5zIGZvciBhIG5ldyB3cml0ZWJhY2sgc2NoZW1lIHdoaWNoIHdpbGwNCiAgICByZXBs
YWNlIGRpb3JlYWRfbm9sb2NrICphbmQqIGRpb3JlYWRfbG9jaywgYW5kIHdoaWNoIHdpbGwgaG9w
ZWZ1bGx5IGJlDQogICAgZmFzdGVyIHRoYW4gZWl0aGVyIGFwcHJvYWNoLg0KDQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLSBUZWQNCg0KICAgIFAu
Uy4gIEknbSBwdXp6bGVkIGJ5IHlvdXIgY29tbWVudCwgIndlIGhhdmUgdG8gbm90ZSB0aGF0IHRo
aXMgc2hvdWxkDQogICAgYmUgb25seSBiZW5lZmljaWFsIHdpdGggZXh0ZW50LWJhc2VkIGZpbGVz
IiAtLS0gd2hpbGUgdGhpcyBpcyB0cnVlLA0KICAgIHdoeSBkb2VzIHRoaXMgbWF0dGVyPyAgVW5s
ZXNzIHlvdSdyZSBkZWFsaW5nIHdpdGggYW4gYW5jaWVudCBmaWxlDQogICAgc3lzdGVtIHRoYXQg
d2FzIG9yaWdpbmFsbHkgY3JlYXRlZCBhcyBleHQyIG9yIGV4dDMgYW5kIHRoZW4gY29udmVydGVk
DQogICAgdG8gZXh0NCwgKmFsbCogZXh0NCBmaWxlcyBzaG91bGQgYmUgZXh0ZW50LWJhc2VkLi4u
DQoNCg==
