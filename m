Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A383141D1F7
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 05:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347982AbhI3Dua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 23:50:30 -0400
Received: from mail-mw2nam12on2069.outbound.protection.outlook.com ([40.107.244.69]:8800
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347975AbhI3Du3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 23:50:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNlAHV3FPOWLkVZMroL8GTKWqE0BhKWSlxz2us5kuGLOyXYidZWXn0WuPQSMXLeaJxJQDleAk7BjIi29Or8LYR2mSSIP/q+bx4NNuJ9SNsNDood1pNOlGAkkfSBdo55q1lO4ko4HKV2YS1opa7R8lQrElX8BG0/wVDr6e4jR/vQpEjsHimsCLWxpduQnkelxmFPFoqXX0q70uOQhG5/luL+uYudPk8p87cTyHNTqVUbSlKE9upO/wfTVxrYjlWVqHPoBSXD3GomydCA/PsQ4c7jwRhy2D/FZEt8ROYKbfx9rQAwMjHrR8ysh0j71+xmhFW+P8TIsRyJJDu3vdRr5Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fUkVBePYfIYhSqtHaXJQIJeAUgILW1u9jdM99nrM1Zw=;
 b=WLMVu/DEseRmsDg3g/BQWQftxe2dG++aYyf1vAgx4BXZs3fgePPKVJoT4oWxnq16L8nScnw/GCtWfOFDMkqrlSc1tnOzEEm7dVG6aU69euebQt+YwbWTY3J00pE1B1Pq4WOD9l7K76FY1gGEgu2WRyKd4VevpasibXfN88fuqLQnOHgU5lB1n8Ve8s7pGYUkh9lh0Dcy2LW9tXdjze+ZTiC2iJJ4GMiFfM+hbB9NkHUL5kUDZFZhfaogsfyMlCsuTyZq2jn3I5ih/hSYCHmgyTifIBbq3UXcBSE8e4BYB0AxCfmvyKqQL7p4Xj6BxPX/4xMvHuxFfwM/mXwbEVEbmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=netapp.com; dmarc=pass action=none header.from=netapp.com;
 dkim=pass header.d=netapp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netapp.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUkVBePYfIYhSqtHaXJQIJeAUgILW1u9jdM99nrM1Zw=;
 b=n21vtKJy7Y15C2m6/5dMj0ffG4j1uHfXcr2qhlejQAKzYhXScaJo8lhBPBgrO2gjlFKJCGtpWTnFT7U4p9dKv9NM1TvmfiBkMXJ9N3a/fsA/hMbWq2xzwE/p/vyPZD6GXyHuiKbOjJBKl87CamikmyCASpsUBLr4XvSvVlPA1qw4GJ8aceaidTi4K8QNF9CfVFNj323i35lCErzuhHyDjCHrBsecWgPlTFgVbfLhAWNuh+aSzazzXoUAkGfbB4hAxUPQdKwCqiIDRHTYfxISXWZXuXvvaVpw296Q+McvZpffk9ARCS5k2WaW0TQto5IeFtq4K29RH7cwAy3BlnDYUg==
Received: from SJ0PR06MB8327.namprd06.prod.outlook.com (2603:10b6:a03:388::10)
 by SJ0PR06MB8293.namprd06.prod.outlook.com (2603:10b6:a03:386::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Thu, 30 Sep
 2021 03:48:43 +0000
Received: from SJ0PR06MB8327.namprd06.prod.outlook.com
 ([fe80::874:7338:be6b:ab5f]) by SJ0PR06MB8327.namprd06.prod.outlook.com
 ([fe80::874:7338:be6b:ab5f%8]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 03:48:42 +0000
From:   "Ho, Patrick" <Patrick.Ho@netapp.com>
To:     "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] nfsd: fix error handling of register_pernet_subsys() in
 init_nfsd()
Thread-Topic: [PATCH] nfsd: fix error handling of register_pernet_subsys() in
 init_nfsd()
Thread-Index: Ade1jt37NNfgpkRySiiZJ5n/Oif8Ng==
Date:   Thu, 30 Sep 2021 03:48:42 +0000
Message-ID: <SJ0PR06MB8327D188504E0F367C8B4E53F4AA9@SJ0PR06MB8327.namprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fieldses.org; dkim=none (message not signed)
 header.d=none;fieldses.org; dmarc=none action=none header.from=netapp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db4c2770-2dbd-458e-da6a-08d983c53286
x-ms-traffictypediagnostic: SJ0PR06MB8293:
x-microsoft-antispam-prvs: <SJ0PR06MB829390F4ECE027D8612C5E78F4AA9@SJ0PR06MB8293.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ay6sLAyUcQmsw+OD8XyeHqYKdL2HLrm1dEyWzMzkeWKrTX1x2vWM3Dqq7lh8lBYKQBIS5MaZIhoDspTe3a0uG98fobGbuiAsWj1QoweBHVI1jrVzMjjboAEF5bfiJ9igMYVaAJ57sx5jnN5+f7HCyAhUIrxf9YzC/MeFRl+oc97CW5+6tu+96IlZnTpzzm+CUPgle0IEfr2aBz5w0GimjV0sgLML/SBjOVAys9uJVMQzJ0QNO2aVV2iO4wWAz+ttsZM8XbG4vTNbJU1cV7g/8PJGYcv72cxxlDFxswJDFuzwMlyxsoDYrMrA38K1Q06AQGKV8Sk7OeChg1oUkS49DW1qsys7IUj79/hLV4WU8ChzO/eb696RSAe2+tcScQjDzPbGXvJhHBkPDVycqgX0eOfgdgC8+vBLTy6jzX31D0ThaKYPJPu0mCwSCwwR7DOGIBLWkJAHsOF+jHlcV2PLwA3ymKB5qNy1aNw8ukHKfmsTDtvT8NHNaE0BN+U16yBWLrT+daTmffIgmHx1Ew8CYNKVGcO4+8zOyjIyAZt071RIAhIxZxT6VYwOQj5cJGkWpAw22hAK4+ZOgIHJV1yWd2cdheCZFbG62kzMLvV2UyOOC/gC9FWBKeVomsufmMQAFXVeNF1LszIhhk0DlMizeGzgDCO0jooS2A2RWdvxN6G5TyHog1JtWnHXwrcuvw6KTjhtss0z4ThqEE08AitWTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR06MB8327.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(38070700005)(64756008)(66446008)(316002)(52536014)(66946007)(76116006)(6506007)(7696005)(186003)(8936002)(66556008)(66476007)(53546011)(5660300002)(110136005)(9686003)(86362001)(83380400001)(8676002)(508600001)(71200400001)(122000001)(4326008)(2906002)(38100700002)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QId7Qh9zPl/6PjhOsRvlV2FgTImLdPIdqLMkFhSTpldVo1QZYpdw7YBxQMhH?=
 =?us-ascii?Q?RD0bLL3aq5Etl8SCgctOLds3EQec0P0XlXpP6IEITkMRwV+yvre1ZYfWzFHg?=
 =?us-ascii?Q?2gK6X26iMUPRx4wnlEi5rRvQweEvqx1igMvBTHnFBgxtQYwIrd5E9YfUIB9q?=
 =?us-ascii?Q?cc0WGVmZiDUv1yy+OaRONVNkRTLjgCfe049svZ8uvY1XvALKssA1ETcd5N7m?=
 =?us-ascii?Q?vbwBvyqvCcKVCd7gBD790cdJLhCR4gj9B3NFpe3fsTgJsJsfisMYzQWkxmLU?=
 =?us-ascii?Q?1DZzda4XRX9jYWOWN9A3bJduUyHP+qUG+9d3E2PabV1FrFA63AXK6zT/yoZ1?=
 =?us-ascii?Q?D0ItG4wBaufH1v+i3VRc/NYZu87Xrij1RqpUBSWZaF1U85zZeyTpgr4udsIZ?=
 =?us-ascii?Q?mjHo9K0b2IrBW02xmuYoTkaLNkPPQruLo1uwR0OniD8Eb+ivKmruzYSeFR8Q?=
 =?us-ascii?Q?RpG4Gx84lkyPLnnzuazsIsy6dhf/8dmxsjWJakI5OkFR83XkzrMzgRAMK8z5?=
 =?us-ascii?Q?noxpzELPdelW5A3G7I1nHba/3GKpxGMBOtwxIR7671rpoENO6Jr4qRpHu4gp?=
 =?us-ascii?Q?u79o1PeaB6RDT0/zYdWLFhDHUOTIHJ88MFAgKAupoTHgGXbPDRfjSxpsNHmy?=
 =?us-ascii?Q?b4HHffZm5WCfumQHZLUtY8KMoDMoHo4EiAQ8jf4Py4Ay/nEJ4aO8w33YPOw1?=
 =?us-ascii?Q?JDMR5fl5PPFWPPRN/m3A7leJfx+NYtyOM26I9Zz8PXpVgK/niEYCDXb3HlzC?=
 =?us-ascii?Q?cU2hswED96pHGNDIe9+6ZfyjUBCvwGp5/ONpXADa6bHX8aX3+efjR4NM152h?=
 =?us-ascii?Q?wEdLwQ1jf/3Ve3goXGScVJpGnHX4E48r8L3RUrowhisVFoH/sPddsgsU2CJd?=
 =?us-ascii?Q?0abfDvqzRHYeYpcJtfyNACtTSPL1v0FD9youw5LYIs9P/ZnnsLBQcLOcvUaR?=
 =?us-ascii?Q?jGinn1UrDWLxztL+ajnBVqzVKAlq5m7uNZfcgS7GLHI/y8SEXqVetagbsudG?=
 =?us-ascii?Q?Q3hrmArNsMuqQ/7EvAviyZxbWf6Urdhsoos7tA8Oh6HoTT3s2v62Rcohci87?=
 =?us-ascii?Q?6fxfYGOhr9JZDctv3Rp8REcpCGQnLR0zH7paL1SkG59MSa5Z0nx843bCl4VD?=
 =?us-ascii?Q?3UpVmyKG7Q6VysuTsg2Oka90VSh0oF6TL+mZierkeOMX+dpK0s1XtLdM0TK6?=
 =?us-ascii?Q?4nCzZQPl3xoUWawd4XFoCMX2KyUfHEo3Q4edSWrFWfDl0NWMIBL3VakoCxxd?=
 =?us-ascii?Q?55eK6voista/C8pUHIUv6VPG05QiZx02gF7Rj4YlHqJ+pnQkczzBqXzkhlLA?=
 =?us-ascii?Q?OqESmUE9fOGkPWfQeWXefJY2UZgqE8J5PZSrern4kd5UYKyv5ku8TYpEx9YU?=
 =?us-ascii?Q?0fvSzL43y3D7NQDnYMnfav4N8H9J?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR06MB8327.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db4c2770-2dbd-458e-da6a-08d983c53286
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 03:48:42.1852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ddPTsAOktQuLcxIheSiUdItLeaKR1aoaKl/lNDGsFmeW56b6sHPkm0lsYQY7iKHv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR06MB8293
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From 7417896fcc7aea645fa0b89f39fa55979251dca3 Mon Sep 17 00:00:00 2001
From: Patrick Ho <Patrick.Ho@netapp.com>
Date: Sat, 21 Aug 2021 02:56:26 -0400
Subject: [PATCH] nfsd: fix error handling of register_pernet_subsys() in
 init_nfsd()

init_nfsd() should not unregister pernet subsys if the register fails
but should instead unwind from the last successful operation which is
register_filesystem().

Unregistering a failed register_pernet_subsys() call can result in
a kernel GPF as revealed by programmatically injecting an error in
register_pernet_subsys().

Verified the fix handled failure gracefully with no lingering nfsd
entry in /proc/filesystems.  This change was introduced by the commit
bd5ae9288d64 ("nfsd: register pernet ops last, unregister first"),
the original error handling logic was correct.

Fixes: bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
Cc: stable@vger.kernel.org
Signed-off-by: Patrick Ho <Patrick.Ho@netapp.com>
---
 fs/nfsd/nfsctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index c2c3d9077dc5..09ae1a0873d0 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1545,7 +1545,7 @@ static int __init init_nfsd(void)
 		goto out_free_all;
 	return 0;
 out_free_all:
-	unregister_pernet_subsys(&nfsd_net_ops);
+	unregister_filesystem(&nfsd_fs_type);
 out_free_exports:
 	remove_proc_entry("fs/nfs/exports", NULL);
 	remove_proc_entry("fs/nfs", NULL);
--=20
2.17.1

