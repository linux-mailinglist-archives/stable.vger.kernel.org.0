Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397A2B0BC6
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 11:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbfILJoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 05:44:15 -0400
Received: from mail-eopbgr30094.outbound.protection.outlook.com ([40.107.3.94]:55461
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730835AbfILJoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 05:44:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aA+OG/XIFSl08Ww+otKdIwdNuFia0oP2YR/0w/IwyAvfywmyeVqhR0HQXFoba43Q28lzdfOsoIeDKj00LgkcuoDiFRzADlfTppLBcEdCbPEgaHkjAT2rk5B74HncA4Q9N7onG9hHL5rtYavd+KD8Xt3pSJvp85uocGmcNsLQ76FhYvweiNIr24RqZP4nnhkU6AfqIRFvYGYrcXP7jVbALJRgzuS3e6Gb0NULTx43uqKStOO0+ZNlR4ChFwhWpbJ9Qheh9gu8H8pX+jvKhELkfDOULh4gmXXaxlmFLjXYcCG3gcdtJS+D35vO8R0ete7ZmZLIix0YHEyjRu4vY29yPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UE+HEtwhHIsezNX6gn/hDBiF4Y2+YR4kyHGqo5ONTkE=;
 b=GLO8B1WXENoW4VtFOzGxd3kI0QyJ6fqSPrTU5d8x0uBTng9IrpmWsl8wy4/hw+idgRZkDA1oTi176khdEre4N0ANbEsFj79bWOW1a12RQzTLiucEbAO+g4nsFv1LGQFd/qCtOl8wpmmuG0HCd/vEP9JSgCVW1N3qNUCMWkBFDG3IICNmaNnlNAP582Hvcii0ipvdFo4MXfk0WReP5WfJ/h3wW2p1aUgEK1EK0v9RwVNQ3X8ptdhcuYGpzpWb50g4m/hoCVpP2GqCil5zuOcLcMX4polCLvMNquhw8+ARLbC1G2TF4KSWP0ZoVaHD/857P8xi/7ascSIGmU6UY8QHUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UE+HEtwhHIsezNX6gn/hDBiF4Y2+YR4kyHGqo5ONTkE=;
 b=GRWPuOpPdWlrKV37hZzW+Qn5YIeCR2PwUBtB4JsE4Nm5NVXXKTe+xztxnu/A0AM2Nu7ONrdyHF1TcW5wEkEzUmK01BxKkJqXsMUBlls0C3aYuKsAkHg84ACGP1ciua/5YDHnuwazQZk+oyTpi2OUHg8oMYo0ya+OQTkiy++Hw3Y=
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com (52.133.24.149) by
 AM6PR0702MB3573.eurprd07.prod.outlook.com (52.133.19.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.10; Thu, 12 Sep 2019 09:44:10 +0000
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56]) by AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56%3]) with mapi id 15.20.2263.016; Thu, 12 Sep 2019
 09:44:10 +0000
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
Subject: [PATCH 3/3] genirq/irqdomain: Detect type race in
 irq_create_fwspec_mapping()
Thread-Topic: [PATCH 3/3] genirq/irqdomain: Detect type race in
 irq_create_fwspec_mapping()
Thread-Index: AQHVaU6gc4wd5DvxjEeG+LE441tLCA==
Date:   Thu, 12 Sep 2019 09:44:10 +0000
Message-ID: <20190912094343.5480-4-alexander.sverdlin@nokia.com>
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
x-ms-office365-filtering-correlation-id: 9fc3c94c-aa8d-41e5-aac3-08d73765c351
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0702MB3573;
x-ms-traffictypediagnostic: AM6PR0702MB3573:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0702MB3573DF4BC54ACCA2F252C76288B00@AM6PR0702MB3573.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(102836004)(2501003)(76176011)(71190400001)(66066001)(3846002)(50226002)(2616005)(6512007)(446003)(7736002)(66446008)(486006)(476003)(6486002)(6436002)(186003)(1076003)(305945005)(71200400001)(11346002)(14454004)(64756008)(86362001)(8676002)(66476007)(66946007)(99286004)(8936002)(6116002)(53936002)(52116002)(110136005)(36756003)(25786009)(386003)(54906003)(26005)(81156014)(66556008)(2906002)(14444005)(6506007)(256004)(478600001)(4326008)(81166006)(316002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR0702MB3573;H:AM6PR0702MB3527.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GzVQaQ9xnxDF9MXlJ6Tgif4JC+W4tdDSlTcdquXyv4ZIGF/AD60wLEL1Rsb7SoEGf9cqtvt6qI842nigWRl5KNzKGLLUiAj8l6/PjmgJ/VruPgyhWMQyrHcW4uX0i9vCPIARyCQo9W+gDh6UsbmbGu3xkIBmzOCY8sR2WYpDgFzy9LPHaIWH6d+CbQCeTclgs2PqqdIynPy706pXEsg5wqz7MHXlRdAhdQR4hsV80KcZKpNnyoPXZKQhQDJx+1EL5BzGwGk8VTuhYxfeRCNKWgGRFB0tfDPKV9XPIvPMXb28KI0CdOOFuJaLLNWN5iXo9O3GxUiXJ7cuZAAIYHAvRawy98iSPKFngtMJkcuqGrpfKY2nSI5oFgRm1HseV46tEqUh8U1N8vGQWHoJqghjMGevwLYJ3B/aUum1AP1tMtg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc3c94c-aa8d-41e5-aac3-08d73765c351
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 09:44:10.5987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z8zs8wMgHUORkafQt+GETME1BicfxLtjbWyI1gV/IgAkRwQzqbtlLVUcaQIlZsgFhxAC9Ja8XZ1qSsM+o3KChJWlsbm2XM1fEmrs1ZwnkIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3573
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

irq_create_fwspec_mapping() can race with itself during IRQ trigger type
configuration. Possible scenarios include:

- Mapping exists, two irq_create_fwspec_mapping() running in parallel do
  not detect type mismatch, IRQ remains configured with one of the
  different trigger types randomly
- Second call to irq_create_fwspec_mapping() sees existing mapping just
  created by first call, but earlier irqd_set_trigger_type() call races
  with later irqd_set_trigger_type() =3D> totally undetected, IRQ type
  is being set randomly to either one or another type

Introduce helper function to detect parallel changes to IRQ type.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 kernel/irq/irqdomain.c | 66 +++++++++++++++++++++++++++++-----------------=
----
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 176f2cc..af4d30c 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -764,10 +764,45 @@ static void of_phandle_args_to_fwspec(struct device_n=
ode *np, const u32 *args,
 		fwspec->param[i] =3D args[i];
 }
=20
+/* Detect races during IRQ type setting */
+static int irq_set_trigger_type_locked(unsigned int virq, unsigned int typ=
e,
+				       irq_hw_number_t hwirq,
+				       const struct irq_fwspec *fwspec)
+{
+	struct irq_data *irq_data;
+	int ret =3D 0;
+
+	mutex_lock(&irq_domain_mutex);
+	/*
+	 * If the trigger type is not specified or matches the current trigger
+	 * type then we are done.
+	 */
+	if (type =3D=3D IRQ_TYPE_NONE || type =3D=3D irq_get_trigger_type(virq))
+		goto unlock;
+
+	/* If the trigger type has not been set yet, then set it now */
+	if (irq_get_trigger_type(virq) !=3D IRQ_TYPE_NONE) {
+		pr_warn("type mismatch, failed to map hwirq-%lu for %s!\n",
+			hwirq, of_node_full_name(to_of_node(fwspec->fwnode)));
+		ret =3D -EINVAL;
+		goto unlock;
+	}
+
+	irq_data =3D irq_get_irq_data(virq);
+	if (!irq_data) {
+		ret =3D -ENOENT;
+		goto unlock;
+	}
+	irqd_set_trigger_type(irq_data, type);
+
+unlock:
+	mutex_unlock(&irq_domain_mutex);
+	return ret;
+}
+
 unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 {
 	struct irq_domain *domain;
-	struct irq_data *irq_data;
 	irq_hw_number_t hwirq;
 	unsigned int type =3D IRQ_TYPE_NONE;
 	int virq;
@@ -802,29 +837,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwsp=
ec *fwspec)
 	 */
 	virq =3D irq_find_mapping(domain, hwirq);
 	if (virq) {
-		/*
-		 * If the trigger type is not specified or matches the
-		 * current trigger type then we are done so return the
-		 * interrupt number.
-		 */
-		if (type =3D=3D IRQ_TYPE_NONE || type =3D=3D irq_get_trigger_type(virq))
-			return virq;
-
-		/*
-		 * If the trigger type has not been set yet, then set
-		 * it now and return the interrupt number.
-		 */
-		if (irq_get_trigger_type(virq) =3D=3D IRQ_TYPE_NONE) {
-			irq_data =3D irq_get_irq_data(virq);
-			if (!irq_data)
-				return 0;
-
-			irqd_set_trigger_type(irq_data, type);
+		if (!irq_set_trigger_type_locked(virq, type, hwirq, fwspec))
 			return virq;
-		}
-
-		pr_warn("type mismatch, failed to map hwirq-%lu for %s!\n",
-			hwirq, of_node_full_name(to_of_node(fwspec->fwnode)));
 		return 0;
 	}
=20
@@ -839,8 +853,7 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspe=
c *fwspec)
 			return virq;
 	}
=20
-	irq_data =3D irq_get_irq_data(virq);
-	if (!irq_data) {
+	if (irq_set_trigger_type_locked(virq, type, hwirq, fwspec)) {
 		if (irq_domain_is_hierarchy(domain))
 			irq_domain_free_irqs(virq, 1);
 		else
@@ -848,9 +861,6 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspe=
c *fwspec)
 		return 0;
 	}
=20
-	/* Store trigger type */
-	irqd_set_trigger_type(irq_data, type);
-
 	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_fwspec_mapping);
--=20
2.4.6

