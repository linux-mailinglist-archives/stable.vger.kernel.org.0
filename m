Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F4B44D086
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 04:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhKKDxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 22:53:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhKKDxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 22:53:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53C8C611C0;
        Thu, 11 Nov 2021 03:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636602643;
        bh=T+cPUWC/bivZ6XKwLoaOFy2OKpe0dq582Iibix/HQYc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p+LZzp2Lr9l8v3nd1/QSNTyDYFjufKyyxIAUUYvMgcg+wgF6s7INq3blY34H4C+dw
         25exyo/uG8ZLWtxbu/V0qw+goxZXr2/O7JOy2BlYi4hAFlif8krBINeSgVKa4JckmY
         BxpuNUMTKWBcbI0NKbAPOcD4n/dTMV4v7sLmyjTKa1mxARdNn5GKCDYdiAJLxSXqpX
         SEKXxgoqcglaynh/Dao243XVcHyrRHkmdL6Zd+fEFvdYte5eTGFLo7HC5tylKlBhtK
         9zEh6kblXXeOof5r8PdRen+kmgYzF8gBur9HhMDNTjjZ+ujV77GnIko5hP9FZFJ5ZG
         d/f80ftzYIVuw==
Message-ID: <f99dca08d332b01daec9eed7e4a55f042b551a67.camel@kernel.org>
Subject: Re: [PATCH V2] x86/sgx: Fix free page accounting
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, linux-sgx@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Thu, 11 Nov 2021 05:50:41 +0200
In-Reply-To: <YYyNeW28jqKwD0tF@agluck-desk2.amr.corp.intel.com>
References: <b2e69e9febcae5d98d331de094d9cc7ce3217e66.1636487172.git.reinette.chatre@intel.com>
         <8e0bb87f05b79317a06ed2d8ab5e2f5cf6132b6a.camel@kernel.org>
         <794a7034-f6a7-4aff-7958-b1bd959ced24@intel.com>
         <94df4c660532a6bf414b6bbd8e25c3ea2e4eda5b.camel@kernel.org>
         <YYyNeW28jqKwD0tF@agluck-desk2.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIxLTExLTEwIGF0IDE5OjI2IC0wODAwLCBMdWNrLCBUb255IHdyb3RlOgo+IE9u
IFRodSwgTm92IDExLCAyMDIxIGF0IDA0OjU1OjE0QU0gKzAyMDAsIEphcmtrbyBTYWtraW5lbiB3
cm90ZToKPiA+IE9uIFdlZCwgMjAyMS0xMS0xMCBhdCAxMDo1MSAtMDgwMCwgUmVpbmV0dGUgQ2hh
dHJlIHdyb3RlOgo+ID4gPiBzZ3hfc2hvdWxkX3JlY2xhaW0oKSB3b3VsZCBvbmx5IHN1Y2NlZWQg
d2hlbiBzZ3hfbnJfZnJlZV9wYWdlcyBnb2VzIAo+ID4gPiBiZWxvdyB0aGUgd2F0ZXJtYXJrLiBP
bmNlIHNneF9ucl9mcmVlX3BhZ2VzIGJlY29tZXMgY29ycnVwdGVkIHRoZXJlIGlzIAo+ID4gPiBu
byBjbGVhciB3YXkgaW4gd2hpY2ggaXQgY2FuIGNvcnJlY3QgaXRzZWxmIHNpbmNlIGl0IGlzIG9u
bHkgZXZlciAKPiA+ID4gaW5jcmVtZW50ZWQgb3IgZGVjcmVtZW50ZWQuCj4gPiAKPiA+IFNvIG9u
ZSBzY2VuYXJpbyB3b3VsZCBiZToKPiA+IAo+ID4gMS4gQ1BVIEEgZG9lcyBhIFJFQUQgb2Ygc2d4
X25yX2ZyZWVfcGFnZXMuCj4gPiAyLiBDUFUgQiBkb2VzIGEgUkVBRCBvZiBzZ3hfbnJfZnJlZV9w
YWdlcy4KPiA+IDMuIENQVSBBIGRvZXMgYSBTVE9SRSBvZiBzZ3hfbnJfZnJlZV9wYWdlcy4KPiA+
IDQuIENQVSBCIGRvZXMgYSBTVE9SRSBvZiBzZ3hfbnJfZnJlZV9wYWdlcy4KPiA+IAo+ID4gPwo+
ID4gCj4gPiBUaGF0IGRvZXMgY29ycnVwdCB0aGUgdmFsdWUsIHllcywgYnV0IEkgZG9uJ3Qgc2Vl
IGFueXRoaW5nIGxpa2UgdGhpcwo+ID4gaW4gdGhlIGNvbW1pdCBtZXNzYWdlLCBzbyBJJ2xsIGhh
dmUgdG8gY2hlY2suCj4gPiAKPiA+IEkgdGhpbmsgdGhlIGNvbW1pdCBtZXNzYWdlIGlzIGxhY2tp
bmcgYSBjb25jdXJyZW5jeSBzY2VuYXJpbywgYW5kIHRoZQo+ID4gY3VycmVudCB0cmFuc2NyaXB0
cyBhcmUgYSBiaXQgdXNlbGVzcy4KPiAKPiBXaGF0IGFib3V0IHRoaXMgcGFydDoKPiAKPiDCoMKg
wqDCoMKgwqDCoMKgV2l0aCBzZ3hfbnJfZnJlZV9wYWdlcyBhY2Nlc3NlZCBhbmQgbW9kaWZpZWQg
ZnJvbSBhIGZldyBwbGFjZXMKPiDCoMKgwqDCoMKgwqDCoMKgaXQgaXMgZXNzZW50aWFsIHRvIGVu
c3VyZSB0aGF0IHRoZXNlIGFjY2Vzc2VzIGFyZSBkb25lIHNhZmVseSBidXQKPiDCoMKgwqDCoMKg
wqDCoMKgdGhpcyBpcyBub3QgdGhlIGNhc2UuIHNneF9ucl9mcmVlX3BhZ2VzIGlzIHJlYWQgd2l0
aG91dCBhbnkKPiDCoMKgwqDCoMKgwqDCoMKgcHJvdGVjdGlvbiBhbmQgdXBkYXRlZCB3aXRoIGlu
Y29uc2lzdGVudCBwcm90ZWN0aW9uIGJ5IGFueSBvbmUKPiDCoMKgwqDCoMKgwqDCoMKgb2YgdGhl
IHNwaW4gbG9ja3MgYXNzb2NpYXRlZCB3aXRoIHRoZSBpbmRpdmlkdWFsIE5VTUEgbm9kZXMuCj4g
wqDCoMKgwqDCoMKgwqDCoEZvciBleGFtcGxlOgo+IAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIENQVV9BwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBDUFVfQgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC0tLS0t
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAtLS0tLQo+IMKgwqDCoMKgwqDCoMKgwqAgc3Bpbl9sb2NrKCZub2RlQS0+bG9jayk7
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Bpbl9sb2NrKCZub2RlQi0+bG9jayk7Cj4gwqDC
oMKgwqDCoMKgwqDCoCAuLi7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAuLi4KPiDCoMKgwqDCoMKgwqDCoMKgIHNneF9u
cl9mcmVlX3BhZ2VzLS07wqAgLyogTk9UIFNBRkUgKi/CoCBzZ3hfbnJfZnJlZV9wYWdlcy0tOwo+
IAo+IMKgwqDCoMKgwqDCoMKgwqAgc3Bpbl91bmxvY2soJm5vZGVBLT5sb2NrKTvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrKCZub2RlQi0+bG9jayk7Cj4gCj4gTWF5YmUgeW91IG1p
c3NlZCB0aGUgIk5PVCBTQUZFIiBoaWRkZW4gaW4gdGhlIG1pZGRsZSBvZgo+IHRoZSBwaWN0dXJl
Pwo+IAo+IC1Ub255CgpGb3IgbWUgZnJvbSB0aGF0IHRoZSBvcmRlcmluZyBpcyBub3QgY2xlYXIu
IEUuZy4gY29tcGFyZSB0bwpodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9Eb2N1bWVudGF0aW9u
L21lbW9yeS1iYXJyaWVycy50eHQKCi9KYXJra28KCg==

