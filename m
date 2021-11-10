Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713E744CDF7
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhKJXoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:44:30 -0500
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:16224
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234005AbhKJXo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 18:44:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDZFZ9tPmCnTgjW24I4rZgADZEwcSe5+pIPq1RydElCiDUI+Vsgb7HBeuv3GKiYBOofHJzsMKVf5smdApLe6NyzRNnE8vt9Lfg2gowJvXy+QnXB2pTPqu5ssHVsS0RFGClTFftTyYgLG6b1dKkJHjIy06bCaZXF3Bx4WcTtM4BCGFlfiBSxSB8SITw3j6VgiZqIVU7LLoqNNzBb88dGAQ0Y2rM0p/NCvDS7u8psu1f2nMJa1E0zPdITogf/Vj5RD01ue3HW3ErANkoXB8Opy/qN17b105kWpYFCIRYJgDuOX1BSaKoTNA0WQ2QziQZoUv3Z1Pwp7EhVj8DbXKVyO2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LatWXkZ9Bgi2px2sU9HXQmRmGo9pTTU7yF1YY8KU9C8=;
 b=kDtVYGei8nMwMSSx5jDNqjJ9/BoBmqg5yNULyDnCcVs8hNxI/w2hz0nPB4PbXhlL0gzChgPQAPAlSxGCmUhvulK8BRApxn4sL2LgHGCLEjw+oLLEDIVDSxZDy83+w+k+RdeXMiJmGXAZVBRBGje3dJFhvC+fAEJCdll/wAAnUpu3vIgfw/HAAqG/kLyz22xNr1QJA7o+D+wMz7nZxO2026+nksMyvzrfGL1hGL3IS1XYox7TNIEkm2AFlWFpt8UpJmx54ZYeV/KoD1Mx7jlAHPr2EuurSx1OJ25l0AbvhseWxcHk23uAbvWnPfnd63yK6pH0isZJiPVeANvob7leXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LatWXkZ9Bgi2px2sU9HXQmRmGo9pTTU7yF1YY8KU9C8=;
 b=WWyJx3NjRvKNa0aMSi45kNb5wAHQ/Qzxz+dt5VbbAIBT5ZofTNgTXG6hmXHzIMRhSs2eTbSboBEOVnwByxz5DvSGd+BtKF/u14hnkQ1b7hJNJZ6Ix0+92PmULzrPGoba1sDSm4w4VQXfFdWbvCtCehAkkEutKs/jo60y5mtnG/w=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SA0PR12MB4559.namprd12.prod.outlook.com (2603:10b6:806:9e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Wed, 10 Nov
 2021 23:41:37 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea%7]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 23:41:37 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Fix GPIO based wakeup on some AMD designs
Thread-Topic: Fix GPIO based wakeup on some AMD designs
Thread-Index: AdfWjB/+xKTcInZIQTK2bPIA/aNcow==
Date:   Wed, 10 Nov 2021 23:41:37 +0000
Message-ID: <SA0PR12MB4510DE9675041E9DE26A9EDBE2939@SA0PR12MB4510.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-11-10T23:41:35Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=b01e290c-029d-425e-8209-7e1b46719748;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ebcd085-6089-4ae8-e9fc-08d9a4a3a322
x-ms-traffictypediagnostic: SA0PR12MB4559:
x-microsoft-antispam-prvs: <SA0PR12MB45595028EFFE68B1E466455CE2939@SA0PR12MB4559.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D/wonV1AX/iTSe5JqeOD6p/cY2wQIkkxAsa0yJDU8b5WFateFcPQEMT5KIyVOOczmcjviVLzdlfH9O0DvXcTtqq3azWSNvqMM+J8eZJ8koqPuBAa3PHTXohXkyBI96sS5FqsgBm/HVz32C4LvS2qgaiRRktVWMGl9fygowBZeuay3Tl521Hx0F47/0mTEXeb2pcjxnYPr1oTVNPqGRxH28YlYV9pbJ1xcub6JZFw4Q9SNGmz0rn4X1iIIiHJRSOTtPQjUZXUD+sLF9OitrNHd3hJt4jrBZJ78L6xvQ3Wzq5QsY9n2/tWnO4X+0Ot7lGDSf1+40dAsRMRwOEMC+QqRrquwyZtn3Ic3n2pRnLBVd9fbEb158aVnlw41xXfMr+Q9yWksoesuKf4vFTeGJ700gfQy6jN9a6b6F2e3GOdRbNWZZwaX88n7AXY/+lHBLMtbNuYClGan8Y7JZ/UP4Tr94gJKtLUY1Xg1zERncV9cXhUvpc+9XkBqSeycAHu9cBKLhT1bE7KkF7tq2KLbVW1Cm7SznH5jp33mtLH96Ygq21I8V/TDE5k9op8CqTefzCYByx5QjqMYwq7sQ9bhMIeXy0GPuCz3Zy5PLlNLxbAg8aTrcfY3hLHv5RLnFyKLL8upgxCz4S8fTPhwyOn3ZLcV6+ZRSACm7GwCcGJQ35hF+zvnsSz5IIynSnfXlwtsbk35Hk6vbo76vqRyrIRwze3yg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(66556008)(86362001)(52536014)(66446008)(66476007)(4744005)(8676002)(33656002)(55016002)(186003)(6916009)(2906002)(8936002)(66946007)(122000001)(508600001)(316002)(38070700005)(5660300002)(38100700002)(7696005)(6506007)(71200400001)(9686003)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OmuPrQZjDUG1eUQZU67XH9rKjd0X17IF2jpzIexn7/JrF/zQVD8WtxRTRliq?=
 =?us-ascii?Q?oCC4nb6aNzkGyfuG8prAS2tousHF5EAhJKNRABC3BPmesAPzoXBFv5mLzOMF?=
 =?us-ascii?Q?80RjIwRpTsBg9rpCnzsVm97RgElm651g27WAk7nh6Wf2e9/Trc+8eaZud/81?=
 =?us-ascii?Q?hnK7QyPWi3kSIpf8fCxg9Rwr/Y0AFvlJqWnB1o0AGHsPGnNvpne3jwldft5I?=
 =?us-ascii?Q?VgCDP+amJkyfoFqX0kFmONCbuyJ1F0rxET3waPwEzI4JlkPVTwMyRLH6xrRU?=
 =?us-ascii?Q?op3icYnrrYJTbkC3/yMtIO0tzrYB1cCZM9UaTHLLSC4fzBodAIu7J+YG/L9g?=
 =?us-ascii?Q?PC/rNsaPvUJd0gnZK6l8WWtYj8ZUjzvmLjYzgR0Tsc+1DN2tIdNEj0WtCxZY?=
 =?us-ascii?Q?ivbcsLNqmilrZcmMeF3TeuCOawmINcg6I1k/mK3FFSJ+/9bDfjZX5C4Vf0Oc?=
 =?us-ascii?Q?G5nIQwrRwX0dV9i3UeJwWegXkGiCNpi/fq++jSqBNJVC37QBL48dudKtmqra?=
 =?us-ascii?Q?qghntSZfUK4UCTChRm+DJUbNHOM5o8OXEbZQwo4RFy5GtLip9jSeLcVG19fL?=
 =?us-ascii?Q?AIHzkU2dMI0tpnTWzk441D0AunW67rvXX/Qx77uK/2yy6MvKH1fADpXpDsya?=
 =?us-ascii?Q?W9QzUjuBTXJjWWnAXmWb6htWdsDP7U7pi0CiOzfL7GpoqcXA3pdi4KXZmZi/?=
 =?us-ascii?Q?Wge/ra2E+rKLSN+3ZhgYmwtuywTvc1x2jRk2WR8/U5si/7LAvEZzFojIm//m?=
 =?us-ascii?Q?dXLPpbQ0Q1GKdqFH+J9ucMHYwWoN7kOqY0mFPwMiYD4F6SShU4Fqs7ZBCWGP?=
 =?us-ascii?Q?OoNWNXSvBKJX0mT+s//hrU1f83o3x7Hv4Y9YV3na7zNIuWT/ONytgUbuV/qR?=
 =?us-ascii?Q?xHHC8uDC9Thyreeb22Du0ozGxm9qqucChxt3TEqwiZXsg7KDfoIXHrBIBQ+s?=
 =?us-ascii?Q?Lgt2vOKeCTTYCiYVR4x1mPCataL4AiMXNzwEzXLyZKjEEJnExR/7Sm3Atk2v?=
 =?us-ascii?Q?W5e92mPJ0hK1kKlW5YN0KBw9TqP4hAzGc+EXulkNqyX0dPuC6sJNe1Fwg6nT?=
 =?us-ascii?Q?2s0ilc7j9eD95t0UupbmuHkhKHv4nReziPz1fT6yzKlkwtQTZZDdf5t96VrR?=
 =?us-ascii?Q?Z1AUZ+nvRQA3qQsOVi7aW72zEJdvxioQ+go+pNG6QiT8dAIQfsweQiWTUE8l?=
 =?us-ascii?Q?pNlB3pglra42AN9I+55atvB2mmi+flxc8D88iv8i0IfncOtH/fWoEINYBi4z?=
 =?us-ascii?Q?gR+ZfIE/Z+jsOpyN6jz7w3FkbiKaXQP/3swLum9ukAr1+xi5d4gGhq/v62PN?=
 =?us-ascii?Q?tey0YewIeZfgtjhTXcGuLwagzxHEGb0LaS1vu4J8NMoDg0GyfW8cIqtRsMZz?=
 =?us-ascii?Q?vAdbbdNoFPVmzsZUGrKINxwgunjjsLAD3FtGo01u8RhWALrl1IE+FSLLHbgd?=
 =?us-ascii?Q?UzrQppFVpHWXHkNgg0U3ne5AaVWluTpaJz5IDt+ep1feLAw2do+iqqMIqVel?=
 =?us-ascii?Q?mbAOf2v6xzWK/8HvUt0rNUOWIYRWAjuQLoSMIyKJOz+A2DskGjOZ2IYHtwNY?=
 =?us-ascii?Q?HwmIWxlDGSerqCQeUdzep1NDo17biL54AlDZJN83YaOMHyRXMp7kMu0HVLig?=
 =?us-ascii?Q?tRWx151wYP3FuWlQgJE+SYO+NBMMHpVy24BHLJ6MCYcX4NuF5dYzxPKJOsTQ?=
 =?us-ascii?Q?4pKsS84ml3RR7t5dr3c1cNWT2Yc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ebcd085-6089-4ae8-e9fc-08d9a4a3a322
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 23:41:37.1611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NTRD/qVALeFZxugaRmCk36h8KiXnv8Ds4GJChIPWBRdq4Bm8H72nE436vCvyPe4+UG+zUQkcqQIns3MhLEYI+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4559
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

On designs that that GPIO controller has a dedicated IRQ, wakeups aren't wo=
rking properly from s0i3.
S0i3 is first supported on 5.14 on AMD, so it's a good idea to fix this the=
re.

This is fixed by the following commits:

commit 7e6f8d6f4a42 ("pinctrl: amd: Add irq field data") # 5.14
commit acd47b9f28e5 ("pinctrl: amd: Handle wake-up interrupt") #5.14

Other designs that the GPIO controller shares the IRQ with the ACPI SCI hav=
e other fixes that will be sent to stable once they're in 5.16.=
