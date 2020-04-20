Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737671B17AA
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 22:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDTU5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 16:57:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:28343 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgDTU5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 16:57:39 -0400
IronPort-SDR: v58Xwp94YQN2aErmbzhGwWwvxnmJnJUEeGk5ODKDB6NVKJpIs3bL1DrW4YrjH+/F158uostgya
 V6FEnsQU2zFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 13:57:38 -0700
IronPort-SDR: DhvBja67gLWH7lzxf+Z8l6BP2md94mzZEQGAv7UJxq6pY8rLhkGBVtH/LmfYw8kS/afmt5KOfg
 cviA3NS2knAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="279376609"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga004.fm.intel.com with ESMTP; 20 Apr 2020 13:57:38 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 13:57:37 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.83]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.70]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 13:57:37 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Tsaur, Erwin" <erwin.tsaur@intel.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: RE: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
Thread-Topic: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
Thread-Index: AQHWFcAkxzMCKIhw+kKWzhMhw9bMXah/0FOAgAIc84CAAM7CAIAADmyAgAAMx4CAAAaOAIAACpqAgAAE7YCAAAYDAP//jKeQ
Date:   Mon, 20 Apr 2020 20:57:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F5FB29E@ORSMSX115.amr.corp.intel.com>
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
 <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
 <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <CAPcyv4hrfZsg48Gw_s7xTLLhjLTk_U+PV0MsLnG+xh3652xFCQ@mail.gmail.com>
 <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com>
 <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
 <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com>
 <CAPcyv4hKcAvQEo+peg3MRT3j+u8UdOHVNUWCZhi0aHaiLbe8gw@mail.gmail.com>
 <CAHk-=wj0yVRjD9KgsnOD39k7FzPqhG794reYT4J7HsL0P89oQg@mail.gmail.com>
In-Reply-To: <CAHk-=wj0yVRjD9KgsnOD39k7FzPqhG794reYT4J7HsL0P89oQg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAgKGEpIGlzIGEgdHJhcCwgbm90IGFuIGV4Y2VwdGlvbiAtIHNvIHRoZSBpbnN0cnVjdGlvbiBo
YXMgYmVlbiBkb25lLA0KPiBhbmQgeW91IGRvbid0IG5lZWQgdG8gdHJ5IHRvIGVtdWxhdGUgaXQg
b3IgYW55dGhpbmcgdG8gY29udGludWUuDQoNCk1heWJlIGZvciBlcnJvcnMgb24gdGhlIGRhdGEg
c2lkZSBvZiB0aGUgcGlwZWxpbmUuIE9uIHRoZSBpbnN0cnVjdGlvbg0Kc2lkZSB3ZSBjYW4gdXN1
YWxseSByZWNvdmVyIGZyb20gdXNlciBzcGFjZSBpbnN0cnVjdGlvbiBmZXRjaGVzIGJ5DQpqdXN0
IHRocm93aW5nIGF3YXkgdGhlIHBhZ2Ugd2l0aCB0aGUgY29ycnVwdGVkIGluc3RydWN0aW9ucyBh
bmQgcmVhZGluZw0KZnJvbSBkaXNrIGludG8gYSBuZXcgcGFnZS4gVGhlbiBqdXN0IHBvaW50IHRo
ZSBwYWdlIHRhYmxlIHRvIHRoZSBuZXcNCnBhZ2UsIGFuZCBoZXkgcHJlc3RvLCBpdHMgYWxsIHRy
YW5zcGFyZW50bHkgZml4ZWQgKG1vZHVsbyB0aW1lIGxvc3QgZml4aW5nDQp0aGluZ3MpLg0KDQot
VG9ueQ0K
