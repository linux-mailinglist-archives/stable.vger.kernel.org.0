Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE73525F188
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 03:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgIGBqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Sep 2020 21:46:31 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:45940 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbgIGBqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Sep 2020 21:46:31 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id C13E68550E34DADF7076;
        Mon,  7 Sep 2020 09:46:28 +0800 (CST)
Received: from DGGEMM526-MBX.china.huawei.com ([169.254.8.250]) by
 DGGEMM406-HUB.china.huawei.com ([10.3.20.214]) with mapi id 14.03.0487.000;
 Mon, 7 Sep 2020 09:46:19 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
To:     Sasha Levin <sashal@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     stable <stable@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: core: fix slab-out-of-bounds Read in
 read_descriptors
Thread-Topic: [PATCH] usb: core: fix slab-out-of-bounds Read in
 read_descriptors
Thread-Index: AQHWgoYWNSGA0/wYa0WdQxkxgVNBTqlabPuAgAH/DIA=
Date:   Mon, 7 Sep 2020 01:46:19 +0000
Message-ID: <678F3D1BB717D949B966B68EAEB446ED482602CA@dggemm526-mbx.china.huawei.com>
References: <1599201467-11000-1-git-send-email-prime.zeng@hisilicon.com>
 <20200906031611.AC67020E65@mail.kernel.org>
In-Reply-To: <20200906031611.AC67020E65@mail.kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.221.187]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYXNoYSBMZXZpbiBbbWFpbHRv
OnNhc2hhbEBrZXJuZWwub3JnXQ0KPiBTZW50OiBTdW5kYXksIFNlcHRlbWJlciAwNiwgMjAyMCAx
MToxNiBBTQ0KPiBUbzogU2FzaGEgTGV2aW47IFplbmd0YW8gKEIpOyBncmVna2hAbGludXhmb3Vu
ZGF0aW9uLm9yZw0KPiBDYzogWmVuZ3RhbyAoQik7IHN0YWJsZTsgQWxhbiBTdGVybjsgc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSB1c2I6IGNvcmU6IGZpeCBz
bGFiLW91dC1vZi1ib3VuZHMgUmVhZCBpbg0KPiByZWFkX2Rlc2NyaXB0b3JzDQo+IA0KPiBIaQ0K
PiANCj4gW1RoaXMgaXMgYW4gYXV0b21hdGVkIGVtYWlsXQ0KPiANCj4gVGhpcyBjb21taXQgaGFz
IGJlZW4gcHJvY2Vzc2VkIGJlY2F1c2UgaXQgY29udGFpbnMgYSAiRml4ZXM6IiB0YWcNCj4gZml4
aW5nIGNvbW1pdDogMjE3YTkwODFkOGU2ICgiVVNCOiBhZGQgYWxsIGNvbmZpZ3MgdG8gdGhlICJk
ZXNjcmlwdG9ycyINCj4gYXR0cmlidXRlIikuDQo+IA0KPiBUaGUgYm90IGhhcyB0ZXN0ZWQgdGhl
IGZvbGxvd2luZyB0cmVlczogdjUuOC42LCB2NS40LjYyLCB2NC4xOS4xNDMsDQo+IHY0LjE0LjE5
NiwgdjQuOS4yMzUsIHY0LjQuMjM1Lg0KPiANCj4gdjUuOC42OiBCdWlsZCBPSyENCj4gdjUuNC42
MjogQnVpbGQgT0shDQo+IHY0LjE5LjE0MzogQnVpbGQgT0shDQo+IHY0LjE0LjE5NjogQnVpbGQg
T0shDQo+IHY0LjkuMjM1OiBCdWlsZCBPSyENCj4gdjQuNC4yMzU6IEJ1aWxkIGZhaWxlZCEgRXJy
b3JzOg0KPiAgICAgZHJpdmVycy91c2IvY29yZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6IGltcGxp
Y2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uDQo+ICd1c2JfbG9ja19kZXZpY2VfaW50ZXJydXB0
aWJsZSc7IGRpZCB5b3UgbWVhbiAndXNiX2xvY2tfZGV2aWNlX2Zvcl9yZXNldCc/DQo+IFstV2Vy
cm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KPiAgICAgZHJpdmVycy91c2IvY29y
ZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9u
DQo+ICd1c2JfbG9ja19kZXZpY2VfaW50ZXJydXB0aWJsZSc7IGRpZCB5b3UgbWVhbiAndXNiX2xv
Y2tfZGV2aWNlX2Zvcl9yZXNldCc/DQo+IFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xh
cmF0aW9uXQ0KPiAgICAgZHJpdmVycy91c2IvY29yZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6IGlt
cGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uDQo+ICd1c2JfbG9ja19kZXZpY2VfaW50ZXJy
dXB0aWJsZSc7IGRpZCB5b3UgbWVhbiAndXNiX2xvY2tfZGV2aWNlX2Zvcl9yZXNldCc/DQo+IFst
V2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KPiAgICAgZHJpdmVycy91c2Iv
Y29yZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0
aW9uDQo+ICd1c2JfbG9ja19kZXZpY2VfaW50ZXJydXB0aWJsZSc7IGRpZCB5b3UgbWVhbiAndXNi
X2xvY2tfZGV2aWNlX2Zvcl9yZXNldCc/DQo+IFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRl
Y2xhcmF0aW9uXQ0KPiAgICAgZHJpdmVycy91c2IvY29yZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6
IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uDQo+ICd1c2JfbG9ja19kZXZpY2VfaW50
ZXJydXB0aWJsZSc7IGRpZCB5b3UgbWVhbiAndXNiX2xvY2tfZGV2aWNlX2Zvcl9yZXNldCc/DQo+
IFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KPiAgICAgZHJpdmVycy91
c2IvY29yZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1
bmN0aW9uDQo+ICd1c2JfbG9ja19kZXZpY2VfaW50ZXJydXB0aWJsZSc7IGRpZCB5b3UgbWVhbiAn
dXNiX2xvY2tfZGV2aWNlX2Zvcl9yZXNldCc/DQo+IFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9u
LWRlY2xhcmF0aW9uXQ0KPiAgICAgZHJpdmVycy91c2IvY29yZS9zeXNmcy5jOjgyNToxMTogZXJy
b3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uDQo+IOKAmHVzYl9sb2NrX2Rldmlj
ZV9pbnRlcnJ1cHRpYmxl4oCZIFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9u
XQ0KPiAgICAgZHJpdmVycy91c2IvY29yZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6IGltcGxpY2l0
IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uDQo+IOKAmHVzYl9sb2NrX2RldmljZV9pbnRlcnJ1cHRp
Ymxl4oCZIFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KPiAgICAgZHJp
dmVycy91c2IvY29yZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9u
IG9mIGZ1bmN0aW9uDQo+ICd1c2JfbG9ja19kZXZpY2VfaW50ZXJydXB0aWJsZSc7IGRpZCB5b3Ug
bWVhbiAndXNiX2xvY2tfZGV2aWNlX2Zvcl9yZXNldCc/DQo+IFstV2Vycm9yPWltcGxpY2l0LWZ1
bmN0aW9uLWRlY2xhcmF0aW9uXQ0KPiAgICAgZHJpdmVycy91c2IvY29yZS9zeXNmcy5jOjgyNTox
MTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uDQo+ICd1c2JfbG9ja19k
ZXZpY2VfaW50ZXJydXB0aWJsZSc7IGRpZCB5b3UgbWVhbiAndXNiX2xvY2tfZGV2aWNlX2Zvcl9y
ZXNldCc/DQo+IFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KPiAgICAg
ZHJpdmVycy91c2IvY29yZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0
aW9uIG9mIGZ1bmN0aW9uDQo+IOKAmHVzYl9sb2NrX2RldmljZV9pbnRlcnJ1cHRpYmxl4oCZIFst
V2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KPiAgICAgZHJpdmVycy91c2Iv
Y29yZS9zeXNmcy5jOjgyNToxMTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0
aW9uDQo+IOKAmHVzYl9sb2NrX2RldmljZV9pbnRlcnJ1cHRpYmxl4oCZIFstV2Vycm9yPWltcGxp
Y2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KPiANCj4gDQo+IE5PVEU6IFRoZSBwYXRjaCB3aWxs
IG5vdCBiZSBxdWV1ZWQgdG8gc3RhYmxlIHRyZWVzIHVudGlsIGl0IGlzIHVwc3RyZWFtLg0KPiAN
Cj4gSG93IHNob3VsZCB3ZSBwcm9jZWVkIHdpdGggdGhpcyBwYXRjaD8NCg0KTmVlZCA3ZGQ5Y2Jh
NWJiOTAgKCJ1c2I6IHN5c2ZzOiBtYWtlIGxvY2tpbmcgaW50ZXJydXB0aWJsZSIpPw0KPiANCj4g
LS0NCj4gVGhhbmtzDQo+IFNhc2hhDQo=
