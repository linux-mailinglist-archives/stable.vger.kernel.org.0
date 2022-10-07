Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D835F7EA3
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 22:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiJGUYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 16:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJGUYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 16:24:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7B7103D9A;
        Fri,  7 Oct 2022 13:24:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2QUQ66ZoQ0fmRtLv7k6q9UQ8gyD7Nlm2o5Xh00ma0B1Tw/6zkVIx7P2dTe9YXM8IC1mqYhcWWOM8+hxQYn3wHJBSHAvgnZfRGSEYaTnhmC+fkL/HXr/fT9/2syu1l8sRTfru3GgjkIMNUrcLGR4ymBU3aiuZaftTcvmVwOluV/zrU2LiRMkU3tEsV2IPdpdqnqyPsJlu5a3beW/Xq8JXBDqaB8vaFhFa0DTHgvPMKnLOjOOiyDhqnlLxaZf9VMw15MAlD5gx1Kelex0DW69hktSzdurWIuiwRugdVKiAbKXPX9ulFsqeMd5CMr7znE0HevNmfj0esedANgk5DAMUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISOMExvuCJ2p2bBun7RGjp/SW/5GhHfpg+TvsuQsaxo=;
 b=KvxIqPWBsS+dXHcVNq8mQY9QGTsWv8bbWOtjkxtkJeDo4jFiBR26FJfk4KpjPu6CxKF1fjoYJbCZ3H94bN/i68wktHwiROaz1Ifr7hXECgNLUODz8QSJGWCuhPRQBGE3RsBl0rstvvHDytivY9PXSg1Fo19E38KTlvLnou6YlcyuvCE5Q8vm/axGZ1XLtPKqW+KMDcazeyd03yFduU3BjaKvn+k2JOnD0sqACCf/OlZ6s8G4C3GYwTiwG7J1zI/scKq0mgzXEQky55BNyFwvb2bxa+ZfMZ2hnS6ZmO604jh8qviarVNbeKmCeBRHxIpAeVlZtBnEVL7lchDau4VaHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISOMExvuCJ2p2bBun7RGjp/SW/5GhHfpg+TvsuQsaxo=;
 b=5ZjG4CHhyTvcF+2RpUkzth2v1+Fl4L8GCARWBVMPymh7EtxkEaKgAaS875rJJqheS0qeQcFlFYXNcIGZHvmJn+XABHHtGe2elif3BgLCVKWlQQRRaONb+TII7shVN4p/0Gnr9meCrCv8GmIyFQ8JabG46n2Z/s15jVGR61xmKoE=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Fri, 7 Oct
 2022 20:24:07 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%9]) with mapi id 15.20.5676.030; Fri, 7 Oct 2022
 20:24:07 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Allen, John" <John.Allen@amd.com>
Subject: RE: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
Thread-Topic: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
Thread-Index: AQHY02p0eBeAgQpQKUasEaFL5KUsXK4Dbg9Q
Date:   Fri, 7 Oct 2022 20:24:06 +0000
Message-ID: <MN0PR12MB61017C926551A7F6D908F6ADE25F9@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20220928184506.13981-1-mario.limonciello@amd.com>
In-Reply-To: <20220928184506.13981-1-mario.limonciello@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-10-07T20:22:05Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=16898a47-f234-442a-b391-e470c042d299;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-10-07T20:24:04Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: c216383b-3a6d-4a6a-9773-7008ccf80e33
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|BL1PR12MB5825:EE_
x-ms-office365-filtering-correlation-id: 27123ebd-f9cb-4724-cd76-08daa8a1e280
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sdr8GNeP6zCBXkN4qnfVBxOX8mrH+e8Jm4j8DUkUdsOtabAzZM3u91SK5DtXT519HBuznXgT466evyNPpvocpHY8WRzsicEGKVm1GyrwstV9Y6R5XHBg8vHq21DVmujCh9Gl6cqMbH57JB24Iwhw/jCQjLap3TLrGREuwE5Ba5fBesOwKGuuk1L7kvpF8muNtEM9vDhsJtzepuKmGE4W3mgA9HCcly+aMuaCBHUuEAmbWSKsHwczzH20BMI5nsBxrPQYcRONNpEHFROEBoRwk01yh2HL6yLmduR7hbr0xMJnI2f6hMJMeV2Kg5WG/4Lg3Iv8pD/BHgIjXX5gX/x7sRic8aefThMFl+gUly5zyxgFMpp03atxo8wqA2N6d1OoLADGJO2Zj7oVPs4pllGCM5OMgh0LwVsKN1PWsYhFWFWc1Zl/4MB/MNDTusghwWr/gbwWpsoWx6pA4jsre9QtZdJjGlOhvfLLlC6S88pLglUio8uuPmsis/UO0wX6CJcvlU3WwYxbv6YwFnNGsWScjdVxf90qa+DHnrM1qJfl1yI+wqCmaLUNNC2SjEkQggbk8PJTWWhgIygoKNJZ32qdi4jkqWAxaDCE5ygBbP4GxxMc0jI8jKJH+UwljOwIokQudRtMlNeKcMFBEdYjr9IpWwoCnjHsR6Cjk6OjzpQhTy9AEUHerf3oMQcqlN/5a0VpMkoc8fs4eG+em52Zl7MezVuLiULaXFt3/niBc+TqY39daFz8zBGBz+N4FzHj9/nX62lHhXOSnY0IKtE7DGqHCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199015)(8936002)(71200400001)(52536014)(9686003)(186003)(2906002)(83380400001)(7696005)(6916009)(6506007)(26005)(66556008)(55016003)(53546011)(64756008)(41300700001)(4326008)(316002)(54906003)(8676002)(66476007)(66446008)(76116006)(478600001)(5660300002)(66946007)(38070700005)(33656002)(86362001)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tqhXivAUp0kLRdeEgb95OQWR/3wewdzvmmdhuabDjXDBQkTyXB06wbmwRLqE?=
 =?us-ascii?Q?gy53rRxnXKl3QMnGRcJfDw/pdsW74haSTIdvJ8zUo7nVoGldhwDO0GVuFOtj?=
 =?us-ascii?Q?Uqw+YoElg3Ynl//TveubFMIkAPCfyP4gtKFqrh4wesaF8D3lx67tmNZgAC4x?=
 =?us-ascii?Q?Nsu4IvYdVzOngtjZHbYMjaVJxKM3krtSniezwuwMVZ+4iRXh1cW1xswc1sQ1?=
 =?us-ascii?Q?f8AV3y3+ITOcvOop6dD8EwdUm/x/Q1GTJAs9/QJw4Q5WWcrkyiAvdP7axTLn?=
 =?us-ascii?Q?Lav+V1yzxh5Fo7Q04LeIxysEdlnHB6N8E+XR2FO7XCe3TrZ+v1GzNdybtk9l?=
 =?us-ascii?Q?SnXwL2dkKMNjQWJKnvwr4it13kigafWMr65rO7PdOS8iWpomHBZ3Iwl0ksV9?=
 =?us-ascii?Q?JyxS44Aayl2xEufM8UwtRFH1REyfmGrxibMD6lEnbAFAZvctooEpvwA7eZEX?=
 =?us-ascii?Q?dv8hSXwcKEgX0LZtI8cFmPOqAjP/UNOS23swAdd1Wis81X4hFhoM+8fUdvSk?=
 =?us-ascii?Q?qhv/xqvyOJrC7rEnseQlqgET/q4Jkg5m6MDCjA8HA0QBb6SHD4TY17gKE1ZK?=
 =?us-ascii?Q?6pnUgy8UF81NthnnpFabLNaR9e9nq7tkzAuUt+8DyCHLVE25dmm7bUrJ3hKj?=
 =?us-ascii?Q?K4ylJzf963adUu39q0mrC8J1gncmu3wd8BX91Zi1pIKM0oQKYcEbLvlKR2Hn?=
 =?us-ascii?Q?kTLwaZeZq+lqFOz5EAvTHKWnSg89qlNxnB0qrjypWZSLsAKpdmyvploG55tp?=
 =?us-ascii?Q?4yOaRgxZxFS3T2ROCR5qZmwI069Gb1F8PGXoptGYhmB5sWcyBSzlfbm4FiNt?=
 =?us-ascii?Q?IgiT0ui+Hy6pbEp/rQJsrumYRTDVp5YMX6KcxejRcvtcQq4cT7vXilI1Sh4k?=
 =?us-ascii?Q?0DbpHK+S3EJYKk2ZmQ4QTlzE1pTaFSYrovyeZgQsKqq08CCo4snZck8VjixQ?=
 =?us-ascii?Q?aRvRZ762L/cupLr9Tl8x37Mr365OD2O0pAo5rhOaXQ3c5/Fnh3MVZ9m8qMmH?=
 =?us-ascii?Q?3hspjN/WR9gGUkI9c4KPxnrC/ZYnJz3ZDexm//gqIgL3NG54JrqZwVls+mvY?=
 =?us-ascii?Q?3HY7FijnWmRfJNNvZU1P9pPt2TGcNIO4iT1DCO73hQhTx0Gx+bWIJtlOlT30?=
 =?us-ascii?Q?2l2AfLNhue8UOn++ZpqABb+nNVnbWtQTQMlIipv94rKD2LkBHBX1oOM+5gyJ?=
 =?us-ascii?Q?cD/mDxP9+GasOuQEyxkB5+siP3KHA/ZvABf0zeKyrCD0dOqaRRrT4+fqUB3N?=
 =?us-ascii?Q?PTD2zerfefbMd34vnSMPRGdc8Hjj+VffTeqkgfNUmaZcPXCpy/gh8DLRgaad?=
 =?us-ascii?Q?3EToLPuOFrAdGp1nAC+Um8CE0EA2sKOpCIObJUpFvC5xpYIYicUOIgKdr2Tn?=
 =?us-ascii?Q?50pLoYoY/iU6mKH+7gv11R43Wxabp5PhbpH/wVHeM7bJMFDukoXVdzRQxUlv?=
 =?us-ascii?Q?bZT2e2qCtxU1WdjUeDuuzN0J5QfEyu03aDgMPUcX2dNn+ZcdPFgbfcUQTYSz?=
 =?us-ascii?Q?8F65fKLK7Y63Pne20akXjTJmc17eaRhGWxH0/TJRhsvYrRBkNW5LkoURAYTH?=
 =?us-ascii?Q?jv/hJ+QeppqMeOmPAhc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27123ebd-f9cb-4724-cd76-08daa8a1e280
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2022 20:24:06.9014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l8WsBSLTeTHPDZ0PHFZwea9GmU1YG2/oRm/2l6Iq27nmQW9Cr+SbMQiLDYJr7VdRAWhoNNj3jYbEuINejwa5sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825
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

> -----Original Message-----
> From: Limonciello, Mario <Mario.Limonciello@amd.com>
> Sent: Wednesday, September 28, 2022 13:45
> To: Limonciello, Mario <Mario.Limonciello@amd.com>; Lendacky, Thomas
> <Thomas.Lendacky@amd.com>; Allen, John <John.Allen@amd.com>
> Cc: stable@vger.kernel.org; Thomas, Rijo-john <Rijo-
> john.Thomas@amd.com>; Herbert Xu <herbert@gondor.apana.org.au>;
> David S. Miller <davem@davemloft.net>; linux-crypto@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
>=20
> SoCs containing 0x14CA are present both in datacenter parts that
> support SEV as well as client parts that support TEE.
>=20
> Cc: stable@vger.kernel.org # 5.15+
> Tested-by: Rijo-john Thomas <Rijo-john.Thomas@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/crypto/ccp/sp-pci.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 792d6da7f0c0..084d052fddcc 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -381,6 +381,15 @@ static const struct psp_vdata pspv3 =3D {
>  	.inten_reg		=3D 0x10690,
>  	.intsts_reg		=3D 0x10694,
>  };
> +
> +static const struct psp_vdata pspv4 =3D {
> +	.sev			=3D &sevv2,
> +	.tee			=3D &teev1,
> +	.feature_reg		=3D 0x109fc,
> +	.inten_reg		=3D 0x10690,
> +	.intsts_reg		=3D 0x10694,
> +};
> +
>  #endif
>=20
>  static const struct sp_dev_vdata dev_vdata[] =3D {
> @@ -426,7 +435,7 @@ static const struct sp_dev_vdata dev_vdata[] =3D {
>  	{	/* 5 */
>  		.bar =3D 2,
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
> -		.psp_vdata =3D &pspv2,
> +		.psp_vdata =3D &pspv4,
>  #endif
>  	},
>  	{	/* 6 */
> --
> 2.34.1

Herbert,

I noticed you sent out the 6.1 PR already.  So I Just wanted to make sure t=
his
didn't get overlooked as it's already got a T-b/A-b.

Thanks!
