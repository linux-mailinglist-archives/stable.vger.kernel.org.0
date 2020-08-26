Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C861B253A66
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 00:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgHZWxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 18:53:13 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:64642 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgHZWxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 18:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598482393; x=1630018393;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=5X9AA/AAIgwS2L9XWuah67/BdYE6MvWoAueH3IVXuUs=;
  b=NPqPR2pGQQh4Kfsn5bl8rajEvSgkGKT5EjGqd7TeqgrpWt/FglMEX3VM
   3YLo6loqnZIA2MG/n0eXT12qxIJNAkoaFkkuSX15J6xkOh//0T83v9IOP
   v/k51UMU02ejPUZKVtUdwfVTVAzd8d2Nm5BRyLHcppaLY0ak+zHmL3Y8q
   o=;
X-IronPort-AV: E=Sophos;i="5.76,357,1592870400"; 
   d="scan'208";a="71215827"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 Aug 2020 22:53:08 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 32841A21A7;
        Wed, 26 Aug 2020 22:52:58 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 22:52:58 +0000
Received: from vpn-10-85-95-61.fra53.corp.amazon.com (10.43.162.73) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 22:52:50 +0000
Subject: Re: x86/irq: Unbreak interrupt affinity setting
To:     David Laight <David.Laight@ACULAB.COM>,
        'Thomas Gleixner' <tglx@linutronix.de>,
        'X86 ML' <x86@kernel.org>
CC:     'Andy Lutomirski' <luto@kernel.org>,
        'LKML' <linux-kernel@vger.kernel.org>,
        'Andrew Cooper' <andrew.cooper3@citrix.com>,
        "'Paul E. McKenney'" <paulmck@kernel.org>,
        'Alexandre Chartre' <alexandre.chartre@oracle.com>,
        'Frederic Weisbecker' <frederic@kernel.org>,
        'Paolo Bonzini' <pbonzini@redhat.com>,
        'Sean Christopherson' <sean.j.christopherson@intel.com>,
        'Masami Hiramatsu' <mhiramat@kernel.org>,
        'Petr Mladek' <pmladek@suse.com>,
        'Steven Rostedt' <rostedt@goodmis.org>,
        'Joel Fernandes' <joel@joelfernandes.org>,
        'Boris Ostrovsky' <boris.ostrovsky@oracle.com>,
        'Juergen Gross' <jgross@suse.com>,
        "'Mathieu Desnoyers'" <mathieu.desnoyers@efficios.com>,
        'Josh Poimboeuf' <jpoimboe@redhat.com>,
        'Will Deacon' <will@kernel.org>,
        'Tom Lendacky' <thomas.lendacky@amd.com>,
        'Wei Liu' <wei.liu@kernel.org>,
        'Michael Kelley' <mikelley@microsoft.com>,
        'Jason Chen CJ' <jason.cj.chen@intel.com>,
        "'Zhao Yakui'" <yakui.zhao@intel.com>,
        "'Peter Zijlstra (Intel)'" <peterz@infradead.org>,
        'Avi Kivity' <avi@scylladb.com>,
        "'Herrenschmidt, Benjamin'" <benh@amazon.com>,
        "'robketr@amazon.de'" <robketr@amazon.de>,
        "'amos@scylladb.com'" <amos@scylladb.com>,
        'Brian Gerst' <brgerst@gmail.com>,
        "'stable@vger.kernel.org'" <stable@vger.kernel.org>,
        'Alex bykov' <alex.bykov@scylladb.com>
References: <20200826115357.3049-1-graf@amazon.com>
 <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
 <fd87a87d-7d8a-9959-6c81-f49003a43c21@amazon.com>
 <87blixuuny.fsf@nanos.tec.linutronix.de>
 <873649utm4.fsf@nanos.tec.linutronix.de>
 <87wo1ltaxz.fsf@nanos.tec.linutronix.de>
 <db3e28b59d404f55aff83120c077d6f6@AcuMS.aculab.com>
 <42ae8716e425495c964ae7372bd7ff52@AcuMS.aculab.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <014fd671-73c1-97f3-cc92-73c2cf9576af@amazon.com>
Date:   Thu, 27 Aug 2020 00:52:48 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <42ae8716e425495c964ae7372bd7ff52@AcuMS.aculab.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D16UWC004.ant.amazon.com (10.43.162.72) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CgpPbiAyNi4wOC4yMCAyMzo0NywgRGF2aWQgTGFpZ2h0IHdyb3RlOgo+IAo+IEZyb206IERhdmlk
IExhaWdodAo+PiBTZW50OiAyNiBBdWd1c3QgMjAyMCAyMjozNwo+Pgo+PiBGcm9tOiBUaG9tYXMg
R2xlaXhuZXIKPj4+IFNlbnQ6IDI2IEF1Z3VzdCAyMDIwIDIxOjIyCj4+IC4uLgo+Pj4gTW92aW5n
IGludGVycnVwdHMgb24geDg2IGhhcHBlbnMgaW4gc2V2ZXJhbCBzdGVwcy4gQSBuZXcgdmVjdG9y
IG9uIGEKPj4+IGRpZmZlcmVudCBDUFUgaXMgYWxsb2NhdGVkIGFuZCB0aGUgcmVsZXZhbnQgaW50
ZXJydXB0IHNvdXJjZSBpcwo+Pj4gcmVwcm9ncmFtbWVkIHRvIHRoYXQuIEJ1dCB0aGF0J3MgcmFj
eSBhbmQgdGhlcmUgbWlnaHQgYmUgYW4gaW50ZXJydXB0Cj4+PiBhbHJlYWR5IGluIGZsaWdodCB0
byB0aGUgb2xkIHZlY3Rvci4gU28gdGhlIG9sZCB2ZWN0b3IgaXMgcHJlc2VydmVkIHVudGlsCj4+
PiB0aGUgZmlyc3QgaW50ZXJydXB0IGFycml2ZXMgb24gdGhlIG5ldyB2ZWN0b3IgYW5kIHRoZSBu
ZXcgdGFyZ2V0IENQVS4gT25jZQo+Pj4gdGhhdCBoYXBwZW5zIHRoZSBvbGQgdmVjdG9yIGlzIGNs
ZWFuZWQgdXAsIGJ1dCB0aGlzIGNsZWFudXAgc3RpbGwgZGVwZW5kcwo+Pj4gb24gdGhlIHZlY3Rv
ciBudW1iZXIgYmVpbmcgc3RvcmVkIGluIHB0X3JlZ3M6Om9yaWdfYXgsIHdoaWNoIGlzIG5vdyAt
MS4KPj4KPj4gSSBzdXNwZWN0IHRoYXQgaXQgaXMgbXVjaCBtb3JlICdyYWN5JyB0aGFuIHRoYXQg
Zm9yIFBDSS1YIGludGVycnVwdHMuCj4+IE9uIHRoZSBoYXJkd2FyZSBzaWRlIHRoZXJlIGlzIGFu
IGludGVycnVwdCBkaXNhYmxlIGJpdCwgYW5kIGFkZHJlc3MKPj4gYW5kIGEgdmFsdWUuCj4+IFRv
IHJhaXNlIGFuIGludGVycnVwdCB0aGUgaGFyZHdhcmUgbXVzdCB3cml0ZSB0aGUgdmFsdWUgdG8g
dGhlIGFkZHJlc3MuCj4+Cj4+IElmIHRoZSBjcHUgbmVlZHMgdG8gbW92ZSBhbiBpbnRlcnJ1cHQg
Ym90aCB0aGUgYWRkcmVzcyBhbmQgdmFsdWUKPj4gbmVlZCBjaGFuZ2luZywgYnV0IHRoZSBjcHUg
d29udCB3cml0ZSB0aGUgYWRkcmVzcyBhbmQgdmFsdWUgdXNpbmcKPj4gdGhlIHNhbWUgVExQLCBz
byB0aGUgaGFyZHdhcmUgY291bGQgcG90ZW50aWFsbHkgd3JpdGUgYSB2YWx1ZSB0bwo+PiB0aGUg
d3JvbmcgYWRkcmVzcy4KPj4gV29yc2UgdGhhbiB0aGF0LCB0aGUgaGFyZHdhcmUgY291bGQgZWFz
aWx5IG9ubHkgbG9vayBhdCB0aGUgYWRkcmVzcwo+PiBhbmQgdmFsdWUgaW4gdGhlIGNsb2NrcyBh
ZnRlciBjaGVja2luZyB0aGUgaW50ZXJydXB0IGlzIGVuYWJsZWQuCj4+IFNvIG1hc2tpbmcgdGhl
IGludGVycnVwdCBpbW1lZGlhdGVseSBwcmlvciB0byBjaGFuZ2luZyB0aGUgdmVjdG9yCj4+IGlu
Zm8gbWF5IG5vdCBiZSBlbm91Z2guCj4+Cj4+IEl0IGlzIGxpa2VseSB0aGF0IGEgcmVhZC1iYWNr
IG9mIHRoZSBtYXNrIGJlZm9yZSB1cGRhdGluZyB0aGUgdmVjdG9yCj4+IGlzIGVub3VnaC4KPiAK
PiBCdXQgbm90IGVub3VnaCB0byBhc3N1bWUgeW91IHdvbid0IHJlY2VpdmUgYW4gaW50ZXJydXB0
IGFmdGVyIHJlYWRpbmcKPiBiYWNrIHRoYXQgaW50ZXJydXB0cyBhcmUgbWFza2VkLgo+IAo+IChJ
J3ZlIGltcGxlbWVudGVkIHRoZSBoYXJkd2FyZSBzaWRlIGZvciBhbiBmcGdhIC4uLikKCkRvIHdl
IGFjdHVhbGx5IGNhcmUgaW4gdGhpcyBjb250ZXh0PyBBbGwgd2Ugd2FudCB0byBrbm93IGhlcmUg
aXMgd2hldGhlciAKYSBkZXZpY2UgKG9yIGlycWNoaXAgaW4gYmV0d2VlbikgaGFzIGFjdHVhbGx5
IG5vdGljZWQgdGhhdCBpdCBzaG91bGQgCnBvc3QgdG8gYSBuZXcgdmVjdG9yLiBJZiB3ZSBnZXQg
aW50ZXJydXB0cyBvbiByYW5kb20gb3RoZXIgdmVjdG9ycyBpbiAKYmV0d2VlbiwgdGhleSB3b3Vs
ZCBzaW1wbHkgc2hvdyB1cCBhcyBzcHVyaW91cywgbm8/CgpTbyBJIGRvbid0IHF1aXRlIHNlZSB3
aGVyZSB0aGlzIHBhdGNoIG1ha2VzIHRoZSBzaXR1YXRpb24gYW55IHdvcnNlIHRoYW4gCmJlZm9y
ZS4KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVz
ZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hs
YWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0
ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3
IDg3OQoKCg==

