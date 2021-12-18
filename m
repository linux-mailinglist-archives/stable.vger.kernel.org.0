Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20B1479A56
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 11:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhLRKgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 05:36:02 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:64265 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhLRKgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 05:36:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1639823761; x=1671359761;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/rNukEk/AKgue/4kHvkeqzceFYvg0qcH59Ha0VvFu6A=;
  b=dH1o88zsSAUlKLiD1wAnNE88xq/50+hMM6ux4MAXRAcMZrVAoty7FTug
   WJ3vk0yEsea17Ob8G3UiH9eCSsyJKZWC4m6cXZFNWmON01fEjTDNVsQun
   rgN0jQZaPBAdi3Uc3NxLPdSMIs74ULwuPgWgGRzfqs0pD9GziHlQJ9PlA
   k=;
X-IronPort-AV: E=Sophos;i="5.88,216,1635206400"; 
   d="scan'208";a="49408652"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 18 Dec 2021 10:35:47 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com (Postfix) with ESMTPS id 3BF629F674;
        Sat, 18 Dec 2021 10:35:41 +0000 (UTC)
Received: from dev-dsk-andraprs-1c-9ffe7195.eu-west-1.amazon.com
 (10.43.162.55) by EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft
 SMTP Server (TLS) id 15.0.1497.26; Sat, 18 Dec 2021 10:35:35 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexandru Vasile <lexnv@amazon.com>,
        "Marcelo Cerri" <marcelo.cerri@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        stable <stable@vger.kernel.org>,
        "Andra Paraschiv" <andraprs@amazon.com>
Subject: =?UTF-8?q?=5BPATCH=20v1=C2=A0=5D=20nitro=5Fenclaves=3A=20Add=20mmap=5Fread=5Flock=28=29=20for=20the=20get=5Fuser=5Fpages=28=29=20call?=
Date:   Sat, 18 Dec 2021 10:35:25 +0000
Message-ID: <20211218103525.26739-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D02UWB002.ant.amazon.com (10.43.161.160) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QWZ0ZXIgY29tbWl0IDViNzhlZDI0ZThlYyAobW0vcGFnZW1hcDogYWRkIG1tYXBfYXNzZXJ0X2xv
Y2tlZCgpCmFubm90YXRpb25zIHRvIGZpbmRfdm1hKigpKSwgdGhlIGNhbGwgdG8gZ2V0X3VzZXJf
cGFnZXMoKSB3aWxsIHRyaWdnZXIKdGhlIG1tYXAgYXNzZXJ0LgoKc3RhdGljIGlubGluZSB2b2lk
IG1tYXBfYXNzZXJ0X2xvY2tlZChzdHJ1Y3QgbW1fc3RydWN0ICptbSkKewoJbG9ja2RlcF9hc3Nl
cnRfaGVsZCgmbW0tPm1tYXBfbG9jayk7CglWTV9CVUdfT05fTU0oIXJ3c2VtX2lzX2xvY2tlZCgm
bW0tPm1tYXBfbG9jayksIG1tKTsKfQoKWyAgIDYyLjUyMTQxMF0ga2VybmVsIEJVRyBhdCBpbmNs
dWRlL2xpbnV4L21tYXBfbG9jay5oOjE1NiEKLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4KWyAgIDYyLjUzODkzOF0gUklQOiAwMDEwOmZp
bmRfdm1hKzB4MzIvMHg4MAouLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgpbICAgNjIuNjA1ODg5XSBDYWxsIFRyYWNlOgpbICAgNjIuNjA4
NTAyXSAgPFRBU0s+ClsgICA2Mi42MTA5NTZdICA/IGxvY2tfdGltZXJfYmFzZSsweDYxLzB4ODAK
WyAgIDYyLjYxNDEwNl0gIGZpbmRfZXh0ZW5kX3ZtYSsweDE5LzB4ODAKWyAgIDYyLjYxNzE5NV0g
IF9fZ2V0X3VzZXJfcGFnZXMrMHg5Yi8weDZhMApbICAgNjIuNjIwMzU2XSAgX19ndXBfbG9uZ3Rl
cm1fbG9ja2VkKzB4NDJkLzB4NDUwClsgICA2Mi42MjM3MjFdICA/IGZpbmlzaF93YWl0KzB4NDEv
MHg4MApbICAgNjIuNjI2NzQ4XSAgPyBfX2ttYWxsb2MrMHgxNzgvMHgyZjAKWyAgIDYyLjYyOTc2
OF0gIG5lX3NldF91c2VyX21lbW9yeV9yZWdpb25faW9jdGwuaXNyYS4wKzB4MjI1LzB4NmEwIFtu
aXRyb19lbmNsYXZlc10KWyAgIDYyLjYzNTc3Nl0gIG5lX2VuY2xhdmVfaW9jdGwrMHgxY2YvMHg2
ZDcgW25pdHJvX2VuY2xhdmVzXQpbICAgNjIuNjM5NTQxXSAgX194NjRfc3lzX2lvY3RsKzB4ODIv
MHhiMApbICAgNjIuNjQyNjIwXSAgZG9fc3lzY2FsbF82NCsweDNiLzB4OTAKWyAgIDYyLjY0NTY0
Ml0gIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YWUKCkFkZCBtbWFwX3Jl
YWRfbG9jaygpIGZvciB0aGUgZ2V0X3VzZXJfcGFnZXMoKSBjYWxsIHdoZW4gc2V0dGluZyB0aGUK
ZW5jbGF2ZSBtZW1vcnkgcmVnaW9ucy4KClNpZ25lZC1vZmYtYnk6IEFuZHJhIFBhcmFzY2hpdiA8
YW5kcmFwcnNAYW1hem9uLmNvbT4KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKLS0tCiBkcml2
ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyB8IDUgKysrKysKIDEgZmlsZSBj
aGFuZ2VkLCA1IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpcnQvbml0cm9f
ZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyBiL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9t
aXNjX2Rldi5jCmluZGV4IDg5Mzk2MTJlZTBlMC4uNmM1MWZmMDI0MDM2IDEwMDY0NAotLS0gYS9k
cml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYworKysgYi9kcml2ZXJzL3Zp
cnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYwpAQCAtODg2LDggKzg4NiwxMyBAQCBzdGF0
aWMgaW50IG5lX3NldF91c2VyX21lbW9yeV9yZWdpb25faW9jdGwoc3RydWN0IG5lX2VuY2xhdmUg
Km5lX2VuY2xhdmUsCiAJCQlnb3RvIHB1dF9wYWdlczsKIAkJfQogCisJCW1tYXBfcmVhZF9sb2Nr
KGN1cnJlbnQtPm1tKTsKKwogCQlndXBfcmMgPSBnZXRfdXNlcl9wYWdlcyhtZW1fcmVnaW9uLnVz
ZXJzcGFjZV9hZGRyICsgbWVtb3J5X3NpemUsIDEsIEZPTExfR0VULAogCQkJCQluZV9tZW1fcmVn
aW9uLT5wYWdlcyArIGksIE5VTEwpOworCisJCW1tYXBfcmVhZF91bmxvY2soY3VycmVudC0+bW0p
OworCiAJCWlmIChndXBfcmMgPCAwKSB7CiAJCQlyYyA9IGd1cF9yYzsKIAotLSAKMi4zMi4wCgoK
CgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBv
ZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENv
dW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlv
biBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

