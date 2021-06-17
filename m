Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203C73AAF2F
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 10:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhFQI71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 04:59:27 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:39008 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhFQI71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 04:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623920241; x=1655456241;
  h=message-id:from:to:cc:date:in-reply-to:references:
   mime-version:content-transfer-encoding:subject;
  bh=Kn8Ho3X5Xbqs1B2LDrBQWn36ys4fG/nIZVHO5qU4VHM=;
  b=uXqLRM/uibuXcmuES5YWyM7Zc0JISxVdDOl164J+r4aZ2+xggfJAEBF3
   iOQzvqjqt8lnQNqnbMHcutKQ9iaTdqqb0nAGaQjQebWmgnuqLzxY4B3vF
   Dt158EBBtimHfTxhJ3f9oQow43ovJpIA726iiFYs0nhKgG4oi/dCnZlxt
   M=;
X-IronPort-AV: E=Sophos;i="5.83,280,1616457600"; 
   d="scan'208";a="119364469"
Subject: Re: [PATCH] arm64: perf: Disable PMU while processing counter overflows
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 17 Jun 2021 08:57:11 +0000
Received: from EX13D39EUC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id B1862A17C6;
        Thu, 17 Jun 2021 08:57:09 +0000 (UTC)
Received: from freeip.amazon.com (10.43.160.137) by
 EX13D39EUC002.ant.amazon.com (10.43.164.187) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 17 Jun 2021 08:57:05 +0000
Message-ID: <a9104042094d658a9ee86f332505dee1d2ed06fd.camel@amazon.de>
From:   Aman Priyadarshi <apeureka@amazon.de>
To:     Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Will Deacon <will@kernel.org>, Alexander Graf <graf@amazon.de>,
        "Mark Rutland" <mark.rutland@arm.com>, <stable@vger.kernel.org>,
        Ali Saidi <alisaidi@amazon.com>
Date:   Thu, 17 Jun 2021 10:57:00 +0200
In-Reply-To: <87r1h1c5bo.wl-maz@kernel.org>
References: <YMoQ1MZgsL2hF2EL@kroah.com>
         <20210616192859.21708-1-apeureka@amazon.de>    <YMrUt+Vhs5exEqVt@kroah.com>
         <87r1h1c5bo.wl-maz@kernel.org>
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D49UWC003.ant.amazon.com (10.43.162.10) To
 EX13D39EUC002.ant.amazon.com (10.43.164.187)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIxLTA2LTE3IGF0IDA4OjM0ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QKPiBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQKPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUu
Cj4gCj4gCj4gCj4gT24gVGh1LCAxNyBKdW4gMjAyMSAwNTo1MTowMyArMDEwMCwKPiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPiB3cm90ZToKPiA+IAo+ID4g
T24gV2VkLCBKdW4gMTYsIDIwMjEgYXQgMDk6Mjg6NTlQTSArMDIwMCwgQW1hbiBQcml5YWRhcnNo
aSB3cm90ZToKPiA+ID4gRnJvbTogU3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJt
LmNvbT4KPiA+ID4gCj4gPiA+IFsgVXBzdHJlYW0gY29tbWl0IDNjY2U1MGRmZWM0YTViMDQxNGM5
NzQxOTA5NDBmNDdkZDMyYzZkZWUgXQo+ID4gPiAKPiA+ID4gVGhlIGFybTY0IFBNVSB1cGRhdGVz
IHRoZSBldmVudCBjb3VudGVycyBhbmQgcmVwcm9ncmFtcyB0aGUKPiA+ID4gY291bnRlcnMgaW4g
dGhlIG92ZXJmbG93IElSUSBoYW5kbGVyIHdpdGhvdXQgZGlzYWJsaW5nIHRoZQo+ID4gPiBQTVUu
IFRoaXMgY291bGQgcG90ZW50aWFsbHkgY2F1c2Ugc2tld3MgaW4gZm9yIGdyb3VwIGNvdW50ZXJz
LAo+ID4gPiB3aGVyZSB0aGUgb3ZlcmZsb3dlZCBjb3VudGVycyBtYXkgcG90ZW50aWFsbHkgbG9v
c2Ugc29tZSBldmVudAo+ID4gPiBjb3VudHMsIHdoaWxlIHRoZXkgYXJlIHJlcHJvZ3JhbW1lZC4g
VG8gcHJldmVudCB0aGlzLCBkaXNhYmxlCj4gPiA+IHRoZSBQTVUgd2hpbGUgd2UgcHJvY2VzcyB0
aGUgY291bnRlciBvdmVyZmxvd3MgYW5kIGVuYWJsZSBpdAo+ID4gPiByaWdodCBiYWNrIHdoZW4g
d2UgYXJlIGRvbmUuCj4gPiA+IAo+ID4gPiBUaGlzIHBhdGNoIGFsc28gbW92ZXMgdGhlIFBNVSBz
dG9wL3N0YXJ0IHJvdXRpbmVzIHRvIGF2b2lkIGEKPiA+ID4gZm9yd2FyZCBkZWNsYXJhdGlvbi4K
PiA+ID4gCj4gPiA+IFN1Z2dlc3RlZC1ieTogTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJt
LmNvbT4KPiA+ID4gQ2M6IFdpbGwgRGVhY29uIDx3aWxsLmRlYWNvbkBhcm0uY29tPgo+ID4gPiBB
Y2tlZC1ieTogTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4KPiA+ID4gU2lnbmVk
LW9mZi1ieTogU3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNvbT4KPiA+ID4g
U2lnbmVkLW9mZi1ieTogV2lsbCBEZWFjb24gPHdpbGwuZGVhY29uQGFybS5jb20+Cj4gPiA+IFNp
Z25lZC1vZmYtYnk6IEFtYW4gUHJpeWFkYXJzaGkgPGFwZXVyZWthQGFtYXpvbi5kZT4KPiA+ID4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKPiA+ID4gLS0tCj4gPiA+ICBhcmNoL2FybTY0L2tl
cm5lbC9wZXJmX2V2ZW50LmMgfCA1MCArKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQo+
ID4gPiAtLQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDIyIGRlbGV0
aW9ucygtKQo+ID4gCj4gPiBXaGF0IHN0YWJsZSB0cmVlKHMpIGRvIHlvdSB3YW50IHRoaXMgYXBw
bGllZCB0bz8KPiAKPiBJIGd1ZXNzIHRoYXQnZCBiZSA0LjE0IGFuZCBwcmV2aW91cyBzdGFibGVz
IGlmIHRoZSBwYXRjaCBhY3R1YWxseQo+IGFwcGxpZXMuCj4gCgpDb3JyZWN0LiBJIGhhdmUgdGVz
dGVkIHRoZSBwYXRjaCBvbiA0LjE0LnksIGNhbiBjb25maXJtIHRoYXQgaXQgYXBwbGllcwpjbGVh
bmx5IG9uIDQuOS55IGFzIHdlbGwuCgpUaGFua3MsCkFtYW4gUHJpeWFkYXJzaGkKCgoKCkFtYXpv
biBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJl
cmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdl
aXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAx
NDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

