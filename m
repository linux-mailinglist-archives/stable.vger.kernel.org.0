Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E5B679735
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjAXME1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjAXME0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:04:26 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853AE2330C
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 04:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1674561850; x=1706097850;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version:content-transfer-encoding;
  bh=ugl48vImlLULq3rgoz0ufZQz3sBht52eV1+xe5PT1lk=;
  b=VfJ3WEYu+I91unHkWaY9QeY6XOl3QZB2I6gmGC/ZFaQm/Y0v+t6sG1wj
   FGf/1mOTXUUaFth2nRaZLeWm+bLEjUBCXjGx4YXP+YXGl1y0T71qp1vc/
   OT2Vnypst+fS+v/Z7hx/07TyF5M1SO7TFxetq3dCUfqOh2Wzt3zpAivXb
   o=;
X-IronPort-AV: E=Sophos;i="5.97,242,1669075200"; 
   d="scan'208";a="303632290"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 12:04:04 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com (Postfix) with ESMTPS id 0F83081F49;
        Tue, 24 Jan 2023 12:03:55 +0000 (UTC)
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 24 Jan 2023 12:03:55 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 24 Jan 2023 12:03:55 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.45 via Frontend Transport; Tue, 24 Jan 2023 12:03:55 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id CD77120D95; Tue, 24 Jan 2023 13:03:53 +0100 (CET)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     Dhruva Gole <d-gole@ti.com>
CC:     Tudor Ambarus <tudor.ambarus@linaro.org>,
        <Takahiro.Kuwano@infineon.com>, <tkuw584924@gmail.com>,
        <linux-mtd@lists.infradead.org>, <pratyush@kernel.org>,
        <michael@walle.cc>, <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <Bacem.Daassi@infineon.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mtd: spi-nor: spansion: Consider reserved bits in
 CFR5 register
References: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
        <20230110164703.83413-1-tudor.ambarus@linaro.org>
        <mafs0v8kxb9mb.fsf_-_@amazon.de>
        <e02d6aa5-2189-4afb-2521-6034feaa3460@ti.com>
        <mafs0tu0gfc1z.fsf_-_@amazon.de>
        <073bb72e-ed53-ef40-1860-c0957d88e0c6@ti.com>
Date:   Tue, 24 Jan 2023 13:03:53 +0100
In-Reply-To: <073bb72e-ed53-ef40-1860-c0957d88e0c6@ti.com> (Dhruva Gole's
        message of "Tue, 24 Jan 2023 16:42:47 +0530")
Message-ID: <mafs0pmb4f8ba.fsf_-_@amazon.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBKYW4gMjQgMjAyMywgRGhydXZhIEdvbGUgd3JvdGU6Cgo+IE9uIDI0LzAxLzIzIDE2
OjEzLCBQcmF0eXVzaCBZYWRhdiB3cm90ZToKPj4gT24gTW9uLCBKYW4gMjMgMjAyMywgRGhydXZh
IEdvbGUgd3JvdGU6Cj4+Cj4+PiBIaSBQcmF0eXVzaCwKPj4+Cj4+PiBPbiAyMy8wMS8yMyAyMDow
NywgUHJhdHl1c2ggWWFkYXYgd3JvdGU6Cj4+Pj4gK0NjIERocnV2YQo+Pj4gSSBoYWQgYWxyZWFk
eSByZXZpZXdlZCB0aGlzLCBidXQgbm93IEkgaGF2ZSBsb2NhbGx5IGFwcGxpZWQgdGhlIHBhdGNo
ZXMsCj4+PiB0byBsaW51eCBtYXN0ZXIgYW5kIGJ1aWx0IGFuZCB0ZXN0ZWQgLSBzZWVtcyBva2F5
LAo+Pj4+IEhpIFR1ZG9yLAo+Pj4+Cj4+Pj4gT24gVHVlLCBKYW4gMTAgMjAyMywgVHVkb3IgQW1i
YXJ1cyB3cm90ZToKPj4+Pgo+Pj4+PiBDRlI1WzZdIGlzIHJlc2VydmVkIGJpdCBhbmQgbXVzdCBi
ZSBhbHdheXMgMS4gU2V0IGl0IHRvIGNvbXBseSB3aXRoIGZsYXNoCj4+Pj4+IHJlcXVpcmVtZW50
cy4gV2hpbGUgZml4aW5nIFNQSU5PUl9SRUdfQ1lQUkVTU19DRlI1Vl9PQ1RfRFRSX3tFTiwgRFN9
Cj4+Pj4+IGRlZmluaXRpb24sIHN0b3AgdXNpbmcgbWFnaWMgbnVtYmVycyBhbmQgZGVzY3JpYmUg
dGhlIG1pc3NpbmcgYml0IGZpZWxkcwo+Pj4+PiBpbiBDRlI1IHJlZ2lzdGVyLiBUaGlzIGlzIHVz
ZWZ1bCBmb3IgYm90aCByZWFkYWJpbGl0eSBhbmQgZnV0dXJlIHBvc3NpYmxlCj4+Pj4+IGFkZGl0
aW9uIG9mIE9jdGFsIFNUUiBtb2RlIHN1cHBvcnQuCj4+Pj4+Cj4+Pj4+IEZpeGVzOiBjMzI2NmFm
MTAxZjIgKCJtdGQ6IHNwaS1ub3I6IHNwYW5zaW9uOiBhZGQgc3VwcG9ydCBmb3IgQ3lwcmVzcyBT
ZW1wZXIgZmxhc2giKQo+Pj4+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwo+Pj4+PiBSZXBv
cnRlZC1ieTogVGFrYWhpcm8gS3V3YW5vIDxUYWthaGlyby5LdXdhbm9AaW5maW5lb24uY29tPgo+
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBUdWRvciBBbWJhcnVzIDx0dWRvci5hbWJhcnVzQGxpbmFyby5v
cmc+Cj4+Pj4+IC0tLQo+Pj4+PiAgZHJpdmVycy9tdGQvc3BpLW5vci9zcGFuc2lvbi5jIHwgOSAr
KysrKysrLS0KPj4+Pj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCj4+Pj4+Cj4+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL210ZC9zcGktbm9yL3NwYW5z
aW9uLmMgYi9kcml2ZXJzL210ZC9zcGktbm9yL3NwYW5zaW9uLmMKPj4+Pj4gaW5kZXggYjYyMWNk
ZmQ1MDZmLi4wN2ZlMGY2ZmRmZTMgMTAwNjQ0Cj4+Pj4+IC0tLSBhL2RyaXZlcnMvbXRkL3NwaS1u
b3Ivc3BhbnNpb24uYwo+Pj4+PiArKysgYi9kcml2ZXJzL210ZC9zcGktbm9yL3NwYW5zaW9uLmMK
Pj4+Pj4gQEAgLTIxLDggKzIxLDEzIEBACj4+Pj4+ICAjZGVmaW5lIFNQSU5PUl9SRUdfQ1lQUkVT
U19DRlIzViAgICAgICAgICAgICAgIDB4MDA4MDAwMDQKPj4+Pj4gICNkZWZpbmUgU1BJTk9SX1JF
R19DWVBSRVNTX0NGUjNWX1BHU1ogICAgICAgICAgQklUKDQpIC8qIFBhZ2Ugc2l6ZS4gKi8KPj4+
Pj4gICNkZWZpbmUgU1BJTk9SX1JFR19DWVBSRVNTX0NGUjVWICAgICAgICAgICAgICAgMHgwMDgw
MDAwNgo+Pj4+PiAtI2RlZmluZSBTUElOT1JfUkVHX0NZUFJFU1NfQ0ZSNVZfT0NUX0RUUl9FTiAg
ICAweDMKPj4+Pj4gLSNkZWZpbmUgU1BJTk9SX1JFR19DWVBSRVNTX0NGUjVWX09DVF9EVFJfRFMg
ICAgMAo+Pj4+PiArI2RlZmluZSBTUElOT1JfUkVHX0NZUFJFU1NfQ0ZSNV9CSVQ2ICAgICAgICAg
ICBCSVQoNikKPj4+PiBQZXJoYXBzIGNvbW1lbnQgaGVyZSB0aGF0IHRoaXMgYml0IGlzIHJlc2Vy
dmVkLiBPdGhlcndpc2UgaXQgaXMgbm90Cj4+Pj4gb2J2aW91cyB3aGF0IHRoaXMgZG9lcyBhbmQg
d2h5IHdlIGFyZSBzZXR0aW5nIGl0IHdpdGhvdXQgZ29pbmcgdGhyb3VnaAo+Pj4+IGdpdC1ibGFt
ZS4gTm8gbmVlZCBmb3IgYSByZS1yb2xsLCBJIHRoaW5rIGl0IGlzIGZpbmUgaWYgeW91IGFkZCB0
aGlzCj4+Pj4gd2hlbiBhcHBseWluZy4KPj4+Pgo+Pj4+PiArI2RlZmluZSBTUElOT1JfUkVHX0NZ
UFJFU1NfQ0ZSNV9ERFIgICAgICAgICAgICBCSVQoMSkKPj4+Pj4gKyNkZWZpbmUgU1BJTk9SX1JF
R19DWVBSRVNTX0NGUjVfT1BJICAgICAgICAgICAgQklUKDApCj4+Pj4+ICsjZGVmaW5lIFNQSU5P
Ul9SRUdfQ1lQUkVTU19DRlI1Vl9PQ1RfRFRSX0VOICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFwKPj4+Pj4gKyAgICAgICAoU1BJTk9SX1JFR19DWVBSRVNTX0NGUjVfQklUNiB8IFNQSU5PUl9S
RUdfQ1lQUkVTU19DRlI1X0REUiB8ICAgXAo+Pj4+PiArICAgICAgICBTUElOT1JfUkVHX0NZUFJF
U1NfQ0ZSNV9PUEkpCj4+Pj4+ICsjZGVmaW5lIFNQSU5PUl9SRUdfQ1lQUkVTU19DRlI1Vl9PQ1Rf
RFRSX0RTICAgIFNQSU5PUl9SRUdfQ1lQUkVTU19DRlI1X0JJVDYKPj4+PiBJIHdvdWxkIHNheSBk
b24ndCBmaXggd2hhdCBpc24ndCBicm9rZW4uIEJ1dCBpZiB5b3UgZG8sIHRlc3QgaXQuIERvIHlv
dQo+Pj4+IG9yIFRha2FoaXJvIGhhdmUgYSBDeXByZXNzIFMyOCogZmxhc2ggdG8gdGVzdCB0aGlz
IGNoYW5nZSBvbj8gSWYgbm8sCj4+Pj4gdGhlbiBwZXJoYXBzIERocnV2YSBjYW4gaGVscCBoZXJl
IHNpbmNlIFRJIHVzZXMgdGhpcyBmbGFzaCBvbiBhIGJ1bmNoIG9mCj4+Pj4gdGhlaXIgYm9hcmRz
Pwo+Pj4+Cj4+Pj4gVGhlIGNoYW5nZSBsb29rcyBmaW5lIHRvIG1lIHdpdGggdGhlIGFib3ZlIGNv
bW1lbnQgYWRkZWQsIEkganVzdCB3b3VsZAo+Pj4+IGxpa2Ugc29tZW9uZSB0byB0ZXN0IGl0IG9u
Y2UuCj4+PiBUZXN0ZWQgT1NQSV9TX0ZVTkNfRERfUldfRVJBU0VTSVpFX1VCSUZTIGZyb20gbHRw
LWRkdCBhbmQgdGVzdCBzZWVtZWQgdG8gcGFzcyBvbiBteQo+Pj4gQU02MjUgU0sgRVZNIGhhdmlu
ZyBhbiBPU1BJIE5PUiBTMjhIUzUxMlQgRmxhc2guCj4+IFRoYW5rcy4KPj4KPj4gQlRXLCBvbmUg
aW50ZXJlc3RpbmcgYml0IGFib3V0IHRoaXMgaW4gY2FzZSB5b3UgZGlkbid0IGtub3cgYWxyZWFk
eS4KPj4gU2luY2UgdGhpcyBpcyBwbGF5aW5nIHdpdGggT2N0YWwgRFRSIGVuYWJsZS9kaXNhYmxl
LCB5b3UgbWlnaHQgYWxzbyB3YW50Cj4+IHRvIGRvdWJsZS1jaGVjayB5b3UgYXJlIGFjdHVhbGx5
IHVzaW5nIE9jdGFsIERUUiBtb2RlLiBUaGlzIGNhbiBiZSBkb25lCj4+IGJ5IGxvb2tpbmcgYXQg
dGhlIFNQSSBOT1IgZGVidWdmcyBlbnRyeSAodXN1YWxseSBpbgo+PiAvc3lzL2tlcm5lbC9kZWJ1
Zy9zcGktbm9yKS4gWW91IGNhbiAiY2F0IHBhcmFtcyIgYW5kIHNlZSB3aGF0IHByb3RvY29scwo+
PiBhcmUgYmVpbmcgdXNlZCwgYW5kIG1ha2Ugc3VyZSA4RC04RC04RCBpcyBiZWluZyB1c2VkLgo+
IFllcywgSSBiZWxpZXZlIDhELThELThEIGlzIGJlaW5nIHVzZWQuCj4gSGVyZSdzIHRoZSBvdXRw
dXQ6Cj4gLi4uCj4gcm9vdEBhbTYyeHgtZXZtOn4jIGNhdCAvc3lzL2tlcm5lbC9kZWJ1Zy9zcGkt
bm9yL3NwaTAuMC9wYXJhbXMKPiBuYW1lICAgICAgICAgICAgczI4aHM1MTJ0Cj4gaWQgICAgICAg
ICAgICAgIDM0IDViIDFhIDBmIDAzIDkwCj4gc2l6ZSAgICAgICAgICAgIDY0LjAgTWlCCj4gd3Jp
dGUgc2l6ZSAgICAgIDE2Cj4gcGFnZSBzaXplICAgICAgIDI1Ngo+IGFkZHJlc3MgbmJ5dGVzICA0
Cj4gZmxhZ3MgICAgICAgICAgIDRCX09QQ09ERVMgfCBIQVNfNEJBSVQgfCBIQVNfMTZCSVRfU1Ig
fCBJT19NT0RFX0VOX1ZPTEFUSUxFIHwgU09GVF9SRVNFVAo+Cj4gb3Bjb2Rlcwo+ICByZWFkICAg
ICAgICAgICAweGVlCj4gICBkdW1teSBjeWNsZXMgIDI0Cj4gIGVyYXNlICAgICAgICAgIDB4ZDgK
PiAgcHJvZ3JhbSAgICAgICAgMHgxMgo+ICA4RCBleHRlbnNpb24gICByZXBlYXQKPgo+IHByb3Rv
Y29scwo+ICByZWFkICAgICAgICAgICA4RC04RC04RAo+ICB3cml0ZSAgICAgICAgICA4RC04RC04
RAo+ICByZWdpc3RlciAgICAgICA4RC04RC04RAo+Cj4gZXJhc2UgY29tbWFuZHMKPiAgMjEgKDQu
MDAgS2lCKSBbMl0KPiAgZGMgKDI1NiBLaUIpIFszXQo+ICBjNyAoNjQuMCBNaUIpCj4KPiBzZWN0
b3IgbWFwCj4gIHJlZ2lvbiAoaW4gaGV4KSAgIHwgZXJhc2UgbWFzayB8IGZsYWdzCj4gIC0tLS0t
LS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0rLS0tLS0tLS0tLQo+ICAwMDAwMDAwMC0wMDAxZmZm
ZiB8wqDCoMKgwqAgW8KgIDIgXSB8Cj4gIDAwMDIwMDAwLTAwMDNmZmZmIHzCoMKgwqDCoCBbwqDC
oCAzXSB8IG92ZXJsYWlkCj4gIDAwMDQwMDAwLTAzZmZmZmZmIHzCoMKgwqDCoCBbwqDCoCAzXSB8
Cj4gLi4uCj4KPiBBbHNvLCB0aGUgcmF3IHJlYWQgc3BlZWQgaXMgYWJvdXQgNDAgTUJQUwo+IFRo
ZSBmcmVxdWVuY3kgd2Ugc2V0IGZyb20gRFQgaXMgMjUgTUh6LAo+IGFzc3VtaW5nIDFNQiBpcyB0
cmFuc2ZlcmVkIGV2ZXJ5IGN5Y2xlJ3MgcmlzaW5nIGFuZCBmYWxsaW5nIGVkZ2UsCj4gaWUuIDI1
KjIgPSA1MCBNQlBTIGlzIGlkZWFsIHNwZWVkLgoKWWVwLCB0aGF0J3Mgd2hhdCBJIHdvdWxkIGV4
cGVjdCBhcyB3ZWxsLiBUaGFua3MgZm9yIGNvbmZpcm1pbmcuCgo+Cj4+Cj4+IEFNNjI1IFNLIF9z
aG91bGRfIGJlIHVzaW5nIDhELThELThEIG1vZGUgYWxyZWFkeSwgYnV0IEkgdGhpbmsgaXQgaXMK
Pj4gdXNlZnVsIGlmIHlvdSBrbm93IGhvdyB0byBjb25maXJtIHRoaXMgYXNzdW1wdGlvbiA6LSkK
Pj4KPj4+PiBSZXZpZXdlZC1ieTogUHJhdHl1c2ggWWFkYXYgPHB0eWFkYXZAYW1hem9uLmRlPgo+
Pj4gRm9yIHRoaXMgc2VyaWVzLAo+Pj4KPj4+IFRlc3RlZC1ieTogRGhydXZhIEdvbGUgPGQtZ29s
ZUB0aS5jb20+Cj4+Pgo+Pj4+PiAgI2RlZmluZSBTUElOT1JfT1BfQ1lQUkVTU19SRF9GQVNUICAg
ICAgICAgICAgICAweGVlCj4+Pj4+Cj4+Pj4+ICAvKiBDeXByZXNzIFNQSSBOT1IgZmxhc2ggb3Bl
cmF0aW9ucy4gKi8KPgo+IC0tCj4gQmVzdCByZWdhcmRzLAo+IERocnV2YSBHb2xlCj4gVGV4YXMg
SW5zdHJ1bWVudHMgSW5jb3Jwb3JhdGVkCj4KCi0tIApSZWdhcmRzLApQcmF0eXVzaCBZYWRhdgoK
CgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAox
MDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25h
dGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRl
ciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

