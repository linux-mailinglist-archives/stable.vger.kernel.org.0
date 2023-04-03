Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3069D6D515C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 21:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjDCTaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 15:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbjDCT36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 15:29:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2103.outbound.protection.outlook.com [40.107.243.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8F430F2;
        Mon,  3 Apr 2023 12:29:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GW+iH/RSFDl5p0ir/KFF/IA5+ln9bUtNXDBxr2RxcBZxF4x2AZQ2ZNlV7irfYxCD+5Shs7bB5MipKyi25Kf7OAidLRZo0qU20n/IRcs308Rs2qaE6lRReoJBpUQsb3Qn+GmqjIR6Xy8ZB8MBQp/hlS4kbeHwpD8dfkcpn505yMzlh539MRyj4qPAebeLLX97216yQksaT7bSUKsSP16s70ptcNfOrXat8Rzd+kv/63e6iuVaN3T9p/vqBXeCPlv7v3+/bEZxJiQvPJJZ3SMvbZv/Co1WZ+vokndhmMmunIEAv+PqoQbx+yojVzK0XyM70ujGnNPNjzeI0W/S7qrhOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k03i3p/AbuPb76kBYmcErlONM+4qKiwERd4E0+C3J0E=;
 b=RRP+s5qcLNM/vgcWqnfV2PqsCmYiF6DL8rKNbY7QZuZUb2/f2O2GW06Ypb6bQjnaOOWVYo9h5NYTrewGo64MfsFYR5zlFlRdggbhPRXeFzvSZEUYlP0+SupdHgDnjMzR6A+lBsCM0lS07LHyeEnrj9Hjg9PTPlkN4KLoLK8V410BpxgaLLY3BMtcjvjwThHf+++Rd0dRSZgVR243a7Yc5BTjISFRLtAMaqaT0Da+Aba1VEu906QtvMfty3eqgew1lj1kKdPmLWApCm9hiniAYRhJAJx4bbrn5cCuIWXtlzCBGJKXDzMBeo1JzWE1UpY5JRPIk7ctuWntgA/Ymn9MfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k03i3p/AbuPb76kBYmcErlONM+4qKiwERd4E0+C3J0E=;
 b=RBVmVDqC/h/tXmBZeIfnHO3NsyBMbuxdRtL3v2mP72tfbg9VoO7iZS95v0VLJ3WHuSss/BALgU4ySqSjf9U/xleZ/GNAz34ghLMTl5uCQ41K5i8XVRInIDkVZCIcQhnAAjo0jl5C8PSjHDBT7GRKJok2p4/AM4CAl5/c6BEu9+I=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by IA1PR21MB3568.namprd21.prod.outlook.com (2603:10b6:208:3e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.8; Mon, 3 Apr
 2023 19:29:53 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6298.009; Mon, 3 Apr 2023
 19:29:53 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "quic_carlv@quicinc.com" <quic_carlv@quicinc.com>,
        Jose Teuttli Carranco <josete@microsoft.com>
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
Thread-Index: AQHZYrMXe0Y6kEKNA0yWUzOcmG4VZq8SosvwgAAxFICAAOEPwIAGQBsAgAAJ7lA=
Date:   Mon, 3 Apr 2023 19:29:53 +0000
Message-ID: <SA1PR21MB1335E548F07A30A1DDBCDB7BBF929@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20221027205256.17678-1-decui@microsoft.com>
 <ZCTsPFb7dBj2IZmo@boqun-archlinux> <ZCT6JEK/yGpKHVLn@boqun-archlinux>
 <SA1PR21MB13354973735A5E727F94A169BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
 <ZCUk_9YQGSfedCOR@kroah.com>
 <SA1PR21MB13350093800BC2C387EE0648BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
 <59e68312-9bd0-73b1-2d18-cd5744588070@quicinc.com>
In-Reply-To: <59e68312-9bd0-73b1-2d18-cd5744588070@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ccfb4802-5f4d-484f-80b4-6492f273978c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-03T19:26:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|IA1PR21MB3568:EE_
x-ms-office365-filtering-correlation-id: 2eada139-57bd-45a2-38bd-08db3479ccb9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DLZh6aiZ28IbEQ9jEVQA95J7/JnXzloZF6jf6Ss2I0d3rEwFuFDOI6uG6rp3/b1m5QS3IY1iTaTGe/uOiUncPJlUqs2+PR+anaFWpTV03HCC91e+/QHKIEO5uwjXfqPssEp+2Ll/1yzPLfYENG2hGYC9hQ8b1TMTU8UzPQY/lJcLNmZwMuGGJxrneS3fv87r7od8BR8devUzy26QDgsEKPiIfJfB0c3VjAFakgDRaT5Tu/+e57K6VjMOl9GqKBaZgGG4frO7Nbq9iPITCqrfa+/zy2IdMp77WR7jblDiVaDcTvj6FAx8ELGd1sHvt2STwoBcApzh2bK1qND1hehHYhbm2SGjvTBBrqOW88bEgmFuRVO3R6SEHzUDoIoh2hiQSNHH7Iwcy1vWb1tuYuKREKtR4uN5QruzWWW7+U0eoM/wgPE5v4yNZ3v0Atdb5clH4W/dgpnt7KoYrj/4s9PSovhh67a7Poa21ykiIOjKisA19GxsqUqh6L8DB9LT29gCwr+2RuEsmJqawg90ZZ5ymhXOPhuymjcdiDYDXi2B9UYsjCvsv8YzeXOvo/gth3N18B9ZgM1ePMDiZNG64kBfKFYHhg9Jg3i8/xMRPYjSZhhXb5bNMifj43CZZnoUB4zKzPpWmJ5/ukALKj0hzc6XDwp3WboFc/xXbVcmL+4g5UI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:ro;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199021)(7416002)(186003)(9686003)(53546011)(6506007)(26005)(4744005)(55016003)(8990500004)(33656002)(110136005)(54906003)(6636002)(478600001)(71200400001)(38100700002)(7696005)(10290500003)(66556008)(86362001)(66946007)(66446008)(66476007)(76116006)(82950400001)(64756008)(786003)(83380400001)(4326008)(8676002)(82960400001)(316002)(122000001)(2906002)(41300700001)(5660300002)(52536014)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?thNPeQLyy/ilVBT2owRf+y/zYW3i93yYjTBjwnZ8/W+lE+3ylyWYTD7eLey7?=
 =?us-ascii?Q?W6SFXgNlJJ+pkdMf9twotOWWeMosjzj1D9Xrt079h7We3peYHf4jRonP1yUa?=
 =?us-ascii?Q?XKnH3wsI1pJR1ek7OqqKz972zPgxfpxDbcWdo1GeSFOhGijEOKsbWKL5nvAs?=
 =?us-ascii?Q?fK2fjqpLf7Iq4gsJt02JLcU/YXq3uAKzXa1Jy6RTxGZfxy5H1prkPiYTfCnq?=
 =?us-ascii?Q?+8/e67WH5oWedb7gm4OemH9wu2KgRjd43MMRMHZ4B8UyAU6xDnb/x94fvOA6?=
 =?us-ascii?Q?xogha4mzZxrTAejQ1xux+7M3aSOTONB4WzZs7Jl0cP+Pbx9Cd01avGgVuWLU?=
 =?us-ascii?Q?f+P/zPjO7+irT+E/SIReNxlBf1J/ZA4MftROssIQDFxxBaFZAnFac7OIAKwO?=
 =?us-ascii?Q?rsdLW5aORq6fgHOB3yHCwnZhSP6S2lt4xoj6Nwz1gQrmpu48GRXpWf9IXlqr?=
 =?us-ascii?Q?e/xu5jbgyo3PdJXCPr3lJjkchem43GW697jX6eUxjNurIXxq1Lra685/Dikz?=
 =?us-ascii?Q?DiMwwiVjlOBI5h65KElvN0RFi32xXdrOpE3yO++gV19adfYqTVI+lPTKCzMF?=
 =?us-ascii?Q?Dr+QxGkXEV6AEbbNZNnHy4E9WmPQEYzuohWHTXBVbupaWJO6KVjf4g1s9c6z?=
 =?us-ascii?Q?26Pcx9IexLwkLSP7NgtFhWelZdFbYR8nZ+DyzWqtUIkLY3oFmbcknKzRxgha?=
 =?us-ascii?Q?HaiJovZt4g62dsMUHOliMvMMdrPDUp1MAnYhKib6KvOmfcaUVhP3sRzIBhzK?=
 =?us-ascii?Q?+yh6zc3aJsGIzjoJbi/a3XFKZ3Z3iF9tLvTswHu4mhNTpT63yVyC7f855iZ9?=
 =?us-ascii?Q?JADISjOg2YUWF3oQFQM+MXltSQ30DiiXzV3onsqHLkQGUw7eiaacN3SOnbZK?=
 =?us-ascii?Q?68Z8fHL8y4xzSS2gXNckTxeXfAnuE2UmuXbmf+m9F4baZvwJIpYiasUmlgkq?=
 =?us-ascii?Q?iWNxzXwgqixoX4OmM9fT2vpOKPiMJuvI5SzubMUmMc0ZGecFoYB8Fc14BXnT?=
 =?us-ascii?Q?qI4aLJp2XDYSy6Zj0spp6akOwg4ZRBt4hju0DaBlpv70zmOJEePhlV/887PY?=
 =?us-ascii?Q?QuaDC2nVasP6M6zLcOSk7jrB+DCyAik0j7IFLtlty5c1Q7YHsRWoI1mQBYPj?=
 =?us-ascii?Q?WAcMBbmY3xX9SB81lg8s1s6JFY2tb6UxSdjVaJClrsdjIk1s+12n7E+CTqra?=
 =?us-ascii?Q?9og9DhUk4CdqotzpGfRZfB/GVAqiX4wG3NWo18t3RFc3MxmwS97cVCgz+uow?=
 =?us-ascii?Q?zXra5q4bUsDj1GPvGATAbih0ZgK8+ebnTtun7SX7tHBurM0/Hz+zhhYKGk1b?=
 =?us-ascii?Q?AaaYYWFxJIziLM9rFSSJBy4CWxoWMrzdNgVLHV0s7wbRoK45rbJLPUYp7QGU?=
 =?us-ascii?Q?YZm5w1ljLSf0jUQfGRIYvtqt0eS6ID5ww3QD694jE3vAL2dwRJswCtIe41u7?=
 =?us-ascii?Q?VT3dSxeGlzuZEZzv/EZtNlB7Mr5jZ3Hf9MtA2Xse0Cj+9xzgyGhDRpDd+7Ap?=
 =?us-ascii?Q?+A1POe0x58ScbVy5izWM/fK1v3vxJDH+WUFhWTsoPbQgN4l0W2bzSWXRWCdV?=
 =?us-ascii?Q?f0oRyIo0TLNKA4HnjU/fxWb1KTCRtenv0XbskufQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eada139-57bd-45a2-38bd-08db3479ccb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 19:29:53.3262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: csb7ObCwwc2nScm8yLWVDsUQ/qGDg3EwwwT1dkdPKH4RFq3JYk3qVmiPSuXviXf4mspbcmAcgaR15+/X/iROQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3568
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Jeffrey Hugo <quic_jhugo@quicinc.com>
> Sent: Monday, April 3, 2023 11:51 AM
>=20
> On 3/30/2023 1:50 PM, Dexuan Cui wrote:
> > ...
> > I tired to manually cherry-pick e70af8d040d2 to 5.15.y and got some
> > merge conflicts. Probably that's why Sasha's script didn't automaticall=
y
> > do the backport. @Carl, @Jeffrey, may I know if you have some cycles to
> > help backport e70af8d040d2?
>=20
> We might have some cycles this week.
>=20
> -Jeff

Thanks, Jeff. We already have Jose on our team working on the backport.
If you think you can do the backport sooner, please let us know so we can
avoid duplicate efforts. :-)
