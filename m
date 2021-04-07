Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D776357467
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 20:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242032AbhDGSdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 14:33:54 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:38497
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230020AbhDGSdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 14:33:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkxq9DnUZhoLrmDKh4EoPdA6iw8MalIx5KCGNczlW2gAw9/eLnPsJT7iBYxwmIlGyiQPuLuRyCZVQZATV8PeuKtqNqY/sTeoC3dtpCGHYtXZSQTHCgbVnr2Js7DPMnnc1qXq6ky3a2EJHYaq8dqg0vjli9JfKLkI5mqCrA9T/WOTrw7Y+4HyEcUCIKGbXW3dUPfLrnZNeRCynkZltWnk/93ujE5T1PTWal9B8PcANpIGpag9y7b5I/MpcRr85Xyj8xRZkZIQHvgejm06p+/pPAcPBxpjarv0ksaXgkuBJX2t79g+ziJLYnKfWqjTLux5XzFL8mM1EFsBSIWPWiUQZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRv7v1SrD9a1WHL7qtPjXS6Y19w4HClqAivQ5IKxQ1g=;
 b=VSfsjAgA75WlSJuFohfFx+rX6ugUAafRUzqil7JFsJjBcfQHnPXQ+Lo+caHcDjjFJDEv+R/t6ocf1eIEN3x9hn0S9z/sJgFVBPTC4qCXePOiWiLDBfNZu/lwjx3R4hZdjK4Wtkh4wQ54YVu8YuqB2N8/Y/5cNKpDnye1MOBoFGB8R4ItglRi5Ndw9lf2NeDsqtKPln2cVaYiMSuz/Uz9apf85lwXkCd2tLsj63H2EQSxSP8rgmn1vNwaupF8Xk0H5vUyYgDrES6teMTam/sok1vnLhvNWkWdf8gew9cRrq2cBEjuokMM30/RGosRcbVEFPUgvWvE14vMqTCrp+U7cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRv7v1SrD9a1WHL7qtPjXS6Y19w4HClqAivQ5IKxQ1g=;
 b=iRWgZgrw6FxaWXywllDi5zQrP4bDSYh4qsCRFar4nYaZP2JKU5fcpPXbnSjufeGpy1v08pnJUDmsEvNdikfWKJN+kTATslmZBy0ywqvgJ0zWj/a5J2Gw75v/arpHfU39BWC8wcUmnjZJo7gDdCmG2aJdAwEHYmr+u5qtO9V+Xsmu8PrHEYuHDYtyYdym17YR0bCePtEp+E7t0QEjaGjt4jA5MSGejF23/GKQ9o7cghcnk0sisHUUjn0YoIfagLgzgXwgho4amuToj/T+gePZG1zz55y9Ee6NOFZh3kin67P+2e27iyBtNGzI+bgO9x/Q7KFxJ5FAxO14a6V4g3FW0w==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4973.namprd12.prod.outlook.com (2603:10b6:5:1b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 18:33:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 18:33:43 +0000
Date:   Wed, 7 Apr 2021 15:33:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     dennis.dalessandro@cornelisnetworks.com, dledford@redhat.com,
        linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-rc 4/4] IB/hfi1: Fix regressions in security fix
Message-ID: <20210407183341.GA551308@nvidia.com>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-5-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329183609.GA3014244@iweiny-DESK2.sc.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329183609.GA3014244@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR01CA0040.prod.exchangelabs.com (2603:10b6:208:23f::9)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0040.prod.exchangelabs.com (2603:10b6:208:23f::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 18:33:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUCzl-002JQm-RA; Wed, 07 Apr 2021 15:33:41 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cb165b7-b6ec-43de-12e9-08d8f9f3ac07
X-MS-TrafficTypeDiagnostic: DM6PR12MB4973:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4973B4A180E0CC0861BE9028C2759@DM6PR12MB4973.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zWDsUH9Xe1zBS3RM5Q3nsxDdaB4MM1bJs6vBeMN1ReWI2ApsYvS6/NxIRPjG626D0PLA+43dDfZ2EVa1khjTZQ/tcV6US7EsW+fY5W+RbAdnstl/COmBBl9C0bsoQON1hAJmeKEiJtaagisZDHXSfi8zl30pKhQpYFGs+NXhGas8AnX2hZssQIoyTL55ZClw0cTxZJpHC8d8CrFLNzwmULutMRENo0+JUEk4UAz6LlKDtfB7c/vP/ZtB8hu6+tRHTNMqggbxwfBUrUViHSq5gG2ZXFphPNGgKIoFkPAAEECAopkeA7MQJv3S54pvP/BezyyyCihx+vqkn+Y8NkrejzoLQbcWO7X5CyQ3jhoL89RkdNFlDUhjYmt3j7Sy6prguaz1nzI9uWFcsqfplQCOED2vi/rxpnMxSo90Ujp+jKPeBOCe8qO0s3xBxVTRkdp3sbCI1tYz6N8tPpKzRD2OUYjGNnPXE35p8nM4qagGvLs43LU75LyRkKQktDCR0S3EgpeJttaWlykNk3Jz61Uete/r0ReF4rHk8JKBOpYIXcK8jbt2TGJ6i9225ATxPNqn1O6cH+wSTJI0klv50mbLUmbv9UXMI9WdehE0dL7312ea06PfxWCkkyPuF11GUQlg/E8yyyo/OPopEfLz/FTddbBuH2xOWFYwBWJyix4nGLcyHFnjFaxxy3bgjKoyMb01
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(4326008)(36756003)(1076003)(66946007)(8676002)(426003)(186003)(33656002)(86362001)(66556008)(66476007)(8936002)(83380400001)(38100700001)(2906002)(2616005)(15650500001)(9786002)(316002)(6916009)(9746002)(478600001)(26005)(5660300002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j/y9OzrUQ557saAqPpGsGN3plewwhg5SuuL3nuMSl/ppoyuWJyHtgwh3su5Q?=
 =?us-ascii?Q?/tJDCGIEcrSdrBnobw2117CtejilWikUIuv4PEFIX1U+kdBRSnVdimA/WcFS?=
 =?us-ascii?Q?QTXgjrQlbIdU4XxZNSItuo73KoPPgC09ZPa/7sDLaCLCADkhr5mNtfKjlNFc?=
 =?us-ascii?Q?rSO0ZjLJrY6fB2gdpSy9DYcgxKvxEqIZIbtAICNA6C7YVOcy3jBb47VvcgrO?=
 =?us-ascii?Q?R14LplNqCZNlKtOLUAuiUeOU5l71YJlH/DlgUOD4rQ2S40MSiWop8XirDPSJ?=
 =?us-ascii?Q?gahrVcfsOpyOt6+2KnHjR82qYVw5Y0nBGdcd0ww4phf9dvepERL0c+ygL6Fy?=
 =?us-ascii?Q?LzBA86SA418pHnHCKOphUx1Sm8OtrbLqu2tEEtHyzKJ50970pX/B/B31YewF?=
 =?us-ascii?Q?x/NxCZ5xzTMkKYtlwdaABmGXYrT5YbTBdDnnR1BjIapMBCbw1ZP4XHvYqsMK?=
 =?us-ascii?Q?tc4Yd3S8CsBAH1iXFwu3AarTp4R9CN6BzY54Wac3+roWHCXu4iaagydlutIN?=
 =?us-ascii?Q?e0fDz4AhLMqNxm3yVKFJ5XtwaLlGCpGOqlwD9FiwathaRxddRE4IKUrtD1RC?=
 =?us-ascii?Q?0k7fNNN4x7s0j6gq8OvCyzI2/WadO0HBGa+KWVpV2G+Dz240WDbX0bwzd/dc?=
 =?us-ascii?Q?DSGdENDXW3jNiSl1YFEX91osRkkNU6hxw+4rB7Ewxl4PhZfC7I2Qo5Eh0470?=
 =?us-ascii?Q?hlwz05fqR0hNXVYYHDSEHX27OQu5GCy641Ykm5s5bls9zVVgitLp4/2aj4a+?=
 =?us-ascii?Q?slsEAr0C6VbCB9OiYmlKlnF1VzdglgqBqoazAhrrhLf5YtNAFxKzrsbyzfih?=
 =?us-ascii?Q?IUGJ1d3rbgTaC/nNpBAEMEZ4JlLd5yjN1Pfyz9lZS0yOgS5d8S/JwMx+GETk?=
 =?us-ascii?Q?wN8pC0R1phJMRjViPv5z7oHlCkYdIvi0bEVAk8LZ8hpSzxEVbyK/fFNzjXMv?=
 =?us-ascii?Q?uv5zmqNC2cteaJFv0PHk8+GTeDSvw0T431hb2n+0rvrO+CeqO5Oyv0EZOtRo?=
 =?us-ascii?Q?LTmGzTrmGyW/m0T2Jye+pp1enA9bWAV4fZpe4WvZwXvFiRXTZ/jQ56Bdgaqy?=
 =?us-ascii?Q?XG7cWRAiRBUlATqekHV8Qr7oz2N6L6TfN7d9SOrEhd2+hkUFOHOdfudIH9hW?=
 =?us-ascii?Q?zs/sArJKaDshV0LriOIsOBqGBZAOK/n9lZfJLbwcfvTbgCeHV694HxXZVsSv?=
 =?us-ascii?Q?4jw94Sqo759ayi8B8iAkTBaaj8+P/5bxJ5mUfqVWhEgHqBjOJCUHVfLPpH6f?=
 =?us-ascii?Q?89NXK7lgjvl9cY2cEWsv9GmC3JCIIDWhtQgL/7HpVx5D5nzVxBPVM2RTvrOh?=
 =?us-ascii?Q?EWdw5Tx71PTy4pmp1ylH8VVUonRkf0eeD/cJY4M5eXfD4Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb165b7-b6ec-43de-12e9-08d8f9f3ac07
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 18:33:43.4587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ldw41aBQhm7Rl5JzLgLaKd2mXhrVIirNnoAnVGW9BcRnDFkNR5h+TZh8ikB2rXH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4973
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 11:36:09AM -0700, Ira Weiny wrote:
> On Mon, Mar 29, 2021 at 09:48:20AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
> > From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> > 
> > The security code guards for non-current mm in all cases for
> > updating the rb tree.
> > 
> > That is ok for insert, but NOT ok for remove, since the insert
> > has already guarded the node from being inserted and the remove
> > can be called with a different mm because of a segfault other similar
> > "close" issues where current-mm is NULL.
> > 
> > Best case, is we leak pages. worst case we delete items for an lru_list
> > more than once:
> > [20945.911107] list_del corruption, ffffa0cd536bcac8->next is LIST_POISON1 (dead000000000100)
> > 
> > Fix by removing the guard from any functions that remove nodes
> > from the tree assuming the node was entered into the tree as valid since
> > the insert is guarded.
> 
> Does this open up a child process being able to remove nodes which the parent
> added?

Dennis?

Jason
