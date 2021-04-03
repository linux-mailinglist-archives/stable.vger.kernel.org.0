Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACEF3534C2
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbhDCQjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 12:39:41 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:30987 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236792AbhDCQjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 12:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617467979; x=1649003979;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=3wIyWtKaelGPnmWxW+x51FMMD1lPVDjnSCkQzPbc57Y=;
  b=A+Ivu1aojdw65aTk7IGYjwHkuFF8ZLMyYL755ON/JaYgF4XWntmtu5rt
   rbGXJqK5f+fCwhAWxxOdVjZwiSlivSLozebTKa1Um5Fx7b4siokGvkHVx
   c7oxe+tO3nZnmO0De4otp3PVANyur4dtrvduuqGhJmeR7rF6Ntxa/JYnA
   4=;
X-IronPort-AV: E=Sophos;i="5.81,302,1610409600"; 
   d="scan'208";a="125002273"
Subject: Re: [PATCH 4.14 2/5] mm: memcg: make sure memory.events is uptodate when
 waking pollers
Thread-Topic: [PATCH 4.14 2/5] mm: memcg: make sure memory.events is uptodate when waking
 pollers
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 03 Apr 2021 16:39:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id D63B2A1E35;
        Sat,  3 Apr 2021 16:39:36 +0000 (UTC)
Received: from EX13D13UWB002.ant.amazon.com (10.43.161.21) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 3 Apr 2021 16:39:35 +0000
Received: from EX13D13UWB002.ant.amazon.com (10.43.161.21) by
 EX13D13UWB002.ant.amazon.com (10.43.161.21) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 3 Apr 2021 16:39:36 +0000
Received: from EX13D13UWB002.ant.amazon.com ([10.43.161.21]) by
 EX13D13UWB002.ant.amazon.com ([10.43.161.21]) with mapi id 15.00.1497.012;
 Sat, 3 Apr 2021 16:39:36 +0000
From:   "van der Linden, Frank" <fllinden@amazon.com>
To:     Greg KH <greg@kroah.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Thread-Index: AQHXJZEuxmCsB/wvhEyvYN2yvz9Wn6qigYYAgAAN24A=
Date:   Sat, 3 Apr 2021 16:39:36 +0000
Message-ID: <B1CF95C1-6777-471A-807D-BAED48F9809B@amazon.com>
References: <20210330181910.15378-1-fllinden@amazon.com>
 <20210330181910.15378-3-fllinden@amazon.com> <YGgsOHbKcHucnAlG@kroah.com>
In-Reply-To: <YGgsOHbKcHucnAlG@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.65]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF647175830A5644A4AB502FEA22AF56@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TG9va3MgbGlrZSBJIHBhc3RlZCB0aGUgd3JvbmcgY29tbWl0IGlkIHRoZXJlIC0gcHJvYmFibHkg
dGhlIG9uZSBpbiBteSBvd24gNC4xNC1zdGFibGUgdHJlZS4gSSBzZWUgdGhhdCB5b3UgZml4ZWQg
aXQgLSB0aGFua3MhDQoNCg0K77u/T24gNC8zLzIxLCAxOjUxIEFNLCAiR3JlZyBLSCIgPGdyZWdA
a3JvYWguY29tPiB3cm90ZToNCg0KICAgIENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBm
cm9tIG91dHNpZGUgb2YgdGhlIG9yZ2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBrbm93
IHRoZSBjb250ZW50IGlzIHNhZmUuDQoNCg0KDQogICAgT24gVHVlLCBNYXIgMzAsIDIwMjEgYXQg
MDY6MTk6MDdQTSArMDAwMCwgRnJhbmsgdmFuIGRlciBMaW5kZW4gd3JvdGU6DQogICAgPiBGcm9t
OiBKb2hhbm5lcyBXZWluZXIgPGhhbm5lc0BjbXB4Y2hnLm9yZz4NCiAgICA+DQogICAgPiBjb21t
aXQgMmQ5Nzg4MDZkODYzZTkyNjM0NTE4NWQwODRhOTBhNGMzNTg0NmUzNyB1cHN0cmVhbS4NCg0K
ICAgIFRoaXMgaXMgbm90IGEgdmFsaWQgZ2l0IGlkIGluIExpbnVzJ3MgdHJlZSwgb3IgYW55d2hl
cmUgZWxzZSB0aGF0IEkgY2FuDQogICAgZmluZCA6KA0KDQogICAgSXMgaXQgcmVhbGx5IGUyN2Jl
MjQwZGY1MyAoIm1tOiBtZW1jZzogbWFrZSBzdXJlIG1lbW9yeS5ldmVudHMgaXMNCiAgICB1cHRv
ZGF0ZSB3aGVuIHdha2luZyBwb2xsZXJzIik/DQoNCiAgICB0aGFua3MsDQoNCiAgICBncmVnIGst
aA0KDQo=
