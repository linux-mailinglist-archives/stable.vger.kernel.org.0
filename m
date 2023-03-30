Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E787A6D0F55
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjC3TuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjC3TuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:50:19 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020020.outbound.protection.outlook.com [52.101.61.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ACBFF19;
        Thu, 30 Mar 2023 12:50:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zs5y+vh9DluRyItNDVtQEO6ETIxF782cOsB8F160/6/qC//P4IhcVfBQVt2JfwnVfD8r1MIM6QbXVSHM4Ippa93M3UoutFpBNAN53dyvLgDoQnDdVCf+K0WyLtyPSSDmF7yO1procjn6Ipsos9qluLr1mAzlge9aMFHswy1SC5mxFldt1pc2RDCcVL2KYWQJiosR+2igdO4Fnm/jec3GqhIUOD8OcIGOAY4a2tMtDYTQY9zskLvExJL2pADJtV97/ZCIVJljZxZ2jPog7WKo72Tkwo1dCG8CM5RY1d+5scrxqSlXSiPyRhpzdZ59sJIf9lf+jXHkqgt/la+81tX6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ba1gwbGWuDIVLHavsMOVm5dT0Cm9jxO6k4ZF4ODmuu4=;
 b=AzpGTns34RuSY5LWW2oZuSYTzq2V/tp31nVV0+R98Hp4zdycKrd+QPbZER07su5iRkaCgR73MEW7WveVou4IWwCwvoupTx7Mus1ppU7zwS/Oj+aTDspiLiZnHRCkqRWn4ChDdn+Jt/ttPsHGapT9FS8TlARk+juFAinzdqRKwi+HlPWInI+bOct76oCHMDvs7xjWX74h49SeACuCkZyuJhxwhOPaMEDRIs6TPn6z+qC1omCP1OAW7EM0hPBPmWlemRCTM9cWUJNCPArTHlw0eqgFjVoRlBQ3mL2eAIinzWetKX4Xbbwu9l4AcjNkctOjEnrKgWdnLSbKzxPA40z48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ba1gwbGWuDIVLHavsMOVm5dT0Cm9jxO6k4ZF4ODmuu4=;
 b=EeD/NLeyNVSA2Z3fMxrBvEWPiMAUFyPslgHmnmpbnb5v9AlvRFwXHWyTumnxn81WsNcfErKt3xbx4A2MUTMUYm1TxZnx9rJCsxBQwnDnBrYjef+vWbjh+MdIR3gszc2pA6LgCvyglL+ESWfM6u3qVau/Ollpw/WXqayEB+YnEwU=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by MW6PR21MB4009.namprd21.prod.outlook.com (2603:10b6:303:23f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.13; Thu, 30 Mar
 2023 19:50:11 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6277.013; Thu, 30 Mar 2023
 19:50:11 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "quic_jhugo@quicinc.com" <quic_jhugo@quicinc.com>,
        "quic_carlv@quicinc.com" <quic_carlv@quicinc.com>
CC:     Boqun Feng <boqun.feng@gmail.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH v2] PCI: hv: Fix the definition of vector in
 hv_compose_msi_msg()
Thread-Topic: [PATCH v2] PCI: hv: Fix the definition of vector in
 hv_compose_msi_msg()
Thread-Index: AQHZYrMXe0Y6kEKNA0yWUzOcmG4VZq8SosvwgAAxFICAAOEPwA==
Date:   Thu, 30 Mar 2023 19:50:11 +0000
Message-ID: <SA1PR21MB13350093800BC2C387EE0648BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20221027205256.17678-1-decui@microsoft.com>
 <ZCTsPFb7dBj2IZmo@boqun-archlinux> <ZCT6JEK/yGpKHVLn@boqun-archlinux>
 <SA1PR21MB13354973735A5E727F94A169BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
 <ZCUk_9YQGSfedCOR@kroah.com>
In-Reply-To: <ZCUk_9YQGSfedCOR@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f3524bc4-1623-418b-851b-3233f8c0186e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-30T19:23:53Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|MW6PR21MB4009:EE_
x-ms-office365-filtering-correlation-id: 99de66fd-8e4c-4c96-1906-08db3157f922
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IwMY5zFvGDQ1BPE4++ZcOBMDB2EvS4fhTG/auVvnkNIP2AJiw0flQnk1Fsunw8CaBAUq2VrB93ZUZRWh3hrOUNxs5RctuDsgnZpTqoSgfsN3hcnDaooQ0PT/R3Lz9eoOBXcqQUO2MshuGDaQMK58MCkmXKGZUaFBwCynRGXqavQxCG2mAz6MLrvw4M5SzIPem/JI8six4gx29/pIQfYIhwSt2MKBLWyl7qa4ZTSFyGffrbgq/nFaNgbQUuI2OGW0mqaH2fYO8i3dD9Ya0m4oWZ9NsfBxht+esZeqFKFpsbUVvgkSSJIrrcRtySbo1f5S0fbL6X8ABkNq80H37O1zEkAlSLg0BdsJITNrjH7aRcJbJH35RUMUAhemIrsf2JeGipW92/oD06uAR0NWvo6rAv/N+RAZuZqn0EnPjF5hg4NRYA8lNkibm2uXpJKXrTMnMetsWG1RhtFO10z0DyoLGua0SUM/S0bKPR6xNFx5JGZEUY+q+OvXmRaJzuriDA3D3Z6VK/Ui7BRYtMpl0GCSHYCcER50nb8kQUAPjQs4Z8l7hafXvja0X5SO5ioE1wW1GncSaAHQTVj8YQ0pi+h5jM4VR+BAnx8CvwAljK4pPUzg5QT+l5zQdZ9BU17ADQb+3n4mumcuIN/ffPvCycbLlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199021)(83380400001)(966005)(478600001)(786003)(10290500003)(71200400001)(7696005)(186003)(316002)(26005)(110136005)(6506007)(54906003)(2906002)(9686003)(8990500004)(5660300002)(7416002)(8936002)(122000001)(33656002)(38100700002)(4326008)(66556008)(82960400001)(64756008)(66446008)(66476007)(41300700001)(55016003)(8676002)(66946007)(76116006)(52536014)(86362001)(38070700005)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TFPE9LqeY+Uaesoe1VkjT3G2khQ3g0bOI+9uz5uyWhjwd1nnjFw/ESJaEEi+?=
 =?us-ascii?Q?VuLTGGLBnDBeR7Eyz1GOvwYZ7bUnRACrlXNCx941nrZWkObv7nhpRy83HSwR?=
 =?us-ascii?Q?KiOYis9RWvMTABFETqnc55gHjOZQPg8ypARsolxYVi1AwDyJfZSPcFOfMtnK?=
 =?us-ascii?Q?BX0k8pAWIbkPolEmI1mvV8YaWyyymajzfwp7f8wSaou5QYrs3qOKBoo0yB2J?=
 =?us-ascii?Q?grpoEvYqtUyHYRyXPtVgfgIkb2Kd15nfxs3ZQNhL9ZWpedoFgkRbBchK0nWg?=
 =?us-ascii?Q?m+h+n2E82FP1pdf6TLnli7i3FK9sDzSq6b/ggOjugmZGH5Ot0j+4Bfl+GP8t?=
 =?us-ascii?Q?O7FHMONUrSh1HYF0Z0MDCXypIK5Nzcci/nR278mNMXzX1qSUd7b6UErlMjjf?=
 =?us-ascii?Q?2hXkbaaLqizm5HkUYP4edMzh3cJW5C2bcsMgZilds0ORg/MzzO8dHU5QOWKt?=
 =?us-ascii?Q?H2C8Egtbz3UBOzNwdoExEq/rEMxbSAhhs1/gZ+TcHeJYjdajNKvU8JPuIBNL?=
 =?us-ascii?Q?I3qz5xfpnmlpddoKiXeWVOiMa/GnbbBVLoElWWt7+aZDeq5iAMZLxt9kT8+l?=
 =?us-ascii?Q?ln0ITNxcckH+JmmMLFFjuvSXBpsdropqh7zlUnTxDt9FDgfLj1LMKdXwV62X?=
 =?us-ascii?Q?bqUfJmUcVts+VNpqsCplXcyqidpEdaZYZFzmNlb4Mvp+KsDtHmfoGgroKiMP?=
 =?us-ascii?Q?7SxJ+QVNT8p2sda8ovxjHuYt/GOK95VVgsvUiQriU3po6l42aUp6MjpUY1Dg?=
 =?us-ascii?Q?tkIkZRubunrxln/cBCuUoirrudHN0ZrRTV/AJMFYnyGsacEOpmJj8hzkTD7F?=
 =?us-ascii?Q?qyjFBeG5mERvGE7hveQcpShHMTwq6Y1+9TD+0pwKvZOHa9ROAQX+PsUEcY2A?=
 =?us-ascii?Q?drp6iSc6fejU1uy3uv8UYNPYqVVUIJyk+LLHF/BJ+Fmq+z/8ZXLoszdKVEAn?=
 =?us-ascii?Q?BCgSlW9OM9ZJ526BL+BLjddQZT54J7DbSjPDzv2urSAO/7pm4QCBCd5StRO5?=
 =?us-ascii?Q?rUqayESjMEzMP4gmkaOyyO7f5EHKkjV6qh3rY09T0NOnqGogVlH4AQ6xaR3N?=
 =?us-ascii?Q?MJCom6RLJQzkSVmkppdTHabOrr8pR1TbB4UdZBAI9OXXKSX4qHRj0gOt07px?=
 =?us-ascii?Q?B0fzAuoR4QI7ol3UgC/q+2m2RKKDl7+wVQsuptFofXp/N/HjkX2ib17ti3ge?=
 =?us-ascii?Q?bqibWu81uuqn5/gh8TYG31QlpHx5Q1Z4hkpdcND/k4E81l1bM1j+GoXbRBrn?=
 =?us-ascii?Q?NaKtWpPsyVLgeWjmbaokAIXg39oV7upPdNY4wyUhixGk1Rpy1NdoioAohMX5?=
 =?us-ascii?Q?FZtIkRZxTdfng86Wu7jg0p5oGzr0xY+kOLx3A1liutUNugBUEuW1AhcDZskS?=
 =?us-ascii?Q?oIHAq01V46N3VJ4FI8yJGE/ch4SfnjjDRD7RSfJZnJxRuwCAyjwyPXwMRlCH?=
 =?us-ascii?Q?7iiaKWIAqBvvNMRVm8WYuurAbX8t79rS9FwrpZGl9Ei6irozZ/YUIVLnIooW?=
 =?us-ascii?Q?ihTLZZAlbR3GlyRB0IAynM/fwNesKn9qAl4rPpxmLBTm9ScRmdWxvIT1eiRf?=
 =?us-ascii?Q?H/Vj8q/YuouMYZHTCpaL8ZZT/qUh5iLaVpW4P3OE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99de66fd-8e4c-4c96-1906-08db3157f922
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 19:50:11.4550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HjjGaIlWsXyKBTC45gPIxFbfvZ1KQ13QUYCb3+oSuR9LOI9j5gzDijztXfhfvsxjCMMO+vB8I1AehOsDKDImLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR21MB4009
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ...
> > e70af8d040d2 has a Fixes tag. Not sure why it's not automatically
> backported.
>=20
> Because "Fixes:" is not the flag that we are sure to trigger off of.
> Please read:
> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.

Thanks, I just read this again to refresh my memory :-)
I remember Sasha has an AI algorithm to pick up patches into the stable
tree and a "Fixes" tag should be a strong indicator.=20

I tired to manually cherry-pick e70af8d040d2 to 5.15.y and got some
merge conflicts. Probably that's why Sasha's script didn't automatically=20
do the backport. @Carl, @Jeffrey, may I know if you have some cycles to
help backport e70af8d040d2?

> That being said, because some subsystem maintainers do NOT put cc:
> stable in their patches, we do sometimes sweep the tree and try to pick
> up things with only "Fixes:" but we don't always catch everything.
>=20
> So if you want to be sure a patch is applied, please always add a cc:
> stable in the patch.
>=20
> greg k-h

Hi Greg, since you're here, I'd like to ask a question:

If I add the cc: stable line in a patch and use git-send-email to post
the patch, git-send-email also posts the patch to the stable list -- is
this acceptable? Sometimes a patch may have to undergo multiple
revisions, meaning all the discussion emails go to the stable list
unnecessarily, and I guess this is not good?

It looks like there is no git-send-email option to exclude an email.

Thanks,
Dexuan
