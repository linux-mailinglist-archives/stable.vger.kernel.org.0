Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B5769EB04
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 00:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjBUXKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 18:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjBUXKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 18:10:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71902B288;
        Tue, 21 Feb 2023 15:10:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5GLeRq1eBiLajqGL0HCC+Eln5CblhxFJtXPSroDU1gAAmztC+64hekqOxfeJ4AQhc6cJ1Arlc164thnuAXXC0UujuIR5zNcjsBvSou9G3XUQiX/+DAQSt5t3YG4VBnrsfYBYkl+KA+1/CwQ8RUGCo+ooSg+5aRL/uv9p+JlQfxAvizfM12XPW/R2DaCwUxiqYKHw7z04a7Au8CO0Us15RWrWFgF2rarawQnqZuq77PjD9yQ5Rlg5F8i/Od/itMNmV2aKE1kNLGklmjKjj9iTyRGd25nKgHBLS8W8Vu6p0IDRPp9avwEvdAIesl2Q6y+Ciq0NQTbplyrcFsehUwIFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+dQJARG3toRcUcCVkDnipnrCog/4usPzL1V7zcKe/g=;
 b=PeNL6MOPYDdxA8hctNaWX5OhxOJYjmDtdggXkahTsZFiWfcDUYHg3HYZSKEL9clXoQluVZ9mCywo1GZ+XrH3m6N6IyljwdJz+V6qz5hJI7fDViJkOdPyWRd1Xht+C7FONAZk515GzROO70a8Q5R6mBLbDXmDpdT2zlOxM7li7x8ZvWZuI9Hhqwk7nEhkgwmQShbZzwUWFD1Bz8XDA5DQF3kw1KpE8I+mqYp3rzFDuHHnOMKVo4u/3oF+JjT300pvOavQkkqGs9YBHMTfAa1vsjpdZo7ybmIIZ+wjOkI6ZTqzV+AJARn5VoQq79D1AKH1OdOkp0nJ+c5pwZEMlzUYGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+dQJARG3toRcUcCVkDnipnrCog/4usPzL1V7zcKe/g=;
 b=WsUM/aPCobsilQY+E1p+wfR1jTWPshtWyTN5FVZl/+RRxFIRfxWN4jVhN9ZLyvFCiJVeDBox5aCbW4QZNzL/GtgPG7Fra+bgCAN0BQMVCQO0HgrVU33BLnFCgqqeEBYh5GniBk115YGQ8VGnE5C/dYh6cqXeJBMorJYkB5ORxEQ=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN0PR12MB6223.namprd12.prod.outlook.com (2603:10b6:208:3c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 23:10:36 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%7]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 23:10:36 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Subject: RE: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
Thread-Topic: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
Thread-Index: AQHZQLHBM0eUxLeNWEioDgDkCuwm9q7TRNWAgAB6HQCAAEBTAIAGDfGAgAADsbA=
Date:   Tue, 21 Feb 2023 23:10:36 +0000
Message-ID: <MN0PR12MB610146866686D09CBFEC7AA2E2A59@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20230214201955.7461-1-mario.limonciello@amd.com>
 <20230214201955.7461-2-mario.limonciello@amd.com>
 <50b5498c-38fb-e2e8-63f0-3d5bbc047737@leemhuis.info>
 <Y/ABPhpMQrQgQ72l@kernel.org> <03c045b5-73f8-0522-9966-472404068949@amd.com>
 <Y/VLYxAqmlF8nbw3@kernel.org>
In-Reply-To: <Y/VLYxAqmlF8nbw3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-02-21T23:10:34Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=f5593078-d5ee-434d-97c5-cc8d17f98ef1;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-02-21T23:10:34Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 4368a0f1-cd0c-46b1-8008-eca2a6434b1a
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|MN0PR12MB6223:EE_
x-ms-office365-filtering-correlation-id: d2818932-e40b-43a0-b70b-08db1460d75e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3X5MwA6NEsD7VnQgsnaCnugMCHr77XJwRWxjnVHmkIhzeNfFxhYp8etopY6GyrXXddx9QwTXILj9pW/G56hiqPNjOGTak2tQbGvDL1LPITC1b0xJVbsrsQnA7vXky9MMvwOl6f0Wab4SBdOrRpImk7Mf3gS/EX0r6yBTDYLn0PD3R4lyGjOpNK72gTIPX+CQMwws3pfbInqrWIFVwT6Tu+pwGuwMe79spMQy8+thyxfKtvwMDxLiyoP+N2/iaX1YxrjGRQmrEnP0TrIs4T9/7zXF5eLhlwIddQ3vdBJQmuxdHb63bhsR+3MielJJjWHw4ZyZzOBCGxP9/TojRBZGvMa8cu7VIwjg0CHRvPdliXvUT9Zt6iWTIflOe2WOia8MEBlzYyw0R99bDz5Ec7XJK7mHltDIODgtU+i2pqD7DA0PWC7RJKAT6ZvcPYaF6++M1nsOAQIFHIAIDsE4bEAz9RlGRui7j0PSYdclgZTiXbtrfdyDU/PaVlwXAexwrX/MKHNZD8VFYlwMgT6oGXzUGYa6Gle6GRqKHic8aqf4UaH5gHeWgKA1HT3Or+8aF8GVZU5nxHzGAjfqkeikiLoi/JNH5moGOusNQ2gmHmIb7fsuOerE+OI5skKmH8WvzA9+xYg952beHk4sJCAgltLa64N9n3ZnSSnajhHRXMFJ8kQN49oyD6wG0uXMhoyD6yWe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199018)(186003)(9686003)(966005)(71200400001)(7696005)(478600001)(6916009)(55016003)(33656002)(38070700005)(86362001)(66476007)(316002)(66446008)(8676002)(64756008)(76116006)(66946007)(66556008)(53546011)(6506007)(54906003)(83380400001)(4326008)(41300700001)(52536014)(8936002)(5660300002)(2906002)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8vrMaYOd7TJhb3RF4LARkTYhJ6oKFKBW0dlvS/JF8pjI5LMnpWjv1gg5MdgH?=
 =?us-ascii?Q?XSrckaYFoZxT3OqzAOxy78DgoLQJEP2BHfsgU4rJMqFqNHVBymA3njll1kMp?=
 =?us-ascii?Q?jJpoU7I+D0nYRc083rzsN0nfNFQfTp6e0joM2sDMQNs3wP6kAxbo3jhrw4rL?=
 =?us-ascii?Q?2dCdAqRmcioe0tuf4fvdAS+6FhMkMY3cNtoZxABVLBRz63IkhorhOMcscqxd?=
 =?us-ascii?Q?nL9tnJeZ5/GRqZQv7Q4BqBjoYMwbIIGDfFG3ohlN5rSdyVq+2eJo/tcGxOWT?=
 =?us-ascii?Q?cG414AL7Ks11JYjmg3kGA9VBgDaONpXlwNBN7FnHwkd0nt3gHpYq3AlEuVVJ?=
 =?us-ascii?Q?UwmSKmY1QiSuQGwsL3SaKjtKFVzQBM+VzyRtHL39xThK7OvW73jFzemBm/Ai?=
 =?us-ascii?Q?/eox73djH1tZ/HpINfcXeh4GmWXeVRgFRwzvq9qvKZTTiOW5/ZjdND3rgoz2?=
 =?us-ascii?Q?/myxgl3ufl89+eT9OqVmtfR/wbVC0cUwCNFHrgm2LKK8c402PPAAporm60Ct?=
 =?us-ascii?Q?bi6EWg9zNQ+QG3HmL2wKbvu+MukaDdGWFkklORDSOJFwm1JVAhDQ42YBYb1c?=
 =?us-ascii?Q?Gzdyp4ulERiY+YVSEr/I0EAnCR/bWroJeC3brOqxbOFVdBn/bexGEyUkq/tx?=
 =?us-ascii?Q?qG3Epkv1jSft3R57ioZ6SHk0GqidbLgjPtVXNJDWlLQzmouc4jDJomMMmeiR?=
 =?us-ascii?Q?EZfRhvmUF8FrlLKIneDSGF8EqinuWuSL3NAZtTkKxsTjYsl6mrE94/1+5Lss?=
 =?us-ascii?Q?ZJ79g/tdMGKu+eOJzPRb6kFefPpJtg+IUzzLg2VbcZbywSYL9vNN3Ayh0JU1?=
 =?us-ascii?Q?A1/uCjwLJKIaWC9m8ita5sPnc0zf+RbmAYggvJJQts3P1xQ0PKKMU8S1fKL/?=
 =?us-ascii?Q?RaBU0XP3DkrK+1Q2C3afKjUEDgvh7rNIhARRUoXJpNCCr5yD+8u8qas2UUhr?=
 =?us-ascii?Q?u0H3OdlZmDC+61lS4749+6hmO0nVrBDXJc7NipD8ifYhzG838geKZnnih7as?=
 =?us-ascii?Q?pkSaOy3qQ8rb9DelRXEbAvtlWwrRrGZF4JSheCVW1zIob+Nlna60Tg/XCiRe?=
 =?us-ascii?Q?K2WdnnMrs/l2kzqwUmPPePiotL5CUpOsM+MOa8ZFNFH2Xv7hOTS52dslmKVP?=
 =?us-ascii?Q?6cAFwHEL5L2UDl6ukVvQed3bywwFTMeCnDYxBp+RYjLLeq+9fPmV2MABs+kM?=
 =?us-ascii?Q?OzcLt5mzbIzxplUMDuNW45ib03FnuNjBN5hnqsxIV+B9DovkU4oxyaCoTX0V?=
 =?us-ascii?Q?+Fkkk+JRZwfI8tHZwXCFljxtyFF3tin1ZgjjGCBGnIQ5/Ze6ysskgOMCdHKV?=
 =?us-ascii?Q?oWfJTDxzc2khl/M3jr1nfZV02GKvSZnlYJKBOf5h9ZdoSIb/L2qiwgKMdeOJ?=
 =?us-ascii?Q?TIvbK1HP0hB264qWta8AhYje4fy6BF6ddq//tObmM9mNXSmW8aRHK2i/UfSR?=
 =?us-ascii?Q?5fytkVQmaVAlrlGg+UYZh27Ybt0SmP5v9WS39NuPjydMzZ1ubit9GKs6RhTp?=
 =?us-ascii?Q?HLc+aNiSRLOHHlEeiYxZV52eZSXqGQJfElhXDsh9ykT+RIC7Wf/onQ4W9KMc?=
 =?us-ascii?Q?3D0h4prue+vl26T8LeejkFwXBhx8CxGFBZe1T7TdBWw84omYLDkAhtrVxOxv?=
 =?us-ascii?Q?l4YCN4LlL8+8mgB/gFx0WnY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2818932-e40b-43a0-b70b-08db1460d75e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 23:10:36.5156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kQeSrLi78g9lORIHiqhXdpgwg8cU9GX+BHjNip/bMV6TUjONn/w3+gNwnsuVVP4hyu0o8D/Ww8I9NlH/p4ZUyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6223
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Tuesday, February 21, 2023 16:53
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: Thorsten Leemhuis <regressions@leemhuis.info>; James Bottomley
> <James.Bottomley@hansenpartnership.com>; Jason@zx2c4.com; linux-
> integrity@vger.kernel.org; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org; Linus Torvalds <torvalds@linux-foundation.org>;
> Linux kernel regressions list <regressions@lists.linux.dev>
> Subject: Re: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
>=20
> On Fri, Feb 17, 2023 at 08:25:56PM -0600, Limonciello, Mario wrote:
> > On 2/17/2023 16:05, Jarkko Sakkinen wrote:
> >
> > > Perhaps tpm_amd_* ?
> >
> > When Jason first proposed this patch I feel the intent was it could cov=
er
> > multiple deficiencies.
> > But as this is the only one for now, sure re-naming it is fine.
> >
> > >
> > > Also, just a question: is there any legit use for fTPM's, which are n=
ot
> > > updated? I.e. why would want tpm_crb to initialize with a dysfunction=
al
> > > firmware?>
> > > I.e. the existential question is: is it better to workaround the issu=
e and
> > > let pass through, or make the user aware that the firmware would real=
ly
> > > need an update.
> > >
> >
> > On 2/17/2023 16:35, Jarkko Sakkinen wrote:
> > > >
> > > > Hmm, no reply since Mario posted this.
> > > >
> > > > Jarkko, James, what's your stance on this? Does the patch look fine
> from
> > > > your point of view? And does the situation justify merging this on =
the
> > > > last minute for 6.2? Or should we merge it early for 6.3 and then
> > > > backport to stable?
> > > >
> > > > Ciao, Thorsten
> > >
> > > As I stated in earlier response: do we want to forbid tpm_crb in this=
 case
> > > or do we want to pass-through with a faulty firmware?
> > >
> > > Not weighting either choice here I just don't see any motivating poin=
ts
> > > in the commit message to pick either, that's all.
> > >
> > > BR, Jarkko
> >
> > Even if you're not using RNG functionality you can still do plenty of o=
ther
> > things with the TPM.  The RNG functionality is what tripped up this iss=
ue
> > though.  All of these issues were only raised because the kernel starte=
d
> > using it by default for RNG and userspace wants random numbers all the
> time.
> >
> > If the firmware was easily updatable from all the OEMs I would lean on
> > trying to encourage people to update.  But alas this has been available=
 for
> > over a year and a sizable number of OEMs haven't distributed a fix.
> >
> > The major issue I see with forbidding tpm_crb is that users may have be=
en
> > using the fTPM for something and taking it away in an update could lead=
 to
> a
> > no-boot scenario if they're (for example) tying a policy to PCR values =
and
> > can no longer access those.
> >
> > If the consensus were to go that direction instead I would want to see =
a
> > module parameter that lets users turn on the fTPM even knowing this
> problem
> > exists so they could recover.  That all seems pretty expensive to me fo=
r
> > this problem.
>=20
> I agree with the last argument.

FYI, I did send out a v2 and folded in this argument to the commit message
and adjusted for your feedback.  You might not have found it in your inbox
yet.

>=20
> I re-read the commit message and
> https://www.amd.com/en/support/kb/faq/pa-410.
>=20
> Why this scopes down to only rng? Should TPM2_CC_GET_RANDOM also
> blocked
> from /dev/tpm0?
>=20

The only reason that this commit was created is because the kernel utilized
the fTPM for hwrng which triggered the problem.  If that never happened
this probably wouldn't have been exposed either.

Yes; I would agree that if someone was to do other fTPM operations over
an extended period of time it's plausible they can cause the problem too.=20

But picking and choosing functionality to block seems quite arbitrary to me=
.
