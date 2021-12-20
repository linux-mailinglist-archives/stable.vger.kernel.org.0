Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D8E47B41E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 20:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhLTT73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 14:59:29 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:51530 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbhLTT72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 14:59:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1640030368; x=1671566368;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jOhjVqFcYvwPQ1CwHgjiiXzwUoexfw663y2/AqkXMd4=;
  b=IaB+ru2d9Uehdnd1Fg+K9ZoSFzL/dBC32XD9JLjpq/zhQ8Nq5kgMR7hE
   vl3ArWIsmSzXcX6IJFsPPCtaM0vx4kTSMYd01mjy6aNISzHgnK9XxZGQ9
   nhe2ZW82/br9lB/oz0VdwecQ1kecTgxiFYnbCuYmI/4ATI1fZBPuAfKRh
   w=;
X-IronPort-AV: E=Sophos;i="5.88,221,1635206400"; 
   d="scan'208";a="164824533"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 20 Dec 2021 19:59:16 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id B64651A010A;
        Mon, 20 Dec 2021 19:59:13 +0000 (UTC)
Received: from dev-dsk-andraprs-1c-9ffe7195.eu-west-1.amazon.com
 (10.43.162.159) by EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft
 SMTP Server (TLS) id 15.0.1497.26; Mon, 20 Dec 2021 19:59:08 +0000
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
Subject: =?UTF-8?q?=5BPATCH=20v2=C2=A0=5D=20nitro=5Fenclaves=3A=20Use=20get=5Fuser=5Fpages=5Funlocked=28=29=20call=20to=20handle=20mmap=20assert?=
Date:   Mon, 20 Dec 2021 19:58:56 +0000
Message-ID: <20211220195856.6549-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Originating-IP: [10.43.162.159]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QWZ0ZXIgY29tbWl0IDViNzhlZDI0ZThlYyAoIm1tL3BhZ2VtYXA6IGFkZCBtbWFwX2Fzc2VydF9s
b2NrZWQoKQphbm5vdGF0aW9ucyB0byBmaW5kX3ZtYSooKSIpLCB0aGUgY2FsbCB0byBnZXRfdXNl
cl9wYWdlcygpIHdpbGwgdHJpZ2dlcgp0aGUgbW1hcCBhc3NlcnQuCgpzdGF0aWMgaW5saW5lIHZv
aWQgbW1hcF9hc3NlcnRfbG9ja2VkKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQp7Cglsb2NrZGVwX2Fz
c2VydF9oZWxkKCZtbS0+bW1hcF9sb2NrKTsKCVZNX0JVR19PTl9NTSghcndzZW1faXNfbG9ja2Vk
KCZtbS0+bW1hcF9sb2NrKSwgbW0pOwp9CgpbICAgNjIuNTIxNDEwXSBrZXJuZWwgQlVHIGF0IGlu
Y2x1ZGUvbGludXgvbW1hcF9sb2NrLmg6MTU2IQouLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgpbICAgNjIuNTM4OTM4XSBSSVA6IDAwMTA6
ZmluZF92bWErMHgzMi8weDgwCi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uClsgICA2Mi42MDU4ODldIENhbGwgVHJhY2U6ClsgICA2Mi42
MDg1MDJdICA8VEFTSz4KWyAgIDYyLjYxMDk1Nl0gID8gbG9ja190aW1lcl9iYXNlKzB4NjEvMHg4
MApbICAgNjIuNjE0MTA2XSAgZmluZF9leHRlbmRfdm1hKzB4MTkvMHg4MApbICAgNjIuNjE3MTk1
XSAgX19nZXRfdXNlcl9wYWdlcysweDliLzB4NmEwClsgICA2Mi42MjAzNTZdICBfX2d1cF9sb25n
dGVybV9sb2NrZWQrMHg0MmQvMHg0NTAKWyAgIDYyLjYyMzcyMV0gID8gZmluaXNoX3dhaXQrMHg0
MS8weDgwClsgICA2Mi42MjY3NDhdICA/IF9fa21hbGxvYysweDE3OC8weDJmMApbICAgNjIuNjI5
NzY4XSAgbmVfc2V0X3VzZXJfbWVtb3J5X3JlZ2lvbl9pb2N0bC5pc3JhLjArMHgyMjUvMHg2YTAg
W25pdHJvX2VuY2xhdmVzXQpbICAgNjIuNjM1Nzc2XSAgbmVfZW5jbGF2ZV9pb2N0bCsweDFjZi8w
eDZkNyBbbml0cm9fZW5jbGF2ZXNdClsgICA2Mi42Mzk1NDFdICBfX3g2NF9zeXNfaW9jdGwrMHg4
Mi8weGIwClsgICA2Mi42NDI2MjBdICBkb19zeXNjYWxsXzY0KzB4M2IvMHg5MApbICAgNjIuNjQ1
NjQyXSAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NDQvMHhhZQoKVXNlIGdldF91
c2VyX3BhZ2VzX3VubG9ja2VkKCkgd2hlbiBzZXR0aW5nIHRoZSBlbmNsYXZlIG1lbW9yeSByZWdp
b25zLgpUaGF0J3MgYSBzaW1pbGFyIHBhdHRlcm4gYXMgbW1hcF9yZWFkX2xvY2soKSB1c2VkIHRv
Z2V0aGVyIHdpdGgKZ2V0X3VzZXJfcGFnZXMoKS4KCkZpeGVzOiA1Yjc4ZWQyNGU4ZWMgKCJtbS9w
YWdlbWFwOiBhZGQgbW1hcF9hc3NlcnRfbG9ja2VkKCkgYW5ub3RhdGlvbnMgdG8gZmluZF92bWEq
KCkiKQpTaWduZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+
CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCi0tLQpDaGFuZ2Vsb2cKCnYxIC0+IHYyCgoqIFVw
ZGF0ZSB0aGUgY29tbWl0IG1lc3NhZ2UgdG8gaW5jbHVkZSB0aGUgcmVmZXJlbmNlIHRvIHRoZSBj
b21taXQKICB0aGF0IGFkZGVkIHRoZSBtbWFwX2Fzc2VydF9sb2NrZWQoKSBhbm5vdGF0aW9ucyB0
byBmaW5kX3ZtYSooKS4KKiBVc2UgZ2V0X3VzZXJfcGFnZXNfdW5sb2NrZWQoKSBpbnN0ZWFkIG9m
IGdldF91c2VyX3BhZ2VzKCksIHRoYXQgaGFzCiAgYSBzaW1pbGFyIHBhdHRlcm4gYXMgbW1hcF9y
ZWFkX2xvY2soKSArIGdldF91c2VyX3BhZ2VzKCkuCi0tLQogZHJpdmVycy92aXJ0L25pdHJvX2Vu
Y2xhdmVzL25lX21pc2NfZGV2LmMgfCA1ICsrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlydC9uaXRyb19l
bmNsYXZlcy9uZV9taXNjX2Rldi5jIGIvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX21p
c2NfZGV2LmMKaW5kZXggODkzOTYxMmVlMGUwLi42ODk0Y2NiODY4YTYgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jCisrKyBiL2RyaXZlcnMvdmly
dC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jCkBAIC04ODYsOCArODg2LDkgQEAgc3RhdGlj
IGludCBuZV9zZXRfdXNlcl9tZW1vcnlfcmVnaW9uX2lvY3RsKHN0cnVjdCBuZV9lbmNsYXZlICpu
ZV9lbmNsYXZlLAogCQkJZ290byBwdXRfcGFnZXM7CiAJCX0KIAotCQlndXBfcmMgPSBnZXRfdXNl
cl9wYWdlcyhtZW1fcmVnaW9uLnVzZXJzcGFjZV9hZGRyICsgbWVtb3J5X3NpemUsIDEsIEZPTExf
R0VULAotCQkJCQluZV9tZW1fcmVnaW9uLT5wYWdlcyArIGksIE5VTEwpOworCQlndXBfcmMgPSBn
ZXRfdXNlcl9wYWdlc191bmxvY2tlZChtZW1fcmVnaW9uLnVzZXJzcGFjZV9hZGRyICsgbWVtb3J5
X3NpemUsIDEsCisJCQkJCQkgbmVfbWVtX3JlZ2lvbi0+cGFnZXMgKyBpLCBGT0xMX0dFVCk7CisK
IAkJaWYgKGd1cF9yYyA8IDApIHsKIAkJCXJjID0gZ3VwX3JjOwogCi0tIAoyLjMyLjAKCgoKCkFt
YXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmlj
ZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5
LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51
bWJlciBKMjIvMjYyMS8yMDA1Lgo=

