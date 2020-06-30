Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3281720F6A7
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 16:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgF3OCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 10:02:00 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:30580 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgF3OB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 10:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1593525719; x=1625061719;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=5cqbwaFqSkabewkIE0PH8u9d3WrDYtEIAmtYZ+31MBM=;
  b=sazdzRWzRkKVtQQkvtztDSRYf2zDcvGcbmkNS1pnHElhPUgGGOHCWxm3
   97s0gtJCdXyxdtD9FOrN/5sI8r6JdqtRZ7Vr2nDkxJ5PUjqilR5wNxP+6
   R8Bo+wLIIJYMzbHlNCPzKjzIsX6AiPpMnuy746SLLygzdAT8yKN+cBBDK
   4=;
IronPort-SDR: wcfL+7NxfY4PeRhWkaHXuaQ8Ft+JFHZsqJMKprw6Tld+8s54LXls7GQjlpHHqrFInsVpEnOuIV
 Icon7/Pwa00w==
X-IronPort-AV: E=Sophos;i="5.75,297,1589241600"; 
   d="scan'208";a="48066445"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 30 Jun 2020 14:01:56 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id B25A3A1A3F;
        Tue, 30 Jun 2020 14:01:54 +0000 (UTC)
Received: from EX13D08EUC004.ant.amazon.com (10.43.164.176) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Jun 2020 14:01:54 +0000
Received: from [10.28.84.91] (10.43.162.109) by EX13D08EUC004.ant.amazon.com
 (10.43.164.176) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 14:01:50 +0000
Subject: Re: [PATCH] nvme: validate cntlid's only for nvme >= 1.1.0
To:     Christoph Hellwig <hch@lst.de>
CC:     Amit Shah <aams@amazon.de>, <stable@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        <linux-nvme@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <20200630122923.70282-1-mheyne@amazon.de>
 <20200630133358.GA20602@lst.de> <20200630133609.GA20809@lst.de>
From:   Maximilian Heyne <mheyne@amazon.de>
Message-ID: <b3b621d9-b653-45c4-4164-f5a492cabd6a@amazon.de>
Date:   Tue, 30 Jun 2020 16:01:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200630133609.GA20809@lst.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.109]
X-ClientProxiedBy: EX13D44UWC001.ant.amazon.com (10.43.162.26) To
 EX13D08EUC004.ant.amazon.com (10.43.164.176)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CgpPbiA2LzMwLzIwIDM6MzYgUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+IE9uIFR1ZSwg
SnVuIDMwLCAyMDIwIGF0IDAzOjMzOjU4UE0gKzAyMDAsIENocmlzdG9waCBIZWxsd2lnIHdyb3Rl
Ogo+PiBPbiBUdWUsIEp1biAzMCwgMjAyMCBhdCAxMjoyOToyM1BNICswMDAwLCBNYXhpbWlsaWFu
IEhleW5lIHdyb3RlOgo+Pj4gQ29udHJvbGxlciBJRCdzIChjbnRsaWQpIGZvciBOVk1lIGRldmlj
ZXMgd2VyZSBpbnRyb2R1Y2VkIGluIHZlcnNpb24KPj4+IDEuMS4wIG9mIHRoZSBzcGVjaWZpY2F0
aW9uLiBDb250cm9sbGVycyB0aGF0IGZvbGxvdyB0aGUgb2xkZXIgMS4wLjAgc3BlYwo+Pj4gZG9u
J3Qgc2V0IHRoaXMgZmllbGQgc28gaXQgZG9lc24ndCBtYWtlIHNlbnNlIHRvIHZhbGlkYXRlIGl0
LiBPbiB0aGUKPj4+IGNvbnRyYXJ5LCB3aGVuIHVzaW5nIFNSLUlPViB0aGlzIGNoZWNrIGJyZWFr
cyBWRnMgYXMgdGhleSBhcmUgYWxsIHBhcnQKPj4+IG9mIHRoZSBzYW1lIE5WTWUgc3Vic3lzdGVt
Lgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IE1heGltaWxpYW4gSGV5bmUgPG1oZXluZUBhbWF6b24u
ZGU+Cj4+PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgNS40Kwo+Pgo+PiBUaGUgZmly
c3QgaHVuayBsb29rcyBvaywgdGhlIHNlY29uZCBkb2Vzbid0IG1ha2Ugc2Vuc2UgYXMgZmFicmlj
cwo+PiB3YXMgb25seSBhZGRlZCB3aXRoIE5WTWUgMS4yLjIuICBJIGNhbiBmaXggaXQgdXAgd2hl
biBhcHBseWluZyBpZiB5b3UKPj4gYXJlIG9rIHdpdGggdGhhdC4KCkknZCBiZSB0b3RhbGx5IG9r
IHdpdGggdGhhdC4KCj4+Cj4+IEJ1dCB5b3UgZ3V5cyByZWFsbHkgc2hvdWxkbid0IGJlIGRvaW5n
IFNSLUlPViB3aXRoIDEuMCBjb250cm9sbGVycwo+PiBpbmRlcGVuZGVudCBvZiB0aGlzLi4KClNv
IGZhciBpdCB3b3JrZWQuLi4KCj4gCj4gQW5kIGFjdHVhbGx5IC0gMS4wIGRpZCBub3QgaGF2ZSB0
aGUgY29uY2VwdCBvZiBhIHN1YnN5c3RlbS4gIFNvIGhhdmluZwo+IGEgZHVwbGljYXRlIHNlcmlh
bCBudW1iZXIgZm9yIGEgMS4wIGNvbnRyb2xsZXIgYWN0dWFsbHkgaXMgYSBwcmV0dHkKPiBuYXN0
eSBidWcuICBDYW4geW91IHBvaW50IG1lIHRvIHRoaXMgYnJva2VuIGNvbnRyb2xsZXI/ICBEbyB5
b3UgdGhpbmsKPiB0aGUgT0VNIGNvdWxkIGZpeCBpdCB1cCB0byByZXBvcnQgYSBwcm9wZXIgdmVy
c2lvbiBudW1iZXIgYW5kIGNvbnRyb2xsZXIKPiBJRD8KPiAKCkkgbWVhbnQgdGhhdCB0aGUgVkYg
TlZNZSBjb250cm9sbGVycyB3aWxsIGFsbCBsYW5kIGluIHRoZSBzYW1lIHN1YnN5c3RlbSBmcm9t
CnRoZSBrZXJuZWwncyBwb2ludCBvZiB2aWV3LCBiZWNhdXNlLCBhcyB5b3Ugc2FpZCwgdGhlcmUg
d2FzIG5vIGlkZWEgb2YgZGlmZmVyZW50CnN1YnN5c3RlbXMgaW4gdGhlIDEuMCBzcGVjLgpJdCdz
IGFuIG9sZGVyIGluLWhvdXNlIGNvbnRyb2xsZXIuIFNlZW1zIHRvIHNldCB0aGUgc2FtZSBzZXJp
YWwgbnVtYmVyIGZvciBhbGwKVkYncy4gU2hvdWxkIHRoZSBmaXJtd2FyZSBzZXQgdW5pcXVlIHNl
cmlhbHMgZm9yIHRoZSBWRidzIGluc3RlYWQ/CgpUaGFua3MKTWF4CgoKCkFtYXpvbiBEZXZlbG9w
bWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNj
aGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdl
dHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpT
aXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

