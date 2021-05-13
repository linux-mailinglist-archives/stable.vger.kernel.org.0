Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3237FC93
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 19:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhEMRfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 13:35:38 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:30913
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231156AbhEMRfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 13:35:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6tnrhWjtYGnNDZbLMTXCds9mOkCtNJdT2f9lsTsl3qnlTf6T2NU5XWHg+Mw1rHPGDrCw/XCCphdmOpmhwR7iRjflTJMHUSGEE7x9m8yhr6j7r1QdtNiXgb97JbarbMmOpv+rz8qwjjzEeNBVca6dOUbNK50PYZ+bB4fqmSyPYb2GinZeX079WbZXHAl1bW/op+N8YNtVdz0r8aklyDCe991JXZ3qJaB6E7bTtj57rO8tk4mulEj/Ft1WcNHpVN9Z9ScpqSqnPKMY35o1JsdQ2AgXu22QOu3eHEf+C9kIvIvHYu2sMtbKE/eBo3wgn6BJ6IijK4t+mGRs3ch1UzF8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zCT9/nuWGNCleT5nl35NL2ScSB20YAg3C8svSoRTQg=;
 b=RIhKtwBEjGEpUq8jwe5X5s5S3SKZg5LkQzX/h5KTjVvyb1dHb7PjtK+tE+uCcC2bpViyC6Ic9z3Le27Y98eM1+akbqKXO8h2PDz6DXC4hWvPdhm0S6vK+ALjo5IvUnMfHX5sDd8yQKSZZpLTyfxqihs/siLRYtTpgd6jg+Yh1OjYK9jPP+3Q9OhsMezuH29BcYX1i1pwxY/ti/YGfkH2DH3oNezn3iNLmyKwSS96efvzfrGWjDn5qSHw0xRzk3wmcu6F5iPIzaqmVnmfLXuY7uLjz4PxpQLNKVSaW3eJkdj0MNiWuEIsSHY+Qaor1Hd4fbQhm0ese5CyZ1rgK5OZCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zCT9/nuWGNCleT5nl35NL2ScSB20YAg3C8svSoRTQg=;
 b=mE0bSIRK8qEX3VTAgDAqsbmqWl91XNLpeBOyh9ubWMnMRz5f1SL/z9wVg9EkBOl49lKk/Mkco3qyqSkkE/Eock5k1qaKBH2DavFJgW+T8jpBanBLR4F4NiU/x24mV3d9dNI2GSdLnh4p2gL5AtjQhh6uEUG8lsm6REhTblSRVzo95ZCaPrROYzYI6mEWo1R8MD4vr5gvc97f6WSK347VFuXxHnOKFEQx5VzEimNRE1JxCDC7JDGWJQU3/BhXLvqg4MLEk1X0vgBHt3bg72a867I3fdqD1ibZVXK2pvrYiJwJkgqTNoXesviiSxq2QG99OUqWGyEm1fod3L5T3YPsgQ==
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1433.namprd12.prod.outlook.com (2603:10b6:3:73::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 13 May
 2021 17:34:24 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 17:34:24 +0000
Date:   Thu, 13 May 2021 14:34:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
Message-ID: <20210513173422.GM1002214@nvidia.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512124120.GV1002214@nvidia.com>
 <759f8840-671a-446c-875b-798dceb10d0f@linux.ibm.com>
 <20210513172509.GJ1002214@nvidia.com>
 <20210513193203.2cc75952.pasic@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513193203.2cc75952.pasic@linux.ibm.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR12CA0012.namprd12.prod.outlook.com
 (2603:10b6:208:a8::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR12CA0012.namprd12.prod.outlook.com (2603:10b6:208:a8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Thu, 13 May 2021 17:34:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lhFE6-0077sZ-Li; Thu, 13 May 2021 14:34:22 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49921848-a289-4cd7-902b-08d916355984
X-MS-TrafficTypeDiagnostic: DM5PR12MB1433:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1433EB2DF7EB1CD3EEF7D804C2519@DM5PR12MB1433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XMIg91dp1JboEu1AIv2XArBSN4zLdyI6xPCrljzVUAMBZW8mY02eW911jd55ZUYaIHrodmwir/Y0n9ZQOxZ4Mt6bZA7R88H7NxmeQBYN8dP0DkzSYIHEOG0BGj4PFSAyx1fZV44zFfGO1iBSNn8i/vD2yOuln3AHCmrPAN5DZApldCQrMdSIthty05qP3laez3TEyTENJg7doLbKYRKYATb3GYA9GLbkSnlmREhP8Oau03UZ8qSHUqiZOwrnR1FW29RfyslSL/Tbu9rHIseUuFGmto6YCzM6RSr/ZQOibLPKIPC+LdmcUYGBrDnmG1cV6Rowumjupb6MD7POJxnolSkHUnlO0gPmMB6FnZ2nNiGRVeYY7kCf3iZ2cp1cZKxAHMaelWWtWZQpRHemvU4tN1P3SlK84WvQnKb/uGNcSVwB3+KuwODqNpDY9DAgivBhPowEZYdFNO8iOnvX+7spdUQedfuwLvG/C16KFAoroLi3MgRKKujdFkheOXgGRn+13VvAyM8c8I5YM9c94xcxfSP7G59Bpicae0a6913jC3oTOsudW4WnJmBGTbRFeg9ssph8E7ag8+bV1CGQFLtADSTKH3K91No/dFgJHer1o4s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39850400004)(36756003)(86362001)(33656002)(38100700002)(7416002)(26005)(66556008)(66946007)(1076003)(2616005)(2906002)(4326008)(316002)(54906003)(6916009)(8676002)(478600001)(426003)(186003)(8936002)(9786002)(9746002)(4744005)(66476007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9fQ4RgP/glAA8kGlF3iNXujtycBVNWZEB843jW3x5DPvFymNglT3ERYeonbl?=
 =?us-ascii?Q?5nzql0ILCGvlrxfldpczHaMBk6zJ3Y+kepFydV/Y4J64bvptzGOqF8OquWbt?=
 =?us-ascii?Q?TJ4mPf5LzEngw/WuPgF/4jGdg49kyUFV1lfIjjYr8ZxNvRImMn6+3lmn+/ZN?=
 =?us-ascii?Q?Ogh8m29Pe4hoJfvR9yjRy6HUTVwcVl05O3D1CIm9h3n+cFOzH3BuRTsQsbJ3?=
 =?us-ascii?Q?GlVYP1lEQX3/Lur4onEezfM+4ve+o65HivIPPEPiLeZvFaAdGR/5ZF5pIRAg?=
 =?us-ascii?Q?LWwpFzWEQ07149XNvKqQDbWJOslXMVSDJFiV4bkWhbN128P/yY0jgxxfQZaQ?=
 =?us-ascii?Q?NysXnCyhHjogUz6gK45Wl90Fs4IYbw/iaKTzX6Qwp3/8aK6Gq4sDHZaxQ+4Y?=
 =?us-ascii?Q?C8qpy3lNSZtJt4yjU/69X6SOPr4jVu/OpHCMK2KW2KswOkR+0fyCB9JzfpgS?=
 =?us-ascii?Q?zz4pPJzOaoFGgkwcrcppl5FHj8onzTTDU0qHIG83x2e/vfwPHR6Lon8rs2MA?=
 =?us-ascii?Q?nlT7gmUZFWJO52JLI5nQPcGjvdZ3l/w3Kns3BxTG5nDh50pLwb/OoaAcy+CT?=
 =?us-ascii?Q?cBo9GbVHbIkAVxbV5yisD9079+PWsGWLv9YEG7v/69sB4arQtkFz0l0Oodc/?=
 =?us-ascii?Q?D46eU2Ci03GDsGdkjaHytWyt+VfgXCNzcrz1CWoEabCDc4sE0aLpnZQTcjFI?=
 =?us-ascii?Q?0q22i7UM5JBbh835oHD1EgmzYBoHnoOVO8MRzRIWBzZspia7iah92MXuz5f8?=
 =?us-ascii?Q?Q+5zAmw7FL6qRSrNptuf2sw0NEloxiUyMOxDXGz+D9TX6K3zP1Mna3xYZ6la?=
 =?us-ascii?Q?RJPy+YepN8dU2dfixP+1mr37Ih6tngnzqcNmeL0ngjWFoFEw3jmzpOHgFwV3?=
 =?us-ascii?Q?1xHu8Rza31kKNp2GM0YKVi9ZWERS0FHMu8Vbn5MyKFTD04G6B1tuAK+jY7SQ?=
 =?us-ascii?Q?B0HDC9wAxAvCAPK/edD2Zeac10PlVGnFcDBt1OTiCBIAwEQ4g2Eg0PnJUSIn?=
 =?us-ascii?Q?i4+NemC3JUKJieCeEe5IMoaKNbw91TX5hg5tj0BdKUCySnomB57bk0caDEIN?=
 =?us-ascii?Q?jgzlrhmueWXBjLF8FHNNABjahIHfBLPgIRRhgTPBNUt9v6obXwPtBBhwAdRH?=
 =?us-ascii?Q?SrGkYKmOI5pK9uIcSZzX2voqF+OQ6YTJMfDHFtJJODnN490H0qyLDg8BK/vX?=
 =?us-ascii?Q?45YIkG0DIxT8W5mR/rN9WSsRf0dFWa1V1E9qf/q3VmoMhvq0OgXdvy8Z14Kx?=
 =?us-ascii?Q?llyV2zKtX/2NcOTTb/+Oqg64PKsyayjc92O14S5chxVc60a0rgHPcSPGUq8d?=
 =?us-ascii?Q?LmeYDgHCZv2nH03acqEIIu2g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49921848-a289-4cd7-902b-08d916355984
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 17:34:24.2412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ajpxoZX9Y3yUF0exhQhCspNqHQbMUfIjK5jtzI4KcuRIYPeDZHFo+YrCa3H6rge
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1433
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 07:32:03PM +0200, Halil Pasic wrote:
> On Thu, 13 May 2021 14:25:09 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > > I'm sorry, I don't know what a -rc branch is nor how to push this
> > > to Alex's tree, but I'd be happy to do so if you tell me now:)  
> > 
> > If Christian takes it for 5.13-rc then that is OK
> 
> I'm pretty confident that Christian is handling this. IMHO there is
> no need to bother Alex with it.

We need to ensure there are not a bunch of conflicts with the VFIO
tree that will have a nother batch of work on this driver for the next
merge window.
 
Jason
