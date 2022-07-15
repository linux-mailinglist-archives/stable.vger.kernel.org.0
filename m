Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409CA575C91
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 09:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiGOHod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 03:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiGOHob (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 03:44:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB93279EE8
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 00:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657871069; x=1689407069;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Er29KSFk0F0n4YQ+vcojLDAa1pDZDjelSOrgC1qWAU0=;
  b=rIsP6todM4Lqw9iknA486h5dwIpsBLJD51vHnsx4vpkdWRIszyXwdsuc
   hH5q7d/mKX9wzuJ+jJPLWXzs67+Iq8PahXRebvGvpQSkI4MazG+KF4sUh
   MM5AANouW+VG61Quy+epK6lRi2A7Jtzzhd0QldZB5wabKW+bztHzvd0Yn
   Ui6FBJhhpGwLGVF3Osw6d2IRzkQA4GnB9dK7PXuKxO9J4xBNxc0vynEtS
   A2FY9MSSzOKXRZmcSU/geFTU4nWpf2gqFyxmcxYpakCFzhlTsf2CGXEJ9
   tpXl5o/B9iNrxubIEls/rZtB757TYOpoTRsSilkDaM5l85IuwRqmIbtTH
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="164872039"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jul 2022 00:44:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 15 Jul 2022 00:44:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 15 Jul 2022 00:44:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CixChIAZKJ4U45hff783P35c7/RIXu8VpnZam7BMi76ULH3YyWEeQe3kBJhoLLRfOf76SC7FwWFzQo1DlomzOx19A1F+Yim+aDdpoYf3h7uN3G99TRj+QCzHFxN2XWdMT4WNBLjgzEdd2GDKgO/05mY4bBXMzNDawq5tTPSG7xclI6/mWvLUZ9jofHMVLPpB34wdPxLM0Jiad/SbljTJ6MBbWuXpnk9CDj9+E/gySQOvaZx6pCn7DTac55efIuvDXD2zHBF7C3UYiojqMDvz+8ai/1YTQeNZwOiHce+sZwmg/pdGOqAC5gg2Ds28GvK+9RNxANSvBzSbPhlLyLoITg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wedv7zDh00va3vHmtvg4dXOjr5L80ELky4WWHEg42sg=;
 b=RGRHbgeIz6Yu9Z4UoIPc+hOjIv9/QJCANW5LNKXZTBka2+420bVEMywDq1zIUyFAsPlGLQzHluDpTmE1/uKRCiiD4qQJoAYiWV30UEHa1K0WTAgBcdsU0kFaVRHVKQu9Mtlgnloa9oqaolXoG7cIYTdr1udM5IxRofJUgAjseNglPburNyPpuW8ZBoxvTTaBwAK0cknCEPVGkqjeXZAg6/0wsklN+iFzkeFq6HlofjVXYmskmxgQeGMkeZOMZ/MgAc7Vx4l6I92ypY3okUSwa6+lYpsLG6/K20lwcjxKCUGocLp2EVD2u9q2m1Th1VXjm2tJY4P+VtILogaomV+SCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wedv7zDh00va3vHmtvg4dXOjr5L80ELky4WWHEg42sg=;
 b=oacJ9J2OE8ji17anbaZUTJ8hrR98RkBbbZvDc8mIrchsgPsgHktVM3xLTDs+V+bDvGblJ+ib4MLvWeKGtTc+PHSyqNZK0TdAepXYj7rRMAvr74Nw7rBaFbZsnAgouQYlA2ZyssHMY5Ro34ZQkyMjSmeJnovxz+sLbbuKDJFiSLI=
Received: from CO1PR11MB4865.namprd11.prod.outlook.com (2603:10b6:303:9c::9)
 by SN6PR11MB3005.namprd11.prod.outlook.com (2603:10b6:805:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 07:44:21 +0000
Received: from CO1PR11MB4865.namprd11.prod.outlook.com
 ([fe80::b82d:23c3:ea1:a5fa]) by CO1PR11MB4865.namprd11.prod.outlook.com
 ([fe80::b82d:23c3:ea1:a5fa%7]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 07:44:21 +0000
From:   <Kavyasree.Kotagiri@microchip.com>
To:     <Kavyasree.Kotagiri@microchip.com>
CC:     <Horatiu.Vultur@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: RE: [Internal PATCH 6/8] spi: atmel-quadspi.c: Fix the buswidth
 adjustment between spi-mem and controller
Thread-Topic: [Internal PATCH 6/8] spi: atmel-quadspi.c: Fix the buswidth
 adjustment between spi-mem and controller
Thread-Index: AQHYmBn041N9z7GJoU67ZnuqnGhwL61/CA8AgAACmwA=
Date:   Fri, 15 Jul 2022 07:44:21 +0000
Message-ID: <CO1PR11MB4865E34F1DEE1A69170D0BA6928B9@CO1PR11MB4865.namprd11.prod.outlook.com>
References: <20220715070940.540335-1-kavyasree.kotagiri@microchip.com>
 <20220715070940.540335-7-kavyasree.kotagiri@microchip.com>
 <YtEWiAIQHwLzKrx4@kroah.com>
In-Reply-To: <YtEWiAIQHwLzKrx4@kroah.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce070242-49b1-4ee2-c24e-08da6635d4a9
x-ms-traffictypediagnostic: SN6PR11MB3005:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oakbtyp+8KyzyX3kiEbOoIVAckOPR0h82U/VnOxzsY8NbDcDXSerdip2rCrcUSTTCWiob00eguKVunxicBdMnjrH1ZRdFyAbMPIvrHpiwP2Jx5PfkUSqB95fqhElNEk3cHmIFCl7ZoQR4mR8Lr6AkONdViDE+AsApuz8wRlzZpqxoz95X9m+zytg/KGBKhoUMPruxnR55+3rbBh0jo5QuhGFtcw4i/QST+AwiRJ44bj4T8GDCFOb53bh0qLcABFAW1EqyLKhyj1l5eoWkMDM3wgEwYxsmQaLi/cyCum7T1RIKCROWS1gGQTotuTcedUaucMw1IVh6XLMMG/VfGJFttibJ2hh+iDtxRRIMwqy4opySv+ovnXfVCFWumoV/mMLk7h/d3uXjEafBDbNgL0Fye15k5rTOLmSydh4ufciuZkdHBBOeKTy98Cf43n8uatTte7P65ExlpsCCScWFwDw89QIztNlhsQDJB0GPPv+6no4YesLfUHfKRwXXS9OqSj5DF0ONpYeCiX2uglNiy7v0twGfxGmpBoCMmtNHZHlPn2AB18bI+AU8prrSnayagDjkJW7YgbFjyfSORpE4SHaufnfY5E1XeUMi+MnBHF2so5aTMjTZvMu7w5Gm7g6Td68xoldUaAEQwj+75xkYJdbJQbXUG/e/R+lIilFkNIB0LwJxE8Weak8eEeVEqjNOtPLmt/aSAb4SH/QvS9l/6n4cbXXoWJbINONX4+3zWqiQ5lOKh2AUtgLmbTQrzU/T5iFeY9R3X6en7Z7dI7emHQ4FXJ5CAo01wxS2g8kvt4OCYHyl0A9qrqq3Lg+yoPAVIpl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4865.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(346002)(366004)(136003)(376002)(6200100001)(33656002)(26005)(52536014)(55016003)(107886003)(71200400001)(2906002)(8676002)(41300700001)(86362001)(66476007)(122000001)(5660300002)(186003)(53546011)(6506007)(7696005)(478600001)(9686003)(54906003)(38070700005)(83380400001)(316002)(4326008)(76116006)(38100700002)(8936002)(66446008)(66946007)(66556008)(64756008)(6862004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zZ8gpGeOn8NqYUD5QC1QeEUmFJcjByijd4RT9S+TDL6hmkV9e4lw+kiIeloE?=
 =?us-ascii?Q?kbCtNLnMM6IWoCWI7lI2TQB3Dg8b8hbimlYRJ1Njs7GmUPKBDM1sGa8fYHKf?=
 =?us-ascii?Q?2Tq+u4LdTxJXdvRJPAOw+2jB3qpgu3SroLtx9qD1uBF7KSXF6P6OdOBumYDr?=
 =?us-ascii?Q?WoQE7D4DZZOfjU0PHWuo70V386JAO+XS0NEGj4qFEUNRQ+OTY6Z9Xk8OjaIW?=
 =?us-ascii?Q?Hqt9IJI39vUgZ9YGcCLiQu0BKy6fY7qAgwN7qmShnndslzA1cIv7egKG3ugM?=
 =?us-ascii?Q?DgFpuVTyCkvT7pAXMDcrWoSjxLyAHZVs2egD/X/Z46zB9SioMCtHmOhJjwuk?=
 =?us-ascii?Q?Yw72ebK2/msGK97Kndd3cqMFyei7m6yff6KNklgHAthv65RK9TZLRBVB4apW?=
 =?us-ascii?Q?JNrP8lMfN80A86e6B71m84QJwDdxRMwwBzhvW+12KEV9gCTzNr29AKHHhmRG?=
 =?us-ascii?Q?OeaW2Hp4WPgrS5j0ggPt7L2uOD6UGmiQ1dmOMfIiacD1aflLiYSb3AcHbGnw?=
 =?us-ascii?Q?LQBj883hgu1BtQ4CYp1Eh1TgD8qUyValBC+ehSQa0H/ZCZRX0h7MlmtyfxYG?=
 =?us-ascii?Q?9VT81gxkKBKLUpPXQzEEC/P/oFWoQ0ffXifORC/ZNjzg21kUtBMZmp+xK1y2?=
 =?us-ascii?Q?TBAdRWonQBxoNFYPiBU1EfMRxMzAjvrFMpXJ9vgAA/OxjH8E6dX2MmT0i1T7?=
 =?us-ascii?Q?78wSVwSPk+jg1CEKcwTpw85ynsp4r0H5L3UKii0RPNKQyqEOg/fZ7Wrfoweh?=
 =?us-ascii?Q?MoOpIl3Mcs4i4P6qZ/xdfLKmBIxPZiCIfIofd6+aK2ZfyL1w1Oy6vDncEl8W?=
 =?us-ascii?Q?pwsXhW9v+ozEsMHvySPhb/pgaS4QSoaEWzogOu1S/yhamdnj3+f6ALaIq0/v?=
 =?us-ascii?Q?Aq7RgXAHBcdCrLgRZO4C9HdotK9m6NjGuZD8q19l/YBtafR7FXZKc+JzAG+i?=
 =?us-ascii?Q?LdsxV+RQjgfZEY8+8Sd/kEO9b4F4wS2FpSZy4aT2Eg3957PMuswQ0H52RX8q?=
 =?us-ascii?Q?1bnmHON/MpYsvkcHduJKTfHeVaax6TH/a+AibjYch2EiQLrG8iKr1tPy/b7D?=
 =?us-ascii?Q?ZQm6ag39FmyM6gHLADAh++Mc85PepRfiaiGAyE7j7aR1mfL6aArSiBEkFH48?=
 =?us-ascii?Q?A/1g6BoZBKIC5ZJXT64Xmed7gAwk/Ybh/0mFfyraktHtrXdbyjooH92MVca2?=
 =?us-ascii?Q?kfkl5QsyYL2UVR4kCW/y8CAWXbCdMBCQpQ7MZsAMV7hVSfpmpQAPbzIbzjqV?=
 =?us-ascii?Q?ylL/YxYkS+cQQxaiEPFwNL8p5GifHFbVfOxv+flnT2BSjEpcP/MgLBlZ5vL6?=
 =?us-ascii?Q?VQobARrSKYwaSA7RsmGaT3YzjdmCragGxmX5jONXtu8+KYGGwB95zyhK7pq+?=
 =?us-ascii?Q?Kx5gHnC/Fzgo7EDqCb08LLOXZUj8QaS6qcElD/a1Z6O9U2O7/SnAP9M5fezH?=
 =?us-ascii?Q?6fDeVmS2hGWRGqEA0WPTc8W8f4gxSaT2X0jXSbJ0ojePgYmw1//cNws4YbJg?=
 =?us-ascii?Q?2SEJGo/7kDBMjqbQwBnW9E/v4/xHIXveKDMtITFWa+Ba4lXV7KRCUcSrYXIE?=
 =?us-ascii?Q?zH3xhd/D+0kKXjjLqA+J4BCHsNIKutt68ek97BdAOPiZNTAaT9g+5Y8y08Th?=
 =?us-ascii?Q?TQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4865.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce070242-49b1-4ee2-c24e-08da6635d4a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 07:44:21.2903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RMquOk2p94NWUrDjd9sd1sNiW/+Gw+OUPIT67JcJ20NsVthXwJ80pkVND3ipbpAsxPF0uyZhU4KfSarbk1vQVgRazpQrELXh2NGdLyNcDjquhXNKJQw7rmt9IAe9a842
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3005
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please ignore. This is wrong communication done, by mistake stable@vger.ker=
nel.org mailing list is added.

Thanks,
kavya
> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, July 15, 2022 12:56 PM
> To: Kavyasree Kotagiri - I30978 <Kavyasree.Kotagiri@microchip.com>
> Cc: Horatiu Vultur - M31836 <Horatiu.Vultur@microchip.com>; Madhuri
> Sripada - I34878 <Madhuri.Sripada@microchip.com>;
> stable@vger.kernel.org
> Subject: Re: [Internal PATCH 6/8] spi: atmel-quadspi.c: Fix the buswidth
> adjustment between spi-mem and controller
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Fri, Jul 15, 2022 at 05:09:38AM -0200, Kavyasree Kotagiri wrote:
> > From: Tudor Ambarus <tudor.ambarus@microchip.com>
> >
> > Use the spi_mem_default_supports_op() core helper in order to take into
> > account the buswidth specified by the user in device tree.
> >
> > Cc: <stable@vger.kernel.org>
> > Fixes: 0e6aae08e9ae ("spi: Add QuadSPI driver for Atmel SAMA5D2")
> > Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> > (cherry picked from commit
> 41ddc39b3d13273648b9aa34075a085a31ce6031)
>=20
> This is not a commit id in Linus's tree :(
>=20
> > ---
> >  drivers/spi/atmel-quadspi.c | 3 +++
> >  1 file changed, 3 insertions(+)
>=20
> What does "Internal PATCH" mean?
>=20
> What stable branch(s) are you wanting this to be applied to?
>=20
> thanks,
>=20
> greg k-h
