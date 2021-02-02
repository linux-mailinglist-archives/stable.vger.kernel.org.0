Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7556830B3DE
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 01:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhBBAIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 19:08:15 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:51863 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhBBAIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 19:08:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1612224493; x=1643760493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QCoVddCEF7QV4ljqWQBw1fvG5DuaxOX9/7UB3PdkroM=;
  b=g6MkpxUf+w5WSWz2apuA1QwwM0Ajo54FKxVigP4jFwq1MSrw9ahKtYZU
   Ce32wwGOIybP6tBGGuk/1YJkbtJLDCsJQpSnLWaZxS1Jv1BZ3dzl8bdWb
   ErMN3RERa6AHFS0leDw6X0by2SQlB2Stsvs8SC+wILb2s8JK4ALSdiiO3
   o=;
X-IronPort-AV: E=Sophos;i="5.79,393,1602547200"; 
   d="scan'208";a="914840313"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 02 Feb 2021 00:07:33 +0000
Received: from EX13D02EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id AC98C120DD1;
        Tue,  2 Feb 2021 00:07:32 +0000 (UTC)
Received: from u2196cf9297dc59.ant.amazon.com (10.43.161.244) by
 EX13D02EUC001.ant.amazon.com (10.43.164.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Feb 2021 00:07:28 +0000
From:   Filippo Sironi <sironi@amazon.de>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <samjonas@amazon.com>,
        <dwmw@amazon.co.uk>, <sironi@amazon.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/2 for Linux 4.9] iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built
Date:   Tue, 2 Feb 2021 01:07:07 +0100
Message-ID: <20210202000707.1696-2-sironi@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202000707.1696-1-sironi@amazon.de>
References: <20210202000707.1696-1-sironi@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D40UWC001.ant.amazon.com (10.43.162.149) To
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
YS9kcml2ZXJzL2lvbW11L2RtYXIuYyBiL2RyaXZlcnMvaW9tbXUvZG1hci5jCmluZGV4IGE2OGUz
YjRmZGQ2ZS4uOWFkNWE3MDE5YWJmIDEwMDY0NAotLS0gYS9kcml2ZXJzL2lvbW11L2RtYXIuYwor
KysgYi9kcml2ZXJzL2lvbW11L2RtYXIuYwpAQCAtMTExMCw2ICsxMTEwLDcgQEAgc3RhdGljIGlu
dCBhbGxvY19pb21tdShzdHJ1Y3QgZG1hcl9kcmhkX3VuaXQgKmRyaGQpCiAJfQogCiAJZHJoZC0+
aW9tbXUgPSBpb21tdTsKKwlpb21tdS0+ZHJoZCA9IGRyaGQ7CiAKIAlyZXR1cm4gMDsKIApAQCAt
MTEyNCw3ICsxMTI1LDcgQEAgc3RhdGljIGludCBhbGxvY19pb21tdShzdHJ1Y3QgZG1hcl9kcmhk
X3VuaXQgKmRyaGQpCiAKIHN0YXRpYyB2b2lkIGZyZWVfaW9tbXUoc3RydWN0IGludGVsX2lvbW11
ICppb21tdSkKIHsKLQlpZiAoaW50ZWxfaW9tbXVfZW5hYmxlZCAmJiBpb21tdS0+aW9tbXVfZGV2
KQorCWlmIChpbnRlbF9pb21tdV9lbmFibGVkICYmICFpb21tdS0+ZHJoZC0+aWdub3JlZCkKIAkJ
aW9tbXVfZGV2aWNlX2Rlc3Ryb3koaW9tbXUtPmlvbW11X2Rldik7CiAKIAlpZiAoaW9tbXUtPmly
cSkgewpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5oIGIvaW5jbHVkZS9s
aW51eC9pbnRlbC1pb21tdS5oCmluZGV4IGQ4NmFjNjIwZjBhYS4uMTg4YmQxNzY4OTcxIDEwMDY0
NAotLS0gYS9pbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmgKKysrIGIvaW5jbHVkZS9saW51eC9p
bnRlbC1pb21tdS5oCkBAIC00NDcsNiArNDQ3LDggQEAgc3RydWN0IGludGVsX2lvbW11IHsKIAlz
dHJ1Y3QgZGV2aWNlCSppb21tdV9kZXY7IC8qIElPTU1VLXN5c2ZzIGRldmljZSAqLwogCWludAkJ
bm9kZTsKIAl1MzIJCWZsYWdzOyAgICAgIC8qIFNvZnR3YXJlIGRlZmluZWQgZmxhZ3MgKi8KKwor
CXN0cnVjdCBkbWFyX2RyaGRfdW5pdCAqZHJoZDsKIH07CiAKIHN0YXRpYyBpbmxpbmUgdm9pZCBf
X2lvbW11X2ZsdXNoX2NhY2hlKAotLSAKMi4xNy4xCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2Vu
dGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1
ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBh
bSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVy
bGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

