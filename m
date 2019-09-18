Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13297B6F8B
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 01:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbfIRXIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 19:08:05 -0400
Received: from mail-eopbgr710046.outbound.protection.outlook.com ([40.107.71.46]:7616
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729042AbfIRXIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 19:08:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JISRIuPhuE8qURO1b6zjUPBJYiCjK84jKjSbE/ln+IPJCQFBY5s6xg+qBRlC6bmDz4ePKnWvmW1/+5wMod1pe6kFOkujodVPBfWREkMyBpB3nihKQVKcpy5LlGoVHMLJ5TPXob6j3ei65y9m1y08HyeVq2T4Tyq7pbCb2ZQAhkoEis0T/hM/3DDN8XtjQ4VWO6k/pb3XHsFOoz/Rmhb5zTReLxdWhVy/7TVgRE2VZ9M2kvnUXin4SgUCe+OiZeZXIEyrbDCvVKeAiw5B1e1cMfiPb0p2I1iYShQXZ2efBjMgBEiWMIJIwl2ZP8tf4HIETKze+eAEYP5xJ5lRrjhxGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx4w8qG2ZujoD++Iq3/ZM/wYQDOPdfZ/G8SjY//tKo0=;
 b=CFdofeTO+PI6LFg5lHnX7AT5oZAra5BgXaZ5YyTSUu9JpBpOZwQeLDLDdMFM4HJ6B7IpTnAmOSERamqOIo0m4TR11Tu+By7zErPWQoCFmxU4SNidUhx8kBfj/Zq3BbXNPEfXsVUJ9P3fJ2o8U1R+hcXzSqKwVacm7tneAZlRR+oYRj2qjOtsiy+e5NzPoY4zuafDyz0izg4IFn0BeC85KspXzUIAQxQgSFbp3RmvnahtUG1cx7IobgZLUGpw5p+BybGkXF2GiknveiDRYDEqJzssj/Csu0YEz7Kzh8kFieKr2wLmJRLPaj/MqEwXGQodpUuqBA7wfjgp58b/0zP34g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx4w8qG2ZujoD++Iq3/ZM/wYQDOPdfZ/G8SjY//tKo0=;
 b=yUObQoZYRGJTwTcLq88vF3xUWdkhttyrU7LuDw2RRvUR8OfyunpF9++oi6JiYTry1yJCcscTfKk1V3zXYWvjy9AVoC0VaHYu4fR9tyncGKgFPmve3uOkUujyFArQNTlwFUvm7Ldy7j00zhIs00L5JY/eCNDi+P1sEvPVxQRwtJY=
Received: from BYAPR05MB5511.namprd05.prod.outlook.com (20.177.186.28) by
 BYAPR05MB6150.namprd05.prod.outlook.com (20.178.55.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Wed, 18 Sep 2019 23:08:02 +0000
Received: from BYAPR05MB5511.namprd05.prod.outlook.com
 ([fe80::81ed:73c3:bc95:7d03]) by BYAPR05MB5511.namprd05.prod.outlook.com
 ([fe80::81ed:73c3:bc95:7d03%5]) with mapi id 15.20.2284.009; Wed, 18 Sep 2019
 23:08:02 +0000
From:   Adit Ranadive <aditr@vmware.com>
To:     "jgg@mellanox.com" <jgg@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Adit Ranadive <aditr@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] RDMA/vmw_pvrdma: Free SRQ only once
Thread-Topic: [PATCH] RDMA/vmw_pvrdma: Free SRQ only once
Thread-Index: AQHVbnXq/ZdDcwSMJkWe4MH4kt57+w==
Date:   Wed, 18 Sep 2019 23:08:00 +0000
Message-ID: <1568848066-12449-1-git-send-email-aditr@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::37) To BYAPR05MB5511.namprd05.prod.outlook.com
 (2603:10b6:a03:1a::28)
x-mailer: git-send-email 1.8.3.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=aditr@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.170.99.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d0e9990-d854-4aca-4052-08d73c8d0cb7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR05MB6150;
x-ms-traffictypediagnostic: BYAPR05MB6150:|BYAPR05MB6150:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB615055497EB5EB5EAD9DA84DC58E0@BYAPR05MB6150.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(199004)(189003)(2201001)(50226002)(2906002)(52116002)(66446008)(66556008)(14454004)(6436002)(6506007)(6512007)(386003)(102836004)(4744005)(71190400001)(26005)(256004)(2501003)(6486002)(7736002)(71200400001)(86362001)(5660300002)(186003)(99286004)(305945005)(66476007)(8936002)(4326008)(486006)(64756008)(81156014)(66946007)(36756003)(3846002)(4720700003)(8676002)(478600001)(25786009)(2616005)(6116002)(316002)(110136005)(66066001)(54906003)(81166006)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB6150;H:BYAPR05MB5511.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sb/5QEC++4f9OkhEoLFwA0oMFxHVN/0ymtwXIB6lR4quY5UmCKS1L/iO4bH6zgULYFWzPuTnuvW1ur6JO1+CsdGEO1Sg5PCupiNTmSBD/8VLhJFNzxzZzYsqOIqiABzvNQUFMD+M3RgIOjlcWrerPwQY2IhWNuezVCZsSv+dTJKAz5/n4bJ39b1DfXLlpihfKQ7WBrf7vJDaJmeN23atGKM1vzZSnCwyEvx1+oD8waa21B+bJK0LHmuEYBTY3fNmTWWDhXoj+NQyse9gST4+IJTFmkMJIjUXszEy2TqMJVcILmqO2g8AbkxeHlQiGfu3/gzC/1JECq6y2XQJlrLdmdOxzefftj/GECbK61Ekmc0SjNgCK9oyXQzK+pPv2SfYD06ALX24UdITSXei5Y+uRDjfET+iklSv9kG/u7g++JU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d0e9990-d854-4aca-4052-08d73c8d0cb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2019 23:08:01.9553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iH0uSqvdbNznuonHbBj0O8vGKHQIMbu2/GyUGQbxC583DMmZiiY0oXgGxehJNtpB3wWvynLS5fq4go/EOP6XZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6150
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An extra kfree cleanup was missed since these are now deallocated
by core.

Cc: <stable@vger.kernel.org>
Fixes: 68e326dea1db ("RDMA: Handle SRQ allocations by IB/core")
Signed-off-by: Adit Ranadive <aditr@vmware.com>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c b/drivers/infini=
band/hw/vmw_pvrdma/pvrdma_srq.c
index 6cac0c88cf39..36cdfbdbd325 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
@@ -230,8 +230,6 @@ static void pvrdma_free_srq(struct pvrdma_dev *dev, str=
uct pvrdma_srq *srq)
=20
 	pvrdma_page_dir_cleanup(dev, &srq->pdir);
=20
-	kfree(srq);
-
 	atomic_dec(&dev->num_srqs);
 }
=20
--=20
1.8.3.1

