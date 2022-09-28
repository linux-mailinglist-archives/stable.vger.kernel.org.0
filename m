Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F005ED47E
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 08:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiI1GIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 02:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiI1GIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 02:08:05 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACF811E5F9;
        Tue, 27 Sep 2022 23:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664345284; x=1695881284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hfA/jIQuPF2pQ333V4cR6Us72NBdPgNuEDPxXQyF/Wo=;
  b=ENz36AyB7LTJX/1Z6V3I70UsAowXLIJXoMGK/+EbQgfoCWKxNdo49rvY
   hnqJR9xwnwg2krrRf61i71mdCXQ/h1JY7zveCleKv4ns/EVOjQJjbR6rR
   yMCvRobi7L4GEuv29YM4x0i4ivj71z+00xCL1KAaCeS5OnIbl3toB+qJr
   Q=;
X-IronPort-AV: E=Sophos;i="5.93,351,1654560000"; 
   d="scan'208";a="134739786"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 06:07:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 2C60E4597E;
        Wed, 28 Sep 2022 06:07:37 +0000 (UTC)
Received: from EX13D23UWC002.ant.amazon.com (10.43.162.22) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 28 Sep 2022 06:07:34 +0000
Received: from EX19D017UWC003.ant.amazon.com (10.13.139.227) by
 EX13D23UWC002.ant.amazon.com (10.43.162.22) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 28 Sep 2022 06:07:34 +0000
Received: from EX19D017UWC003.ant.amazon.com ([fe80::78e9:1d67:81fd:68c5]) by
 EX19D017UWC003.ant.amazon.com ([fe80::78e9:1d67:81fd:68c5%6]) with mapi id
 15.02.1118.012; Wed, 28 Sep 2022 06:07:34 +0000
From:   "Lu, Davina" <davinalu@amazon.com>
To:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
        hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
CC:     "Kiselev, Oleg" <okiselev@amazon.com>,
        "Liu, Frank" <franklmz@amazon.com>
Subject: significant drop  fio IOPS performance on v5.10
Thread-Topic: significant drop  fio IOPS performance on v5.10
Thread-Index: AdjO5vTzPItE0he4TsCHXHwBRGK6iAB1NzvQAJElJTA=
Date:   Wed, 28 Sep 2022 06:07:34 +0000
Message-ID: <5c819c9d6190452f9b10bb78a72cb47f@amazon.com>
References: <357ace228adf4e859df5e9f3f4f18b49@amazon.com>
 <1cdc68e6a98d4e93a95be5d887bcc75d@amazon.com>
In-Reply-To: <1cdc68e6a98d4e93a95be5d887bcc75d@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.43.162.55]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpIZWxsbywNCg0KSSB3YXMgcHJvZmlsaW5nIHRoZSA1LjEwIGtlcm5lbCBhbmQgY29tcGFyaW5n
IGl0IHRvIDQuMTQuICBPbiBhIHN5c3RlbSB3aXRoIDY0IHZpcnR1YWwgQ1BVcyBhbmQgMjU2IEdp
QiBvZiBSQU0sIEkgYW0gb2JzZXJ2aW5nIGEgc2lnbmlmaWNhbnQgZHJvcCBpbiBJTyBwZXJmb3Jt
YW5jZS4gVXNpbmcgdGhlIGZvbGxvd2luZyBGSU8gd2l0aCB0aGUgc2NyaXB0ICJzdWRvIGZ0ZXN0
X3dyaXRlLnNoIDxkZXZfbmFtZT4iIGluIGF0dGFjaG1lbnQsIEkgc2F3IEZJTyBpb3BzIHJlc3Vs
dCBkcm9wIGZyb20gMjJLIHRvIGxlc3MgdGhhbiAxSy4gDQpUaGUgc2NyaXB0IHNpbXBseSBkb2Vz
OiBtb3VudCBhIHRoZSBFWFQ0IDE2R2lCIHZvbHVtZSB3aXRoIG1heCBJT1BTIDY0MDAwSywgbW91
bnRpbmcgb3B0aW9uIGlzICIgLW8gbm9hdGltZSxub2RpcmF0aW1lLGRhdGE9b3JkZXJlZCIsIHRo
ZW4gcnVuIGZpbyB3aXRoIDIwNDggZmlvIHdyaW5nIHRocmVhZCB3aXRoIDI4ODAwMDAwIGZpbGUg
c2l6ZSB3aXRoIHsgLS1uYW1lPTE2a2JfcmFuZF93cml0ZV9vbmx5XzIwNDhfam9icyAtLWRpcmVj
dG9yeT0vcmRzZGJkYXRhMSAtLXJ3PXJhbmR3cml0ZSAtLWlvZW5naW5lPXN5bmMgLS1idWZmZXJl
ZD0xIC0tYnM9MTZrIC0tbWF4LWpvYnM9MjA0OCAtLW51bWpvYnM9MjA0OCAtLXJ1bnRpbWU9NjAg
LS10aW1lX2Jhc2VkIC0tdGhyZWFkIC0tZmlsZXNpemU9Mjg4MDAwMDAgLS1mc3luYz0xIC0tZ3Jv
dXBfcmVwb3J0aW5nIH0uDQoNCk15IGFuYWx5emluZyBpcyB0aGF0IHRoZSBkZWdyYWRhdGlvbiBp
cyBpbnRyb2R1Y2UgYnkgY29tbWl0IHsyNDRhZGY2NDI2ZWUzMWE4M2YzOTdiNzAwZDk2NGNmZjEy
YTI0N2QzfSBhbmQgdGhlIGlzc3VlIGlzIHRoZSBjb250ZW50aW9uIG9uIHJzdl9jb252ZXJzaW9u
X3dxLiAgVGhlIHNpbXBsZXN0IG9wdGlvbiBpcyB0byBpbmNyZWFzZSB0aGUgam91cm5hbCBzaXpl
LCBidXQgdGhhdCBpbnRyb2R1Y2VzIG1vcmUgb3BlcmF0aW9uYWwgY29tcGxleGl0eS4gIEFub3Ro
ZXIgb3B0aW9uIGlzIHRvIGFkZCB0aGUgZm9sbG93aW5nIGNoYW5nZSBpbiBhdHRhY2htZW50ICJh
bGxvdyBtb3JlIGV4dDQtcnN2LWNvbnZlcnNpb24gd29ya3F1ZXVlLnBhdGNoIg0KDQpGcm9tIDI3
ZTFiMGUxNDI3NWEyODFiMzUyOWY2YTYwYzdiMjNhODEzNTY3NTEgTW9uIFNlcCAxNyAwMDowMDow
MCAyMDAxDQpGcm9tOiBkYXZpbmFsdSA8ZGF2aW5hbHVAYW1hem9uLmNvbT4NCkRhdGU6IEZyaSwg
MjMgU2VwIDIwMjIgMDA6NDM6NTMgKzAwMDANClN1YmplY3Q6IFtQQVRDSF0gYWxsb3cgbW9yZSBl
eHQ0LXJzdi1jb252ZXJzaW9uIHdvcmtxdWV1ZSB0byBzcGVlZHVwIGZpbyAgd3JpdGluZw0KLS0t
DQogZnMvZXh0NC9zdXBlci5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9zdXBlci5jIGIvZnMvZXh0
NC9zdXBlci5jIGluZGV4IGEwYWY4MzNmN2RhNy4uNmIzNDI5OGNkYzNiIDEwMDY0NA0KLS0tIGEv
ZnMvZXh0NC9zdXBlci5jDQorKysgYi9mcy9leHQ0L3N1cGVyLmMNCkBAIC00OTYzLDcgKzQ5NjMs
NyBAQCBzdGF0aWMgaW50IGV4dDRfZmlsbF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCB2
b2lkICpkYXRhLCBpbnQgc2lsZW50KQ0KICAgICAgICAgKiBjb25jdXJyZW5jeSBpc24ndCByZWFs
bHkgbmVjZXNzYXJ5LiAgTGltaXQgaXQgdG8gMS4NCiAgICAgICAgICovDQogICAgICAgIEVYVDRf
U0Ioc2IpLT5yc3ZfY29udmVyc2lvbl93cSA9DQotICAgICAgICAgICAgICAgYWxsb2Nfd29ya3F1
ZXVlKCJleHQ0LXJzdi1jb252ZXJzaW9uIiwgV1FfTUVNX1JFQ0xBSU0gfCBXUV9VTkJPVU5ELCAx
KTsNCisgICAgICAgICAgICAgICBhbGxvY193b3JrcXVldWUoImV4dDQtcnN2LWNvbnZlcnNpb24i
LCBXUV9NRU1fUkVDTEFJTSB8IA0KKyBXUV9VTkJPVU5EIHwgX19XUV9PUkRFUkVELCAwKTsNCiAg
ICAgICAgaWYgKCFFWFQ0X1NCKHNiKS0+cnN2X2NvbnZlcnNpb25fd3EpIHsNCiAgICAgICAgICAg
ICAgICBwcmludGsoS0VSTl9FUlIgIkVYVDQtZnM6IGZhaWxlZCB0byBjcmVhdGUgd29ya3F1ZXVl
XG4iKTsNCiAgICAgICAgICAgICAgICByZXQgPSAtRU5PTUVNOw0KDQpNeSB0aG91Z2h0IGlzOiBJ
ZiB0aGUgbWF4X2FjdGl2ZSBpcyAxLCBpdCBtZWFucyB0aGUgIl9fV1FfT1JERVJFRCIgY29tYmlu
ZWQgd2l0aCBXUV9VTkJPVU5EIHNldHRpbmcsIGJhc2VkIG9uIGFsbG9jX3dvcmtxdWV1ZSgpLiBT
byBJIGFkZGVkIGl0IC4NCkkgYW0gbm90IHN1cmUgc2hvdWxkIHdlIG5lZWQgIl9fV1FfT1JERVJF
RCIgb3Igbm90PyB3aXRob3V0ICJfX1dRX09SREVSRUQiIGl0IGxvb2tzIGFsc28gd29yayBhdCBt
eSB0ZXN0YmVkLCBidXQgSSBhZGRlZCBzaW5jZSBub3QgbXVjaCBmaW8gVFAgZGlmZmVyZW5jZSBv
biBteSB0ZXN0YmVkIHJlc3VsdCB3aXRoL291dCAiX19XUV9PUkRFUkVEIi4NCg0KRnJvbSBNeSB1
bmRlcnN0YW5kaW5nIGFuZCBvYnNlcnZhdGlvbjogd2l0aCBkaW9yZWFkX3VubG9jayBhbmQgZGVs
YXlfYWxsb2MgYm90aCBlbmFibGVkLCAgdGhlICBiaW9fZW5kaW8oKSBhbmQgZXh0NF93cml0ZXBh
Z2VzKCkgd2lsbCB0cmlnZ2VyIHRoaXMgd29yayBxdWV1ZSB0byBleHQ0X2RvX2ZsdXNoX2NvbXBs
ZXRlZF9JTygpLiBMb29rcyBsaWtlIHRoZSB3b3JrIHF1ZXVlIGlzIGFuIG9uZS1ieS1vbmUgdXBk
YXRpbmc6IGF0IEVYVDQgZXh0ZW5kLmMgaW9fZW5kLT5saXN0X3ZlYyAgbGlzdCBvbmx5IGhhdmUg
b25lIGlvX2VuZF92ZWMgZWFjaCB0aW1lLiBTbyBpZiB0aGUgQklPIGhhcyBoaWdoIHBlcmZvcm1h
bmNlLCBhbmQgd2UgaGF2ZSBvbmx5IG9uZSB0aHJlYWQgdG8gZG8gRVhUNCBmbHVzaCB3aWxsIGJl
IGFuIGJvdHRsZW5lY2sgaGVyZS4gVGhlICJleHQ0LXJzdi1jb252ZXJzaW9uIiB0aGlzIHdvcmtx
dWV1ZSBpcyBtYWlubHkgZm9yIHVwZGF0ZSB0aGUgRVhUNF9JT19FTkRfVU5XUklUVEVOIGV4dGVu
ZCBibG9jayhvbmx5IGV4aXN0IG9uIGRpb3JlYWRfdW5sb2NrIGFuZCBkZWxheV9hbGxvYyBvcHRp
b25zIGFyZSBzZXQpIGFuZCBleHRlbmQgc3RhdHVzICBpZiBJIHVuZGVyc3RhbmQgY29ycmVjdGx5
IGhlcmUuIEFtICBJIGNvcnJlY3Q/DQoNClRoaXMgd29ya3Mgb24gbXkgdGVzdCBzeXN0ZW0gYW5k
IHBhc3NlcyB4ZnN0ZXN0cywgYnV0ICB3aWxsIHRoaXMgY2F1c2UgYW55IGNvcnJ1cHRpb24gb24g
ZXh0NCBleHRlbmRzIGJsb2NrcyB1cGRhdGVzLCBub3QgZXZlbiBzdXJlIGFib3V0IHRoZSBqb3Vy
bmFsIHRyYW5zYWN0aW9uIHVwZGF0ZXMgZWl0aGVyPw0KQ2FuIHlvdSB0ZWxsIG1lIHdoYXQgSSB3
aWxsIGJyZWFrIGlmIHRoaXMgY2hhbmdlIGlzIG1hZGU/DQoNClRoYW5rcw0KRGF2aW5hDQoNCg==
