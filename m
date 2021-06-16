Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612EC3A98E3
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 13:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFPLMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 07:12:07 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:28700 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhFPLMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 07:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623841800; x=1655377800;
  h=message-id:subject:from:to:cc:date:mime-version:
   content-transfer-encoding;
  bh=vXB4d1gDhmYh10ZPw8bshhBBfcqxOPrafr1p7XiBWf4=;
  b=qjHddaHS2Uy7ChJlEa7GBuYvh8Umk/GC+08x2MXd9T2h2qrOmgpuuoU7
   XA1al2J68lC+bCK1dW/wsReY8b8w2fYJwiFaIvD2uMPGpyKU2R/+hzkVB
   SIEAcwWTD7eF32fVvklpDMGQpzffsp9QbRlb7GMP0Y464Q0ONH4BxCQei
   k=;
X-IronPort-AV: E=Sophos;i="5.83,277,1616457600"; 
   d="scan'208";a="114628187"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 16 Jun 2021 11:09:59 +0000
Received: from EX13D39EUC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 1115BA01DE;
        Wed, 16 Jun 2021 11:09:58 +0000 (UTC)
Received: from freeip.amazon.com (10.43.162.73) by
 EX13D39EUC002.ant.amazon.com (10.43.164.187) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 16 Jun 2021 11:09:54 +0000
Message-ID: <61660ade9bedf601e2fdbd12c5fade05d910526d.camel@amazon.de>
Subject: [v4.14.y] 3cce50dfec4a arm64: perf: Disable PMU while processing
 counter overflows
From:   Aman Priyadarshi <apeureka@amazon.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Alexander Graf <graf@amazon.com>,
        "Ali Saidi" <alisaidi@amazon.com>
Date:   Wed, 16 Jun 2021 13:09:49 +0200
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D46UWB001.ant.amazon.com (10.43.161.16) To
 EX13D39EUC002.ant.amazon.com (10.43.164.187)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywKCkZvbGxvd2luZyB0aGUgY29udmVyc2F0aW9uIHdpdGggTWFyYywgd2UgZGlzY292
ZXJlZCB0aGF0IGFuCmltcG9ydGFudCBmaXggZm9yIEFSTSBQTVUgaXMgbm90IGJhY2twb3J0ZWQg
dG8gNC4xNC55IHRyZWUsIGl0IGFmZmVjdHMKY291bnRlciB2YWx1ZSBhbmQgZ2l2ZSBvdXQgbm9u
c2Vuc2ljYWwgcmVzdWx0LgoKQ2FuIHlvdSBwbGVhc2UgaW5jbHVkZSB0aGUgZm9sbG93aW5nIGNv
bW1pdD8KYGBgCmNvbW1pdCAzY2NlNTBkZmVjNGE1YjA0MTRjOTc0MTkwOTQwZjQ3ZGQzMmM2ZGVl
CkF1dGhvcjogU3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNvbT4KRGF0ZTog
ICBUdWUgSnVsIDEwIDA5OjU4OjAzIDIwMTggKzAxMDAKCiAgICBhcm02NDogcGVyZjogRGlzYWJs
ZSBQTVUgd2hpbGUgcHJvY2Vzc2luZyBjb3VudGVyIG92ZXJmbG93cwogICAgCiAgICBUaGUgYXJt
NjQgUE1VIHVwZGF0ZXMgdGhlIGV2ZW50IGNvdW50ZXJzIGFuZCByZXByb2dyYW1zIHRoZQogICAg
Y291bnRlcnMgaW4gdGhlIG92ZXJmbG93IElSUSBoYW5kbGVyIHdpdGhvdXQgZGlzYWJsaW5nIHRo
ZQogICAgUE1VLiBUaGlzIGNvdWxkIHBvdGVudGlhbGx5IGNhdXNlIHNrZXdzIGluIGZvciBncm91
cCBjb3VudGVycywKICAgIHdoZXJlIHRoZSBvdmVyZmxvd2VkIGNvdW50ZXJzIG1heSBwb3RlbnRp
YWxseSBsb29zZSBzb21lIGV2ZW50CiAgICBjb3VudHMsIHdoaWxlIHRoZXkgYXJlIHJlcHJvZ3Jh
bW1lZC4gVG8gcHJldmVudCB0aGlzLCBkaXNhYmxlCiAgICB0aGUgUE1VIHdoaWxlIHdlIHByb2Nl
c3MgdGhlIGNvdW50ZXIgb3ZlcmZsb3dzIGFuZCBlbmFibGUgaXQKICAgIHJpZ2h0IGJhY2sgd2hl
biB3ZSBhcmUgZG9uZS4KICAgIAogICAgVGhpcyBwYXRjaCBhbHNvIG1vdmVzIHRoZSBQTVUgc3Rv
cC9zdGFydCByb3V0aW5lcyB0byBhdm9pZCBhCiAgICBmb3J3YXJkIGRlY2xhcmF0aW9uLgogICAg
CiAgICBTdWdnZXN0ZWQtYnk6IE1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+CiAg
ICBDYzogV2lsbCBEZWFjb24gPHdpbGwuZGVhY29uQGFybS5jb20+CiAgICBBY2tlZC1ieTogTWFy
ayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IFN1enVr
aSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBX
aWxsIERlYWNvbiA8d2lsbC5kZWFjb25AYXJtLmNvbT4KYGBgCgpGb3IgbW9yZSBkZXRhaWxzOgoK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvcGlwZXJtYWlsL2t2bWFybS8yMDIxLUp1bmUv
MDQ3NDcxLmh0bWwKClJlZ2FyZHMsCkFtYW4gUHJpeWFkYXJzaGkKCgoKCgoKCkFtYXpvbiBEZXZl
bG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpH
ZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVp
bmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMg
QgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

