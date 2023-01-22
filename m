Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376DE676A93
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 02:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjAVBsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 20:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjAVBsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 20:48:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3978C1F90E;
        Sat, 21 Jan 2023 17:48:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBL8wEqrc34fUHEORCud4onYnmvq2i5B9xS/eaoQOPiZO9bTvQ2uPoyr4mmePA1WEQi5oFI+ambUaALtPo1QVxMSepDFjaMI63gNG2TeZks2RFkBfABo/we1xR2t7kftJgqL7at3dhZhBnZsDW0CZv8hsqSj070RzAReG7SR6ptt/SS+RX78cjpBmTCJsxZdd6d3JdqJSSph7zSlzW4HMAxUjsuuKC+jlJsKPTL4r2P2ymoC3CYmHweGjcnh3W23iKge9FLlhX9DCgnwXHcbM7P889OjonV0jZRug9L8KEySsbwrMBLAlVmATK3m4hZWHlcsJXCAX0V0rIDjHGDXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DnkZg9m6brY01sPZvgV7y0/mrm3kzdqvEZwwsr0gB3s=;
 b=cLJJ8+FfdQIhi2s7L+H+Dw10/42oQ8obY9NeEEpU19sMHgGGhLyXAzt1Ge6GBH7qAedKCxmu26Rl+RczIZkxK+p57k4+xc8cFMgZ7gT6OHoEbf7BNOj6wfMLQwXiD2HYABeeCtIh7ozB5f07KBibF5+f7qWOsGXxYJDFtu43A7PCHutI30CnSGx2Dh7P8e8QehUenJcwgeEDH3eGkqY/H/1bH7kqxKPVuN1nMJGnsXgj2+yhrW9gIvtnQk40ZoZhwMbO6j+3Hd0ZnpAbPGMw1gmZ5oQvzDia3AvrfQ2lM+HiIw1AKC4TVG/Vd/FBuk8bcbUM4gQrtWv7EHD4WQSAfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DnkZg9m6brY01sPZvgV7y0/mrm3kzdqvEZwwsr0gB3s=;
 b=kfWddTPz1Sq2g/Hu7L9u6gdMo3CJl5qIr9Bdjg9/O7x70c4cATvyf8efibAsrP8RS3fbQEa4IMkxJm+7p3/78Fh3FsH0ZbcRuh1SBLgATgkTDws6J5i0nm1dtv6gWQylwoqH92p26OyyFH/nx2c+DVB/hgdJiu/thhNZuxOFC5WKKg0HD4sTbAOSPUbTNJC7QfKQnx6SVaDJmBFOjCsZUTqv3gjURKW/LZZKHWGJXDvSbU1YmpzmlqrZmEwScjmgMrErNcIt97pyMWd0zhM1l4V4MtpOETvLafuK+AuQpAc2VtkCw2xIpszeTai9wyV+L0ykzEsglYmvvC1gXgQiUA==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by CH2PR12MB4101.namprd12.prod.outlook.com (2603:10b6:610:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.31; Sun, 22 Jan
 2023 01:48:35 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc%6]) with mapi id 15.20.6002.028; Sun, 22 Jan 2023
 01:48:35 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "shaoqin.huang@intel.com" <shaoqin.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [RFC PATCH v6 1/6] KVM: x86: only allow exits disable before
 vCPUs created
Thread-Topic: [RFC PATCH v6 1/6] KVM: x86: only allow exits disable before
 vCPUs created
Thread-Index: AQHZLT0752AEQSVew0mY9wO2FUfPXq6oeU0AgAExd+A=
Date:   Sun, 22 Jan 2023 01:48:35 +0000
Message-ID: <DM6PR12MB35000D46146BA68EE294953BCACB9@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
 <20230121020738.2973-2-kechenl@nvidia.com> <Y8uUAFv9Qz7GvSei@kroah.com>
In-Reply-To: <Y8uUAFv9Qz7GvSei@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3500:EE_|CH2PR12MB4101:EE_
x-ms-office365-filtering-correlation-id: 4fc73842-1d4a-4d49-2483-08dafc1ac666
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jQxcBAmcBdP3gspEWiW4LRG1Vl5rSS+KV6qVLcREG7pCqxZu0qX0pU5+J+SVQDSbPVz0507GlWWUuADIuQYpOVOqodoKQgrCgz9T/i4m3zVhn1SKGzRQAiVsvWUYmY88uUAl/w5AFPlhj5PM890VFVww5x/5CEd8Es/XvKWJZoYPG42YAD5J1+SvAfGzmpZMvaikk92GQlOkNwewLVvA/ZSvpCktKlX29X/EkMCumDfWTgDdUGFklw0LQ6+l4726pdon3pTvJm0NlU/zjOHCoQk5BMYo2K2Mi2RTZfXrO3a3IpVhkzXJDPjY2HALpPOjcnXHhU6OalKDezP+0vYGEiGBOa0ktPiD8RHnMk7HzrmBfuIY9j7y0qDCiHHjuidYB3kwzOKRsq1H6tgrb8wYpOHKq4VKYCHPBmBuCkaQcT1UBaJjHBSVposvmS7+3TJ7UGKrDoicYQMYYrnSmvJu4674aimnAbgP2D/aLFYt8bTEQMVGCBKkUryBiIFKAuQNPjYNxr0aTRyC0dZzap4IqPpCZ6KFF/rwN/o7uvciyAXoDTN2hY/9CwmRUgNWHQL+wrT5IpgSqavptv9ub7z3xGpvi7JB9vo5KZk4Q/RvGHttx46IOORE4kLITV5/PgPOlwt/rBi2OF7gvzuXDQcUipJ1uNkR13RHZXxg4EE8Gm/ZdcLc+QKBdzaQo9IEgmXI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(316002)(54906003)(86362001)(38070700005)(122000001)(33656002)(38100700002)(26005)(186003)(9686003)(83380400001)(6506007)(53546011)(52536014)(55016003)(76116006)(66946007)(8936002)(6916009)(4326008)(7696005)(478600001)(7416002)(5660300002)(71200400001)(66476007)(66556008)(41300700001)(66446008)(64756008)(8676002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0qPyxAE/9OlFBB1HuJPXd/GKS5Viek0QjUnbLQfPVpcve0JFmlPYf8t+KA/P?=
 =?us-ascii?Q?vZtSOhYMKjKPBKp3VqHlWeeDEVE9nGTNDNAT264WBKv2flWAHk0fW/soU0Ra?=
 =?us-ascii?Q?sN7CZdzEpCieEvVrjblPzHzfg8ShJrtv58vIcE2LyRnBbaAUaq+cs63bUIcL?=
 =?us-ascii?Q?Za2AtYiYymgKIcmA7HBi+JNA1TWW1VWCsNNCRztb+D1VD8PniUotBgHOSLX7?=
 =?us-ascii?Q?kIXbUQZ2hqWgKu+l+8Ez5nrWjDKPJJ6eac8yPX0aKXcA54CfLdknk/yv7cW7?=
 =?us-ascii?Q?Ajx9vmCxS/BIZgZHm/wSAiWZ5oG2mqBGL+dXWr2XhznZPptqSQLRKt3GCvRh?=
 =?us-ascii?Q?ZCfcB8DK84FsnLuu0MWBymMG/Go2uF4gnXX07Mre2ziefWBgXgVegl/tKW0j?=
 =?us-ascii?Q?JsaCz94eoMSfkvd9C+cd09UbUFpDMvUxRI+AA36lOu2xSyHzj6LcG6EvjtW+?=
 =?us-ascii?Q?VhaLGIuRJCbBQRcpR4zuyKhKLJcY5riA9J0i9dJSDfhZbnb/NR0ZihEnpr34?=
 =?us-ascii?Q?1dZLSUIY/nGf9H+HZHNMWc7ZgyW6oAwbmvlOeY8NxkDJ9stvAOeoYW01IDG7?=
 =?us-ascii?Q?FjO7FnJulpcgwfAJNMChVjo0yxq5G21GpHVSU2aZR47EknfUiuYCx4Du2kDb?=
 =?us-ascii?Q?KKe3WGkq41skWSS8fiIlxARJgLpFWZCPj6SaW69+i0bGUzzgAIdRJGm3X1DI?=
 =?us-ascii?Q?DrB1fNVn7q25VmLjgOR0oC9HBIvKdtUWkTBA7pLwOTUZLlVVA3MU5JkShU4M?=
 =?us-ascii?Q?FHnJT6hp+t+ucGePx2b47xXPMbulr+eo7IAcsXfzm7mJurOGHpzsAUd3g4cr?=
 =?us-ascii?Q?zn88esBWj+ZFNSY0cybDMSIj7s/YdH2AGx6pv3Yp4q67TG4GwFnyKyaKZVbw?=
 =?us-ascii?Q?ggTiBfJ1boL5RIn9y1ebZtf0MXdu5i9pC0Wb7I3ezrWeQ4l95gIxjP8jhrkp?=
 =?us-ascii?Q?SBbGtwK0BUrn/UI3aGLAyI0hAKmxYircv7UTSBlLfL3n4qFAHB+GR/YAkixG?=
 =?us-ascii?Q?xz4e6pkIjZFOx3YKVikxiwaoTlbl897hiYhzteyEuBKotjA4kAILYYLN63/R?=
 =?us-ascii?Q?fRYJhUNPZqH+fFYEIzMz9c1kfvjKteB9+0Az8sCWwoY5LZ/Lzu/bcHmLgize?=
 =?us-ascii?Q?7WEmfHkMFZCyTMzCHoT2uKxpc9UhuQ3LxgRVQijvjoHxDHTA1jDAHZN+6qjB?=
 =?us-ascii?Q?8fzp0ryUT4imyOWP3xVo6jVqH4HkqokqWTm0Nyd29QkUK8WuKVBCpnwHthER?=
 =?us-ascii?Q?A8wtceDD4MfkOxfJV7q83M2roNnMQBfOJXjUFSIsF2RRDwy7TnX3lOK4gqGN?=
 =?us-ascii?Q?fbSKC4qXRldjV7oVgteqWtiFRGaRoZo+aSqCPh0+Pmq1CIzd2yivK0+h+60J?=
 =?us-ascii?Q?oTxt56SIuE5F1bLK5yq1XcfYk89DSVJqPwCxUrP/QAiyKVRXCBiExdnHtkhC?=
 =?us-ascii?Q?8XVbZpo7cM1DSyDazZYcIBq4HmznplSg9CVAbc6qTi0yCcCodAzn2y1J8KKR?=
 =?us-ascii?Q?0u6fFD141kVInW36l2WpDS8CONqJhlBIDbvG3NzazNskPPJKsLhaE+pfO8O7?=
 =?us-ascii?Q?gxJmagMpA1D7/IHvv1PmYPm7rBc3G91kUvPe+FLx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc73842-1d4a-4d49-2483-08dafc1ac666
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2023 01:48:35.3966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LTkjmyeI4OrVUlNIThjCDw/GESIj+tf2gGurG6ERILO46QaQ9u8ZWRYmdEyTUKRm/SG6AwZzCQapzjGTc9yu0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4101
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Friday, January 20, 2023 11:28 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; seanjc@google.com; pbonzini@redhat.com;
> zhi.wang.linux@gmail.com; chao.gao@intel.com; shaoqin.huang@intel.com;
> vkuznets@redhat.com; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org
> Subject: Re: [RFC PATCH v6 1/6] KVM: x86: only allow exits disable before
> vCPUs created
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Sat, Jan 21, 2023 at 02:07:33AM +0000, Kechen Lu wrote:
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Since VMX and SVM both would never update the control bits if exits
> > are disable after vCPUs are created, only allow setting exits disable
> > flag before vCPU creation.
> >
> > Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT
> > intercepts")
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>=20
> Nit, no blank line between fixes and signed-off-by please.

Ack.

>=20
> And an RFC on v6?  An RFC usually means "I don't think this is correct so=
 do
> not take it".  How can you do that for 6 versions?  And know that no one =
will
> take an RFC series for that reason (or at least I will
> not...)

Thanks for correcting this, this is my bad. The v2 to v4 revisions, there a=
re big changes=20
on the following patches after this prerequisite patch, so I still "RFC" fo=
r the design.
But I should drop the "RFC" starting from v5, there are already consensus o=
n the v5 design=20
options

Best Regards,
Kechen

>=20
> thanks,
>=20
> greg k-h
