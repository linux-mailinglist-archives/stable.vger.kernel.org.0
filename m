Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8DD372FB8
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 20:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhEDSa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 14:30:59 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:53337
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230385AbhEDSa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 14:30:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvpzihxPOVqW5IU9sYzjCDD9RdwsGeiZudgT3kM0xamz8//prgNOWpIf0MWToWrBBQxRF1FrHE46mjNn+HGv568gc84OVr9t63WRi1jmwYH1eIx+XFE8w5+luq4ogETolVLDw6v3DGT0qcaYefPpX4W9YfvkW6vuueJLxXJHHL406/+fd8XHWtZ1x67uAbGFtTpnfGJi3FNxNihtQGT1Nvz4Fk6GwxWNp7bJQ0rIbQE2NwKTgq4bUYUDDp8qeckLc5if4B7QtNNASX6LOWy8xU4TpNfb4Xiy7uc/pOKRurHDz5KYxLrHdEXgmCPMwfSEn8UJOBmS8r1Jz+lrNDPdYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Nmw/Igv0teUIhOEeiFSO7GQNoKtgnfKz9gY1McjRsQ=;
 b=ZU7QraNaZH0QpZ7YGRRjFhznMiY+sCbCarv1aOnuzvYmdY+jRI4Y6ST3QSE7SOWPfYlEjLFTgVLG0AHke6Xuf2qgRpZjnSyspyEjuEqFfs6jr1x7vWbjZvtJ92QHr2m+as2WAhSqQ6m+YhQ1EfROAQY/gizWY9OZaAjjwe2uPpJsdw/6UQB3Kl24LckpTdjZ3b5Kqr1//TEV4ZE1oK1Sxdo8HAnYs3cWt+kQjZe5kZtLzcOU3uiGXRjSaseBgZU2BydDNx7jHVZP/65qnsQGO+pn8rd4jJ+qanVT7cVm11H3WP6n4UszTUd3TLpdlAs4axZTXL3Qp0m8T6KmXsOeNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Nmw/Igv0teUIhOEeiFSO7GQNoKtgnfKz9gY1McjRsQ=;
 b=AHtpvk+yyMglZGpQNtgl/Cu9q+zlFHVFZU7RQiuv0sbSFEE72j9unHIjRhVwzQDJ93QvG+0jUys7D7454jHQuLF8IB+FcZqjke6vWST9mlnE3HDm/9KRAyD/Q3T5OtF/mXvaKnfPYDpVTEqnlekxqqeVGGqvO0TOAwa9nUaHNO8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3108.namprd12.prod.outlook.com (2603:10b6:408:40::20)
 by BN6PR1201MB0148.namprd12.prod.outlook.com (2603:10b6:405:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 4 May
 2021 18:30:01 +0000
Received: from BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::418b:8ea0:dc4b:d211]) by BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::418b:8ea0:dc4b:d211%6]) with mapi id 15.20.4065.039; Tue, 4 May 2021
 18:30:01 +0000
Date:   Tue, 4 May 2021 14:29:54 -0400
From:   Yazen Ghannam <yazen.ghannam@amd.com>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Smita.KoralahalliChannabasappa@amd.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/MCE: Don't call kill_me_now() directly
Message-ID: <20210504182954.GA25053@aus-x-yghannam.amd.com>
References: <20210504174712.27675-1-Yazen.Ghannam@amd.com>
 <20210504174712.27675-3-Yazen.Ghannam@amd.com>
 <20210504180734.GA721714@agluck-desk2.amr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504180734.GA721714@agluck-desk2.amr.corp.intel.com>
X-Originating-IP: [165.204.25.250]
X-ClientProxiedBy: BN6PR22CA0039.namprd22.prod.outlook.com
 (2603:10b6:404:37::25) To BN8PR12MB3108.namprd12.prod.outlook.com
 (2603:10b6:408:40::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from aus-x-yghannam.amd.com (165.204.25.250) by BN6PR22CA0039.namprd22.prod.outlook.com (2603:10b6:404:37::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 18:30:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 668eec9c-7070-4fa6-048e-08d90f2aa0ef
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01487F57B8B1DBE0FDEE47A1F85A9@BN6PR1201MB0148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wIO/O+wOaFzHIgPLhl3sBA0izUjGD4wnW/nVBS852+ck47Tlg5Dp1JERWYnery5ULjHI9X1rytVkcNYxkxkMblYF0Qm0JGMt91dSIZFMoAP8ZKzDYodbyALYpvC5Rv6PZyXk+ulWDHK3oFsxqOEfaF3jAEX33m2BAGDyLK04egZQp6RqhDJMXQeSsDZYsClktb9ChR1GYyClZ5uBVze/W0DzCHQWh+FzhcSwmXfzuiwSIcDAcDlvog1pJbJZlY6lBS/cAuAAhQPX+CLa1Oz1jzc9iizA+oHofV2zmANahPG2csq8hS7tLxL3ddxUuIsaG6AVMt4jOJUKm6b+EMbamEb5aTe52hzaylBDozwgYJ6WsXFSGcZQRaTVHQqUJRyEdA1FoN14RImiCKqDiMSzOr0TS+DuXx2j6cZn7YU7/dl/4yIvSudoCwt1ApZ/n/xqC6wmZceXbEr5ea394DZdajBWP0x7JwFC/NR3QUq9tecLQX+Ftul1ztJ+WxfYCpJaE1KyIUIA544/us+Dbt/ElYUttvz1UZqLuA+eDroa13aOSjBwxZJXtnxkJZ2eLDCDT1tcIPS6OhImvqmkL/hK/xYwptHV9/eIhXbiPF1O7lZWu9/SAcVvm/u1LZDtfnlPJNPhMGqpwPdtI1JFwamrOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3108.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(478600001)(38350700002)(6916009)(55016002)(8676002)(86362001)(316002)(33656002)(38100700002)(186003)(956004)(6666004)(26005)(8936002)(2906002)(66476007)(66556008)(52116002)(7696005)(66946007)(1076003)(44832011)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RQ5MF3gSpFIsGXFJlhyCDthzXdQ/pGikmu6IM4SPzc+DSlCYGVQ4JBEj7frh?=
 =?us-ascii?Q?roktDBU0jMTnxSsCvs9HuRkLc89J/mtfTAhRQGqDv7TlaGcjoQCotxqIbYQt?=
 =?us-ascii?Q?QWRJixQDPoriFch1+RNB+o1YVesd5Xc+arNA0758R3YIWoMiMzCmwY6DRRS6?=
 =?us-ascii?Q?tgKOLH3NilIbOlS7o37XNads6IbBtf3mp1KjBzMq0WTTRO6rNLrhK31jWLRP?=
 =?us-ascii?Q?Q26D8Q7dX5V1vtqnEib4tmX60pBH36J75t88LEFA3kmaSzyIQqfIwVJzUk7h?=
 =?us-ascii?Q?cf9htBV2JWFT0kFfxIFBSJDgzzKxMYwzDXNDOFiDYZiYW8aA/gDf0IGkE39/?=
 =?us-ascii?Q?ifsYsa3oPJfXZhN/wCI+HuKcg1d49yFzRP7/j/Q+FOEfmP36HR7UdfX0sHaV?=
 =?us-ascii?Q?fHNJdbXGJxp+xifMqaFdAjhubieGset6x5a6Hpa1gltAkusbkIxg6aX8Kb3R?=
 =?us-ascii?Q?WKZuIzORjYZSykuTWNGAGAS1EuKssZ99nh5ZRdcabDpqjrMd2y7qPnSPcPIn?=
 =?us-ascii?Q?6VtcxOIRcOMm0peDom0fFxr4clGWJU4V0eIo68q9t+rTLG9fVe9hs2o+9GjB?=
 =?us-ascii?Q?EHdN+WPsnC8gS943cYwVq3C4R21vn9x+Afgzxh5Hzzd2t6hsUI1W3N0WP+Uo?=
 =?us-ascii?Q?PFa+qtMEXmbqhqXHSNdfrbslGSK99IXppfWV2GvQ5oGdVDxqG8HdLMCJxUE2?=
 =?us-ascii?Q?bGvDrrLV1YBYaw1s3jdDrE4RqANJ8nQL6yMcrMRHPY5esAST54f8i6lyZgH1?=
 =?us-ascii?Q?BxkvUG93o3dTogSD90pMQqU3rlSk5zfldbH7VOA9O1tQrzpSuqUld4IjuQRN?=
 =?us-ascii?Q?Dw3cqtiYKCYZaqkv9rR56rGZ4H1vTmRze3pUcpf1AIuv5VCQ6+J+5qvHmYIY?=
 =?us-ascii?Q?YxMsqZzZ3I8bLGYWPrGVW02CJtt3shA8Os2czJ1H7bSk8ObpP2EOrABnPI/M?=
 =?us-ascii?Q?g5fyKQ0QPHnxUfcUnZmUthi5dHdGIs6KKSJJfMUmH//rsUSoS7soCueRyYgv?=
 =?us-ascii?Q?qAoxFwPm8CIyTAIsv0f3qMXANmuG84/Z0/ikUVFwoedDZI/V+1bgLNV9hQ80?=
 =?us-ascii?Q?pdU/yXXDLY84hEueBDRFyx/xkoait1hNGLmM65/inH4JgnJUOfJQ3xLFtYoG?=
 =?us-ascii?Q?/MNY5SeCS6D4KeIcfmgonk8hlU9EUreM8jt9gPG9Oclt6+Y8t+KsjV9UNqNz?=
 =?us-ascii?Q?OuIpLsL6s9tg27kxGewE5Y+cZzckRZ22WeZalvFjAG52wW9VFIPm4G8UbVuF?=
 =?us-ascii?Q?ZXyT1CTGCYCkD5+0WQ8GFkIwxZ3jgwFxAeegjbiG9cAwpy+C4JrM71KmVrH9?=
 =?us-ascii?Q?9fMsmB9y9c4pyw+htGvqJ9ZC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 668eec9c-7070-4fa6-048e-08d90f2aa0ef
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3108.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 18:30:01.4096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: coGoTHJyC5drTrRgsAi/Ch0OHYEkskiFe7o33sfGlKowlqlGqc3+j4272SrNmjnX2wFCQ2OL+mxMOu9xZEzsAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0148
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 11:07:34AM -0700, Luck, Tony wrote:
> On Tue, May 04, 2021 at 05:47:12PM +0000, Yazen Ghannam wrote:
...
> > diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> > index 308fb644b94a..9040d45ed997 100644
> > --- a/arch/x86/kernel/cpu/mce/core.c
> > +++ b/arch/x86/kernel/cpu/mce/core.c
> > @@ -1285,10 +1285,7 @@ static void queue_task_work(struct mce *m, int kill_current_task)
> >  	current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
> >  	current->mce_whole_page = whole_page(m);
> >  
> > -	if (kill_current_task)
> > -		current->mce_kill_me.func = kill_me_now;
> > -	else
> > -		current->mce_kill_me.func = kill_me_maybe;
> > +	current->mce_kill_me.func = kill_me_maybe;
> >  
> >  	task_work_add(current, &current->mce_kill_me, TWA_RESUME);
> >  }
> 
> Could we just get rid of kill_me_now() at the same time? It's only
> one line, and with this change only called in one place (from
> kill_me_maybe()) ... just put the force_sig(SIGBUS); inline?
>

Okay, will do.

Thanks,
Yazen
