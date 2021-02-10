Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA407316D52
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbhBJRvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 12:51:21 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:17103 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbhBJRun (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 12:50:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1612979442; x=1644515442;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=5RwsGI+G2DMh/LT3LUkOrjh5XVrq5GYltMUWmHdYBhA=;
  b=AbQEBVzyVI34b2Qsw384ayOOBQ33jlSZalUv8MoO1ZJPkev4FrbLpZ9E
   jxlDDAezSSqD9IVJJXG2x9SrDgmHBkAfQlePEzrVfZWVujtOxcARfUKEm
   G/qAHSDdEYJ49rTuAfq45pfx8Q7A+nIzy6MtXgfR12g8sn/r6hk4i6ghD
   Q=;
X-IronPort-AV: E=Sophos;i="5.81,168,1610409600"; 
   d="scan'208";a="81713523"
Subject: Re: [PATCH] arm/xen: Don't probe xenbus as part of an early initcall
Thread-Topic: [PATCH] arm/xen: Don't probe xenbus as part of an early initcall
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Feb 2021 17:49:53 +0000
Received: from EX13D37EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 37CA122017C;
        Wed, 10 Feb 2021 17:49:52 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13D37EUA001.ant.amazon.com (10.43.165.212) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Feb 2021 17:49:50 +0000
Received: from EX13D08UEB001.ant.amazon.com ([10.43.60.245]) by
 EX13D08UEB001.ant.amazon.com ([10.43.60.245]) with mapi id 15.00.1497.010;
 Wed, 10 Feb 2021 17:49:49 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "julien@xen.org" <julien@xen.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iwj@xenproject.org" <iwj@xenproject.org>,
        "Grall, Julien" <jgrall@amazon.co.uk>
Thread-Index: AQHW/89FvDxsOsmt+E6oHHLpfjI51qpRqqKA
Date:   Wed, 10 Feb 2021 17:49:49 +0000
Message-ID: <7858866d099732baf56e395a627f610968d24a7d.camel@amazon.co.uk>
References: <20210210170654.5377-1-julien@xen.org>
In-Reply-To: <20210210170654.5377-1-julien@xen.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.207]
Content-Type: text/plain; charset="utf-8"
Content-ID: <873FCF2D6172CE4BBDD0A453F0DDE074@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIxLTAyLTEwIGF0IDE3OjA2ICswMDAwLCBKdWxpZW4gR3JhbGwgd3JvdGU6DQo+
IEZyb206IEp1bGllbiBHcmFsbCA8amdyYWxsQGFtYXpvbi5jb20+DQo+IA0KPiBBZnRlciBDb21t
aXQgMzQ5OWJhODE5OGNhZCAoInhlbjogRml4IGV2ZW50IGNoYW5uZWwgY2FsbGJhY2sgdmlhDQo+
IElOVFgvR1NJIiksIHhlbmJ1c19wcm9iZSgpIHdpbGwgYmUgY2FsbGVkIHRvbyBlYXJseSBvbiBB
cm0uIFRoaXMgd2lsbA0KPiByZWNlbnQgdG8gYSBndWVzdCBoYW5nIGR1cmluZyBib290Lg0KPiAN
Cj4gSWYgdGhlcmUgaGFuZyB3YXNuJ3QgdGhlcmUsIHdlIHdvdWxkIGhhdmUgZW5kZWQgdXAgdG8g
Y2FsbA0KPiB4ZW5idXNfcHJvYmUoKSB0d2ljZSAodGhlIHNlY29uZCB0aW1lIGlzIGluIHhlbmJ1
c19wcm9iZV9pbml0Y2FsbCgpKS4NCj4gDQo+IFdlIGRvbid0IG5lZWQgdG8gaW5pdGlhbGl6ZSB4
ZW5idXNfcHJvYmUoKSBlYXJseSBmb3IgQXJtIGd1ZXN0Lg0KPiBUaGVyZWZvcmUsIHRoZSBjYWxs
IGluIHhlbl9ndWVzdF9pbml0KCkgaXMgbm93IHJlbW92ZWQuDQo+IA0KPiBBZnRlciB0aGlzIGNo
YW5nZSwgdGhlcmUgaXMgbm8gbW9yZSBleHRlcm5hbCBjYWxsZXIgZm9yIHhlbmJ1c19wcm9iZSgp
Lg0KPiBTbyB0aGUgZnVuY3Rpb24gaXMgdHVybmVkIHRvIGEgc3RhdGljIG9uZS4gSW50ZXJlc3Rp
bmdseSB0aGVyZSB3ZXJlIHR3bw0KPiBwcm90b3R5cGVzIGZvciBpdC4NCj4gDQo+IEZpeGVzOiAz
NDk5YmE4MTk4Y2FkICgieGVuOiBGaXggZXZlbnQgY2hhbm5lbCBjYWxsYmFjayB2aWEgSU5UWC9H
U0kiKQ0KPiBSZXBvcnRlZC1ieTogSWFuIEphY2tzb24gPGl3akB4ZW5wcm9qZWN0Lm9yZz4NCj4g
U2lnbmVkLW9mZi1ieTogSnVsaWVuIEdyYWxsIDxqZ3JhbGxAYW1hem9uLmNvbT4NCg0KUmV2aWV3
ZWQtYnk6IERhdmlkIFdvb2Rob3VzZSA8ZHdtd0BhbWF6b24uY28udWs+DQpDYzogc3RhYmxlQHZn
ZXIua2VybmVsLm9yZw0KDQoNCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50cmUgKExvbmRvbikg
THRkLiBSZWdpc3RlcmVkIGluIEVuZ2xhbmQgYW5kIFdhbGVzIHdpdGggcmVnaXN0cmF0aW9uIG51
bWJlciAwNDU0MzIzMiB3aXRoIGl0cyByZWdpc3RlcmVkIG9mZmljZSBhdCAxIFByaW5jaXBhbCBQ
bGFjZSwgV29yc2hpcCBTdHJlZXQsIExvbmRvbiBFQzJBIDJGQSwgVW5pdGVkIEtpbmdkb20uCgoK

