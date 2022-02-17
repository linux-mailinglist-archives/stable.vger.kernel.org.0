Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FC24BA456
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 16:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbiBQP16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 10:27:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbiBQP15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 10:27:57 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17577291FBA
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 07:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645111663; x=1676647663;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rP/wAo6u1NpTZphPM3H9zEJxX3dtCWUuGvFXy7FfK18=;
  b=Ix1pyyZFsuG4dKDQ0Gn/BNrUshYHx93SK41xfXCwY+pO+C/gK/LypQ55
   Z8EIcwLhUQh72sAstJ1JM8a/x8KXeGaJ+AlX46KgYad5xDlyuU+Dj/BxE
   5GOuJ7Ns3AlTJY8apNNp5HrC7raZ+eglzCF+2d/LBSouvOlSu3AN/GOUj
   oQT/Lqu+Gs1MGB4ff6Ek4WdjceUzl1B26zr64v87E+vnG2t+BcCYXYZop
   pdhKG97EF04e0076jFkLWjYrO9V6Va94ig37NJLTOi2EJWg41f3Dw86To
   +0wWlbZAeLm8JuWqE0YQOaOozoDdZSTbgSwrRGBk0Z4EaK93SNDoqKVJ4
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="248492349"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="248492349"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 07:27:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="637183449"
Received: from irsmsx603.ger.corp.intel.com ([163.33.146.9])
  by orsmga004.jf.intel.com with ESMTP; 17 Feb 2022 07:27:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 irsmsx603.ger.corp.intel.com (163.33.146.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 17 Feb 2022 15:27:39 +0000
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2308.020;
 Thu, 17 Feb 2022 07:27:38 -0800
From:   "Souza, Jose" <jose.souza@intel.com>
To:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Deak, Imre" <imre.deak@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/i915: Disconnect PHYs left connected by BIOS on
 disabled ports
Thread-Topic: [PATCH] drm/i915: Disconnect PHYs left connected by BIOS on
 disabled ports
Thread-Index: AQHYJBI0mBLaYPNKHEa+ydNfMSbp/qyYZF6A
Date:   Thu, 17 Feb 2022 15:27:38 +0000
Message-ID: <abf2e7d187ab1dbdc67a1442da680e3f5b38064e.camel@intel.com>
References: <20220217152237.670220-1-imre.deak@intel.com>
In-Reply-To: <20220217152237.670220-1-imre.deak@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D930C33F15BAE8418BFC4045D5AE429B@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIyLTAyLTE3IGF0IDE3OjIyICswMjAwLCBJbXJlIERlYWsgd3JvdGU6DQo+IEJJ
T1MgbWF5IGxlYXZlIGEgVHlwZUMgUEhZIGluIGEgY29ubmVjdGVkIHN0YXRlIGV2ZW4gdGhvdWdo
IHRoZQ0KPiBjb3JyZXNwb25kaW5nIHBvcnQgaXMgZGlzYWJsZWQuIFRoaXMgd2lsbCBwcmV2ZW50
IGFueSBob3RwbHVnIGV2ZW50cw0KPiBmcm9tIGJlaW5nIHNpZ25hbGxlZCAoYWZ0ZXIgdGhlIG1v
bml0b3IgZGVhc3NlcnRzIGFuZCB0aGVuIHJlYXNzZXJ0cyBpdHMNCj4gSFBEKSB1bnRpbCB0aGUg
UEhZIGlzIGRpc2Nvbm5lY3RlZCBhbmQgc28gdGhlIGRyaXZlciB3aWxsIG5vdCBkZXRlY3QgYQ0K
PiBjb25uZWN0ZWQgc2luay4gUmVib290aW5nIHdpdGggdGhlIFBIWSBpbiB0aGUgY29ubmVjdGVk
IHN0YXRlIGFsc28NCj4gcmVzdWx0cyBpbiBhIHN5c3RlbSBoYW5nLg0KPiANCj4gRml4IHRoZSBh
Ym92ZSBieSBkaXNjb25uZWN0aW5nIFR5cGVDIFBIWXMgb24gZGlzYWJsZWQgcG9ydHMuDQo+IA0K
PiBCZWZvcmUgY29tbWl0IDY0ODUxYTMyYzQ2M2U1IHRoZSBQSFkgY29ubmVjdGVkIHN0YXRlIHdh
cyByZWFkIG91dCBldmVuDQo+IGZvciBkaXNhYmxlZCBwb3J0cyBhbmQgbGF0ZXIgdGhlIFBIWSBn
b3QgZGlzY29ubmVjdGVkIGFzIGEgc2lkZSBlZmZlY3QNCj4gb2YgYSB0Y19wb3J0X2xvY2svdW5s
b2NrKCkgc2VxdWVuY2UgKGR1cmluZyBjb25uZWN0b3IgcHJvYmluZyksIGhlbmNlDQo+IHJlY292
ZXJpbmcgdGhlIHBvcnQncyBob3RwbHVnIGZ1bmN0aW9uYWxpdHkuDQoNClJldmlld2VkLWJ5OiBK
b3PDqSBSb2JlcnRvIGRlIFNvdXphIDxqb3NlLnNvdXphQGludGVsLmNvbT4NCg0KPiANCj4gQ2xv
c2VzOiBodHRwczovL2dpdGxhYi5mcmVlZGVza3RvcC5vcmcvZHJtL2ludGVsLy0vaXNzdWVzLzUw
MTQNCj4gRml4ZXM6IDY0ODUxYTMyYzQ2MyAoImRybS9pOTE1L3RjOiBBZGQgYSBtb2RlIGZvciB0
aGUgVHlwZUMgUEhZJ3MgZGlzY29ubmVjdGVkIHN0YXRlIikNCj4gQ2M6IDxzdGFibGVAdmdlci5r
ZXJuZWwub3JnPiAjIHY1LjE2Kw0KPiBDYzogSm9zw6kgUm9iZXJ0byBkZSBTb3V6YSA8am9zZS5z
b3V6YUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEltcmUgRGVhayA8aW1yZS5kZWFrQGlu
dGVsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2dwdS9kcm0vaTkxNS9kaXNwbGF5L2ludGVsX3Rj
LmMgfCAyOCArKysrKysrKysrKysrKysrKystLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjEg
aW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2dwdS9kcm0vaTkxNS9kaXNwbGF5L2ludGVsX3RjLmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9k
aXNwbGF5L2ludGVsX3RjLmMNCj4gaW5kZXggZmVlYWQwOGRkZjhmZi4uZmMwMzdjMDI3ZWE1YSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF90Yy5jDQo+
ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfdGMuYw0KPiBAQCAtNjkz
LDYgKzY5Myw4IEBAIHZvaWQgaW50ZWxfdGNfcG9ydF9zYW5pdGl6ZShzdHJ1Y3QgaW50ZWxfZGln
aXRhbF9wb3J0ICpkaWdfcG9ydCkNCj4gIHsNCj4gIAlzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAq
aTkxNSA9IHRvX2k5MTUoZGlnX3BvcnQtPmJhc2UuYmFzZS5kZXYpOw0KPiAgCXN0cnVjdCBpbnRl
bF9lbmNvZGVyICplbmNvZGVyID0gJmRpZ19wb3J0LT5iYXNlOw0KPiArCWludGVsX3dha2VyZWZf
dCB0Y19jb2xkX3dyZWY7DQo+ICsJZW51bSBpbnRlbF9kaXNwbGF5X3Bvd2VyX2RvbWFpbiBkb21h
aW47DQo+ICAJaW50IGFjdGl2ZV9saW5rcyA9IDA7DQo+ICANCj4gIAltdXRleF9sb2NrKCZkaWdf
cG9ydC0+dGNfbG9jayk7DQo+IEBAIC03MDQsMTIgKzcwNiwxMSBAQCB2b2lkIGludGVsX3RjX3Bv
cnRfc2FuaXRpemUoc3RydWN0IGludGVsX2RpZ2l0YWxfcG9ydCAqZGlnX3BvcnQpDQo+ICANCj4g
IAlkcm1fV0FSTl9PTigmaTkxNS0+ZHJtLCBkaWdfcG9ydC0+dGNfbW9kZSAhPSBUQ19QT1JUX0RJ
U0NPTk5FQ1RFRCk7DQo+ICAJZHJtX1dBUk5fT04oJmk5MTUtPmRybSwgZGlnX3BvcnQtPnRjX2xv
Y2tfd2FrZXJlZik7DQo+ICsNCj4gKwl0Y19jb2xkX3dyZWYgPSB0Y19jb2xkX2Jsb2NrKGRpZ19w
b3J0LCAmZG9tYWluKTsNCj4gKw0KPiArCWRpZ19wb3J0LT50Y19tb2RlID0gaW50ZWxfdGNfcG9y
dF9nZXRfY3VycmVudF9tb2RlKGRpZ19wb3J0KTsNCj4gIAlpZiAoYWN0aXZlX2xpbmtzKSB7DQo+
IC0JCWVudW0gaW50ZWxfZGlzcGxheV9wb3dlcl9kb21haW4gZG9tYWluOw0KPiAtCQlpbnRlbF93
YWtlcmVmX3QgdGNfY29sZF93cmVmID0gdGNfY29sZF9ibG9jayhkaWdfcG9ydCwgJmRvbWFpbik7
DQo+IC0NCj4gLQkJZGlnX3BvcnQtPnRjX21vZGUgPSBpbnRlbF90Y19wb3J0X2dldF9jdXJyZW50
X21vZGUoZGlnX3BvcnQpOw0KPiAtDQo+ICAJCWlmICghaWNsX3RjX3BoeV9pc19jb25uZWN0ZWQo
ZGlnX3BvcnQpKQ0KPiAgCQkJZHJtX2RiZ19rbXMoJmk5MTUtPmRybSwNCj4gIAkJCQkgICAgIlBv
cnQgJXM6IFBIWSBkaXNjb25uZWN0ZWQgd2l0aCAlZCBhY3RpdmUgbGluayhzKVxuIiwNCj4gQEAg
LTcxOCwxMCArNzE5LDIzIEBAIHZvaWQgaW50ZWxfdGNfcG9ydF9zYW5pdGl6ZShzdHJ1Y3QgaW50
ZWxfZGlnaXRhbF9wb3J0ICpkaWdfcG9ydCkNCj4gIA0KPiAgCQlkaWdfcG9ydC0+dGNfbG9ja193
YWtlcmVmID0gdGNfY29sZF9ibG9jayhkaWdfcG9ydCwNCj4gIAkJCQkJCQkgICZkaWdfcG9ydC0+
dGNfbG9ja19wb3dlcl9kb21haW4pOw0KPiAtDQo+IC0JCXRjX2NvbGRfdW5ibG9jayhkaWdfcG9y
dCwgZG9tYWluLCB0Y19jb2xkX3dyZWYpOw0KPiArCX0gZWxzZSB7DQo+ICsJCS8qDQo+ICsJCSAq
IFRCVC1hbHQgaXMgdGhlIGRlZmF1bHQgbW9kZSBpbiBhbnkgY2FzZSB0aGUgUEhZIG93bmVyc2hp
cCBpcyBub3QNCj4gKwkJICogaGVsZCAocmVnYXJkbGVzcyBvZiB0aGUgc2luaydzIGNvbm5lY3Rl
ZCBsaXZlIHN0YXRlKSwgc28NCj4gKwkJICogd2UnbGwganVzdCBzd2l0Y2ggdG8gZGlzY29ubmVj
dGVkIG1vZGUgZnJvbSBpdCBoZXJlIHdpdGhvdXQNCj4gKwkJICogYSBub3RlLg0KPiArCQkgKi8N
Cj4gKwkJaWYgKGRpZ19wb3J0LT50Y19tb2RlICE9IFRDX1BPUlRfVEJUX0FMVCkNCj4gKwkJCWRy
bV9kYmdfa21zKCZpOTE1LT5kcm0sDQo+ICsJCQkJICAgICJQb3J0ICVzOiBQSFkgbGVmdCBpbiAl
cyBtb2RlIG9uIGRpc2FibGVkIHBvcnQsIGRpc2Nvbm5lY3RpbmcgaXRcbiIsDQo+ICsJCQkJICAg
IGRpZ19wb3J0LT50Y19wb3J0X25hbWUsDQo+ICsJCQkJICAgIHRjX3BvcnRfbW9kZV9uYW1lKGRp
Z19wb3J0LT50Y19tb2RlKSk7DQo+ICsJCWljbF90Y19waHlfZGlzY29ubmVjdChkaWdfcG9ydCk7
DQo+ICAJfQ0KPiAgDQo+ICsJdGNfY29sZF91bmJsb2NrKGRpZ19wb3J0LCBkb21haW4sIHRjX2Nv
bGRfd3JlZik7DQo+ICsNCj4gIAlkcm1fZGJnX2ttcygmaTkxNS0+ZHJtLCAiUG9ydCAlczogc2Fu
aXRpemUgbW9kZSAoJXMpXG4iLA0KPiAgCQkgICAgZGlnX3BvcnQtPnRjX3BvcnRfbmFtZSwNCj4g
IAkJICAgIHRjX3BvcnRfbW9kZV9uYW1lKGRpZ19wb3J0LT50Y19tb2RlKSk7DQoNCg==
