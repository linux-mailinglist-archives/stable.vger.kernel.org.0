Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6316830B3E7
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 01:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhBBAK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 19:10:56 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:51650 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhBBAKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 19:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1612224653; x=1643760653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sov4X5C/9kcENh6T51cQT1ePVhetW1kKbeYZ5PrtKIg=;
  b=m8/mm/RITxRq+MHyk9vRHkBkt4j8/F08Q+W65Wu6aX6SkYyih61PEALq
   AdI3v00VhUUx0BWx7HtnPKEp4GlspA4ESMs3MDlDKQTCDEwMh1knKyA17
   bzcHtgV2pxvxPfJHX2ntA9SkO5dqmpfJ/q9m56pUHZLTdkNyYTjk7fWRK
   Y=;
X-IronPort-AV: E=Sophos;i="5.79,393,1602547200"; 
   d="scan'208";a="83115610"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 02 Feb 2021 00:10:14 +0000
Received: from EX13D02EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id D4C2EA2392;
        Tue,  2 Feb 2021 00:10:01 +0000 (UTC)
Received: from u2196cf9297dc59.ant.amazon.com (10.43.160.244) by
 EX13D02EUC001.ant.amazon.com (10.43.164.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Feb 2021 00:09:57 +0000
From:   Filippo Sironi <sironi@amazon.de>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <samjonas@amazon.com>,
        <dwmw@amazon.co.uk>, <sironi@amazon.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/2 for Linux 4.4] iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built
Date:   Tue, 2 Feb 2021 01:09:37 +0100
Message-ID: <20210202000937.2151-2-sironi@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202000937.2151-1-sironi@amazon.de>
References: <20210202000937.2151-1-sironi@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.244]
X-ClientProxiedBy: EX13D06UWC003.ant.amazon.com (10.43.162.86) To
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
YS9kcml2ZXJzL2lvbW11L2RtYXIuYyBiL2RyaXZlcnMvaW9tbXUvZG1hci5jCmluZGV4IDA5NTAy
MjkyMzI1OC4uNTRmMjdkZDlmMTU2IDEwMDY0NAotLS0gYS9kcml2ZXJzL2lvbW11L2RtYXIuYwor
KysgYi9kcml2ZXJzL2lvbW11L2RtYXIuYwpAQCAtMTA4Nyw2ICsxMDg3LDcgQEAgc3RhdGljIGlu
dCBhbGxvY19pb21tdShzdHJ1Y3QgZG1hcl9kcmhkX3VuaXQgKmRyaGQpCiAJcmF3X3NwaW5fbG9j
a19pbml0KCZpb21tdS0+cmVnaXN0ZXJfbG9jayk7CiAKIAlkcmhkLT5pb21tdSA9IGlvbW11Owor
CWlvbW11LT5kcmhkID0gZHJoZDsKIAogCWlmIChpbnRlbF9pb21tdV9lbmFibGVkICYmICFkcmhk
LT5pZ25vcmVkKQogCQlpb21tdS0+aW9tbXVfZGV2ID0gaW9tbXVfZGV2aWNlX2NyZWF0ZShOVUxM
LCBpb21tdSwKQEAgLTExMDQsNyArMTEwNSw3IEBAIGVycm9yOgogCiBzdGF0aWMgdm9pZCBmcmVl
X2lvbW11KHN0cnVjdCBpbnRlbF9pb21tdSAqaW9tbXUpCiB7Ci0JaWYgKGludGVsX2lvbW11X2Vu
YWJsZWQgJiYgaW9tbXUtPmlvbW11X2RldikKKwlpZiAoaW50ZWxfaW9tbXVfZW5hYmxlZCAmJiAh
aW9tbXUtPmRyaGQtPmlnbm9yZWQpCiAJCWlvbW11X2RldmljZV9kZXN0cm95KGlvbW11LT5pb21t
dV9kZXYpOwogCiAJaWYgKGlvbW11LT5pcnEpIHsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
aW50ZWwtaW9tbXUuaCBiL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaAppbmRleCBkODZhYzYy
MGYwYWEuLjE4OGJkMTc2ODk3MSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9pbnRlbC1pb21t
dS5oCisrKyBiL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaApAQCAtNDQ3LDYgKzQ0Nyw4IEBA
IHN0cnVjdCBpbnRlbF9pb21tdSB7CiAJc3RydWN0IGRldmljZQkqaW9tbXVfZGV2OyAvKiBJT01N
VS1zeXNmcyBkZXZpY2UgKi8KIAlpbnQJCW5vZGU7CiAJdTMyCQlmbGFnczsgICAgICAvKiBTb2Z0
d2FyZSBkZWZpbmVkIGZsYWdzICovCisKKwlzdHJ1Y3QgZG1hcl9kcmhkX3VuaXQgKmRyaGQ7CiB9
OwogCiBzdGF0aWMgaW5saW5lIHZvaWQgX19pb21tdV9mbHVzaF9jYWNoZSgKLS0gCjIuMTcuMQoK
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgK
MTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9u
YXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50
ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

