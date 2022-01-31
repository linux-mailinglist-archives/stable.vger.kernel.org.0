Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788794A3FE2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242767AbiAaKN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:13:26 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42796 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiAaKNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:13:25 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 794621F381;
        Mon, 31 Jan 2022 10:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1643624004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rd9CmQUsjRGD2JChwuTMm4dyR7BKneigkDz+IKnsrt8=;
        b=PWCn0PO8CnlrRNZr91kbs8QffbwfA++c0q6E59m5Gyew2rnWbXQy/6Gv3Y2CNNA64fju79
        3nCv9Zvirg1y07vO3oVADCV5L1utDiUS50y1L1iuZyB3oPJB4iC4YcgCToHS7BFiA53tKK
        0lQ1RJzY8B63SKPv6I8T6rsSgRasMwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1643624004;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rd9CmQUsjRGD2JChwuTMm4dyR7BKneigkDz+IKnsrt8=;
        b=/Y593z9kz0ERz9yJh5rLiYWmyy5W4mozJnEyrCzxSG+CTzQgxsFU8Y7Qr79cbpjtqFCkv/
        bBDTMHsiNRmP78Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3431C13BB9;
        Mon, 31 Jan 2022 10:13:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tZRZC0S292G5IQAAMHmgww
        (envelope-from <ptesarik@suse.cz>); Mon, 31 Jan 2022 10:13:24 +0000
Message-ID: <3ca4de98-8f4d-9937-923e-f8865c96f82c@suse.cz>
Date:   Mon, 31 Jan 2022 11:13:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Content-Language: en-GB
To:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Michael Mueller <mimu@linux.ibm.com>
References: <20210827125429.1912577-1-pasic@linux.ibm.com>
From:   =?UTF-8?B?UGV0ciBUZXNhxZnDrWs=?= <ptesarik@suse.cz>
In-Reply-To: <20210827125429.1912577-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgSGFsaWwsDQoNCkRuZSAyNy4gMDguIDIxIHYgMTQ6NTQgSGFsaWwgUGFzaWMgbmFwc2Fs
KGEpOg0KPiBXaGlsZSBpbiBwcmFjdGljZSB2Y3B1LT52Y3B1X2lkeCA9PSAgdmNwdS0+dmNw
X2lkIGlzIG9mdGVuIHRydWUsDQo+IGl0IG1heSBub3QgYWx3YXlzIGJlLCBhbmQgd2UgbXVz
dCBub3QgcmVseSBvbiB0aGlzLg0KPiANCj4gQ3VycmVudGx5IGt2bS0+YXJjaC5pZGxlX21h
c2sgaXMgaW5kZXhlZCBieSB2Y3B1X2lkLCB3aGljaCBpbXBsaWVzDQo+IHRoYXQgY29kZSBs
aWtlDQo+IGZvcl9lYWNoX3NldF9iaXQodmNwdV9pZCwga3ZtLT5hcmNoLmlkbGVfbWFzaywg
b25saW5lX3ZjcHVzKSB7DQo+ICAgICAgICAgICAgICAgICAgdmNwdSA9IGt2bV9nZXRfdmNw
dShrdm0sIHZjcHVfaWQpOw0KPiAJCWRvX3N0dWZmKHZjcHUpOw0KPiB9DQo+IGlzIG5vdCBs
ZWdpdC4gVGhlIHRyb3VibGUgaXMsIHdlIGRvIGFjdHVhbGx5IHVzZSBrdm0tPmFyY2guaWRs
ZV9tYXNrDQo+IGxpa2UgdGhpcy4gVG8gZml4IHRoaXMgcHJvYmxlbSB3ZSBoYXZlIHR3byBv
cHRpb25zLiBFaXRoZXIgdXNlDQo+IGt2bV9nZXRfdmNwdV9ieV9pZCh2Y3B1X2lkKSwgd2hp
Y2ggd291bGQgbG9vcCB0byBmaW5kIHRoZSByaWdodCB2Y3B1X2lkLA0KPiBvciBzd2l0Y2gg
dG8gaW5kZXhpbmcgdmlhIHZjcHVfaWR4LiBUaGUgbGF0dGVyIGlzIHByZWZlcmFibGUgZm9y
IG9idmlvdXMNCj4gcmVhc29ucy4NCg0KSSdtIGp1c3QgYmFja3BvcnRpbmcgdGhpcyBmaXgg
dG8gU0xFUyAxMiBTUDUsIGFuZCBJJ3ZlIG5vdGljZWQgdGhhdCANCnRoZXJlIGlzIHN0aWxs
IHRoaXMgY29kZSBpbiBfX2Zsb2F0aW5nX2lycV9raWNrKCk6DQoNCgkvKiBmaW5kIGlkbGUg
VkNQVXMgZmlyc3QsIHRoZW4gcm91bmQgcm9iaW4gKi8NCglzaWdjcHUgPSBmaW5kX2ZpcnN0
X2JpdChmaS0+aWRsZV9tYXNrLCBvbmxpbmVfdmNwdXMpOw0KLyogLi4uIHJvdW5kIHJvYmlu
IGxvb3AgcmVtb3ZlZCAuLi4NCglkc3RfdmNwdSA9IGt2bV9nZXRfdmNwdShrdm0sIHNpZ2Nw
dSk7DQoNCkl0IHNlZW1zIHRvIG1lIHRoYXQgdGhpcyBkb2VzIGV4YWN0bHkgdGhlIHRoaW5n
IHRoYXQgaXMgbm90IGxlZ2l0LCBidXQgDQpJJ20gbm8gZXhwZXJ0LiBEaWQgSSBtaXNzIHNv
bWV0aGluZz8NCg0KUGV0ciBUDQoNCj4gTGV0IHVzIG1ha2Ugc3dpdGNoIGZyb20gaW5kZXhp
bmcga3ZtLT5hcmNoLmlkbGVfbWFzayBieSB2Y3B1X2lkIHRvDQo+IGluZGV4aW5nIGl0IGJ5
IHZjcHVfaWR4LiAgVG8ga2VlcCBnaXNhX2ludC5raWNrZWRfbWFzayBpbmRleGVkIGJ5IHRo
ZQ0KPiBzYW1lIGluZGV4IGFzIGlkbGVfbWFzayBsZXRzIG1ha2UgdGhlIHNhbWUgY2hhbmdl
IGZvciBpdCBhcyB3ZWxsLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGFsaWwgUGFzaWMgPHBh
c2ljQGxpbnV4LmlibS5jb20+DQo+IEZpeGVzOiAxZWUwYmM1NTlkYzMgKCJLVk06IHMzOTA6
IGdldCByaWQgb2YgbG9jYWxfaW50IGFycmF5IikNCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPiAjIDMuMTUrDQo+IC0tLQ0KPiAgIGFyY2gvczM5MC9pbmNsdWRlL2FzbS9rdm1f
aG9zdC5oIHwgIDEgKw0KPiAgIGFyY2gvczM5MC9rdm0vaW50ZXJydXB0LmMgICAgICAgIHwg
MTIgKysrKysrLS0tLS0tDQo+ICAgYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jICAgICAgICAg
fCAgMiArLQ0KPiAgIGFyY2gvczM5MC9rdm0va3ZtLXMzOTAuaCAgICAgICAgIHwgIDIgKy0N
Cj4gICA0IGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3MzOTAvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBi
L2FyY2gvczM5MC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+IGluZGV4IDE2MWE5ZTEyYmZi
OC4uNjMwZWFiMGZhMTc2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3MzOTAvaW5jbHVkZS9hc20v
a3ZtX2hvc3QuaA0KPiArKysgYi9hcmNoL3MzOTAvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0K
PiBAQCAtOTU3LDYgKzk1Nyw3IEBAIHN0cnVjdCBrdm1fYXJjaHsNCj4gICAJYXRvbWljNjRf
dCBjbW1hX2RpcnR5X3BhZ2VzOw0KPiAgIAkvKiBzdWJzZXQgb2YgYXZhaWxhYmxlIGNwdSBm
ZWF0dXJlcyBlbmFibGVkIGJ5IHVzZXIgc3BhY2UgKi8NCj4gICAJREVDTEFSRV9CSVRNQVAo
Y3B1X2ZlYXQsIEtWTV9TMzkwX1ZNX0NQVV9GRUFUX05SX0JJVFMpOw0KPiArCS8qIGluZGV4
ZWQgYnkgdmNwdV9pZHggKi8NCj4gICAJREVDTEFSRV9CSVRNQVAoaWRsZV9tYXNrLCBLVk1f
TUFYX1ZDUFVTKTsNCj4gICAJc3RydWN0IGt2bV9zMzkwX2dpc2FfaW50ZXJydXB0IGdpc2Ff
aW50Ow0KPiAgIAlzdHJ1Y3Qga3ZtX3MzOTBfcHYgcHY7DQo+IGRpZmYgLS1naXQgYS9hcmNo
L3MzOTAva3ZtL2ludGVycnVwdC5jIGIvYXJjaC9zMzkwL2t2bS9pbnRlcnJ1cHQuYw0KPiBp
bmRleCBkNTQ4ZDYwY2FlZDIuLjE2MjU2ZTE3YTU0NCAxMDA2NDQNCj4gLS0tIGEvYXJjaC9z
MzkwL2t2bS9pbnRlcnJ1cHQuYw0KPiArKysgYi9hcmNoL3MzOTAva3ZtL2ludGVycnVwdC5j
DQo+IEBAIC00MTksMTMgKzQxOSwxMyBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBkZWxpdmVy
YWJsZV9pcnFzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gICBzdGF0aWMgdm9pZCBfX3Nl
dF9jcHVfaWRsZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAgew0KPiAgIAlrdm1fczM5
MF9zZXRfY3B1ZmxhZ3ModmNwdSwgQ1BVU1RBVF9XQUlUKTsNCj4gLQlzZXRfYml0KHZjcHUt
PnZjcHVfaWQsIHZjcHUtPmt2bS0+YXJjaC5pZGxlX21hc2spOw0KPiArCXNldF9iaXQoa3Zt
X3ZjcHVfZ2V0X2lkeCh2Y3B1KSwgdmNwdS0+a3ZtLT5hcmNoLmlkbGVfbWFzayk7DQo+ICAg
fQ0KPiAgIA0KPiAgIHN0YXRpYyB2b2lkIF9fdW5zZXRfY3B1X2lkbGUoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1KQ0KPiAgIHsNCj4gICAJa3ZtX3MzOTBfY2xlYXJfY3B1ZmxhZ3ModmNwdSwg
Q1BVU1RBVF9XQUlUKTsNCj4gLQljbGVhcl9iaXQodmNwdS0+dmNwdV9pZCwgdmNwdS0+a3Zt
LT5hcmNoLmlkbGVfbWFzayk7DQo+ICsJY2xlYXJfYml0KGt2bV92Y3B1X2dldF9pZHgodmNw
dSksIHZjcHUtPmt2bS0+YXJjaC5pZGxlX21hc2spOw0KPiAgIH0NCj4gICANCj4gICBzdGF0
aWMgdm9pZCBfX3Jlc2V0X2ludGVyY2VwdF9pbmRpY2F0b3JzKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkNCj4gQEAgLTMwNTAsMTggKzMwNTAsMTggQEAgaW50IGt2bV9zMzkwX2dldF9pcnFf
c3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBfX3U4IF9fdXNlciAqYnVmLCBpbnQgbGVu
KQ0KPiAgIA0KPiAgIHN0YXRpYyB2b2lkIF9fYWlycXNfa2lja19zaW5nbGVfdmNwdShzdHJ1
Y3Qga3ZtICprdm0sIHU4IGRlbGl2ZXJhYmxlX21hc2spDQo+ICAgew0KPiAtCWludCB2Y3B1
X2lkLCBvbmxpbmVfdmNwdXMgPSBhdG9taWNfcmVhZCgma3ZtLT5vbmxpbmVfdmNwdXMpOw0K
PiArCWludCB2Y3B1X2lkeCwgb25saW5lX3ZjcHVzID0gYXRvbWljX3JlYWQoJmt2bS0+b25s
aW5lX3ZjcHVzKTsNCj4gICAJc3RydWN0IGt2bV9zMzkwX2dpc2FfaW50ZXJydXB0ICpnaSA9
ICZrdm0tPmFyY2guZ2lzYV9pbnQ7DQo+ICAgCXN0cnVjdCBrdm1fdmNwdSAqdmNwdTsNCj4g
ICANCj4gLQlmb3JfZWFjaF9zZXRfYml0KHZjcHVfaWQsIGt2bS0+YXJjaC5pZGxlX21hc2ss
IG9ubGluZV92Y3B1cykgew0KPiAtCQl2Y3B1ID0ga3ZtX2dldF92Y3B1KGt2bSwgdmNwdV9p
ZCk7DQo+ICsJZm9yX2VhY2hfc2V0X2JpdCh2Y3B1X2lkeCwga3ZtLT5hcmNoLmlkbGVfbWFz
aywgb25saW5lX3ZjcHVzKSB7DQo+ICsJCXZjcHUgPSBrdm1fZ2V0X3ZjcHUoa3ZtLCB2Y3B1
X2lkeCk7DQo+ICAgCQlpZiAocHN3X2lvaW50X2Rpc2FibGVkKHZjcHUpKQ0KPiAgIAkJCWNv
bnRpbnVlOw0KPiAgIAkJZGVsaXZlcmFibGVfbWFzayAmPSAodTgpKHZjcHUtPmFyY2guc2ll
X2Jsb2NrLT5nY3JbNl0gPj4gMjQpOw0KPiAgIAkJaWYgKGRlbGl2ZXJhYmxlX21hc2spIHsN
Cj4gICAJCQkvKiBsYXRlbHkga2lja2VkIGJ1dCBub3QgeWV0IHJ1bm5pbmcgKi8NCj4gLQkJ
CWlmICh0ZXN0X2FuZF9zZXRfYml0KHZjcHVfaWQsIGdpLT5raWNrZWRfbWFzaykpDQo+ICsJ
CQlpZiAodGVzdF9hbmRfc2V0X2JpdCh2Y3B1X2lkeCwgZ2ktPmtpY2tlZF9tYXNrKSkNCj4g
ICAJCQkJcmV0dXJuOw0KPiAgIAkJCWt2bV9zMzkwX3ZjcHVfd2FrZXVwKHZjcHUpOw0KPiAg
IAkJCXJldHVybjsNCj4gZGlmZiAtLWdpdCBhL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYyBi
L2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPiBpbmRleCA0NTI3YWM3YjU5NjEuLjg1ODA1
NDNjNWJjMyAxMDA2NDQNCj4gLS0tIGEvYXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jDQo+ICsr
KyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuYw0KPiBAQCAtNDA0NCw3ICs0MDQ0LDcgQEAg
c3RhdGljIGludCB2Y3B1X3ByZV9ydW4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgIAkJ
a3ZtX3MzOTBfcGF0Y2hfZ3Vlc3RfcGVyX3JlZ3ModmNwdSk7DQo+ICAgCX0NCj4gICANCj4g
LQljbGVhcl9iaXQodmNwdS0+dmNwdV9pZCwgdmNwdS0+a3ZtLT5hcmNoLmdpc2FfaW50Lmtp
Y2tlZF9tYXNrKTsNCj4gKwljbGVhcl9iaXQoa3ZtX3ZjcHVfZ2V0X2lkeCh2Y3B1KSwgdmNw
dS0+a3ZtLT5hcmNoLmdpc2FfaW50LmtpY2tlZF9tYXNrKTsNCj4gICANCj4gICAJdmNwdS0+
YXJjaC5zaWVfYmxvY2stPmljcHRjb2RlID0gMDsNCj4gICAJY3B1ZmxhZ3MgPSBhdG9taWNf
cmVhZCgmdmNwdS0+YXJjaC5zaWVfYmxvY2stPmNwdWZsYWdzKTsNCj4gZGlmZiAtLWdpdCBh
L2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuaCBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAuaA0K
PiBpbmRleCA5ZmFkMjUxMDliMGQuLmVjZDc0MWVlMzI3NiAxMDA2NDQNCj4gLS0tIGEvYXJj
aC9zMzkwL2t2bS9rdm0tczM5MC5oDQo+ICsrKyBiL2FyY2gvczM5MC9rdm0va3ZtLXMzOTAu
aA0KPiBAQCAtNzksNyArNzksNyBAQCBzdGF0aWMgaW5saW5lIGludCBpc192Y3B1X3N0b3Bw
ZWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgIA0KPiAgIHN0YXRpYyBpbmxpbmUgaW50
IGlzX3ZjcHVfaWRsZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAgew0KPiAtCXJldHVy
biB0ZXN0X2JpdCh2Y3B1LT52Y3B1X2lkLCB2Y3B1LT5rdm0tPmFyY2guaWRsZV9tYXNrKTsN
Cj4gKwlyZXR1cm4gdGVzdF9iaXQoa3ZtX3ZjcHVfZ2V0X2lkeCh2Y3B1KSwgdmNwdS0+a3Zt
LT5hcmNoLmlkbGVfbWFzayk7DQo+ICAgfQ0KPiAgIA0KPiAgIHN0YXRpYyBpbmxpbmUgaW50
IGt2bV9pc191Y29udHJvbChzdHJ1Y3Qga3ZtICprdm0pDQo+IA0KPiBiYXNlLWNvbW1pdDog
NzdkZDExNDM5Yjg2ZTNmNzk5MGU0YzBjOWUwYjY3ZGNhODI3NTBiYQ0K
