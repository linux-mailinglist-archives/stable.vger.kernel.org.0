Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9678744C8B0
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 20:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhKJTTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:19:02 -0500
Received: from mga07.intel.com ([134.134.136.100]:19615 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhKJTTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 14:19:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="296187210"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="296187210"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 11:16:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="669931055"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2021 11:16:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 10 Nov 2021 11:16:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 10 Nov 2021 11:16:12 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.012;
 Wed, 10 Nov 2021 11:16:12 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V2] x86/sgx: Fix free page accounting
Thread-Topic: [PATCH V2] x86/sgx: Fix free page accounting
Thread-Index: AQHX1aSNA6jpVsmpAU6yO0Emm2q6Nqv9ZWUAgAA9SYD//37xcA==
Date:   Wed, 10 Nov 2021 19:16:12 +0000
Message-ID: <bcc3a465dde24f8dab469b4260753e40@intel.com>
References: <b2e69e9febcae5d98d331de094d9cc7ce3217e66.1636487172.git.reinette.chatre@intel.com>
 <8e0bb87f05b79317a06ed2d8ab5e2f5cf6132b6a.camel@kernel.org>
 <794a7034-f6a7-4aff-7958-b1bd959ced24@intel.com>
In-Reply-To: <794a7034-f6a7-4aff-7958-b1bd959ced24@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pj4+IFRoZSBjb25zZXF1ZW5jZSBvZiBzZ3hfbnJfZnJlZV9wYWdlcyBub3QgYmVpbmcgcHJvdGVj
dGVkIGlzIHRoYXQNCj4+PiBpdHMgdmFsdWUgbWF5IG5vdCBhY2N1cmF0ZWx5IHJlZmxlY3QgdGhl
IGFjdHVhbCBudW1iZXIgb2YgZnJlZQ0KPj4+IHBhZ2VzIG9uIHRoZSBzeXN0ZW0sIGltcGFjdGlu
ZyB0aGUgYXZhaWxhYmlsaXR5IG9mIGZyZWUgcGFnZXMgaW4NCj4+PiBzdXBwb3J0IG9mIG1hbnkg
Zmxvd3MuIFRoZSBwcm9ibGVtYXRpYyBzY2VuYXJpbyBpc3Ugd2hlbiB0aGUNCj4+IA0KPiA+IElu
IG5vbi1hdG9taWNpdHkgaXMgbm90IGEgcHJvYmxlbSwgd2hlbiBpdCBpcyBub3QgYSBwcm9ibGVt
IDotKQ0KDQpUaGlzIGlzIG1vc3QgZGVmaW5pdGVseSBhIHByb2JsZW0uDQoNCnN0YXJ0IHdpdGgg
c2d4X25yX2ZyZWVfcGFnZXMgPT0gMTAwDQoNCk5vdyBoYXZlIGEgY3B1IG9uIG5vZGUwIGFsbG9j
YXRlIGEgcGFnZSBhdCB0aGUgc2FtZSB0aW1lIGFzIGFub3RoZXINCmNwdSBvbiBub2RlMSBhbGxj
b2F0ZXMgYSBwYWdlLiBFYWNoIGhvbGRzIHRoZSByZWxldmVudCBwZXItbm9kZSBsb2NrLA0KYnV0
IHRoYXQgZG9lc24ndCBzdG9wIGJvdGggQ1BVcyBmcm9tIGFjY2Vzc2luZyB0aGUgZ2xvYmFsIHRv
Z2V0aGVyOg0KDQoJQ1BVIG9uIG5vZGUwCQlDUFUgb24gbm9kZTENCglzZ3hfbnJfZnJlZV9wYWdl
cy0tOwkJc2d4X25yX2ZyZWVfcGFnZXMtLTsNCg0KV2hhdCBpcyB0aGUgdmFsdWUgb2Ygc2d4X25y
X2ZyZWVfcGFnZXMgbm93PyBXZSB3YW50IGl0IHRvIGJlIDk4LA0KYnV0IGl0IGNvdWxkIGJlIDk5
Lg0KDQpSaW5zZSwgcmVwZWF0IHRob3VzYW5kcyBvZiB0aW1lcy4gRXZlbnR1YWxseSB0aGUgdmFs
dWUgb2Ygc2d4X25yX2ZyZWVfcGFnZXMNCmhhcyBub3QgZXZlbiBhIGNsb3NlIGNvbm5lY3Rpb24g
dG8gdGhlIG51bWJlciBvZiBmcmVlIHBhZ2VzLg0KDQotVG9ueQ0KDQoNCg==
