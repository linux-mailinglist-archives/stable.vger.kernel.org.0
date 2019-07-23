Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9B7712C3
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 09:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732624AbfGWHYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 03:24:06 -0400
Received: from mail-eopbgr130091.outbound.protection.outlook.com ([40.107.13.91]:46990
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729058AbfGWHYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 03:24:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLkj4p7OTIDzlboAHrLKEuNW8MhWvAvTD1NbtasgpLgzl2uUtIlwFZWkbriB3RIAl2zknVbu15XnnZM2VJwisN8PqJPCrFBRtmX4k03CEkyFSERVaBtFD2+o9Kgiiy5rEOuwKCrMr+3dZuw40EkX4JcJu4siGNJG8pl/+NE6s2NYX6Ekx6+iXs7yXfv0FVPexTljkgwgmj5PxZzmJLolHT22UOR3vGg6M9o2mgAKg//mKTCTBsnAsiZUiy1lUAeiH6Ey193Hdfl9NovW+Z/J1PZRC1qfbeecfAmpTfmhmLBSy+TPip00wXDRzIMGSPYZaaX4QJHwBYaMY7PU7PJ51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5hU+DKNSchRp8v2Ux3+d6LiYh83B/dMOvqNHjq5mRmE=;
 b=RUNaQ4kdExrF1jDzGAAl+fWoH1FtDaradwVOWW8kKUSHzPnp6HpFzxpaB05MTy5Q31QZmutMEJOjgx2xywF911TdB0S7T85SL3XFKMJon7OoM/T41Y8XAnulxDbyffHR9jQ/mQWueWlHHyz42T4K2frU2TSETaWdn2WJGwPhbrDteKA/d0IEq8JKmyR0fSQ8IuiyDS1WjZfc/IJLFWtVq+PGO1hayxtDJ11w5mqwiph4re+kZPJ3tjn2LUWePtlyp+EskW+oJ0m1nFuQUmLJj48kJgVKcz3UjEn9okQ+fbUtwQP1mh/FdPcWzCyjw6vfRnxNjutbLGsyXmTxQiSIgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nokia.com;dmarc=pass action=none
 header.from=nokia.com;dkim=pass header.d=nokia.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5hU+DKNSchRp8v2Ux3+d6LiYh83B/dMOvqNHjq5mRmE=;
 b=p17qHFO9qt8/vblpiq41PzGoa8v85Vkdx9HoVfksg3sgp6KW0K7QiuTpH5Ew1IkjWoni/67ThD2eA6pY49UmWxXCZ5qiz4gMOLzEYpBFS2gY5A7/e6ApoIzmIyc4JTwXifVxtw6tWTMfrAW2WsK7pl/2KOa4/eDMLU/SXwTCowk=
Received: from AM6PR07MB5464.eurprd07.prod.outlook.com (20.178.88.217) by
 AM6PR07MB5240.eurprd07.prod.outlook.com (20.177.198.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 23 Jul 2019 07:24:01 +0000
Received: from AM6PR07MB5464.eurprd07.prod.outlook.com
 ([fe80::fcbb:3799:a7da:29ce]) by AM6PR07MB5464.eurprd07.prod.outlook.com
 ([fe80::fcbb:3799:a7da:29ce%3]) with mapi id 15.20.2115.005; Tue, 23 Jul 2019
 07:24:01 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     "qat-linux@intel.com" <qat-linux@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] crypto: qat - Silence smp_processor_id() warning
Thread-Topic: [PATCH] crypto: qat - Silence smp_processor_id() warning
Thread-Index: AQHVQSeZEH10CvozN0KsW1z2XZZxpg==
Date:   Tue, 23 Jul 2019 07:24:01 +0000
Message-ID: <20190723072347.16247-1-alexander.sverdlin@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.180]
x-mailer: git-send-email 2.22.0
x-clientproxiedby: HE1PR0202CA0042.eurprd02.prod.outlook.com
 (2603:10a6:3:e4::28) To AM6PR07MB5464.eurprd07.prod.outlook.com
 (2603:10a6:20b:84::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b767cd00-3fe7-40f1-b673-08d70f3ebbe3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR07MB5240;
x-ms-traffictypediagnostic: AM6PR07MB5240:
x-microsoft-antispam-prvs: <AM6PR07MB52402C9DF0E7E0B36F5DEB1988C70@AM6PR07MB5240.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(199004)(189003)(102836004)(6506007)(386003)(66946007)(6512007)(52116002)(14454004)(305945005)(7736002)(316002)(3846002)(6116002)(36756003)(2501003)(86362001)(81156014)(81166006)(50226002)(66446008)(99286004)(53936002)(25786009)(5660300002)(66476007)(64756008)(8676002)(6436002)(8936002)(6486002)(66556008)(486006)(1076003)(68736007)(2906002)(4326008)(476003)(110136005)(66066001)(54906003)(478600001)(186003)(14444005)(71200400001)(71190400001)(256004)(2616005)(26005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR07MB5240;H:AM6PR07MB5464.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vV/deJe8g0ywpA+kle1MUIC3ZAiwUDxrzeM+rTqgGsKO9yrRdpHUxAvr5DuUAlGap84FeRMgVurs8VoTB1yeawsY59J05+biJ08E+mPZa85zX0VZSY5Rn5rAuyUbfucLGa/luFpwKpJgyc0kZrxIr1i0fhUWejKVrxZh7cWipTqhfTYRnZiS5zMHpo9CMT30d+eGN1sMxV9w4SRoIN+dqDA6sEAPkBJ/+inpyYLPAHXFmV8wEpnX0bzkuMj/a+e6RtYmacHzJgcOJBOsKTW/cgM8HRiZK2I8tWI9nBZ9RnES74a/MpWedUxLHT+NO7MZyHx0+M1KG9BlFXk18O0m32U8PmUnth8LsZxobGIn0qPgHlHY4sFbKe4U5nowokz8qejwK5VaKxl3W39wzsMQ2UdHcJu3YlPpTDobuKvFIDo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b767cd00-3fe7-40f1-b673-08d70f3ebbe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 07:24:01.2765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: alexander.sverdlin@nokia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB5240
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

It seems that smp_processor_id() is only used for a best-effort
load-balancing, refer to qat_crypto_get_instance_node(). It's not feasible
to disable preemption for the duration of the crypto requests. Therefore,
just silence the warning. This commit is similar to e7a9b05ca4
("crypto: cavium - Fix smp_processor_id() warnings").

Silences the following splat:
BUG: using smp_processor_id() in preemptible [00000000] code: cryptomgr_tes=
t/2904
caller is qat_alg_ablkcipher_setkey+0x300/0x4a0 [intel_qat]
CPU: 1 PID: 2904 Comm: cryptomgr_test Tainted: P           O    4.14.69 #1
...
Call Trace:
 dump_stack+0x5f/0x86
 check_preemption_disabled+0xd3/0xe0
 qat_alg_ablkcipher_setkey+0x300/0x4a0 [intel_qat]
 skcipher_setkey_ablkcipher+0x2b/0x40
 __test_skcipher+0x1f3/0xb20
 ? cpumask_next_and+0x26/0x40
 ? find_busiest_group+0x10e/0x9d0
 ? preempt_count_add+0x49/0xa0
 ? try_module_get+0x61/0xf0
 ? crypto_mod_get+0x15/0x30
 ? __kmalloc+0x1df/0x1f0
 ? __crypto_alloc_tfm+0x116/0x180
 ? crypto_skcipher_init_tfm+0xa6/0x180
 ? crypto_create_tfm+0x4b/0xf0
 test_skcipher+0x21/0xa0
 alg_test_skcipher+0x3f/0xa0
 alg_test.part.6+0x126/0x2a0
 ? finish_task_switch+0x21b/0x260
 ? __schedule+0x1e9/0x800
 ? __wake_up_common+0x8d/0x140
 cryptomgr_test+0x40/0x50
 kthread+0xff/0x130
 ? cryptomgr_notify+0x540/0x540
 ? kthread_create_on_node+0x70/0x70
 ret_from_fork+0x24/0x50

Fixes: ed8ccaef52 ("crypto: qat - Add support for SRIOV")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypt=
o/qat/qat_common/adf_common_drv.h
index 5c4c0a2..d78f8d5 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -95,7 +95,7 @@ struct service_hndl {
=20
 static inline int get_current_node(void)
 {
-	return topology_physical_package_id(smp_processor_id());
+	return topology_physical_package_id(raw_smp_processor_id());
 }
=20
 int adf_service_register(struct service_hndl *service);
--=20
2.4.6

