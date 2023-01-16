Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DBD66C289
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjAPOpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbjAPOoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:44:23 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D448922A3A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 06:24:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQMAwSndAQ4cUASkCr6xd6+NddAMmSAmOFC07lPViVqMocLPRnDMcfTdoEcSnRz94iou1Kq4Abg6oMq2shAHKOAy+D/kYrPDJEAy/bqCGCp0CPTWfuvN2JFZeNokKO8VwWslBEb3smccmRGNqEvPEa4Mm7cArEt8CSRCgIn3KJdQklzkNCueHLZZPIgtK1BhRdNii49+Gms0RPTyNWyeKzzzBDx3DSD5QJggF27hPmvdu0je8Ag3iRUtKZp3j73IRbxSC9Rxth7pyTsJProYvQN4q7R6Ko3aCyG6WXUlBoFBvOcxCHzUDIQ0Pqwr1GAMKIXVIQ+ZlYfBO6idpeUWHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSAX39TdMhgFcL65lHgjRVzwOD1IcD/Q/arNJIjhOj0=;
 b=TWQSsEgpgiyKogq0hFZBZPApsVSH2K3vvv08BXFxxRQ7uiCEVuafa31sMSRJ7TIF6+membpnFCViluEBiPOBdKlonCfv94PcRXekZ4n6W/XTG7Q4Ox35XdSm+cZPoYxrtj3bk4WxnWicp6eEPKQSjTYgT+/QMxl88I4Fp75Gv0fwX/hbIvlH7KytQchMj0FhRXOTOlKMGKkBWhUij983gjT9ZpC25td3GQAHO2IBwMWH/BPhWqOxbsytyrtSUm9bltv7s04AjUaohjmBTkr8RrP2+tCzVvoaedw92gL15HZut/55rRlA8h+NpSWuyQF3b0mmQZaQGe6C1xhtjoceBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSAX39TdMhgFcL65lHgjRVzwOD1IcD/Q/arNJIjhOj0=;
 b=cph7E2DPFz4VQC/wVxpgGbDD13gWchbLRsjf70U9RYfceIQm5MIc4KOqwa1GQP5LtrcYdFQvWhxl7R+h+mM13aGQZHUwMziW4YmD+y5lkw+rCRFnfxTyUeDPeCfLEHXx/SmPyK7ZfGPhq0Au4X+hKfu2aMMT2e4ZKKiOIFDVVss=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB5327.namprd12.prod.outlook.com (2603:10b6:5:39e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 14:24:17 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%8]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 14:24:17 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Backport a patch to enable debugging GPIO issues
Thread-Topic: Backport a patch to enable debugging GPIO issues
Thread-Index: AdkptZAmZYiiIw7gQc2QPyInCwMh5w==
Date:   Mon, 16 Jan 2023 14:24:17 +0000
Message-ID: <MN0PR12MB61014D5E4750F45AFD3F26F9E2C19@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-16T14:24:18Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=a38a0e9a-fd82-4f10-ab38-b3ca849d60a4;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-16T14:24:18Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 42a01c79-9d90-447d-ae02-da78b41b4d24
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DM4PR12MB5327:EE_
x-ms-office365-filtering-correlation-id: ad1e7bf8-c7f1-4195-18d8-08daf7cd59fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nbz4CGciyoeHkME8ULAf67EsTPezTiFVrU5BcSLW6psQFmSgJUR1YVrUapAEEUtDDg8BApyVHPe54b30E6ecB/+8+HIfotQ94rOh0pRCGS+mid1fzrXfH1qzlsRWyYeJ1zn8VVNyYCAypwBdBhKnfVT0hjfwR7xVf0aTUgPpxFjky7BooeCbLnp4s/SqdcMA2MoXBpiACCcTPwp0fTXVijaSWP7NE4dq7GoQMCUzwes94tscTNonF22K2ZI3yGsDi8m9gmS+1JBBCUGC2L/0Zg+KrLDilXnO9LZSs3/o5kPKOmFJAnh2LOfkE0Lpi08fRAZemaWP9EWKKCysjFu/O5kecSDjVlVGrHm5I0uKZK8J00fzngw/VEIebMiac7NXy/JDEtO8s7C1HJQbpugnDyVar856aAQ8USlNfBbsVE2lHsWBLNq9ULx2+pUq04GBFJphfQd+DnaZl48KstUftjCepkcSHFIh9vGYJQuNAKS9P/hBwiEU0VxfnN9uYDmT8lmsEjhdldtSqG+UWu/UAydbPiAuFRVCOtfHh1p93khPI4vE+0AKGy+lWm0X3wrp7pTgQP94DhKlzFxA+VNvbNMjHmP0AYZm0iEIhTIKeB18SrYMqkdTpO4Lq6QIsEVVBEbPdtQxvw045srqUe3HworVeUZKh9nLiBjMEo7RvdWhz6CzMshoz0ZMDzUFpEHr4BlJ/J7WVZr8y3kPW8d4/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(38100700002)(38070700005)(86362001)(8936002)(6916009)(8676002)(66556008)(55016003)(64756008)(76116006)(52536014)(66946007)(66446008)(66476007)(2906002)(5660300002)(4744005)(122000001)(33656002)(478600001)(71200400001)(7696005)(316002)(41300700001)(9686003)(26005)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oZwqmtRKq5UNDt4RracCBZiQ4y/+6WoESBnW7jk7MkGJMCuQzgqnwfxFaS49?=
 =?us-ascii?Q?NmIeA29O6twKBV3uDJh7Ln7Qcfn7wQpwSPJPcMLw4cvgOe6FyWYddi7sabSw?=
 =?us-ascii?Q?5i3+deX5E47KKgL88rt/m5HNDJU4DZO99gYCRh5jzM9cU7GMfh6a4fCqxuZF?=
 =?us-ascii?Q?YOXvIxhL4gERjHVQVaUdDA3pz/uytI8Frguc3lxH+OU0m+jAY/CvXow0FgvY?=
 =?us-ascii?Q?5HXOy58rwwlmA2oDwUwKVVaj3vY6QXkxmDQQUKsRkZ1KirylAC9K7d/m02UR?=
 =?us-ascii?Q?KbuNn/PBkLnny0PH1UxyN2pOIXqgxAiD+XiQIawPafSBipQwxtrZL3psPQHy?=
 =?us-ascii?Q?z6mhLtWs6IP0aM707rRD11S9+MmJSR9zyY1Rcd5NlJxDykHRmIj7whLDoqt9?=
 =?us-ascii?Q?bIcPTVB88ndk4KcT3Ji0l7BDuV1yG5tuRxkwBrmlKclYJRjjPBzQfLlp13xJ?=
 =?us-ascii?Q?8kP1JS3/wJc1EPUk8L5L5nI00Ihs+/a2X6vgxgM3AHz0XDinf61okTGE5aOU?=
 =?us-ascii?Q?bqofyoWhZ/Q10eNIDQWN5oVnwIergVLQzb43P19iiFjHx7uVmyc41HwEYB5y?=
 =?us-ascii?Q?x7bFVZNvwUS4sthI/QM9FVywSwmvaxpAMgdE3yArTKXLXlXfkROYzKHOj62t?=
 =?us-ascii?Q?UY2f56ARfuQ3NxRPhXeSq1t0TQhafTNY5y+/Skjwy+3IK3c5gd9iy1i8i438?=
 =?us-ascii?Q?jiiZTqALVs18LyD4a/VmWa/ROWOlGOxMA2e/vL7GdjBRQUq6MUtfbfX/b5by?=
 =?us-ascii?Q?lx8CczPhrVEEeMVCmnr/jBe/MxcTqyLekUzmUm9oN00nkqtvMhnRVjEyJRA5?=
 =?us-ascii?Q?ZYI9+RCMkZvP0t389xjPGeA/2jBBSEpCIdOtj/E9JzxBI6WCf2k6iuti8QEw?=
 =?us-ascii?Q?q2NyZpna94OkitsKPUs7XMbTQ1NPJN13gpSJM8lJyEMb76hh9p4IwYdQRFqa?=
 =?us-ascii?Q?uwBYIxY0GlhHjse0RQSFj7jzjFb+Ko+MtbXvcAeQGLxdXxAXZEWI+ukgw2A1?=
 =?us-ascii?Q?RV8pPmI0zPJMh+SPivJPxLohNfllM7K/0v6ysSgAD+4CU6OE9snFG27iyrhB?=
 =?us-ascii?Q?JmkfbIcD4bB0ntMjUuthnPm7zVT8Qhd+1aFkAkwvNv0/Uvs6ZTs/ZNxfVNaf?=
 =?us-ascii?Q?eUazUylAQWcyvkoReDNzlt9NY6iw2JIgxkHZPFRWH55a2m3iCZFC7+5l5EsI?=
 =?us-ascii?Q?b9h70xOk1GdrcuykolegVA4iiIXJ853JvRJhfUh9U/0IZYwIN8iCki4SRuSm?=
 =?us-ascii?Q?BR/X5sNz2w4JLx7Yha3xPDqwGrr0+MR5IkcCiICprxhNpnnmOQxp4U8O1K+Y?=
 =?us-ascii?Q?uOCUmFn5V8oCqFatpzGwEWLYtGHRHC7eGp+IeF+dZmjqXPQFwMBDnquo5nKM?=
 =?us-ascii?Q?gTlqRhzSeETMCCDHWPr8/w1J7rc5zEws6kBRF+EAuDBEdQ+1T6ggszVRNz9i?=
 =?us-ascii?Q?bO7/TUkK+vPjF53UyJ3vBKA+pth77BlRmdVzkuvq6oA9dZ0RWlQmARtF8Hf0?=
 =?us-ascii?Q?y4AUWr3nb8dmZJPSlquuIYLdXWER/YLp6+qiQj866OHURCxaJjtkO5bQjMtO?=
 =?us-ascii?Q?7jv7dAyxDPlRmwDPAg0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1e7bf8-c7f1-4195-18d8-08daf7cd59fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 14:24:17.6215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gGDBqR4QlJdeDBxctFvb+U4go2WfC8Li6O7a0AADQUvcatNFLQpvH1u0DSF2i4Px7stRSkjTV1SGwDNd0DC6Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5327
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

A patch was introduced into 6.2 that will allow outputting what GPIO is act=
ive at a given time for pinctrl-amd with dynamic debugging.  This patch is =
useful particularly for debugging the wakeup source when it says that it's =
the GPIO controller.
I've asked at least 4 people to apply it on 6.1.y kernels and turn on those=
 statements in /sys/kernel/debug/dynamic_debug/control to debug issues of s=
purious wakeups which has me realizing it would make sense to just generall=
y being in 6.1.y.

Would you please cherry-pick this commit?

1d66e379731f ("pinctrl: amd: Add dynamic debugging for active GPIOs")

Thanks,=
