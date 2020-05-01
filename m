Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97D51C175D
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgEAOJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 10:09:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:26239 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728840AbgEAOJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 10:09:22 -0400
IronPort-SDR: oqzMxGezNetHf1zVxqo1/37tdvdP2zOc1I7Md452rwzg+SLJ+2CtM0qmkejT7Ki6QfLGAgWa//
 Rg9ap2dNWnSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 07:09:21 -0700
IronPort-SDR: T8F0QqIQVBxO8n19+0hE/vGhvzYePOPeBHTI9gbaOnHqLw9nF12kUm+ibLM91YufzG0lEtO7Jh
 TDHwScBUPBRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,339,1583222400"; 
   d="scan'208";a="460272134"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga006.fm.intel.com with ESMTP; 01 May 2020 07:09:21 -0700
Received: from orsmsx160.amr.corp.intel.com (10.22.226.43) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 1 May 2020 07:09:20 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.83]) by
 ORSMSX160.amr.corp.intel.com ([169.254.13.187]) with mapi id 14.03.0439.000;
 Fri, 1 May 2020 07:09:20 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Tsaur, Erwin" <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Thread-Topic: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Thread-Index: AQHWHsst2+7frPAw9kCYaqQsGNEgp6iSJ9mAgAAvKwCAAAcmgIAAF8EA//+WBACAAH0TAIAAQ4gAgAAE/4CAAAO1gIAAb4YQ
Date:   Fri, 1 May 2020 14:09:20 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F60EBB6@ORSMSX115.amr.corp.intel.com>
References: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
 <1962EE67-8AD1-409D-963A-4F1E1AB3B865@amacapital.net>
In-Reply-To: <1962EE67-8AD1-409D-963A-4F1E1AB3B865@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBOb3cgbWF5YmUgY29weV90b191c2VyKCkgc2hvdWxkICphbHdheXMqIHdvcmsgdGhpcyB3YXks
IGJ1dCBJ4oCZbSBub3QgY29udmluY2VkLg0KPiBDZXJ0YWlubHkgcHV0X3VzZXIoKSBzaG91bGRu
4oCZdCDigJQgdGhlIHJlc3VsdCB3b3VsZG7igJl0IGV2ZW4gYmUgd2VsbCBkZWZpbmVkLiBBbmQg
SeKAmW0NCj4gIHVuY29udmluY2VkIHRoYXQgaXQgbWFrZXMgbXVjaCBzZW5zZSBmb3IgdGhlIG1h
am9yaXR5IG9mIGNvcHlfdG9fdXNlcigpIGNhbGxlcnMNCj4gIHRoYXQgYXJlIGFsc28gZGlyZWN0
bHkgYWNjZXNzaW5nIHRoZSBzb3VyY2Ugc3RydWN0dXJlLg0KDQpPbmUgY2FzZSB0aGF0IG1pZ2h0
IHdvcmsgaXMgY29weV90b191c2VyKCkgdGhhdCdzIGNvcHlpbmcgZnJvbSB0aGUga2VybmVsIHBh
Z2UgY2FjaGUNCnRvIHRoZSB1c2VyIGluIHJlc3BvbnNlIHRvIGEgcmVhZCgyKSBzeXN0ZW0gY2Fs
bC4gIEFjdGlvbiB3b3VsZCBiZSB0byBjaGVjayBpZiB3ZSBjb3VsZA0KcmUtcmVhZCBmcm9tIHRo
ZSBmaWxlIHN5c3RlbSB0byBhIGRpZmZlcmVudCBwYWdlLiBJZiBub3QsIHJldHVybiAtRUlPLiBF
aXRoZXIgd2F5IGRpdGNoIHRoZQ0KcG9pc29uIHBhZ2UgZnJvbSB0aGUgcGFnZSBjYWNoZS4NCg0K
LVRvbnkNCg==
