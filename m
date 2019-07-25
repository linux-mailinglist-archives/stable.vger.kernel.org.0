Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5750D750E2
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 16:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387868AbfGYOWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 10:22:49 -0400
Received: from mail-eopbgr70124.outbound.protection.outlook.com ([40.107.7.124]:39749
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387415AbfGYOWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 10:22:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGzmR9UDE9zW3PJI3vITAJ2D1VDjWeqhGsfXqDrdpqRqHcH9TYePqVfqEKm0q5NZu11L0l/koEY1u6L9JTp++KT5XEAlSGKiCRlXbFVEJ/wwJLcpfyz4JCD6U0oG0bnwduCi0qeX/khZjDgBaO3GLIzDMxV5+ZgR/GQ0n+I2N9lBu9qXeoYpw2ntJp0BJKDWNaWcFrQeS7/c7rUAQh8dhA6W6lWZdSBkymDehue7AAXXWEVwYZHLgY8esLYmmDCjlUPzfEM2LT7p6I3gYIRKFRepGRefmki3OBPrBnEIkOVqUNWo5hbUrwqqgkvX3of2Wh6EtufN1ztQI0DZ00GWhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4Iw2M+lq+Jnt9yiST4848/eAN3EJBkNyMCChWJKdjs=;
 b=XSgTV7p+Mvo4lN3osueLrIyx2XDJWhZyHKAZeq3ODCNDr9LkHr4pXMxk5XGtf4b2dziHt1mY/6fXMgQi7mx6PBsUxGA6RnxcI4sM1b1h7W1CW6R6zXLrbbkrCEbyAyqDyXhu9aXJGZHMHvedKJmqn0iTw0L9yikOOwxFTWu+4AHJpe/7vkr9lHwpprdULTW2Ji/v63EVlpvCcNnxNCBdGTQFRB2cobHR9hFAtP8nZBy5nQV0s12LuejMH9QNZ1sojsNwdb1fGlxXDpdC+LWZVUvs49E7BeaydL0Zc/nZyWYMjJNO2zdnzg8t5VyC2lE9VnEm/o0b9stkGUtZgr3Xww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nokia.com;dmarc=pass action=none
 header.from=nokia.com;dkim=pass header.d=nokia.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4Iw2M+lq+Jnt9yiST4848/eAN3EJBkNyMCChWJKdjs=;
 b=k4Mhjft6GIEt7aah+MXuuZBoaWe6GMq2sX8cg7GVvFe24hMssGx9Uukji5FImwXYlbHbPyM7/O9N03vFNwHWvzGN5QGQgiIf1ZQfQi1HYEMWwYX7ANgCmmP/R9g0gJHYyt7P1PS1xpQdbdVKX9JFVuOoyyeJ78HRyMHkV25x6Jg=
Received: from AM6PR07MB5464.eurprd07.prod.outlook.com (20.178.88.217) by
 AM6PR07MB5397.eurprd07.prod.outlook.com (20.178.88.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Thu, 25 Jul 2019 14:22:45 +0000
Received: from AM6PR07MB5464.eurprd07.prod.outlook.com
 ([fe80::406f:957:9c7a:123d]) by AM6PR07MB5464.eurprd07.prod.outlook.com
 ([fe80::406f:957:9c7a:123d%6]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 14:22:45 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
CC:     "qat-linux@intel.com" <qat-linux@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Silence smp_processor_id() warning
Thread-Topic: [PATCH] crypto: qat - Silence smp_processor_id() warning
Thread-Index: AQHVQSeZEH10CvozN0KsW1z2XZZxpqbbVuWAgAAPoAA=
Date:   Thu, 25 Jul 2019 14:22:45 +0000
Message-ID: <3aab38c9-d9a3-a4f0-74e9-4ac202f782ef@nokia.com>
References: <20190723072347.16247-1-alexander.sverdlin@nokia.com>
 <20190725132645.GA16573@sivswdev08.ir.intel.com>
In-Reply-To: <20190725132645.GA16573@sivswdev08.ir.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.166]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
x-clientproxiedby: HE1PR05CA0254.eurprd05.prod.outlook.com
 (2603:10a6:3:fb::30) To AM6PR07MB5464.eurprd07.prod.outlook.com
 (2603:10a6:20b:84::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2955a084-02c7-4709-533d-08d7110b8fb1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR07MB5397;
x-ms-traffictypediagnostic: AM6PR07MB5397:
x-microsoft-antispam-prvs: <AM6PR07MB5397DE1139A0EC209A0176BA88C10@AM6PR07MB5397.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(189003)(199004)(64126003)(25786009)(6512007)(316002)(2906002)(36756003)(6246003)(53936002)(52116002)(71190400001)(71200400001)(229853002)(4326008)(6486002)(31686004)(66946007)(66476007)(66556008)(64756008)(66446008)(81156014)(81166006)(6916009)(305945005)(76176011)(8676002)(65806001)(66066001)(65956001)(386003)(7736002)(31696002)(102836004)(53546011)(8936002)(3846002)(99286004)(6116002)(86362001)(6506007)(14444005)(478600001)(68736007)(2616005)(54906003)(476003)(486006)(65826007)(446003)(11346002)(58126008)(5660300002)(14454004)(6436002)(4744005)(186003)(26005)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR07MB5397;H:AM6PR07MB5464.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZkItfrDkuXCl4T/jCnQl/cnVzmHogTcpnsAbXUKoLUF/6RzmD1cIE4PA73baz5nuacawD0qB6C0rOdwSnG/CVD2FSOdbb6VFUKjy+hK6Nr/Q+DN+OgJPgeT4/8MdgqXaa2sLZ5n/fzJfmjN6PA6YvOPJkmJwwbfNqVhzQmDyPReMzOt6KJlS805ong78EHiLh8owcnOWVzu8Hp9G4UXnbx0NSxu79Q0O5pAu8mhZqlGUkpEXQz8YP83vUi6Hfxhh8mHwoHMjhBuyjfg1PJwBrtCs7+5LjMxTVK2U0OmoHWenzXn5f/rhmkqbuUWRpZPICFMelw1FptHweZH9jUBt0giZW3KxksAltBC/w0wg+3pVmQeK0rjcv+0fMCHuz1Y8gnx0hgYBsO6Zh/P4Xk40aP9GkSazpdkSjeA+ke7ZqsA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EB059C2511F0B48AAD00A8249BEE0D3@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2955a084-02c7-4709-533d-08d7110b8fb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 14:22:45.1119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: alexander.sverdlin@nokia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB5397
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkhDQoNCk9uIDI1LzA3LzIwMTkgMTU6MjYsIEdpb3Zhbm5pIENhYmlkZHUgd3JvdGU6DQo+PiBJ
dCBzZWVtcyB0aGF0IHNtcF9wcm9jZXNzb3JfaWQoKSBpcyBvbmx5IHVzZWQgZm9yIGEgYmVzdC1l
ZmZvcnQNCj4+IGxvYWQtYmFsYW5jaW5nLCByZWZlciB0byBxYXRfY3J5cHRvX2dldF9pbnN0YW5j
ZV9ub2RlKCkuIEl0J3Mgbm90IGZlYXNpYmxlDQo+PiB0byBkaXNhYmxlIHByZWVtcHRpb24gZm9y
IHRoZSBkdXJhdGlvbiBvZiB0aGUgY3J5cHRvIHJlcXVlc3RzLiBUaGVyZWZvcmUsDQo+PiBqdXN0
IHNpbGVuY2UgdGhlIHdhcm5pbmcuIFRoaXMgY29tbWl0IGlzIHNpbWlsYXIgdG8gZTdhOWIwNWNh
NA0KPj4gKCJjcnlwdG86IGNhdml1bSAtIEZpeCBzbXBfcHJvY2Vzc29yX2lkKCkgd2FybmluZ3Mi
KS4NCj4+DQo+PiBTaWxlbmNlcyB0aGUgZm9sbG93aW5nIHNwbGF0Og0KPj4gQlVHOiB1c2luZyBz
bXBfcHJvY2Vzc29yX2lkKCkgaW4gcHJlZW1wdGlibGUgWzAwMDAwMDAwXSBjb2RlOiBjcnlwdG9t
Z3JfdGVzdC8yOTA0DQo+PiBjYWxsZXIgaXMgcWF0X2FsZ19hYmxrY2lwaGVyX3NldGtleSsweDMw
MC8weDRhMCBbaW50ZWxfcWF0XQ0KPj4gQ1BVOiAxIFBJRDogMjkwNCBDb21tOiBjcnlwdG9tZ3Jf
dGVzdCBUYWludGVkOiBQICAgICAgICAgICBPICAgIDQuMTQuNjkgIzENCj4gSG93IGRpZCB5b3Ug
cmVwcm9kdWNlIHRoaXMgcHJvYmxlbT8NCg0KSXNuJ3QganVzdCBDT05GSUdfREVCVUdfQVRPTUlD
X1NMRUVQIGVub3VnaCBpbiB5b3VyIHNldHVwPw0KDQotLSANCkJlc3QgcmVnYXJkcywNCkFsZXhh
bmRlciBTdmVyZGxpbi4NCg==
