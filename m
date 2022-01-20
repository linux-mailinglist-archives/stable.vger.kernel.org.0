Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9C1495506
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 20:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbiATTmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 14:42:38 -0500
Received: from mail-mw2nam12on2081.outbound.protection.outlook.com ([40.107.244.81]:8417
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234821AbiATTmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jan 2022 14:42:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDak1XkwAN0mNctsxG0XunG8vfBtk3w1fMFSuHzsKOqJn19Kpw9eiMZDChgFgO175Ovdj5WCWJJiAUWbH5jjKjiykBGtNMCh5NV7PrmXC6i3ZYTrZykvC2DHFpzIR2dnVYDOSrIWUpUdtnIrbrLSYSkpns15C9LOMpDT1xvA6Wa/EaT4cXLePpqputWQsgGgNhpKARmovfcloTGSi5I0wxl9lInxNr7rgaYsY7PPorqByY2n/LL+uQ37kOlmpIHCbYJF0EhEUJIE+MkbyGq33VdUE1ygxXj+kgANW9nSi0/CYOiLxMkbVpl36OLNfwEBydXkr/o3I9W+es0AWF0Yng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUdpcQVVUXeRFAvDCs1/3Co0WGKtv1fZUC2NJv/r4IM=;
 b=UlC1QXVyvms9DqMNMBfkPDdrYuRBwuyUjNPC48ZYBIMUj+Ls4H6eplJuWtbOdtEPKNCJ6UYlgwnOcl2RY1KLWSQdoVaBuYzem3CKw3Rvb5xfl7J6Dv31OGhhTMvAEr6uRiAyHljmKGY6FsBma3QNVDM11BQLdMMWUQEI4Sb/jOcZH3abiMbVqhngjkunUNRUmBd9vd8+JHRIkPljOD7K2j7m1ZGsHIdqrAYbAbLyeD8SSpPvc2qJnkmn7fUvh/geLeolFnx0kRKSQdBYNUgiDzVlem2QdPTgFQKn1HpYmmcORdenuXdZ/HQ20iCSHeqk9uscgRnHkPP/+KeTh2aloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUdpcQVVUXeRFAvDCs1/3Co0WGKtv1fZUC2NJv/r4IM=;
 b=BJ4yVsL5WaCy3Sex4HN4sNOyaFJcQ57EnbwfL5txB/ELl2ibI26q2GfIbQtW5EEdyTEOYPaubH+WaOnR3eGRBolHKYkUBIoyjN9TTFFLYQmOLMeuVygpv3ih9reRrjEQdfndaY4CYAFjmyJf3h5sMc933WNouAbF6wYVzVY8PU4=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BN6PR12MB1122.namprd12.prod.outlook.com (2603:10b6:404:20::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 19:42:35 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%6]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 19:42:35 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Make WCN6855 work in 5.16.0
Thread-Topic: Make WCN6855 work in 5.16.0
Thread-Index: AdgONWehcv8d4InPRlmolxzrhtT4mQ==
Date:   Thu, 20 Jan 2022 19:42:35 +0000
Message-ID: <BL1PR12MB51578314DF452921CDC3B192E25A9@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-20T19:39:16Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=9a07f091-397f-40c6-90dd-b76eaa0a2bd9;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-20T19:42:33Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 0d2cfde7-8824-4570-bbf3-32a377189633
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6f8f7fe-66a7-41cc-db35-08d9dc4d023f
x-ms-traffictypediagnostic: BN6PR12MB1122:EE_
x-microsoft-antispam-prvs: <BN6PR12MB11228CEE75E592EB5A066094E25A9@BN6PR12MB1122.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CrWR3T6cTaBzOB2mDqgYk2dr99duwBv2nAuxVyKkyIeS5i+SiFQGF0V6Qt4Iyj8+aj66LU3oWNInnCQfXnV8uoEpM1FPrxmpSlotYio82Tvn7vIKijpkOAOgLPvwao3Np5msyHYR2VlFNyrcDZG9DprdJpb0VfDEOqYqzQqYPvRuIUWRoBujwfZX6QFWmtONY9zKQVpbPyHkdIfrDwyeZo3umJas3XBSnNlwwJJKwXEg/LofLJBL7k+gt7JSjLpk1a2UrfA0jjXXgAjN63VQ7k0yPEqSdpXrn7h5ITx8F1rMtFeK/YJoIGW9AyK7NCBsuBe8yCfXdpQxZMNmrgAPHmiqbKXeSvnZpWT9NtOheUek79nwSKjGtZNdbEr4qf6OFBDVog8+ch0HZpa2ATFwPWMUASEJ9qtvtvMNng6250JZhbKzqHzd1NWj8fF4/h3u21zdCTkmqQYexU9eSPE8lHhdwdTu76lTFMCHx3B3uPMFWE/sbdtVirkF559cpeZapWq0caMSeDZmq+Z9Hx3qyISo6M8TM/cNk445kme8yWKLpmR7Kq16VtN4Hz1JnpDnFdRB3Yixpsj8APF/VcL20pXtt8nqfT7qsZ9806gUG9QopBSbB8LOZ1/+xswyYMjuH0L7uH+0YY5k4Ei2KLb6iOdN78KYOz3fT+GX3NK9Ugf0I69ZP6eziSHf0M8BrocvoW3n2uDFif9GUATyQwBaFIqQN0PXv6BtUsV2j4yF/pIOf4iopylrimful8gWVEORc97d1OSImaBuzpBbIkdG3jqvxiQzmxmvytPQMAaKygY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66946007)(8676002)(38100700002)(2906002)(8936002)(66556008)(122000001)(55016003)(71200400001)(9686003)(33656002)(186003)(38070700005)(52536014)(966005)(86362001)(6916009)(76116006)(316002)(6506007)(83380400001)(66446008)(508600001)(4744005)(7696005)(64756008)(26005)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PYmaDU92Z5Zx1flBnep71luihz9R4Q7SMnw0kCQWZM34akJ51xP5oLWyA/pA?=
 =?us-ascii?Q?IVx0bQ2UqjDeTCJEVxQmOXsHobZbH+Eqxk5gJdDIB8Hrf6isSeV5GoCpGGBl?=
 =?us-ascii?Q?9XlBI64SYse4Lzbvwq2me62GAo0DUavhWzM2uiCwZrl8OSaV4gxwvDD4wQim?=
 =?us-ascii?Q?oYZM/sr7jZ4qJ7UZRfn3NAR/dFu7DlHWNDp0jF0A+tufJNGycQtXFZRY7Jjo?=
 =?us-ascii?Q?0vGNGoXoo4BRpBOm45GKhylkfJ+3hnAXvaiIYwdDAii3Q3r+BSxXvwP2WX1F?=
 =?us-ascii?Q?dJ4xjSEdjG3usKBemlTH4NTZt1MYp5E8as14102gm8h16Umw4aBxBgUhjjZP?=
 =?us-ascii?Q?co1sbU5RgmTqbkdOZBUZgQx2DMB1mFSrFyTm/uMKibp2wKZy263Q3Fg15ftJ?=
 =?us-ascii?Q?rRXYbJDhw0vfywIWzSijXLVgBb5J4VSzuwYmWk4a6jbHbKKuk57+X+IKvXUX?=
 =?us-ascii?Q?OiHm3igdklmNN+qIYOGOkOp3Z8Znl/pl1FiierRFA4vbcTHQNxmLaBD1+CkM?=
 =?us-ascii?Q?zq8AW8ywXV+SkE+Zdi0fbRTt0CahpIeGkI7hJ7l31RRv3zI6skdsbmlWWhwr?=
 =?us-ascii?Q?GQVebeSPyQtpKYiNoODm9YGqdUgiVIfN+j4iDaWc53YsDzFqtH/8YR1Bmjuf?=
 =?us-ascii?Q?y6Ua0onRbuqZ1G9aFIhVN7zm2oiBcOQ7vpk+VHNtr7n5kfg44oKyrkbZrdpR?=
 =?us-ascii?Q?yBJ8iWl1vKfy/v6TjdOfwrxOVYLGrHbg0nrFa9o5qqPr1OM4MiplqZg+NiDo?=
 =?us-ascii?Q?yMwWl3wk3NhNqv9y6Z9A6I4RgYB6wZB4TnJQeZ9RZlTW/neI3eOvZBE5f2w6?=
 =?us-ascii?Q?ZzjAY16IPbJTshvObTzO6WKjTbMpScC12ZierIiJkXp8Yajgj2wjQBNW2STm?=
 =?us-ascii?Q?yeeyDpmAcej2di5+EKzPkKW7b+DUs/6nQFxMQtB8E1U6kLpFshAShqhfYgLa?=
 =?us-ascii?Q?3QFEVa6V2X3GUr0uu12J3hF+IO6mWCcvK4zZULGfLTLoWv/4ZIgilEDPbEKC?=
 =?us-ascii?Q?zT/QwvtPNxf9gIUFOe8BWyP8jSWGsdizo+lHuaP60Tv53KXSIFKV2DXNAmXb?=
 =?us-ascii?Q?7zF3x6dnG5O0XJ7J3HlQCrHFUdO8BtFUB36sjWiT3jr/pdZx9rBf+z8Xz1e2?=
 =?us-ascii?Q?oftPxy8wrBh+ibOKPDIOljrtUf/47R8Emu8jp4fVPC7T1nRxGnYugP55f73M?=
 =?us-ascii?Q?yjyMRuIzS54qDzAH4dZCPMmwh1gLasZUYxZblNTpU//csIcwemDuhtbq94hO?=
 =?us-ascii?Q?Zs+buLBDffY52oIi6M25mSBel0nQ1KpOrKqnSsFf5fXVDyhX86eumvwweGif?=
 =?us-ascii?Q?B8iZhU52FozAvMpShqUBgIMgQBED/5Ac1Ams5OeUqVNmYLWn1f0zoD5sUT2p?=
 =?us-ascii?Q?Mvpd7mp8YVTyaMacgTrlApjc7amzhIuMLI6xZxWvLbR9rHMhzyehWVv1dHkm?=
 =?us-ascii?Q?eVvZNrLD0vxoZluzOzG4Zf8rmmms4Pw5uzjwVnXIynZNMy/tKNqcOB0ZIR5W?=
 =?us-ascii?Q?bMCxKDyf7wo/0alsGFCMM139YEEEA8AkSO5VJb6vn7GA4f/3SDVc/XD0UywE?=
 =?us-ascii?Q?UVi4aoTTXee9Vom7doPPlbp7kGHrBdJ8iy3PRVS1rz0rMz43aKVPmcQ6gS0U?=
 =?us-ascii?Q?HQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6f8f7fe-66a7-41cc-db35-08d9dc4d023f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 19:42:35.7030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P2ArYvUbhFF02gLDQkqFZDyvnvdGgg2ffl8yzFz9nW+AnFrR71+5DfJXw1ZPL2/M4mwlbEx2OC+BpXPiARxasA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1122
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

I found recently that WCN6855 even with the latest firmware doesn't work on=
 5.16.  As a result of not working it causes failures during suspend: https=
://bugzilla.kernel.org/show_bug.cgi?id=3D215504

However the reason that wireless isn't working in 5.16.0 is because the way=
 to find the board IDs in the firmware binary needs modification.  I can co=
nfirm that it's able to parse once
commit fc95d10ac41d75c14a81afcc8722333d8b2cf80f ("ath11k: add string type t=
o search board data in board-2.bin for WCN6855") is backported and that avo=
ids the suspend bug (that otherwise still occurs when no firmware found and=
 should separately be fixed) so I think this is a good candidate to come ba=
ck to 5.16.y.

Thanks,=
