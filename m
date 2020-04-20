Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1181D1B1766
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 22:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgDTUpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 16:45:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:7869 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTUpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 16:45:34 -0400
IronPort-SDR: MPUnbGyn7+o8mzo/GldtqqgNDMDwBo8Z120WNx3OJk7dYnwdRxujJW6if0O0RXRfdgM9cqkl43
 GxZ0Af8abH9A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 13:45:34 -0700
IronPort-SDR: 9wacpcNj1X7bZVjCS2BWPnrcI9BXhubPhcWdxC9v9tkuthZl31RSKE8EyqAK89B1ixIJ8dk2Od
 vVplzjpcKI9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="279373633"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga004.fm.intel.com with ESMTP; 20 Apr 2020 13:45:34 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.83]) by
 ORSMSX105.amr.corp.intel.com ([169.254.2.15]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 13:45:33 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Tsaur, Erwin" <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: RE: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
Thread-Topic: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
Thread-Index: AQHWFcAkxzMCKIhw+kKWzhMhw9bMXah/0FOAgAIc84CAAM7CAIAADmyAgAAMx4CAAAaOAIAACpqA//+PPQCAAHZ6AP//jGvw
Date:   Mon, 20 Apr 2020 20:45:33 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F5FB1C0@ORSMSX115.amr.corp.intel.com>
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
 <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
 <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <CAPcyv4hrfZsg48Gw_s7xTLLhjLTk_U+PV0MsLnG+xh3652xFCQ@mail.gmail.com>
 <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com>
 <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
 <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com>
 <20200420202332.GA30160@agluck-desk2.amr.corp.intel.com>
 <CAHk-=whNL-P71xQRsahpYrzKquvz3WwqPCUVPT+1TUmWZ+67TQ@mail.gmail.com>
In-Reply-To: <CAHk-=whNL-P71xQRsahpYrzKquvz3WwqPCUVPT+1TUmWZ+67TQ@mail.gmail.com>
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

PiBCeSAiYXN5bmNocm9ub3VzIiBJIGRvbid0IG1lYW4gImhvdXJzIGxhdGVyIi4NCj4NCj4gTWFr
ZSBpdCBiZSAiaW50ZXJydXB0cyBhcmUgZW5hYmxlZCwgYmVmb3JlIHNlcmlhbGl6aW5nIGluc3Ry
dWN0aW9uIi4NCj4NCj4gWWVzLCB3ZSB3YW50IGJvdW5kZWQgZXJyb3IgaGFuZGxpbmcgbGF0ZW5j
eS4gQnV0IHRoYXQgZG9lc24ndCBtZWFuICJzeW5jaHJvbm91cyINCg0KQW5vdGhlciBYODYgdmVu
ZG9yIHNlZW1zIHRvIGJlIGFkZGluZyBzb21ldGhpbmcgbGlrZSB0aGF0LiBTZWUgTUNPTU1JVA0K
aW4gaHR0cHM6Ly93d3cuYW1kLmNvbS9zeXN0ZW0vZmlsZXMvVGVjaERvY3MvMjQ1OTQucGRmDQoN
CkJ1dCBJIHdvbmRlciBob3cgYW4gT1Mgd2lsbCBrbm93IHdoZXRoZXIgaXQgaXMgcnVubmluZyBz
b21lIHNtYXJ0DQpNQ09NTUlULWF3YXJlIGFwcGxpY2F0aW9uIHRoYXQgY2FuIGZpZ3VyZSBvdXQg
d2hhdCB0byBkbyB3aXRoIGJhZA0KZGF0YSwgb3IgYSBsZWdhY3kgYXBwbGljYXRpb24gdGhhdCBz
aG91bGQgcHJvYmFibHkgYmUgc3RvcHBlZCBiZWZvcmUNCml0IGh1cnRzIHNvbWVib2R5Lg0KDQpJ
IGFsc28gd29uZGVyIGhvdyBleHBlbnNpdmUgTUNPTU1JVCBpcyAoc2luY2UgaXQgaXMgZXNzZW50
aWFsbHkNCnBvbGxpbmcgZm9yICJkaWQgYW55IGVycm9ycyBoYXBwZW4iKS4NCg0KLVRvbnkNCg==
