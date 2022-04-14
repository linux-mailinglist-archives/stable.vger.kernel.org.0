Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA3050124A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345420AbiDNNxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344960AbiDNNo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:44:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4641654BCF
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 06:41:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AG52hMTzNY416e7KGR7mIxLGuzHMCP9M05Ej+DqkRt/OqX93izc74TbjRSaf5cAxtiaRrjY54jVqHG2XVAWth73HrM0hKyrYHU5aXMcWPdAtS4JjnjvJ+3gBbz/U7g2vfruE1U8o9G25StveMJ3rkYxnqgJ5chP3teTsSrwsO1tRsJmOXZbCxRgiRMU5dT1m1nZF05V8uZ6iNrvGsvTiyS/sZpTsvlzQ2lK/VBqzjXKIU+pd3P3V5P5FM5yAPzkP7mM9PGvgizN66FkRXJqWP83n6SjXVKeiYjKvqKd/uAQntXkp+j0nrQoPDsGTgsdNdcrIhqG1Pc0bp32FJwyU9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TEEsrw8QUEETd4lGibPCjVGBnIOdj2SzpPzC4rc2M0=;
 b=HGm+Y7x0QxXou6FU0m9FjdYpmDFygyQQStdg31+tDv/F3w05oThggfP3ECSVTlsxfSTQiwFe3KOKbXw6DiVbMJUirusDxfRIK6Z/RI8TeTlJjFWnmeXNyp4L4t1OZ1izaG6PId+/7Wp8BQBXn6YzDvoXdOx06Ljeq6I1KQ+Fjb8cv5/3j1GUtVuzYyEFlatyemIjy01FPs38Z74nQieyuuj1c6+lhOsHQrhrLWcq7ltlnBLIPnJFXTk+FhbmUs5tDxhZzbH9e+q09FOqw74WykGeP2znO4xSRrC8Ih+jj27Pc3MDzvcP9IpAFg15HSL7zGl4N1XtJ+4hUMQzVAnmBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TEEsrw8QUEETd4lGibPCjVGBnIOdj2SzpPzC4rc2M0=;
 b=fH0DMl7WplxlDcbj5PxSJQ9dHCQ2wScrBJKYYVqLMaHrUMcfjYAdc8hJBC2Lh38tgDYEiEknqEwdC88rtJJjAhoKxAxjY0MpfxPxJ5HINwtfRp991rQoF6VoKp7KW8w5rSnso9rlvhmE9Un/8UTXeQ3k2VnM8R4n2j7o51XpY18=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM6PR12MB2747.namprd12.prod.outlook.com (2603:10b6:5:4a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 13:40:59 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::b057:2bb9:60d0:b3ad]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::b057:2bb9:60d0:b3ad%7]) with mapi id 15.20.5164.018; Thu, 14 Apr 2022
 13:40:59 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Yang, Eric" <Eric.Yang2@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: RE: [PATCH 1/2] drm/amd/display: Add pstate verification and recovery
 for DCN31
Thread-Topic: [PATCH 1/2] drm/amd/display: Add pstate verification and
 recovery for DCN31
Thread-Index: AQHYT0vlYdwJIV0LnUynU/0gPBi1aKzvOvQAgAAwtIA=
Date:   Thu, 14 Apr 2022 13:40:59 +0000
Message-ID: <BL1PR12MB51440309CA0CA8593CB02CDEF7EF9@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20220413153339.1436168-1-alexander.deucher@amd.com>
 <Ylf7UEKnjHW6p7Em@kroah.com>
In-Reply-To: <Ylf7UEKnjHW6p7Em@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-14T13:40:02Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=1fa84ed4-8cc5-4cd3-937a-e31ef59c59a5;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-14T13:40:57Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: e2b5c5bb-f636-45ea-bac1-f6fa859b0d11
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b45f9808-5e27-4921-25b7-08da1e1c68c9
x-ms-traffictypediagnostic: DM6PR12MB2747:EE_
x-microsoft-antispam-prvs: <DM6PR12MB2747336CCB4D4D9A650D91E6F7EF9@DM6PR12MB2747.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lliQ+gUnkIs4DgGSgqSA4EceV28ctSDY1Aloscg6yc3vGgJQikebY1RuQ09V78TdQrBmH/2QrNt+RHCzcrvUYkysollYJf4/T7i20sQz7zN4jAiRjGul75HwOO5lW2EVqzut4xaTgaA6djWQNeMrSxdCmLBHJzFFFSSD5R0dNioYYuiNujhvpS/VBF93XDXUfhKCW4OjFgJsMyV1H0ckYenH0vKEz68k54mZ0bka8Jkkpsoi9EGFF8aEEk3S7fbOS1+/QJUv/kM8Isn4MDwtGHcyFOSWb1hF1Xzp4C2vj/d4riQ6B0rHH8DjcEdq2RoDFMXv951Ilu4N00uXZSQJg7l2LOmPzjy9EXycLhwClAemmsI4itdfN9FuzWiCQuyQ7Ybc+5Myr4W+eeV6hhhGYgp1+rkJbU3po07ZkRijFUbQAQX98d6Jtwg8qAGHhSkRjcv07N7QLYSmmc0mn4qCigSRB9tQeYTvOwP4d5rSKS3Uux7n87E2rf90RWt9a7HQiUWyw5OdjMYAaP7CWjn3EoZEiVX6YUbIh+wcvvFxIurjlAVBP8ZZI/YXp4sJbYpAMHR1O41EZQTDGYz2m4GYeVuyp2yQtJTH4StOXg6qELlLjdBkW281V5pRi076b0gEBY23k4LwT4O/lgxayXdlwldpJW6jV8msqOxYJerxflEEsTTvASgXEfNO7GIQSzZ0BdFVjmRfcZuFKiLbXwrJvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(316002)(5660300002)(122000001)(55016003)(15650500001)(8936002)(2906002)(33656002)(76116006)(64756008)(52536014)(86362001)(6916009)(9686003)(66946007)(66556008)(71200400001)(66476007)(38100700002)(4326008)(66446008)(83380400001)(8676002)(26005)(186003)(38070700005)(6506007)(53546011)(508600001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yxr8Wr/TZXvsZKs08+Vsd2YD50F7pq6WR1VU1TSxIKs5mMsOkicNfyQzkBoe?=
 =?us-ascii?Q?8vPMA3mjbRsHfuQ1T7R4Yfd1xFNTDq9170bdWIUHURhtNDZUHbbLTUm5a6bN?=
 =?us-ascii?Q?4qgQPaRjWTIim+Vi2AAokYOKsbn2SjKLk1Ss1J21OKOQYlY+X0y4LRlHm83J?=
 =?us-ascii?Q?EiDIHQE9qUE2uSV+WP5HpO944YYWgAKKDiQcLLcwwT0KVtqL+P+WFrmSpio8?=
 =?us-ascii?Q?tWFkWMSD6VEZj/rBcEzqTFY71VtGg8PRlEHWIEOvqRjpdeIYeYfyfqtG/9Nt?=
 =?us-ascii?Q?NdPBvPwvLb2LYfLNkg/8Ja1LWtVEndg/2aYoOXbwWOBaLZYlHJfh2cizhU3E?=
 =?us-ascii?Q?4gM49BkU6PWl23rBLttYHxTwZVlFAylIh/xd6coqRYFFLYvuJzsUDELE0oay?=
 =?us-ascii?Q?8jyFXn8J5ui1TVrOHcEN5eJylkWE7MZ+zPMYXSLeKHNSOzgH+DPRxD3H1+CC?=
 =?us-ascii?Q?uP5W9pT3Uo1Kw9xoPJUDhBLP/IRbDudJhRWCS3K/AGHy0jmibz8lRmN2KxVI?=
 =?us-ascii?Q?veZHzXDMuTabzh/mc0PK5LCUVtynPKWH99PoXUwgHaJN/dFPw56hdfjgzgjK?=
 =?us-ascii?Q?dYsqxGnD/sLnMFkOUUcdkOKZz8/FwuB7Xo8GH3x/uTeMUTEvJ7T4Y/PSuZNQ?=
 =?us-ascii?Q?HL5zNqRAr/MqXKpWQ3RNLiar9DwImzQnpj0RKxKOVT95gJWjJkfiKKNF0oVl?=
 =?us-ascii?Q?wz+aGs9f036cPOROwp9e8s0eLV8xEs901TNgsATx0DVsReFbMj8XCmNw1PbG?=
 =?us-ascii?Q?Yt30VHXtn04jOpkKb20gR3FQskxuW6Pc2yNJYEs5BYnjHWKJRGwbMw7SIqDA?=
 =?us-ascii?Q?qF8mEPaVtj7H6sERDQKW6bQB3r1jEhbttGYTnjmnsWKoa5FyF+y6Me3CJJ22?=
 =?us-ascii?Q?HNHNZklI5mwtYCWMIQCiUSI+MabdaJ1lRi11cBdaFg0CraBNb+Ns+RROofCH?=
 =?us-ascii?Q?5oampozUlWqNJWB3iBiWsJCtKmZp1vQq+Z4zP/BPKI+AV0OUvULpGmE+bIme?=
 =?us-ascii?Q?LQ4UrCsmumDZbV+Kx9ffZo9+fonf+SIfg57CgbpCfE+/ZGv4Ur1nUIVNrJSL?=
 =?us-ascii?Q?K4xP1/2qESXqV7+uwGJtL9r38rDzk1/KhmfGcYj2lO9vFLJM95VnQHFkY5Bx?=
 =?us-ascii?Q?uglSg22LfCPlnJa72+x7ODnag0ru9Kjt9+nz22zmsPs9KrzRPcOlIfddFZSC?=
 =?us-ascii?Q?mym5DuZWY/Heqp0aG4pNBrh6JR1/KU9d30lA9TnVbZOwhDa86SPiviyliSps?=
 =?us-ascii?Q?kQmD1s7rQiBYeKh3ubDrcp0kCxGtDjdd5Xhc1VTNrBS+FK3RY+UlDfm8kquI?=
 =?us-ascii?Q?ZcMYg2sE4iUeb1jSoZBYzlBSy23pMHjJF89vDRf35Bnp9bHN85tteXNbFwHY?=
 =?us-ascii?Q?s2bFOWp3YXYTeyfIgtJ43PGCqMEsF9NtyZG5H5H4KzDn1HcKowpfOv+HoZxf?=
 =?us-ascii?Q?W1FuLa2q2dd9jkoIMfuqQUKw2qdmHzSY5gky5hmO7nOs5sxa/SyLLI4mjJWS?=
 =?us-ascii?Q?Fxr6hKkUwGlElO1V0EyPjho6R/jHYmeLCgbQeb7/ISZeizsqa5k6osxZ3NnM?=
 =?us-ascii?Q?LYw+ybz6ztb4pSM/ud594OBtwHkU/jNGHOsuRImF5+s6lQOb2tStbFD9KGPq?=
 =?us-ascii?Q?CaOahqIouSQ3u8r9vcqJPWeD07mywtiB4XeqgLAkthT3VYzqKuStRASTI8kN?=
 =?us-ascii?Q?LGje3NLxtxu8lTjmfQvIDQQDV6XW9xFEp8L6U76UzX9FFh4p0+r3vXrX91+e?=
 =?us-ascii?Q?i3GSJo7I3Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b45f9808-5e27-4921-25b7-08da1e1c68c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 13:40:59.0714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EubpDwUA6x5SYljw0KbibdAK3BTExYW4EZMgWrjjKVQ4HQkNorqPbdsp7Szpl8Yj7F9d8zrwxKPmzFlobShkGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2747
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Thursday, April 14, 2022 6:46 AM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org; Kazlauskas, Nicholas
> <Nicholas.Kazlauskas@amd.com>; Yang, Eric <Eric.Yang2@amd.com>;
> Wentland, Harry <Harry.Wentland@amd.com>; Gong, Richard
> <Richard.Gong@amd.com>
> Subject: Re: [PATCH 1/2] drm/amd/display: Add pstate verification and
> recovery for DCN31
>=20
> On Wed, Apr 13, 2022 at 11:33:38AM -0400, Alex Deucher wrote:
> > From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> >
> > [Why]
> > To debug when p-state is being blocked and avoid PMFW hangs when it
> > does occur.
> >
> > [How]
> > Re-use the DCN10 hardware sequencer by adding a new interface for
> > verifying p-state high on the hubbub. The interface is mostly the same
> > as the DCN10 interface, but the bit definitions have changed for the
> > debug bus.
> >
> > Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> > Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
> > Reviewed-by: Harry Wentland <harry.wentland@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (cherry
> picked
> > from commit e7031d8258f1b4d6d50e5e5b5d92ba16f66eb8b4)
> > Cc: richard.gong@amd.com
> > Cc: nicholas.kazlauskas@amd.com
> > Cc: stable@vger.kernel.org # 3.15.x
>=20
> This does not apply to all of those kernels.  Please provide backports fo=
r the
> ones you want it applied to older than 5.15.y

Argh, sorry I typed that, I meant 5.15.x.  All good.

Thanks,

Alex
