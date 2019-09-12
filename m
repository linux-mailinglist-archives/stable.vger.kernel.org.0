Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C78B0BC7
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 11:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfILJoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 05:44:15 -0400
Received: from mail-eopbgr70097.outbound.protection.outlook.com ([40.107.7.97]:50646
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730337AbfILJoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 05:44:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMJGzONiLJVVPa4j42Mk24F81FUsi6E2wVpxBBaPJat2UxA/BZdRd6Tf4gt5p3uTbPawnpSNjhQW7TQV2UwE5E8hPJKfsN4Smuj16/+vsa4ndHgq0aZzT8LNmK87ed2aEzzmItZI2KzoTtVgcm6/69ySOAK4XZZfQDtPNovZXDrMVvTcWMkQ2KatabRAz+vI/b2OAQm9agoxa38NysbfCYo2QgITZp5b2IKKkVtwHKTac4k3D6qjSeY7QYpcoPpp7GtOeu1MgO3nyH6qTpf3QfrWxGyTTx6daowlmhwRyDQ81uKQ+frAMZ5V1GID9hRmMMmUMcc03N+s7jvIbnmL4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvbLBdOgNc8GMuVGYUoRzlna0XbW4372XgJXA2IX4YI=;
 b=R472CLklf5pkcv6ynV52xZeiXW+2bWejrynWVy8JqOsPJ0CKSDnxMdBwz3hzs3qXVhbRNQH9d60ZWAiUfMwS50WBrB1f6ZcAsEwQUaEdW2w2GQ2NzgUoqcBAxZmI71ZiphfONYgWiJblCJvI1j2IoHNgQNT9W+ckBCfkSnWlFAPZ3/+rDku7Es3HRy2MARBbJO2KbkSCQprop2d/EFFA8YTJj+EOUp99+mucNr5MUFHccSleGRtYepZMOMaaWYoEvyXOamFMnQm5MoGPz9ENgiT4yPoPQEnHY5u/QUE2d+0jq3WEGBmUsgBXXcm3RvqkKzJvG0XuAiq8hPwh5sfU6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvbLBdOgNc8GMuVGYUoRzlna0XbW4372XgJXA2IX4YI=;
 b=BMPyCoWgWREzbjGkKRnjmBQeV0BZafosl5QnWk6bd5qjcVYlLfSAkPhegnzkcb/hflK7rcp+6mGLFXMfLyxdTYHLnT9wGThMtMLSqTzV4D0FtIlclabN/xE8q19ImKwDr/QGMrdW6khiZVVMe1gmn1+gCZhPxgsMdlMTlGOa1vw=
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com (52.133.24.149) by
 AM6PR0702MB3654.eurprd07.prod.outlook.com (52.133.21.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.7; Thu, 12 Sep 2019 09:44:09 +0000
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56]) by AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56%3]) with mapi id 15.20.2263.016; Thu, 12 Sep 2019
 09:44:09 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Glavinic-Pecotic, Matija (EXT - DE/Ulm)" 
        <matija.glavinic-pecotic.ext@nokia.com>,
        "Adamski, Krzysztof (Nokia - PL/Wroclaw)" 
        <krzysztof.adamski@nokia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 2/3] genirq/irqdomain: Re-check mapping after associate in
 irq_create_mapping()
Thread-Topic: [PATCH 2/3] genirq/irqdomain: Re-check mapping after associate
 in irq_create_mapping()
Thread-Index: AQHVaU6gP0yvNptpJkyGgiCIhPQf3Q==
Date:   Thu, 12 Sep 2019 09:44:09 +0000
Message-ID: <20190912094343.5480-3-alexander.sverdlin@nokia.com>
References: <20190912094343.5480-1-alexander.sverdlin@nokia.com>
In-Reply-To: <20190912094343.5480-1-alexander.sverdlin@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.2.21]
x-mailer: git-send-email 2.23.0
x-clientproxiedby: HE1PR05CA0342.eurprd05.prod.outlook.com
 (2603:10a6:7:92::37) To AM6PR0702MB3527.eurprd07.prod.outlook.com
 (2603:10a6:209:11::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19c49bd0-81fa-4b10-c36b-08d73765c263
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0702MB3654;
x-ms-traffictypediagnostic: AM6PR0702MB3654:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0702MB36548532F349C31ADF9F2F7188B00@AM6PR0702MB3654.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(199004)(189003)(64756008)(2501003)(6116002)(110136005)(5660300002)(53936002)(486006)(66066001)(386003)(6506007)(86362001)(6512007)(102836004)(186003)(26005)(316002)(76176011)(446003)(8676002)(11346002)(476003)(81156014)(2616005)(81166006)(6436002)(50226002)(3846002)(256004)(6486002)(54906003)(1076003)(71190400001)(25786009)(66946007)(8936002)(2906002)(66556008)(66446008)(99286004)(4326008)(14454004)(36756003)(52116002)(71200400001)(305945005)(66476007)(478600001)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR0702MB3654;H:AM6PR0702MB3527.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5UyjhXl39IYXK2gLNWvKDhH6k3XRoEJL9K/215PruU3oDmtyJIvKJvWq6iANly+HPkwMGzKaUAIhBNlbnxYqQLPH7fVCKQ6TkRPcAkZfBekAmST3U5NlPL8/puUvVhkBvGMYpIfs2/sczEBPLna8E0R+7x/4GaJA0gvhE+m3tw2nUSH23ElEe+IwTFY3rwM9xZeEVPEUH1uE2UoRhGzN5rfNHVNcr5lO6BahWBNC/gnF8l3aDjPTbMgKio0B0Tiru8ZOUnLJkurp78J6Iugwg6oHFXzDfdp9I+xpV2aK2nPnp4hXU09oj7y3CZQ1XD+UbGjuTgn6w1p5jWVyyWUpfQcd0MdHWxAJTSr3vWQqx4ztWxC/iuViEHaQlTXGx7LmhJweUBCV4tb1YEg3ZADYK3t9k+6ahVXizsru5ZiW0po=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c49bd0-81fa-4b10-c36b-08d73765c263
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 09:44:09.0915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j73d0bVVTV4gu/Z8XI7+uQKO7quo8lLqEl3WTnLdAws5jd8welKjO0LamBRbOcf+XpgxrZZTIOdaNNoZ0z2Jti/3+o70AMCpDnG8Y415gGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3654
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

If two irq_create_mapping() calls perform a mapping of the same hwirq on
two CPU cores in parallel they both will get 0 from irq_find_mapping(),
both will allocate unique virq using irq_domain_alloc_descs() and both
will finally irq_domain_associate() it. Giving different virq numbers
to their callers.

In practice the first caller is usually an interrupt controller driver and
the seconds is some device requesting the interrupt providede by the above
interrupt controller.

In this case either the interrupt controller driver configures virq which
is not the one being "associated" with hwirq, or the "slave" device
requests the virq which is never being triggered.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 kernel/irq/irqdomain.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7bc07b6..176f2cc 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -675,13 +675,6 @@ unsigned int irq_create_mapping(struct irq_domain *dom=
ain,
=20
 	of_node =3D irq_domain_get_of_node(domain);
=20
-	/* Check if mapping already exists */
-	virq =3D irq_find_mapping(domain, hwirq);
-	if (virq) {
-		pr_debug("-> existing mapping on virq %d\n", virq);
-		return virq;
-	}
-
 	/* Allocate a virtual interrupt number */
 	virq =3D irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node), NU=
LL);
 	if (virq <=3D 0) {
@@ -691,7 +684,11 @@ unsigned int irq_create_mapping(struct irq_domain *dom=
ain,
=20
 	if (irq_domain_associate(domain, virq, hwirq)) {
 		irq_free_desc(virq);
-		return 0;
+
+		virq =3D irq_find_mapping(domain, hwirq);
+		if (virq)
+			pr_debug("-> existing mapping on virq %d\n", virq);
+		return virq;
 	}
=20
 	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
--=20
2.4.6

