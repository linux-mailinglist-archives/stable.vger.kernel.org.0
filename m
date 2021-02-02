Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078BD30B3D3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 01:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhBBAFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 19:05:52 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:45081 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhBBAFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 19:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1612224352; x=1643760352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JEWUfEn+GQ63A/eil383AfdEQiCSj84ojbTWjvEnsVQ=;
  b=J8jf2w+Bmv27+MiX93Tja04Tw7qjh4Ep1DZ2SigawzpYI1tx6IYv8vE6
   wfwGBKj7u99JnQ4uUEmflZBh9n3lQqwJ0qDi9l36S6AXLpo5G7kmBKeG3
   SMdcj03+e8w5P3eWec0cJquSEwkcoeDZ5+wW9n7uMrALCGKBZd0zZkfl5
   A=;
X-IronPort-AV: E=Sophos;i="5.79,393,1602547200"; 
   d="scan'208";a="83114908"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 02 Feb 2021 00:05:11 +0000
Received: from EX13D02EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 2B84BB3981;
        Tue,  2 Feb 2021 00:05:10 +0000 (UTC)
Received: from u2196cf9297dc59.ant.amazon.com (10.43.162.32) by
 EX13D02EUC001.ant.amazon.com (10.43.164.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Feb 2021 00:05:05 +0000
From:   Filippo Sironi <sironi@amazon.de>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <samjonas@amazon.com>,
        <dwmw@amazon.co.uk>, <sironi@amazon.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/2 for Linux 4.14] iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built
Date:   Tue, 2 Feb 2021 01:04:45 +0100
Message-ID: <20210202000445.711-2-sironi@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202000445.711-1-sironi@amazon.de>
References: <20210202000445.711-1-sironi@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.32]
X-ClientProxiedBy: EX13D11UWB002.ant.amazon.com (10.43.161.20) To
 EX13D02EUC001.ant.amazon.com (10.43.164.92)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQmFydG9zeiBHb2xhc3pld3NraSA8YmdvbGFzemV3c2tpQGJheWxpYnJlLmNvbT4KCmNv
bW1pdCA5ZGVmM2IxYTA3YzQxZTIxYzY4YTBlYjM1M2UzZTU2OWZkZDFkMmIxIHVwc3RyZWFtLgoK
U2luY2UgY29tbWl0IGM0MGFhYWFjMTAxOCAoImlvbW11L3Z0LWQ6IEdyYWNlZnVsbHkgaGFuZGxl
IERNQVIgdW5pdHMKd2l0aCBubyBzdXBwb3J0ZWQgYWRkcmVzcyB3aWR0aHMiKSBkbWFyLmMgbmVl
ZHMgc3RydWN0IGlvbW11X2RldmljZSB0bwpiZSBzZWxlY3RlZC4gV2UgY2FuIGRyb3AgdGhpcyBk
ZXBlbmRlbmN5IGJ5IG5vdCBkZXJlZmVyZW5jaW5nIHN0cnVjdAppb21tdV9kZXZpY2UgaWYgSU9N
TVVfQVBJIGlzIG5vdCBzZWxlY3RlZCBhbmQgYnkgcmV1c2luZyB0aGUgaW5mb3JtYXRpb24Kc3Rv
cmVkIGluIGlvbW11LT5kcmhkLT5pZ25vcmVkIGluc3RlYWQuCgpUaGlzIGZpeGVzIHRoZSBmb2xs
b3dpbmcgYnVpbGQgZXJyb3Igd2hlbiBJT01NVV9BUEkgaXMgbm90IHNlbGVjdGVkOgoKZHJpdmVy
cy9pb21tdS9kbWFyLmM6IEluIGZ1bmN0aW9uIOKAmGZyZWVfaW9tbXXigJk6CmRyaXZlcnMvaW9t
bXUvZG1hci5jOjExMzk6NDE6IGVycm9yOiDigJhzdHJ1Y3QgaW9tbXVfZGV2aWNl4oCZIGhhcyBu
byBtZW1iZXIgbmFtZWQg4oCYb3Bz4oCZCiAxMTM5IHwgIGlmIChpbnRlbF9pb21tdV9lbmFibGVk
ICYmIGlvbW11LT5pb21tdS5vcHMpIHsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXgoKRml4ZXM6IGM0MGFhYWFjMTAxOCAoImlvbW11L3Z0LWQ6IEdyYWNl
ZnVsbHkgaGFuZGxlIERNQVIgdW5pdHMgd2l0aCBubyBzdXBwb3J0ZWQgYWRkcmVzcyB3aWR0aHMi
KQpTaWduZWQtb2ZmLWJ5OiBCYXJ0b3N6IEdvbGFzemV3c2tpIDxiZ29sYXN6ZXdza2lAYmF5bGli
cmUuY29tPgpBY2tlZC1ieTogTHUgQmFvbHUgPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT4KQWNr
ZWQtYnk6IERhdmlkIFdvb2Rob3VzZSA8ZHdtd0BhbWF6b24uY28udWs+Ckxpbms6IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL3IvMjAyMDEwMTMwNzMwNTUuMTEyNjItMS1icmdsQGJnZGV2LnBsClNp
Z25lZC1vZmYtYnk6IEpvZXJnIFJvZWRlbCA8anJvZWRlbEBzdXNlLmRlPgpbIC0gY29udGV4dCBj
aGFuZ2UgZHVlIHRvIG1vdmluZyBkcml2ZXJzL2lvbW11L2RtYXIuYyB0bwogICAgZHJpdmVycy9p
b21tdS9pbnRlbC9kbWFyLmMKICAtIHNldCB0aGUgZHJociBpbiB0aGUgaW9tbXUgbGlrZSBpbiB1
cHN0cmVhbSBjb21taXQgYjEwMTJjYThkYzRmCiAgICAoImlvbW11L3Z0LWQ6IFNraXAgVEUgZGlz
YWJsaW5nIG9uIHF1aXJreSBnZnggZGVkaWNhdGVkIGlvbW11IikgXQpTaWduZWQtb2ZmLWJ5OiBG
aWxpcHBvIFNpcm9uaSA8c2lyb25pQGFtYXpvbi5kZT4KLS0tCiBkcml2ZXJzL2lvbW11L2RtYXIu
YyAgICAgICAgfCAzICsrLQogaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5oIHwgMiArKwogMiBm
aWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2lvbW11L2RtYXIuYyBiL2RyaXZlcnMvaW9tbXUvZG1hci5jCmluZGV4IDRkNjJk
ZDIxMzFlMi4uZWY0MTU3OTg5N2NiIDEwMDY0NAotLS0gYS9kcml2ZXJzL2lvbW11L2RtYXIuYwor
KysgYi9kcml2ZXJzL2lvbW11L2RtYXIuYwpAQCAtMTEyMCw2ICsxMTIwLDcgQEAgc3RhdGljIGlu
dCBhbGxvY19pb21tdShzdHJ1Y3QgZG1hcl9kcmhkX3VuaXQgKmRyaGQpCiAJfQogCiAJZHJoZC0+
aW9tbXUgPSBpb21tdTsKKwlpb21tdS0+ZHJoZCA9IGRyaGQ7CiAKIAlyZXR1cm4gMDsKIApAQCAt
MTEzNCw3ICsxMTM1LDcgQEAgc3RhdGljIGludCBhbGxvY19pb21tdShzdHJ1Y3QgZG1hcl9kcmhk
X3VuaXQgKmRyaGQpCiAKIHN0YXRpYyB2b2lkIGZyZWVfaW9tbXUoc3RydWN0IGludGVsX2lvbW11
ICppb21tdSkKIHsKLQlpZiAoaW50ZWxfaW9tbXVfZW5hYmxlZCAmJiBpb21tdS0+aW9tbXUub3Bz
KSB7CisJaWYgKGludGVsX2lvbW11X2VuYWJsZWQgJiYgIWlvbW11LT5kcmhkLT5pZ25vcmVkKSB7
CiAJCWlvbW11X2RldmljZV91bnJlZ2lzdGVyKCZpb21tdS0+aW9tbXUpOwogCQlpb21tdV9kZXZp
Y2Vfc3lzZnNfcmVtb3ZlKCZpb21tdS0+aW9tbXUpOwogCX0KZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvaW50ZWwtaW9tbXUuaCBiL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaAppbmRleCBk
MjM2NGJhOTlmNmMuLmYxMjFiNGJjOGIxNCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9pbnRl
bC1pb21tdS5oCisrKyBiL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaApAQCAtNDM0LDYgKzQz
NCw4IEBAIHN0cnVjdCBpbnRlbF9pb21tdSB7CiAJc3RydWN0IGlvbW11X2RldmljZSBpb21tdTsg
IC8qIElPTU1VIGNvcmUgY29kZSBoYW5kbGUgKi8KIAlpbnQJCW5vZGU7CiAJdTMyCQlmbGFnczsg
ICAgICAvKiBTb2Z0d2FyZSBkZWZpbmVkIGZsYWdzICovCisKKwlzdHJ1Y3QgZG1hcl9kcmhkX3Vu
aXQgKmRyaGQ7CiB9OwogCiBzdGF0aWMgaW5saW5lIHZvaWQgX19pb21tdV9mbHVzaF9jYWNoZSgK
LS0gCjIuMTcuMQoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3Jh
dXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNj
aGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxv
dHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAy
MzcgODc5CgoK

