Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F4C3747A7
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 20:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhEESBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 14:01:51 -0400
Received: from mail-bn8nam11on2065.outbound.protection.outlook.com ([40.107.236.65]:4904
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234444AbhEESBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 14:01:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IF8u7V0XndpfnBa9rU0ATFaFrnUhx3H6ET5MkJbtpHOqxCaijJ3Nv+Ch3HOaRR8SnMfj+/Dj+274Nj/kZWLkpNWWwI7N5lHR9qzJgxppHsfEcQkrEDv7ZQj2K3saKXuw5B6V1BDrZIVWv+n2e0sSmxbjGNbysgbFhIULqP18YqusAzhTl84OurE1Vuxb8ISKuI2eYBfuFgyEdrQeu5YpbYQKpjqs8oCcWRjSxvK4y5k22Xkg93oR9z7XZqMG8qNB2smgLvRch+GJx9QDUecAQht9byZ4xMg4XXId3ryL+sQaPvgRR7JHw7SwtBNtxPBR3ta1AypYAJ6p7VsR9EA+Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3MNI2M1iznplajhBFUkNWzVjrtq4MQbk0Hk1/AzHtM=;
 b=MfvsJkmJ6a6z6YKZP2rnfumBWw/eK5g4Fv0lktxVVXuCTdJ/QaHX79ZyoRpt0GnzJ1kJBomJKpB5lO/pYGfpGUtWItPw5azUdf1Cd6tndoPw6qHSROC8admObXrKxLSzrD8LuBRjytNAgEIflHKN3M8PN4YdElCnEp1PDnoKlPeSnvGksR6XyyWOjBTL1rZ73wexFoVfMeTUOaA532wOH7mBz+VsLNrj02Zr7hVjbEUki8mAtTT+TrzvtpyWws1rM0V2D4TZgVWi1D5xJX2hRI2/xwU9zhLpjAuuAswtrBuBisaY9kYTBdTr+GJe19Sl+MeFexu83QGT8bdPclWKWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3MNI2M1iznplajhBFUkNWzVjrtq4MQbk0Hk1/AzHtM=;
 b=kEi1xXg/HjxDZ6d7+Z+FX6XGm3+bdrDcnp9UBneDLsFNs9FAEnmWVOcCx4uphr93QxkvNzsP9tjhY2ZNVGFdAVJE5K7uLtCXnImX4HCpFXeh/Pnt2CJGOUUrYy/WwI3S94wfwPojgWuzVzVsmT6KkdYQviy33nbt4s2DZsNm7JNm9eoZUUubLHpE2GXSdyYlEefegX+pLKAXJc51S8QiGf4vF/slOg/dcqp96EtgFvl+G5yt/C4ofUuLCZvQUoRaZJ8n3BCejcbxZ2EPPpxVWPsqJRX8J8Zx9Ok0dVSxSOLe9mG282ekjpKdlcqolYtGHJUdGR4cdBqt8rqHXqptyw==
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Wed, 5 May
 2021 18:00:39 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4108.026; Wed, 5 May 2021
 18:00:39 +0000
Date:   Wed, 5 May 2021 15:00:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH] s390/vfio-ap: fix memory leak in mdev remove callback
Message-ID: <20210505180038.GK1370958@nvidia.com>
References: <20210505172826.105304-1-akrowiak@linux.ibm.com>
 <7b20afce-5782-53c6-beab-ae852ae69b40@de.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b20afce-5782-53c6-beab-ae852ae69b40@de.ibm.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR15CA0049.namprd15.prod.outlook.com
 (2603:10b6:208:237::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR15CA0049.namprd15.prod.outlook.com (2603:10b6:208:237::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 18:00:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1leLp8-0017u4-9F; Wed, 05 May 2021 15:00:38 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ecfabdf-41b0-4aa3-0b6f-08d90fefb140
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267B40BDAB0DB8A9B22F4C2C2599@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d4Futp+7XpAnawhX3qZwwLGAAZmMgnKS6RG9X2jOnITVyn31EU6C2mJf1T2FbPMxZMVQF2mHLfp0uww5OMxNEJLRRYRno8MZKs9AkOx5sawfo7Q8XOuWmHZpKMF6pFEshvulvqAEwBB1LHIF5ir6WmJ0pVe+cnGvpunlQLf2OkS5s9+tw6+hGPhfcXQSBblRO1/fSMsX/0oSz1A+7rE9UAKsjmZRJBF3sv5YcND1HpzHpW5qMnG9vlEkKx4jHBi0bc4Q+CqCmgJBDafEWJfFF29RgX6HjUHAMi0Xg+LdxYq+I8v9spM3dYOT+pP4LWSXsmgufoY5LTy7aaIAYkHACXRxOzzVEhpP18rFiV56w39N+Xojo9t58skEFEXQBvGkKjiX6koZ4a1kAThgp1eSx3xO3Wc+w1QI0QlD4Xz8NpS69FmnxHQp3oT3Le2ewWymLA7KUCBdrCXJYN9grhEM4CKyS1/gw3gY3CPXy+ReiVyuvxRrtO+HCkqHSxWGKk4PYKyKn+QzuCZF8VQQL92USWm1u6d5Hud+yGgwltbfjbKKbQanYzGMxp5M6z2BWzY+aFOcX6owXLS+POzKhmZ43UWVWyx8abYRuDkPWydesv4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(33656002)(53546011)(8936002)(54906003)(478600001)(2616005)(7416002)(316002)(6916009)(36756003)(1076003)(4326008)(2906002)(5660300002)(186003)(38100700002)(86362001)(426003)(66946007)(66476007)(66556008)(9786002)(83380400001)(9746002)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xoKWpY4Uvd2lEf3JjBBPj+7YjHaS5qo6GN0QVcWt0fGKupgZ/SZKiSN9hp5i?=
 =?us-ascii?Q?a2WrgW2F3agFu8plq9VjA8s3DpJNg5Oa1sbP3kYGXyd4ajNk9EVKefqP4HjP?=
 =?us-ascii?Q?vc3nzLd/NFMrPvLYKwn1AdMRIhT/W5TkTY/dFX+UwaFRdazIXpKGdC9R+lES?=
 =?us-ascii?Q?Vw38Rg0tfmTVvEhUgdk7Ot7LWfdWaLZ3xOVm/Vt8t8dmKn7Q1LwZ88EgKKnG?=
 =?us-ascii?Q?NRGhYsdG3BlR9p+UpQqjpjutuq/sA3bMUFlV1R0BV/qF8vb4Uy8xMyXF+6qQ?=
 =?us-ascii?Q?mlATFVT9gzNt3dFqQBjQ69S0UK7M2UnIguBi0ViR84vAXCej+e0R1j0MSalP?=
 =?us-ascii?Q?oYQ41SNcYfz/azo57w2JoHW913WMusviWlLq3bpsvt1v61efsbTOgRNQx8qb?=
 =?us-ascii?Q?XK3qi1JxH8WUCOPrBqQ6mqH/mjgLnd6OdWt2MXVnwVjQve3ug4VIBDdK5Ayo?=
 =?us-ascii?Q?1E2dULvaNstwheuMyXNRlpNb2n7iPBpp7J/AOhQl3vZ6pFmidjtYPH/+uprc?=
 =?us-ascii?Q?2Ww7WNSE1/sttKJdf0mG9PXezR9Mo8zJZXEM6dPnaCamwXBbOcYZxSx8tXgC?=
 =?us-ascii?Q?LMiHnkeRHfdCLPf20ksRjGDCLHqaihzwKdkymexhHQegcJ5x7xqbKNaLgi+a?=
 =?us-ascii?Q?dVbU0io/LfVXgde0K7UT9FiDLH4YdjPDbqYfcOux98ELA5qDlNCzHWkiFguE?=
 =?us-ascii?Q?Sx6TrM3085DUJrt5nybyNjOjpVBwR7jfzlcDkpA8SBUzbZiAn7kl+vhc+SZ9?=
 =?us-ascii?Q?PqgobLs1/1jLAPDuQNppdIOKm+AYLDEF+tITGWBOAmJ1UCYPl9dbNLOpsezL?=
 =?us-ascii?Q?eVNS+zwXQD3MGsVWrU35KAV4keSJwvoyybCuFh+NJR8xEjnW11f73ufUbUti?=
 =?us-ascii?Q?jbbI/wKgMb50Ihmqs1ZQCHfWw2hPkoxQ0XFwFgs+IZRtpYF7NNoMJECze2YQ?=
 =?us-ascii?Q?rr/oR3h4JgUWemA03HOWIuqZ8dQg+h4StDIYvJN6cgtXaFLpbf+nlCujDeD3?=
 =?us-ascii?Q?tySMM7MQaG8WtW1RP9Gx/gSWA1vgwqDCRjCzMuVy/AJHOPnglp27dXBLyDPE?=
 =?us-ascii?Q?f3gzjL8QODx9DAxYx6hsGS9fjAi24lEGNtxpllNuo9EfBX1ifWov83rHjgtw?=
 =?us-ascii?Q?2GtVx52RgOuQP7rvvUxB87UQZ0lPy1fufCwFs3b80TNqIXPxiutOvwOeSNQM?=
 =?us-ascii?Q?vGlcJrZ1diYO7V1yLOiHUBRE9unqua1e+Ux+MaeNH6XbJsHM1y8Mmc86tNO2?=
 =?us-ascii?Q?0cwy0jDywm8IfENEblQZlkrT9pYVlxwuYlhNsmubWs+66yYQp2ILa1SGEyjc?=
 =?us-ascii?Q?Jy73VktdhOBpEXSe4fuQa/xL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ecfabdf-41b0-4aa3-0b6f-08d90fefb140
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 18:00:39.6120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5Qc0C7EjlgxwBop92ywtSn75IxMtT8j+Ukp4FWZK3xqS8LF+eLt1e4lHwtT2ZYV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 07:44:55PM +0200, Christian Borntraeger wrote:
> 
> 
> On 05.05.21 19:28, Tony Krowiak wrote:
> > The mdev remove callback for the vfio_ap device driver bails out with
> > -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
> > to prevent the mdev from being removed while in use; however, returning a
> > non-zero rc does not prevent removal. This could result in a memory leak
> > of the resources allocated when the mdev was created. In addition, the
> > KVM guest will still have access to the AP devices assigned to the mdev
> > even though the mdev no longer exists.
> > 
> > To prevent this scenario, cleanup will be done - including unplugging the
> > AP adapters, domains and control domains - regardless of whether the mdev
> > is in use by a KVM guest or not.
> [...]
> >   static int vfio_ap_mdev_create(struct mdev_device *mdev)
> >   {
> >   	struct ap_matrix_mdev *matrix_mdev;
> > @@ -366,16 +392,9 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
> >   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> >   	mutex_lock(&matrix_dev->lock);
> > -
> > -	/*
> > -	 * If the KVM pointer is in flux or the guest is running, disallow
> > -	 * un-assignment of control domain.
> > -	 */
> > -	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
> > -		mutex_unlock(&matrix_dev->lock);
> > -		return -EBUSY;
> > -	}
> > -
> > +	WARN(vfio_ap_mdev_has_crycb(matrix_mdev),
> > +	     "Removing mdev leaves KVM guest without any crypto devices");
> > +	vfio_ap_mdev_clear_apcb(matrix_mdev);
> 
> Triggering a kernel warning due to an administrative task is not good.
> Can't you simply clear the crycb? Maybe do a printk, but not a WARN.

+1

Jason
