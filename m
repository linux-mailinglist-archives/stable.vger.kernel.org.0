Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF93610066
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 20:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbiJ0SjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 14:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbiJ0SjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 14:39:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198BC9410B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 11:39:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdnn2fNK7hu9tepzR8dFuGfWWqNmzL3gS609BfpBS/vOl22IIkLiJ2dWCtWqMqT2WNtU5Qv/yjKMrdWUPakvt0wfcbiCwcuk+0PKlCMUU00KG3/CL1KiTV/36JkZIlkSHVhndFg9MIDuU55gEuwfuBInbjgQlmpzA/0fQEPaTOpPRRErfubAzWoAQ8uPMOnO3oAANh49/iL9pfW4JoK3tkNDj2ShzN43E75AeilgYG4oWpXOGdJWcoR5XxRV16LoLdUVXlPbOUJ4iODKB2WaVnxPUuE4/cJ+CZ66G3KY8/CUh9y8kEdHToTE0SxaKoEqcvRN8+BGdvMWdy/7Vo5obA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FtmyzzzOwYC3b+9d9brI1s00OouHJzGslK819Byur84=;
 b=dE8CR81bsm6+UE8hTmHaMmYtoHR7CHRezGaxwXPwd9KXbKRKeYFrf/Jpe/DN3Qf1I17T6uCMI4Jje/11+ix9l1kf5aGW9JHk8ERQT3n7x8IaD26NTlYT3VT7gCVpwb9SStYMlmsr5Jrewjaod6sQoyQ8vhBJeqdWSokkwrAK05RcPsU9EREQUOGIM7130cTCzoP1kkts1fq2bnIb3A23C+QWs243Tsv6lcbLyzUSiPhwywRuA5H3Ni/B9wf660QECCUFKfKAPXFyeiKicRyyR8C5S5q3LPOwtWcF4aWCxSg3X+qCG/CmdKAJ/zEQ8IkgD4QMCysB4H7u+hd9dyDgPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FtmyzzzOwYC3b+9d9brI1s00OouHJzGslK819Byur84=;
 b=N6fiYscmlwyHpuPM9wT1SuwheCy+7Rp5fauy71Z/v+tMgK7hS40UfbhBEUO4vJ3vDHcg0BTKWZ74VQSzMK1aT+Wl4gLRfC0CIUOFegzu8TNWTGnqyebCfLNJeRotmRJixt7KdZvgocmlLWalG09vhI58YNj7LcwrReawJSVJ4V0=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB5071.namprd12.prod.outlook.com (2603:10b6:5:38a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 18:39:16 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f8c0:db03:2d30:792c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f8c0:db03:2d30:792c%3]) with mapi id 15.20.5769.015; Thu, 27 Oct 2022
 18:39:16 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "post@davidak.de" <post@davidak.de>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Fixes for amdgpu drm buddy allocator support
Thread-Topic: Fixes for amdgpu drm buddy allocator support
Thread-Index: AdjqM2nHoMfNDH4DRSSuRYQORh1+pg==
Date:   Thu, 27 Oct 2022 18:39:16 +0000
Message-ID: <MN0PR12MB6101D368C4AE6F2A142F4C5AE2339@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-10-27T18:32:49Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=49de67ae-3712-45e5-b273-3a1536d88462;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-10-27T18:39:14Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: ad681210-ecbe-4965-ba47-8c67f44b669a
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DM4PR12MB5071:EE_
x-ms-office365-filtering-correlation-id: 38b593a9-898c-40e6-63a9-08dab84a8d29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zUAo2X2aPsKNlo3KLS+skAbQu3/HRPtUuYat03BUy7gB3XQNSn52Qakk4GwnZoRVVdZ17O5ZCOW6HDAd6t7CaP3zsag5XR2h8Qpturk1R2/TBKG5fRuBWCRneiM/Vmnl70hiasVg3oM+TjP3Ma6kRAM3iM4/R5ArJ3I3jm2uwcj0L9la/HR4sxXu3qE1x4qSWeHrW5kQjqGbGVN2rsoe3dXaQ/mudsdO6x17jENEdMd1ytQs7LZ/XWRSAnNy8TaIqGReoz5zMmWgzgjlio7Rf2/y4/jeuskieWvQXoGaUUzpoN28I8mTwP7UVcfZY03y4KJGh6ITL3V4vU+4QKPfHUsHY6WaiDJTNAL50rKXDzNPmwCCQciMsdH/tpWYaIMarw1wZ9xBvi7GEiBOhYY1S7TYLPHxpOzq5quok0dHhySfp9x2rEyJdHy89VvTNAcz/ptjFyu0CEq5XFotyQjQwLBlrYmFgvf0xbwMPMBTpp2q/3aOwHzlConUzaZIbwjdIXKJvcWGyMPt0h/aAjzI9QliMAulGDJbJQ5YLSafH9E7GlCjWHYnNE4jWLlXoCkBEBU4skpuChKWR1RQh9wRbPCDcgiqW9KcjQcE1kSV2lG3rz7HqStieU4edLRIvk9X4fFK/ZLcWCvrQoy1J1rfhT2obyBJDX55BZIb4/l9CSHCbTeH41lHczoxsAmt+rb4OT2WMOxVeUExaG2tShooNYVb8SzXSj91+0pfNXCbPO+lTDjjgoP7u7WooxjDwZ36Bb+f+AKXUd7x80aWb8uVwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(451199015)(186003)(478600001)(6506007)(33656002)(38100700002)(2906002)(38070700005)(71200400001)(4744005)(55016003)(86362001)(7696005)(26005)(9686003)(66556008)(64756008)(4326008)(54906003)(8676002)(41300700001)(66476007)(122000001)(66446008)(76116006)(66946007)(52536014)(316002)(5660300002)(6916009)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fssEyGL3q9eomtN2E4XpYJMW3+R5FUIQg6W4jXLBdOMDYAUSabOvKW1vID1I?=
 =?us-ascii?Q?2Gxt+ewxy5OYQybXzQi9IDYIvSPIocDHOKcmBSlxcfsvDG54vfaIKxI/q06i?=
 =?us-ascii?Q?Y+n4udxy9pviceTGNTxfpiG4/1eZ1kqZbbNoR1btXX6eyIDjacgoyhdu9QyR?=
 =?us-ascii?Q?hy0B4742Z5JOs3LLMpSe8YEDKW7olCFuAjpRXzaLx7LUsF8iRO6kn1Jbbqp7?=
 =?us-ascii?Q?BX81dq6aFiU2Zvli1dpoJIEB/DbG2GUu2HH4SKXko+/HdCcMRmvZVoJVzIU2?=
 =?us-ascii?Q?5FVeJA5TBMguO1Ueq1sdptQWQBJjhfVHo96zutv7dHNpmk1ynkoGXppVapgU?=
 =?us-ascii?Q?rsBqy3T19Of3rBlzvEBk7QSvHRc5QS7JH1aj5lH/DhXCgeZJhLiPJjpes9TD?=
 =?us-ascii?Q?Uds3cMXWQ40Xky57Y5uQIsLBcuTfBzxwLOLW6ZclQuD9SadZE/5KQ0IpVl+f?=
 =?us-ascii?Q?bgRuVMoAC1DJ1jX9zOXWhrErrzLKba48Y8FuNwHUf1IioH0r5Vgeo3e1D7uD?=
 =?us-ascii?Q?Wqnr23aEP79dvUIT3tLXtSuYNBqdANfH96q8sry6qK0aVhEmOJJzTjRwbXEy?=
 =?us-ascii?Q?O90v7qwf+oWZJJ+h//bkAUsqBmMSSAQE9fcuSAEvhwcjpF6FYQV8pplFmwtr?=
 =?us-ascii?Q?kJpbxnNY9eC+OtdOICf2M+17pwteclOB2g+ukEYU1rZxqTQ2T++/3PMszWYy?=
 =?us-ascii?Q?CVuQiLW8mgxeHVFRTEmKHygJTSNINqmGQa+9q+avIYLEG7Nsh+TcYyZr3tUu?=
 =?us-ascii?Q?ihaGEVEY4ykBnE+o+Lp9tA2ujF0xUazszZN2wGLu6HO9J8aI+NRs5prCiTZC?=
 =?us-ascii?Q?pTDJv/e4bafyNTIxjqpvpyv6p6Wv3X4Bnz9vDVKaMIf2J+suRXuUZr8M1l1D?=
 =?us-ascii?Q?vl3iI52N7smv+2gHo4qDinXxCkWc1lE+ttmJ7sMofj3ujYrUFBD4Zt2vJ5tL?=
 =?us-ascii?Q?AOg6DiHpA8nqjBge+M+t8OHVnvOEcY4tEgOmZEAvTA6G10aSyj5uTBVCp14B?=
 =?us-ascii?Q?d/RBfb0bXvM/4UnFdn7vMtYXEbMoKLwTSg8/IIm43yW0D49PZ3ZK18IwLFv/?=
 =?us-ascii?Q?svXHv34F3SUB0rQTyggV1G5yLq+6W5/hR3F/p23zAJ/BDs77cBQ6pDq/NS1y?=
 =?us-ascii?Q?5NmHCXJBH5PysGrxOQEM0sBFSX3BX/h1jrjePsv/sVH3IIunQKwAAHPsF5Bo?=
 =?us-ascii?Q?3RbFt4EHWqI7AK0jOn08MsHAc5/iz/eUbagjaTuutsKC7sZmP8PXXEV80IIU?=
 =?us-ascii?Q?MUUeVjfPm0iUBUca/l7fspHouocYlJ0Z8xPzUkA7lgjwgqKNOYm3MBk+neIx?=
 =?us-ascii?Q?TJTkUzsDcIBQU7AYfRI1Kf4hRfZg+0xUOS0u1j1TjOs2iwxF+Vo8vXc7YEf/?=
 =?us-ascii?Q?oZkfKXUrs9JnQY6X4vkUVSZX9GlTexhksm+SazzSfLZZPirxpvPfNNrNNLEj?=
 =?us-ascii?Q?mqA8U0FFTMUfiuqD40tVezQEzsZqYSQMOaDlN31ZMj19OcayUhbYkpKu+QFL?=
 =?us-ascii?Q?atoVG1BhX+/5FkhBE3OgM6QBIzLa4LfmeaByeJPuFWgrvaeMocUz1AZiS4cS?=
 =?us-ascii?Q?T0aBQjI9sxyvg+gMTHg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38b593a9-898c-40e6-63a9-08dab84a8d29
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 18:39:16.1424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OdLTb8ljWQgsUIQMo2zvPhQSziG7TU6/OrEyw2wwtMUHS8Mc2K6MSQ+aPjWiq/3fQAov9QPX1OgCA+BnSbRy7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5071
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

DRM buddy allocator support was introduced for amdgpu in 5.19.  These two f=
ixes went into 6.1.

312b4dc11d4f ("drm/amdgpu: Fix VRAM BO swap issue")
8273b4048664 ("drm/amdgpu: Fix for BO move issue")

They were tagged with "Fixes", but Sasha hasn't grabbed them yet and there =
are a bunch of issues cropping up lately that I believe will be fixed by th=
em.
I didn't see them in the queue yet, so can you please take them to 6.0.y?

Thanks,=
