Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D68825306B
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgHZNwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:52:02 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:49099 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730450AbgHZNwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 09:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598449920; x=1629985920;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=R/UiUNzpRC6vnoctXzbPpJl22XZf2dpsVm7NtJe6n4g=;
  b=Yo6TpDWroOZFM2I+bbzqxKo9c/mokN76clVs9lbB/f+VzQhXTMj0O5EN
   CqDvexjrjm6aT2gT574AcjeVyySF5U+6BZLV0VuQpXNGWYsD0wfNWzbNs
   IrrWAndZG7KprioUdxjRcFpszFR+sCsTk3RKGr1AbIH0YDKTSZGzgkkvR
   E=;
X-IronPort-AV: E=Sophos;i="5.76,355,1592870400"; 
   d="scan'208";a="62901837"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 26 Aug 2020 13:51:24 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 0362BA2204;
        Wed, 26 Aug 2020 13:51:15 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 13:51:15 +0000
Received: from edge-m2-r3-214.e-iad50.amazon.com (10.43.160.229) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 13:51:07 +0000
Subject: Re: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
To:     Josh Poimboeuf <jpoimboe@redhat.com>
CC:     X86 ML <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Will Deacon <will@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Avi Kivity <avi@scylladb.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>, <robketr@amazon.de>,
        <amos@scylladb.com>, Brian Gerst <brgerst@gmail.com>,
        <stable@vger.kernel.org>
References: <20200826115357.3049-1-graf@amazon.com>
 <20200826132210.k4pxphxvxuvb2fe6@treble>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <19292905-9cfc-ff36-217b-73b944e41442@amazon.com>
Date:   Wed, 26 Aug 2020 15:51:05 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200826132210.k4pxphxvxuvb2fe6@treble>
Content-Language: en-US
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D44UWB001.ant.amazon.com (10.43.161.32) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CgpPbiAyNi4wOC4yMCAxNToyMiwgSm9zaCBQb2ltYm9ldWYgd3JvdGU6Cj4gCj4gT24gV2VkLCBB
dWcgMjYsIDIwMjAgYXQgMDE6NTM6NTdQTSArMDIwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+
IC0ubWFjcm8gaWR0ZW50cnlfYm9keSBjZnVuYyBoYXNfZXJyb3JfY29kZTpyZXEKPj4gKy5tYWNy
byBpZHRlbnRyeV9ib2R5IGNmdW5jIGhhc19lcnJvcl9jb2RlOnJlcSBwcmVzZXJ2ZV9lcnJvcl9j
b2RlOnJlcQo+Pgo+PiAgICAgICAgY2FsbCAgICBlcnJvcl9lbnRyeQo+PiAgICAgICAgVU5XSU5E
X0hJTlRfUkVHUwo+PiBAQCAtMzI4LDcgKzMyOCw5IEBAIFNZTV9DT0RFX0VORChyZXRfZnJvbV9m
b3JrKQo+Pgo+PiAgICAgICAgLmlmIFxoYXNfZXJyb3JfY29kZSA9PSAxCj4+ICAgICAgICAgICAg
ICAgIG1vdnEgICAgT1JJR19SQVgoJXJzcCksICVyc2kgICAgLyogZ2V0IGVycm9yIGNvZGUgaW50
byAybmQgYXJndW1lbnQqLwo+PiAtICAgICAgICAgICAgIG1vdnEgICAgJC0xLCBPUklHX1JBWCgl
cnNwKSAgICAgLyogbm8gc3lzY2FsbCB0byByZXN0YXJ0ICovCj4+ICsgICAgICAgICAgICAgLmlm
IFxwcmVzZXJ2ZV9lcnJvcl9jb2RlID09IDAKPj4gKyAgICAgICAgICAgICAgICAgICAgIG1vdnEg
ICAgJC0xLCBPUklHX1JBWCglcnNwKSAgICAgLyogbm8gc3lzY2FsbCB0byByZXN0YXJ0ICovCj4+
ICsgICAgICAgICAgICAgLmVuZGlmCj4gCj4gV2hlbiBkb2VzIHRoaXMgaGFwcGVuIChoYXNfZXJy
b3JfY29kZT0xICYmIHByZXNlcnZlX2Vycm9yX2NvZGU9MCk/ICBJCj4gZG9uJ3Qgc2VlIGFueSB1
c2VycyBvZiB0aGlzIG1hY3JvIChvciBpZHRlbnRyeSkgd2l0aCB0aGlzIGNvbWJpbmF0aW9uLgoK
SXQncyB3ZWxsIGhpZGRlbiBpbiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9pZHRlbnRyeS5oOgoKI2Rl
ZmluZSBERUNMQVJFX0lEVEVOVFJZX0VSUk9SQ09ERSh2ZWN0b3IsIGZ1bmMpICAgICAgICAgICAg
ICAgICAgICAgICAgXAogICAgICAgICBpZHRlbnRyeSB2ZWN0b3IgYXNtXyMjZnVuYyBmdW5jIGhh
c19lcnJvcl9jb2RlPTEKCi8qIFNpbXBsZSBleGNlcHRpb24gZW50cmllcyB3aXRoIGVycm9yIGNv
ZGUgcHVzaGVkIGJ5IGhhcmR3YXJlICovCkRFQ0xBUkVfSURURU5UUllfRVJST1JDT0RFKFg4Nl9U
UkFQX1RTLCBleGNfaW52YWxpZF90c3MpOwpERUNMQVJFX0lEVEVOVFJZX0VSUk9SQ09ERShYODZf
VFJBUF9OUCwgZXhjX3NlZ21lbnRfbm90X3ByZXNlbnQpOwpERUNMQVJFX0lEVEVOVFJZX0VSUk9S
Q09ERShYODZfVFJBUF9TUywgZXhjX3N0YWNrX3NlZ21lbnQpOwpERUNMQVJFX0lEVEVOVFJZX0VS
Uk9SQ09ERShYODZfVFJBUF9HUCwgZXhjX2dlbmVyYWxfcHJvdGVjdGlvbik7CkRFQ0xBUkVfSURU
RU5UUllfRVJST1JDT0RFKFg4Nl9UUkFQX0FDLCBleGNfYWxpZ25tZW50X2NoZWNrKTsKWy4uLl0K
REVDTEFSRV9JRFRFTlRSWV9SQVdfRVJST1JDT0RFKFg4Nl9UUkFQX1BGLCAgICAgZXhjX3BhZ2Vf
ZmF1bHQpOwoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgK
S3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFu
IFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hh
cmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4
OSAyMzcgODc5CgoK

