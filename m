Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9889E5B91F3
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 02:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiIOA5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 20:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIOA5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 20:57:17 -0400
Received: from m1383.mail.163.com (m1383.mail.163.com [220.181.13.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3DA17C773;
        Wed, 14 Sep 2022 17:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=SkIS1
        Oz89ZrQgYsvTqea/Y/rETUbm0bJ3j0rTOEbpV8=; b=erOcHMWtRdTJ67QvBvLir
        3pAzaMVo/2Nt5PH2Ojs9h3zpq4Ba49e2jqf96ubvLxeknLjK/lN+dSch+n+fvTCw
        Mc14hn8/fiqgJ9xUNvx2aEdWEJVPEcz3LOuGFmu2ks+S/aO3YMjr93VclLStTUtQ
        4HQCFuUxcNl7xen7q1Gz4c=
Received: from 15815827059$163.com ( [223.147.18.37] ) by
 ajax-webmail-wmsvr83 (Coremail) ; Thu, 15 Sep 2022 08:56:30 +0800 (CST)
X-Originating-IP: [223.147.18.37]
Date:   Thu, 15 Sep 2022 08:56:30 +0800 (CST)
From:   huhai <15815827059@163.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, huhai <huhai@kylinos.cn>,
        stable@vger.kernel.org, "Jackie Liu" <liuyun01@kylinos.cn>
Subject: Re:[PATCH v2] scsi: mpt3sas: Fix NULL pointer crash due to missing
 check device hostdata
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <20220901063409.85272-1-15815827059@163.com>
References: <20220901063409.85272-1-15815827059@163.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <6af4d139.731.1833ea5b2c9.Coremail.15815827059@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: U8GowADncqQ+eCJjwltAAA--.1428W
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbB0xp2hVXlwwFJgQABsB
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cGluZy4uLgoKCkF0IDIwMjItMDktMDEgMTQ6MzQ6MDksICJodWhhaSIgPDE1ODE1ODI3MDU5QDE2
My5jb20+IHdyb3RlOgo+RnJvbTogaHVoYWkgPGh1aGFpQGt5bGlub3MuY24+Cj4KPklmIF9zY3Np
aF9pb19kb25lKCkgaXMgY2FsbGVkIHdpdGggc2NtZC0+ZGV2aWNlLT5ob3N0ZGF0YT1OVUxMLCBp
dCBjYW4gbGVhZAo+dG8gdGhlIGZvbGxvd2luZyBwYW5pYzoKPgo+ICBCVUc6IHVuYWJsZSB0byBo
YW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAwMDAwMDAwMDE4
Cj4gIFBHRCA0NTQ3YTQwNjcgUDREIDQ1NDdhNDA2NyBQVUQgMAo+ICBPb3BzOiAwMDAyIFsjMV0g
U01QIE5PUFRJCj4gIENQVTogNjIgUElEOiAwIENvbW06IHN3YXBwZXIvNjIgS2R1bXA6IGxvYWRl
ZCBOb3QgdGFpbnRlZCA0LjE5LjkwLTI0LjQudjIxMDEua3kxMC54ODZfNjQgIzEKPiAgSGFyZHdh
cmUgbmFtZTogU3RvcmFnZSBTZXJ2ZXIvNjVOMzItVVMsIEJJT1MgU1FMMTA0MTIxNyAwNS8zMC8y
MDIyCj4gIFJJUDogMDAxMDpfc2NzaWhfc2V0X3NhdGxfcGVuZGluZysweDJkLzB4NTAgW21wdDNz
YXNdCj4gIENvZGU6IDAwIDAwIDQ4IDhiIDg3IDYwIDAxIDAwIDAwIDBmIGI2IDEwIDgwIGZhIGEx
IDc0IDA5IDMxIGMwIDgwIGZhIDg1IDc0IDAyIGYzIGMzIDQ4IDhiIDQ3IDM4IDQwIDg0IGY2IDQ4
IDhiIDgwIDk4IDAwIDAwIDAwIDc1IDA4IDxmMD4gODAgNjAgMTggZmUgMzEgYzAgYzMgZjAgNDgg
MGYgYmEgNjggMTggMDAgMGYgOTIgYzAgMGYgYjYgYzAgYzMKPiAgUlNQOiAwMDE4OmZmZmY4ZWMy
MmZjMDNlMDAgRUZMQUdTOiAwMDAxMDA0Ngo+ICBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBm
ZmZmOGViYTFiMDcyNTE4IFJDWDogMDAwMDAwMDAwMDAwMDAwMQo+ICBSRFg6IDAwMDAwMDAwMDAw
MDAwODUgUlNJOiAwMDAwMDAwMDAwMDAwMDAwIFJESTogZmZmZjhlYmExYjA3MjUxOAo+ICBSQlA6
IDAwMDAwMDAwMDAwMDBkYmQgUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAwMDAy
OTcwMAo+ICBSMTA6IGZmZmY4ZWMyMmZjMDNmODAgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjog
ZmZmZjhlYmUyZDM2MDllOAo+ICBSMTM6IGZmZmY4ZWJlMmE3MmI2MDAgUjE0OiBmZmZmOGVjYTQ3
MjcwN2UwIFIxNTogMDAwMDAwMDAwMDAwMDAyMAo+ICBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAw
MCkgR1M6ZmZmZjhlYzIyZmMwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwCj4gIENT
OiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKPiAgQ1IyOiAw
MDAwMDAwMDAwMDAwMDE4IENSMzogMDAwMDAwMDQ2ZTVmNjAwMCBDUjQ6IDAwMDAwMDAwMDAzNDA2
ZTAKPiAgQ2FsbCBUcmFjZToKPiAgIDxJUlE+Cj4gICBfc2NzaWhfaW9fZG9uZSsweDRhLzB4OWYw
IFttcHQzc2FzXQo+ICAgX2Jhc2VfaW50ZXJydXB0KzB4MjNmLzB4ZTEwIFttcHQzc2FzXQo+ICAg
X19oYW5kbGVfaXJxX2V2ZW50X3BlcmNwdSsweDQwLzB4MTkwCj4gICBoYW5kbGVfaXJxX2V2ZW50
X3BlcmNwdSsweDMwLzB4NzAKPiAgIGhhbmRsZV9pcnFfZXZlbnQrMHgzNi8weDYwCj4gICBoYW5k
bGVfZWRnZV9pcnErMHg3ZS8weDE5MAo+ICAgaGFuZGxlX2lycSsweGE4LzB4MTEwCj4gICBkb19J
UlErMHg0OS8weGUwCj4KPkZpeCBpdCBieSBtb3ZlIHNjbWQtPmRldmljZS0+aG9zdGRhdGEgY2hl
Y2sgYmVmb3JlIF9zY3NpaF9zZXRfc2F0bF9wZW5kaW5nCj5jYWxsZWQuCj4KPk90aGVyIGNoYW5n
ZXM6Cj4tIEl0IGxvb2tzIGNsZWFyIHRvIG1vdmUgZ2V0IG1waV9yZXBseSB0byBuZWFyIGl0cyBj
aGVjay4KPgo+Rml4ZXM6IGZmYjU4NDU2NTg5NCAoInNjc2k6IG1wdDNzYXM6IGZpeCBoYW5nIG9u
IGF0YSBwYXNzdGhyb3VnaCBjb21tYW5kcyIpCj5DYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+
ICMgdjQuOSsKPlN1Z2dlc3RlZC1ieTogU2F0aHlhIFByYWthc2ggVmVlcmljaGV0dHkgPHNhdGh5
YS5wcmFrYXNoQGJyb2FkY29tLmNvbT4KPkNvLWRldmVsb3BlZC1ieTogSmFja2llIExpdSA8bGl1
eXVuMDFAa3lsaW5vcy5jbj4KPlNpZ25lZC1vZmYtYnk6IEphY2tpZSBMaXUgPGxpdXl1bjAxQGt5
bGlub3MuY24+Cj5TaWduZWQtb2ZmLWJ5OiBodWhhaSA8aHVoYWlAa3lsaW5vcy5jbj4KPi0tLQo+
IGRyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfc2NzaWguYyB8IDEyICsrKysrKystLS0tLQo+
IDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4KPmRpZmYg
LS1naXQgYS9kcml2ZXJzL3Njc2kvbXB0M3Nhcy9tcHQzc2FzX3Njc2loLmMgYi9kcml2ZXJzL3Nj
c2kvbXB0M3Nhcy9tcHQzc2FzX3Njc2loLmMKPmluZGV4IGRlZjM3YTdlNTk4MC4uNzk5MGJkOTUw
MmUxIDEwMDY0NAo+LS0tIGEvZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jCj4r
KysgYi9kcml2ZXJzL3Njc2kvbXB0M3Nhcy9tcHQzc2FzX3Njc2loLmMKPkBAIC01NzA0LDI0ICs1
NzA0LDI2IEBAIF9zY3NpaF9pb19kb25lKHN0cnVjdCBNUFQzU0FTX0FEQVBURVIgKmlvYywgdTE2
IHNtaWQsIHU4IG1zaXhfaW5kZXgsIHUzMiByZXBseSkKPiAJc3RydWN0IE1QVDNTQVNfREVWSUNF
ICpzYXNfZGV2aWNlX3ByaXZfZGF0YTsKPiAJdTMyIHJlc3BvbnNlX2NvZGUgPSAwOwo+IAo+LQlt
cGlfcmVwbHkgPSBtcHQzc2FzX2Jhc2VfZ2V0X3JlcGx5X3ZpcnRfYWRkcihpb2MsIHJlcGx5KTsK
Pi0KPiAJc2NtZCA9IG1wdDNzYXNfc2NzaWhfc2NzaV9sb29rdXBfZ2V0KGlvYywgc21pZCk7Cj4g
CWlmIChzY21kID09IE5VTEwpCj4gCQlyZXR1cm4gMTsKPiAKPisJc2FzX2RldmljZV9wcml2X2Rh
dGEgPSBzY21kLT5kZXZpY2UtPmhvc3RkYXRhOwo+KwlpZiAoIXNhc19kZXZpY2VfcHJpdl9kYXRh
IHx8ICFzYXNfZGV2aWNlX3ByaXZfZGF0YS0+c2FzX3RhcmdldCkgewo+KwkJc2NtZC0+cmVzdWx0
ID0gRElEX05PX0NPTk5FQ1QgPDwgMTY7Cj4rCQlnb3RvIG91dDsKPisJfQo+IAlfc2NzaWhfc2V0
X3NhdGxfcGVuZGluZyhzY21kLCBmYWxzZSk7Cj4gCj4gCW1waV9yZXF1ZXN0ID0gbXB0M3Nhc19i
YXNlX2dldF9tc2dfZnJhbWUoaW9jLCBzbWlkKTsKPiAKPisJbXBpX3JlcGx5ID0gbXB0M3Nhc19i
YXNlX2dldF9yZXBseV92aXJ0X2FkZHIoaW9jLCByZXBseSk7Cj4gCWlmIChtcGlfcmVwbHkgPT0g
TlVMTCkgewo+IAkJc2NtZC0+cmVzdWx0ID0gRElEX09LIDw8IDE2Owo+IAkJZ290byBvdXQ7Cj4g
CX0KPiAKPi0Jc2FzX2RldmljZV9wcml2X2RhdGEgPSBzY21kLT5kZXZpY2UtPmhvc3RkYXRhOwo+
LQlpZiAoIXNhc19kZXZpY2VfcHJpdl9kYXRhIHx8ICFzYXNfZGV2aWNlX3ByaXZfZGF0YS0+c2Fz
X3RhcmdldCB8fAo+LQkgICAgIHNhc19kZXZpY2VfcHJpdl9kYXRhLT5zYXNfdGFyZ2V0LT5kZWxl
dGVkKSB7Cj4rCWlmIChzYXNfZGV2aWNlX3ByaXZfZGF0YS0+c2FzX3RhcmdldC0+ZGVsZXRlZCkg
ewo+IAkJc2NtZC0+cmVzdWx0ID0gRElEX05PX0NPTk5FQ1QgPDwgMTY7Cj4gCQlnb3RvIG91dDsK
PiAJfQo+LS0gCj4yLjI3LjAKPgo+Cj5ObyB2aXJ1cyBmb3VuZAo+CQlDaGVja2VkIGJ5IEhpbGxz
dG9uZSBOZXR3b3JrIEFudGlWaXJ1cwo=
