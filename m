Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F3330B3C4
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 01:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBBABo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 19:01:44 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:42968 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhBBABo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 19:01:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1612224103; x=1643760103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wg30tc+SDviKzmp+OPI+dqgVAhbbf9XWGMgs51nNyrw=;
  b=SQu5UysTcVtbXcYqwqzbCCLd8PkRxycnVB2MHPQoknR8ZBEgQ+C0tFYu
   sEP4yZfzc+JwwATF0grXaXr4O/W/xZoBDHYKJJOnCbIdudt0nJLupFIMC
   IvSOCipjvCdZ5JvFz+l6hO9+GlnKM+AJC+AxbX2bqi2UCP7050TVHuN4Y
   0=;
X-IronPort-AV: E=Sophos;i="5.79,393,1602547200"; 
   d="scan'208";a="914839182"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 02 Feb 2021 00:00:56 +0000
Received: from EX13D02EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 2D63BA1D19;
        Tue,  2 Feb 2021 00:00:56 +0000 (UTC)
Received: from u2196cf9297dc59.ant.amazon.com (10.43.160.67) by
 EX13D02EUC001.ant.amazon.com (10.43.164.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Feb 2021 00:00:51 +0000
From:   Filippo Sironi <sironi@amazon.de>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <samjonas@amazon.com>,
        <dwmw@amazon.co.uk>, <sironi@amazon.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/2 for Linux 5.4] iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built
Date:   Tue, 2 Feb 2021 01:00:09 +0100
Message-ID: <20210202000009.31392-2-sironi@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202000009.31392-1-sironi@amazon.de>
References: <20210202000009.31392-1-sironi@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.67]
X-ClientProxiedBy: EX13D21UWA001.ant.amazon.com (10.43.160.154) To
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
YS9kcml2ZXJzL2lvbW11L2RtYXIuYyBiL2RyaXZlcnMvaW9tbXUvZG1hci5jCmluZGV4IGE1ZjY5
ZDliYjBiOC4uMWI5Nzk1NzQzMjc2IDEwMDY0NAotLS0gYS9kcml2ZXJzL2lvbW11L2RtYXIuYwor
KysgYi9kcml2ZXJzL2lvbW11L2RtYXIuYwpAQCAtMTExNCw2ICsxMTE0LDcgQEAgc3RhdGljIGlu
dCBhbGxvY19pb21tdShzdHJ1Y3QgZG1hcl9kcmhkX3VuaXQgKmRyaGQpCiAJfQogCiAJZHJoZC0+
aW9tbXUgPSBpb21tdTsKKwlpb21tdS0+ZHJoZCA9IGRyaGQ7CiAKIAlyZXR1cm4gMDsKIApAQCAt
MTEyOCw3ICsxMTI5LDcgQEAgc3RhdGljIGludCBhbGxvY19pb21tdShzdHJ1Y3QgZG1hcl9kcmhk
X3VuaXQgKmRyaGQpCiAKIHN0YXRpYyB2b2lkIGZyZWVfaW9tbXUoc3RydWN0IGludGVsX2lvbW11
ICppb21tdSkKIHsKLQlpZiAoaW50ZWxfaW9tbXVfZW5hYmxlZCAmJiBpb21tdS0+aW9tbXUub3Bz
KSB7CisJaWYgKGludGVsX2lvbW11X2VuYWJsZWQgJiYgIWlvbW11LT5kcmhkLT5pZ25vcmVkKSB7
CiAJCWlvbW11X2RldmljZV91bnJlZ2lzdGVyKCZpb21tdS0+aW9tbXUpOwogCQlpb21tdV9kZXZp
Y2Vfc3lzZnNfcmVtb3ZlKCZpb21tdS0+aW9tbXUpOwogCX0KZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvaW50ZWwtaW9tbXUuaCBiL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaAppbmRleCA2
YjU1OWQyNWE4NGUuLjg4YWM4ZWRmNDRlMyAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9pbnRl
bC1pb21tdS5oCisrKyBiL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaApAQCAtNTU2LDYgKzU1
Niw4IEBAIHN0cnVjdCBpbnRlbF9pb21tdSB7CiAJc3RydWN0IGlvbW11X2RldmljZSBpb21tdTsg
IC8qIElPTU1VIGNvcmUgY29kZSBoYW5kbGUgKi8KIAlpbnQJCW5vZGU7CiAJdTMyCQlmbGFnczsg
ICAgICAvKiBTb2Z0d2FyZSBkZWZpbmVkIGZsYWdzICovCisKKwlzdHJ1Y3QgZG1hcl9kcmhkX3Vu
aXQgKmRyaGQ7CiB9OwogCiAvKiBQQ0kgZG9tYWluLWRldmljZSByZWxhdGlvbnNoaXAgKi8KLS0g
CjIuMTcuMQoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNl
bnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxh
ZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRl
bmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcg
ODc5CgoK

