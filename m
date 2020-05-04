Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BD91C47A5
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 22:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgEDUFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 16:05:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:18647 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgEDUFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 16:05:14 -0400
IronPort-SDR: KWgWEZ/ii+ivuP3yJ+IF6olgaVQi4gNX6mp7rmUcoLwys6nj1Vf9TQZAC9RrvTcLYCLy6R2qNq
 YsW18I/MueLg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 13:05:14 -0700
IronPort-SDR: y6fTkTYfYGLd3JKagbsQwauiKg0nMn8mM9txTn416ln2atUAwyG96Uo76gWXw3GTge/+DbTk/6
 +0HZlUW+PY3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,353,1583222400"; 
   d="scan'208";a="338429331"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga001.jf.intel.com with ESMTP; 04 May 2020 13:05:14 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 4 May 2020 13:05:13 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.83]) by
 ORSMSX121.amr.corp.intel.com ([169.254.10.248]) with mapi id 14.03.0439.000;
 Mon, 4 May 2020 13:05:13 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Tsaur, Erwin" <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Thread-Topic: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Thread-Index: AQHWHsst2+7frPAw9kCYaqQsGNEgp6iSJ9mAgAAvKwCAAAcmgIAAF8EA//+WBACAAH0TAIAAQ4gAgAAE/4CAAAO1gIAAb4YQgAK28ICAAmL9AA==
Date:   Mon, 4 May 2020 20:05:13 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F612DF4@ORSMSX115.amr.corp.intel.com>
References: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
 <1962EE67-8AD1-409D-963A-4F1E1AB3B865@amacapital.net>
 <3908561D78D1C84285E8C5FCA982C28F7F60EBB6@ORSMSX115.amr.corp.intel.com>
 <CALCETrW5zNLOrhOS69xeb3ANa0HVAW5+xaHvG2CA8iFy1ByHKQ@mail.gmail.com>
In-Reply-To: <CALCETrW5zNLOrhOS69xeb3ANa0HVAW5+xaHvG2CA8iFy1ByHKQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBXaGVuIGEgY29weSBmdW5jdGlvbiBoaXRzIGEgYmFkIHBhZ2UgYW5kIHRoZSBwYWdlIGlzIG5v
dCB5ZXQga25vd24gdG8NCj4gYmUgYmFkLCB3aGF0IGRvZXMgaXQgZG8/ICAoSS5lLiB0aGUgcGFn
ZSB3YXMgYmVsaWV2ZWQgdG8gYmUgZmluZSBidXQNCj4gdGhlIGNvcHkgZnVuY3Rpb24gZ2V0cyAj
TUMuKSAgRG9lcyBpdCB1bm1hcCBpdCByaWdodCBhd2F5PyAgV2hhdCBkb2VzDQo+IGl0IHJldHVy
bj8NCg0KSSBzdXNwZWN0IHRoYXQgd2Ugd2lsbCBvbmx5IGV2ZXIgZmluZCBhIGhhbmRmdWwgb2Yg
c2l0dWF0aW9ucyB3aGVyZSB0aGUNCmtlcm5lbCBjYW4gcmVjb3ZlciBmcm9tIG1lbW9yeSB0aGF0
IGhhcyBnb25lIGJhZCB0aGF0IGFyZSB3b3J0aCBmaXhpbmcNCihnb3QgdG8gYmUgc29tZSBjb2Rl
IHBhdGggdGhhdCB0b3VjaGVzIGEgbWVhbmluZ2Z1bCBmcmFjdGlvbiBvZiBtZW1vcnksDQpvdGhl
cndpc2Ugd2UgZ2V0IGNvZGUgY29tcGxleGl0eSB3aXRob3V0IGFueSBtZWFuaW5nZnVsIHBheW9m
ZikuDQoNCkkgZG9uJ3QgdGhpbmsgd2UnZCB3YW50IGRpZmZlcmVudCBhY3Rpb25zIGZvciB0aGUg
Y2FzZXMgb2YgIndlIGp1c3QgZm91bmQgb3V0DQpub3cgdGhhdCB0aGlzIHBhZ2UgaXMgYmFkIiBh
bmQgIndlIGdvdCBhIG5vdGlmaWNhdGlvbiBhbiBob3VyIGFnbyB0aGF0IHRoaXMNCnBhZ2UgaGFk
IGdvbmUgYmFkIi4gQ3VycmVudGx5IHdlIHRyZWF0IHRob3NlIHRoZSBzYW1lIGZvciBhcHBsaWNh
dGlvbg0KZXJyb3JzIC4uLiBTSUdCVVMgZWl0aGVyIHdheVsxXS4NCg0KLVRvbnkNCg0KWzFdIHdl
bGwgdGhlcmUgYXJlIG9wdGlvbnMgYm90aCBnbG9iYWxseSBhbmQgYXQgdGhlIHBlci1wcm9jZXNz
IGxldmVsIHRvIGhhdmUNCnRoZSAiZWFybHkiIG5vdGlmaWNhdGlvbnMgZGVsaXZlcmVkIHJpZ2h0
IGF3YXkuDQo=
