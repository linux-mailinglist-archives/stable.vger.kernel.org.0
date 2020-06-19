Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEED9200540
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 11:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbgFSJd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 05:33:29 -0400
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:34936 "EHLO
        SHSQR01.unisoc.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732083AbgFSJc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 05:32:28 -0400
Received: from SHSQR01.spreadtrum.com (localhost [127.0.0.2] (may be forged))
        by SHSQR01.unisoc.com with ESMTP id 05J91tkU012801
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 17:01:55 +0800 (CST)
        (envelope-from hongyu.jin@unisoc.com)
Received: from ig2.spreadtrum.com (bjmbx01.spreadtrum.com [10.0.64.7])
        by SHSQR01.spreadtrum.com with ESMTPS id 05J90rqt009148
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
        Fri, 19 Jun 2020 17:00:54 +0800 (CST)
        (envelope-from hongyu.jin@unisoc.com)
Received: from BJMBX01.spreadtrum.com (10.0.64.7) by BJMBX01.spreadtrum.com
 (10.0.64.7) with Microsoft SMTP Server (TLS) id 15.0.847.32; Fri, 19 Jun 2020
 17:00:53 +0800
Received: from BJMBX01.spreadtrum.com ([fe80::54e:9a:129d:fac7]) by
 BJMBX01.spreadtrum.com ([fe80::54e:9a:129d:fac7%16]) with mapi id
 15.00.0847.030; Fri, 19 Jun 2020 17:00:53 +0800
From:   =?gb2312?B?vfC67NPuIChIb25neXUgSmluKQ==?= <hongyu.jin@unisoc.com>
To:     Gao Xiang <hsiangkao@aol.com>,
        "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
        Chao Yu <yuchao0@huawei.com>
CC:     Chao Yu <chao@kernel.org>, Li Guifu <bluce.liguifu@huawei.com>,
        Fang Wei <fangwei1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] erofs: fix partially uninitialized misuse in
 z_erofs_onlinepage_fixup
Thread-Topic: [PATCH v2] erofs: fix partially uninitialized misuse in
 z_erofs_onlinepage_fixup
Thread-Index: AQHWRcphTFCNsOawuk2LQqgGLvVLoajfooAF
Date:   Fri, 19 Jun 2020 09:00:53 +0000
Message-ID: <37ee181865a6411bb029745b809adae9@BJMBX01.spreadtrum.com>
References: <20200618111936.19845-1-hsiangkao@aol.com>,<20200618234349.22553-1-hsiangkao@aol.com>
In-Reply-To: <20200618234349.22553-1-hsiangkao@aol.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.74.65]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MAIL: SHSQR01.spreadtrum.com 05J90rqt009148
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgeGlhbmc6DQoNCkhvbmd5dSByZXBvcnRlZCAiaWQgIT0gaW5kZXgiIGluIHpfZXJvZnNfb25s
aW5lcGFnZV9maXh1cCgpIHdpdGgNCnNwZWNpZmljIGFhcmNoNjQgZW52aXJvbm1lbnQgZWFzaWx5
LCB3aGljaCB3YXNuJ3Qgc2hvd24gYmVmb3JlLg0KDQpBZnRlciBkaWdnaW5nIGludG8gdGhhdCwg
SSBmb3VuZCB0aGF0IGhpZ2ggMzIgYml0cyBvZiBwYWdlLT5wcml2YXRlDQp3YXMgc2V0IHRvIDB4
YWFhYWFhYWEgcmF0aGVyIHRoYW4gMCAoZHVlIHRvIHpfZXJvZnNfb25saW5lcGFnZV9pbml0DQpi
ZWhhdmlvciB3aXRoIHNwZWNpZmljIGNvbXBpbGVyIG9wdGlvbnMpLiBBY3R1YWxseSB3ZSBvbmx5
IHVzZSBsb3cNCjMyIGJpdHMgdG8ga2VlcCB0aGUgcGFnZSBpbmZvcm1hdGlvbiBzaW5jZSBwYWdl
LT5wcml2YXRlIGlzIG9ubHkgNA0KYnl0ZXMgb24gbW9zdCAzMi1iaXQgcGxhdGZvcm1zLiBIb3dl
dmVyIHpfZXJvZnNfb25saW5lcGFnZV9maXh1cCgpDQp1c2VzIHRoZSB1cHBlciAzMiBiaXRzIGJ5
IG1pc3Rha2UuDQoNClRlc3RlZC1ieTogaG9uZ3l1LmppbkB1bmlzb2MuY29tDQoNCml0J3Mgb2su
DQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQq3orz+yMs6IEdhbyBY
aWFuZyA8aHNpYW5na2FvQGFvbC5jb20+DQq3osvNyrG85DogMjAyMMTqNtTCMTnI1SA3OjQzDQrK
1bz+yMs6IGxpbnV4LWVyb2ZzQGxpc3RzLm96bGFicy5vcmc7IENoYW8gWXUNCrOty806IENoYW8g
WXU7IExpIEd1aWZ1OyBGYW5nIFdlaTsgTEtNTDsgR2FvIFhpYW5nOyC98Lrs0+4gKEhvbmd5dSBK
aW4pOyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQrW98ziOiBbUEFUQ0ggdjJdIGVyb2ZzOiBmaXgg
cGFydGlhbGx5IHVuaW5pdGlhbGl6ZWQgbWlzdXNlIGluIHpfZXJvZnNfb25saW5lcGFnZV9maXh1
cA0KDQpGcm9tOiBHYW8gWGlhbmcgPGhzaWFuZ2thb0ByZWRoYXQuY29tPg0KDQpIb25neXUgcmVw
b3J0ZWQgImlkICE9IGluZGV4IiBpbiB6X2Vyb2ZzX29ubGluZXBhZ2VfZml4dXAoKSB3aXRoDQpz
cGVjaWZpYyBhYXJjaDY0IGVudmlyb25tZW50IGVhc2lseSwgd2hpY2ggd2Fzbid0IHNob3duIGJl
Zm9yZS4NCg0KQWZ0ZXIgZGlnZ2luZyBpbnRvIHRoYXQsIEkgZm91bmQgdGhhdCBoaWdoIDMyIGJp
dHMgb2YgcGFnZS0+cHJpdmF0ZQ0Kd2FzIHNldCB0byAweGFhYWFhYWFhIHJhdGhlciB0aGFuIDAg
KGR1ZSB0byB6X2Vyb2ZzX29ubGluZXBhZ2VfaW5pdA0KYmVoYXZpb3Igd2l0aCBzcGVjaWZpYyBj
b21waWxlciBvcHRpb25zKS4gQWN0dWFsbHkgd2Ugb25seSB1c2UgbG93DQozMiBiaXRzIHRvIGtl
ZXAgdGhlIHBhZ2UgaW5mb3JtYXRpb24gc2luY2UgcGFnZS0+cHJpdmF0ZSBpcyBvbmx5IDQNCmJ5
dGVzIG9uIG1vc3QgMzItYml0IHBsYXRmb3Jtcy4gSG93ZXZlciB6X2Vyb2ZzX29ubGluZXBhZ2Vf
Zml4dXAoKQ0KdXNlcyB0aGUgdXBwZXIgMzIgYml0cyBieSBtaXN0YWtlLg0KDQpMZXQncyBmaXgg
aXQgbm93Lg0KDQpSZXBvcnRlZC1ieTogSG9uZ3l1IEppbiA8aG9uZ3l1LmppbkB1bmlzb2MuY29t
Pg0KRml4ZXM6IDM4ODNhNzlhYmQwMiAoInN0YWdpbmc6IGVyb2ZzOiBpbnRyb2R1Y2UgVkxFIGRl
Y29tcHJlc3Npb24gc3VwcG9ydCIpDQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgNC4x
OSsNClNpZ25lZC1vZmYtYnk6IEdhbyBYaWFuZyA8aHNpYW5na2FvQHJlZGhhdC5jb20+DQotLS0N
CmNoYW5nZSBzaW5jZSB2MToNCiBtb3ZlIC52IGFzc2lnbm1lbnQgb3V0IHNpbmNlIGl0IGRvZXNu
J3QgbmVlZCBmb3IgZXZlcnkgbG9vcDsNCg0KIGZzL2Vyb2ZzL3pkYXRhLmggfCAyMCArKysrKysr
KysrLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAxMCBkZWxl
dGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2ZzL2Vyb2ZzL3pkYXRhLmggYi9mcy9lcm9mcy96ZGF0
YS5oDQppbmRleCA3ODI0ZjU1NjNhNTUuLjliNjZjMjhiM2FlOSAxMDA2NDQNCi0tLSBhL2ZzL2Vy
b2ZzL3pkYXRhLmgNCisrKyBiL2ZzL2Vyb2ZzL3pkYXRhLmgNCkBAIC0xNDQsMjIgKzE0NCwyMiBA
QCBzdGF0aWMgaW5saW5lIHZvaWQgel9lcm9mc19vbmxpbmVwYWdlX2luaXQoc3RydWN0IHBhZ2Ug
KnBhZ2UpDQogc3RhdGljIGlubGluZSB2b2lkIHpfZXJvZnNfb25saW5lcGFnZV9maXh1cChzdHJ1
Y3QgcGFnZSAqcGFnZSwNCiAgICAgICAgdWludHB0cl90IGluZGV4LCBib29sIGRvd24pDQogew0K
LSAgICAgICB1bnNpZ25lZCBsb25nICpwLCBvLCB2LCBpZDsNCi1yZXBlYXQ6DQotICAgICAgIHAg
PSAmcGFnZV9wcml2YXRlKHBhZ2UpOw0KLSAgICAgICBvID0gUkVBRF9PTkNFKCpwKTsNCisgICAg
ICAgdW5pb24gel9lcm9mc19vbmxpbmVwYWdlX2NvbnZlcnRlciB1ID0geyAudiA9ICZwYWdlX3By
aXZhdGUocGFnZSkgfTsNCisgICAgICAgaW50IG9yaWcsIG9yaWdfaW5kZXgsIHZhbDsNCg0KLSAg
ICAgICBpZCA9IG8gPj4gWl9FUk9GU19PTkxJTkVQQUdFX0lOREVYX1NISUZUOw0KLSAgICAgICBp
ZiAoaWQpIHsNCityZXBlYXQ6DQorICAgICAgIG9yaWcgPSBhdG9taWNfcmVhZCh1Lm8pOw0KKyAg
ICAgICBvcmlnX2luZGV4ID0gb3JpZyA+PiBaX0VST0ZTX09OTElORVBBR0VfSU5ERVhfU0hJRlQ7
DQorICAgICAgIGlmIChvcmlnX2luZGV4KSB7DQogICAgICAgICAgICAgICAgaWYgKCFpbmRleCkN
CiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybjsNCg0KLSAgICAgICAgICAgICAgIERCR19C
VUdPTihpZCAhPSBpbmRleCk7DQorICAgICAgICAgICAgICAgREJHX0JVR09OKG9yaWdfaW5kZXgg
IT0gaW5kZXgpOw0KICAgICAgICB9DQoNCi0gICAgICAgdiA9IChpbmRleCA8PCBaX0VST0ZTX09O
TElORVBBR0VfSU5ERVhfU0hJRlQpIHwNCi0gICAgICAgICAgICAgICAoKG8gJiBaX0VST0ZTX09O
TElORVBBR0VfQ09VTlRfTUFTSykgKyAodW5zaWduZWQgaW50KWRvd24pOw0KLSAgICAgICBpZiAo
Y21weGNoZyhwLCBvLCB2KSAhPSBvKQ0KKyAgICAgICB2YWwgPSAoaW5kZXggPDwgWl9FUk9GU19P
TkxJTkVQQUdFX0lOREVYX1NISUZUKSB8DQorICAgICAgICAgICAgICAgKChvcmlnICYgWl9FUk9G
U19PTkxJTkVQQUdFX0NPVU5UX01BU0spICsgKHVuc2lnbmVkIGludClkb3duKTsNCisgICAgICAg
aWYgKGF0b21pY19jbXB4Y2hnKHUubywgb3JpZywgdmFsKSAhPSBvcmlnKQ0KICAgICAgICAgICAg
ICAgIGdvdG8gcmVwZWF0Ow0KIH0NCg0KLS0NCjIuMjQuMA0KDQpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXw0KIFRoaXMgZW1haWwgKGluY2x1ZGluZyBpdHMgYXR0YWNobWVudHMpIGlz
IGludGVuZGVkIG9ubHkgZm9yIHRoZSBwZXJzb24gb3IgZW50aXR5IHRvIHdoaWNoIGl0IGlzIGFk
ZHJlc3NlZCBhbmQgbWF5IGNvbnRhaW4gaW5mb3JtYXRpb24gdGhhdCBpcyBwcml2aWxlZ2VkLCBj
b25maWRlbnRpYWwgb3Igb3RoZXJ3aXNlIHByb3RlY3RlZCBmcm9tIGRpc2Nsb3N1cmUuIFVuYXV0
aG9yaXplZCB1c2UsIGRpc3NlbWluYXRpb24sIGRpc3RyaWJ1dGlvbiBvciBjb3B5aW5nIG9mIHRo
aXMgZW1haWwgb3IgdGhlIGluZm9ybWF0aW9uIGhlcmVpbiBvciB0YWtpbmcgYW55IGFjdGlvbiBp
biByZWxpYW5jZSBvbiB0aGUgY29udGVudHMgb2YgdGhpcyBlbWFpbCBvciB0aGUgaW5mb3JtYXRp
b24gaGVyZWluLCBieSBhbnlvbmUgb3RoZXIgdGhhbiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50LCBv
ciBhbiBlbXBsb3llZSBvciBhZ2VudCByZXNwb25zaWJsZSBmb3IgZGVsaXZlcmluZyB0aGUgbWVz
c2FnZSB0byB0aGUgaW50ZW5kZWQgcmVjaXBpZW50LCBpcyBzdHJpY3RseSBwcm9oaWJpdGVkLiBJ
ZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50LCBwbGVhc2UgZG8gbm90IHJlYWQs
IGNvcHksIHVzZSBvciBkaXNjbG9zZSBhbnkgcGFydCBvZiB0aGlzIGUtbWFpbCB0byBvdGhlcnMu
IFBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgcGVybWFuZW50bHkgZGVs
ZXRlIHRoaXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNobWVudHMgaWYgeW91IHJlY2VpdmVkIGl0IGlu
IGVycm9yLiBJbnRlcm5ldCBjb21tdW5pY2F0aW9ucyBjYW5ub3QgYmUgZ3VhcmFudGVlZCB0byBi
ZSB0aW1lbHksIHNlY3VyZSwgZXJyb3ItZnJlZSBvciB2aXJ1cy1mcmVlLiBUaGUgc2VuZGVyIGRv
ZXMgbm90IGFjY2VwdCBsaWFiaWxpdHkgZm9yIGFueSBlcnJvcnMgb3Igb21pc3Npb25zLg0Ksb7T
yrz+vLDG5Li9vP6+39PQsaPD3NDU1sqjrMrct6jCybGju6Syu7XD0LnCtqOsvfa3osvNuPixvtPK
vP7L+da4zNi2qMrVvP7Iy6Gj0c+9+7fHvq3K2sioyrnTw6Gi0Pu0q6Git6KyvLvyuLTWxrG+08q8
/rvyxuTE2sjdoaPI9LfHuMPM2LaoytW8/sjLo6zH687w1MS2waGiuLTWxqGiIMq508O78sX7wrax
vtPKvP61xMjOus7E2sjdoaPI9M7zytWxvtPKvP6jrMfrtNPPtc2z1tDTwL7D0NTJvrP9sb7Tyrz+
vLDL+dPQuL28/qOssqLS1LvYuLTTyrz+tcS3vcq9vLS/zLjm1qq3orz+yMuho87et6ixo9aku6XB
qs34zajQxbywyrGhorCyyKuhos7ezvO78rfAtr6ho7eivP7Iy7bUyM66zrTtwqm++bK7s9C1o9Tw
yM6how0K
