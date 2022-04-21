Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6132950A593
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 18:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiDUQcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 12:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiDUQbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 12:31:35 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E90949FA4
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650558370; x=1682094370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+LVmmSgIRkiUYRJbFcorSakSQhRGZaMbYvqpQv1dbmk=;
  b=EvlcOoBIYN43QMACc1qdYWjPbAKlCIjB4IDv6ItDlh6NIFr+fVS2BXQ7
   RMBkiZKDiPF4VAjB3+NsECazGt7EyLsrrxSl4SGddR38u/cicnSjk114T
   Pd4OF/t6DVRjfUCDAmkFR3hDfHEX0dpCZGN2nndDgjB0dvRWgoQuvPnu8
   HnyP2y2v9Oc8qcvr3yBOghyYGJxan5t9zMPfcwQoiqUMTrYbhGm4PSEBj
   8wqlkT1yB8348lCF6e3IYzJgwY88NOzo3lAkCNTdQZs7NxdztPqgM22y1
   2Z9WrixFHReMaaH5oB6vQl8A5sr8Y1wP5n/XSo1KNMafvvIAChVQCsUQY
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="263874131"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="263874131"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 09:26:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="533417818"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 21 Apr 2022 09:26:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 09:26:07 -0700
Received: from fmsmsx611.amr.corp.intel.com ([10.18.126.91]) by
 fmsmsx611.amr.corp.intel.com ([10.18.126.91]) with mapi id 15.01.2308.027;
 Thu, 21 Apr 2022 09:26:07 -0700
From:   "Souza, Jose" <jose.souza@intel.com>
To:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Deak, Imre" <imre.deak@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/i915: Fix SEL_FETCH_PLANE_*(PIPE_B+) register
 addresses
Thread-Topic: [PATCH] drm/i915: Fix SEL_FETCH_PLANE_*(PIPE_B+) register
 addresses
Thread-Index: AQHYVZv9nqiS+L3RjkashARhnQ1hX6z7A58A
Date:   Thu, 21 Apr 2022 16:26:07 +0000
Message-ID: <dfe47e5aae29f2895baa9d319a7e5d7f6345c4fd.camel@intel.com>
References: <20220421162221.2261895-1-imre.deak@intel.com>
In-Reply-To: <20220421162221.2261895-1-imre.deak@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-ID: <757C572EC7848B489D3061DF1A349698@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIyLTA0LTIxIGF0IDE5OjIyICswMzAwLCBJbXJlIERlYWsgd3JvdGU6DQo+IEZp
eCB0eXBvIGluIHRoZSBfU0VMX0ZFVENIX1BMQU5FX0JBU0VfMV9CIHJlZ2lzdGVyIGJhc2UgYWRk
cmVzcy4NCj4gDQoNClJldmlld2VkLWJ5OiBKb3PDqSBSb2JlcnRvIGRlIFNvdXphIDxqb3NlLnNv
dXphQGludGVsLmNvbT4NCg0KPiBGaXhlczogYTU1MjNlMmZmMDc0YTUgKCJkcm0vaTkxNTogQWRk
IFBTUjIgc2VsZWN0aXZlIGZldGNoIHJlZ2lzdGVycyIpDQo+IFJlZmVyZW5jZXM6IGh0dHBzOi8v
Z2l0bGFiLmZyZWVkZXNrdG9wLm9yZy9kcm0vaW50ZWwvLS9pc3N1ZXMvNTQwMA0KPiBDYzogSm9z
w6kgUm9iZXJ0byBkZSBTb3V6YSA8am9zZS5zb3V6YUBpbnRlbC5jb20+DQo+IENjOiA8c3RhYmxl
QHZnZXIua2VybmVsLm9yZz4gIyB2NS45Kw0KPiBTaWduZWQtb2ZmLWJ5OiBJbXJlIERlYWsgPGlt
cmUuZGVha0BpbnRlbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9y
ZWcuaCB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfcmVnLmgg
Yi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X3JlZy5oDQo+IGluZGV4IDA0ZDg2Y2I2MjI0ZmMu
LjBjYTY1MTdiNDU5NWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVf
cmVnLmgNCj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9yZWcuaA0KPiBAQCAtNTE3
Miw3ICs1MTcyLDcgQEANCj4gICNkZWZpbmUgX1NFTF9GRVRDSF9QTEFORV9CQVNFXzZfQQkJMHg3
MDk0MA0KPiAgI2RlZmluZSBfU0VMX0ZFVENIX1BMQU5FX0JBU0VfN19BCQkweDcwOTYwDQo+ICAj
ZGVmaW5lIF9TRUxfRkVUQ0hfUExBTkVfQkFTRV9DVVJfQQkJMHg3MDg4MA0KPiAtI2RlZmluZSBf
U0VMX0ZFVENIX1BMQU5FX0JBU0VfMV9CCQkweDcwOTkwDQo+ICsjZGVmaW5lIF9TRUxfRkVUQ0hf
UExBTkVfQkFTRV8xX0IJCTB4NzE4OTANCj4gIA0KPiAgI2RlZmluZSBfU0VMX0ZFVENIX1BMQU5F
X0JBU0VfQShwbGFuZSkgX1BJQ0socGxhbmUsIFwNCj4gIAkJCQkJICAgICBfU0VMX0ZFVENIX1BM
QU5FX0JBU0VfMV9BLCBcDQoNCg==
