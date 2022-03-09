Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194494D3B73
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 21:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbiCIU5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 15:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiCIU5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 15:57:06 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46204E03;
        Wed,  9 Mar 2022 12:56:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjYDaRMroskn5Dm53wszoaGGnWfBIAAZbbIBPt+tcq0hEKlW4u9GJbzMMSBEdUxuc8kZVifPj/En4ZHkG+E85WQLynMXzQDQajLSzaGWTkX7YoDuDontkHB3UliGVXhfQ2LiyG+L8flZnnQvNe7ETlTI56+Hh7j+DEn/Wv7b3cjv2sSHTp+vu1DD8YbVuuZUziDGOkvlHe/O1sO5JPd7elIPaEWqV5jeuZY3u3x15N+QFuT8MjP2C3Li/A4+goX6Zqo8C+AYJyao+9CrDBzR+kiaBcIq2ShIethKRN1l0RvjoiGWCFv5EirHNVlWwCxy7ZxtTa/kBssTnAWWSjv+Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OSqYKCcUy8DoUGuKrZndpTkCV7xlDlP2pdj8jTZGRF4=;
 b=eNS8eunnjbxKZYioNzQx0zRfnLVk6hMlzQI54tagVbvqdd2YVEU2XQdTqQ0zMRK4npn+ZEuFnOrar9LacYQziid1Ey87CFgGLIgpYqLB4xP62ckf2KdwSEy80sbH2lLMFHgroeyQo6fZ4eqbiQojtggtBFTsXK74eC8qxNwH3I/iMtk65vv18IHvCCW+h8/vh/CU6MjzPkS2KNKI3CYuvyKuntyMEm+GfBeZMX/uB7D75221e7MoHhhWW4PK577E7WkjhcbHLIwLZxDB8y8mVkHhoiyxD+rwI0pdDmRMj3YehKMs4nxTzar2HDBQ/aRHDo8Xbvc3eoHAcP44j4TVzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSqYKCcUy8DoUGuKrZndpTkCV7xlDlP2pdj8jTZGRF4=;
 b=aO+br08ioggrOJv30wNjLsw6Tk9u8FagGif96B+wc3ebYiRltPJroEy+QCbelu+fIY6fU8ZDObHYGhzggvcYm1z/PLPu39Pf+0WO7dEAnof2fY9Y+hdrMHeYeZY8qGjo4nz0PT3rx2Ca+PcIrvC+9cJNk82NIRKdr0uK5k6sTmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3108.namprd12.prod.outlook.com (2603:10b6:408:40::20)
 by BN6PR12MB1201.namprd12.prod.outlook.com (2603:10b6:404:20::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Wed, 9 Mar
 2022 20:56:05 +0000
Received: from BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::ad74:927:9e6:d2cd]) by BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::ad74:927:9e6:d2cd%2]) with mapi id 15.20.5038.029; Wed, 9 Mar 2022
 20:56:05 +0000
Date:   Wed, 9 Mar 2022 20:55:55 +0000
From:   Yazen Ghannam <yazen.ghannam@amd.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when
 `threshold_create_bank()` fails
Message-ID: <YikUW0i4hSh7t74c@yaz-ubuntu>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
 <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
 <4371a592-6686-c535-4daf-993dedb43cd4@gnuweeb.org>
 <109a10da-d1d1-c47a-2f04-31796457f6ff@gnuweeb.org>
 <20220303015826.4176416-1-alviro.iskandar@gnuweeb.org>
 <49313736-61f8-d001-0fe4-b6166c859585@gnuweeb.org>
 <9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org>
 <b18bac61-a27f-8de5-8aa5-10bda9309ac5@gnuweeb.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b18bac61-a27f-8de5-8aa5-10bda9309ac5@gnuweeb.org>
X-ClientProxiedBy: CH2PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:610:53::32) To BN8PR12MB3108.namprd12.prod.outlook.com
 (2603:10b6:408:40::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b86a5d4-bb43-4fd1-c061-08da020f3a07
X-MS-TrafficTypeDiagnostic: BN6PR12MB1201:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB12015AEED1537D3CC25A1A6AF80A9@BN6PR12MB1201.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2YAI7kVNAeqK2qA50jh8CqzvB66/uG6LiJWCHypAgCU5LHHbiOnkIPcYpfwKh6NnTPO7ZWGlFkh52KxzSzQjyRbkpNtuZiIartmZp1Jlq69F2s3peb+Ye233V9jC4J16qYos85FyC8LIPcd6tfzcpKAVUMUlCpbWEfgdUkjb6hrPJnjXjPCqYWHb1+hC5WkoTCgzbjIzzaNznzsZyedhh9ZaE6dNoY3LHPdWgdNn/dRSZeQpqSROG18GVZtbs1qUyJoCDK0HY8vzJGdLmPNCut0SNyAbqDVmw7e2WXBSl2wugEQMltpZ5MSW1yx7JifqjUhEooK07k2wyn7eASmdwULeFEmqXzwLRXU5ZD9oYWgRRn1m0RQyiyzy+dzfReCPbL6CnRjfFt274QRgiX0t28MvSKTM73J6cLB666MfCdHBKWqqnVpe43zuAXZpaZS3tLmEOIH4tiBIW1hR38Eeg6ghFZbx/37JvVaU7IMlMIktlcgftmx1ztAa2CU1bNeWBDmIdUYUcSm2G+8JF2FDZGsdD7ZHI3HLgqEvrvC2LGi0Sz4nVMWKxOvdeUOmu8CcFaolUxW31biX4L9U5nzD6Fhu0B+3CS9SJMftIUFYvUVi1Sgduz/qjeGKjFTgDM+xnFJR6HC8fJ+Zx7yMlopvFMhsfpORp3UcTI0sLvbCw5lcg45KcDMEi9auXLibt327DA6mvApaTtFkadSiM7QxIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3108.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6486002)(316002)(54906003)(6916009)(8676002)(66946007)(4326008)(66556008)(66476007)(508600001)(83380400001)(86362001)(5660300002)(26005)(33716001)(6666004)(186003)(6506007)(7416002)(8936002)(2906002)(38100700002)(53546011)(44832011)(9686003)(6512007)(81973001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4PIIoEo3PYGPBULak38rYHwWu8/y3srfSFIRLuBKTTaOianxNDA7SXGxNkZi?=
 =?us-ascii?Q?z5Pr74o6U4IKBdHkN+hLDu/zEyNGAJ4LVxKFZFMuFeICKikhG1Yr/IZogNzA?=
 =?us-ascii?Q?kEx06p8mGAxIWDUPmRtyl6e6LReCqIRaOB0EngCVN0MLMfVZmMpGsaq1/Oy1?=
 =?us-ascii?Q?093UZLO1v5Suxz1GeaVdcRx9w+puZiWDUqPP0x/n/aYV9gqYOrVCY5jnIWLO?=
 =?us-ascii?Q?SrTIAk3O2DyPVVPUXdr49Xa/uD04axdIt5iSWMJbaISWpVxqvsKQOPHq62xG?=
 =?us-ascii?Q?aerb2pTiGHbxZpbRu5dTjivBwcNCJDSTz+jZdR8ICXJTeifDdHbgZyugBQD1?=
 =?us-ascii?Q?MUb7WtTYrgGl8xYesotrTW+/UqaSM6easj0v+ryXXPHa8TIpZUiuiG8Qi0sJ?=
 =?us-ascii?Q?ppBrAxbI0saJJXhRge47uTfqHpVfEUXoGqaKGnU+m1uoPCgM3UxE/K1Dfmzn?=
 =?us-ascii?Q?x2OUD2OD1RK+voD+zq8YqjLwdcbFOalh0gK/Nec8sHHqcK2YODPfNCtP1lvE?=
 =?us-ascii?Q?5sVGd/JZUoZ178byYZZSXVqhlY84FFYo7SA9M989jHk24tzmlNRHQ5j/K5Ly?=
 =?us-ascii?Q?ad789KwW2pKpIx1iQuXqacUhH8YpaOJouMA4l65R6rorIS+4+jQ01qDXoquG?=
 =?us-ascii?Q?ZXzIMzy4neuEtmfoZAi8yXEmk4lnqJUk/fuZI5kNeySOhXOwOdmvzn+y7ajh?=
 =?us-ascii?Q?9dMJNEeeQ/UrTuGw7vsFmfFkb4GR4yhVXgWsGZVHyEa/oQ6Wt+satEkwLQEx?=
 =?us-ascii?Q?Wi5j5t1bRnQT75smcfg/cW7OaiQP4WnL7lBUAqGu/knNXo0+RrGdh+XTjvc2?=
 =?us-ascii?Q?BOroaMUXSvOuvFgqu2gPa/bOoER0QyzcMQRd8HoQhtHiVheSL0PzbbwcTPot?=
 =?us-ascii?Q?fbGD9CmU6aXMp+aOZugV5miZxMnYjP++tDJPWc7IYsBBbEBCREPsj88xy1go?=
 =?us-ascii?Q?1FPli9XAC902RKSyJ4ngE/4SqgA6pqfuRxZVAlgVXFXOrKVXEPBLWD8AW63I?=
 =?us-ascii?Q?iKlGGAUZHeFC20k+GSzp3bmGKLD0o0AT5LwcxMQ8uceMMk28agCzW3aC9hKm?=
 =?us-ascii?Q?rhgUeZm1gAN8WpJ8oc0V9piiTgoXK1gwu409qliBlWR/nQw1vJmsCprXi/CH?=
 =?us-ascii?Q?ncw9R8BykF/WBj8f489APljE/OktQhjUw75dSVhaKlI258/rw5Ytkp+9SKjd?=
 =?us-ascii?Q?JxuyPN80wZCIQZO2uuYkpOmmEMEaaP67rMltf2xzt5TWOsBnbCqCHaOz3SVn?=
 =?us-ascii?Q?5lq6iQNDAuL5zl6Y0c62mPXqo4a/N5gK+jvm7XV6mgOg+1GTGi1xX02PM39A?=
 =?us-ascii?Q?O73qDnpPOEJzl0toOSGFZaiFwNKzNqsoNNXppSobII5nm9ZLMMCJWAcyHOtf?=
 =?us-ascii?Q?8bCO2fg52MY2F/nkI5Aep2zd6OO0dprDmE+G1DcvJK4DU1w+Y8dMztE6TaTS?=
 =?us-ascii?Q?lc6Mn9WCbwsqmqnOjDnqNzzMKhKqd6Kt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b86a5d4-bb43-4fd1-c061-08da020f3a07
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3108.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 20:56:05.0822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gRDgWHZSkgXv2HdnzeOUatBEFjuOfk+Agqu8l4FRnX1I+GUWux0nLbEN1IfRQ7BjRyyn6o4gdz7UTZI1BTE1yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1201
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 07:27:44AM +0700, Ammar Faizi wrote:
> On 3/3/22 9:32 AM, Ammar Faizi wrote:
> > It looks like this now. Yazen, Alviro, please review the
> > following patch. If you think it looks good, I will submit
> > it for the v5.
> > 
> >  From 91a447f837d502b7a040cd68f333fb98f4b941d9 Mon Sep 17 00:00:00 2001
> > From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> > Date: Thu, 3 Mar 2022 09:22:17 +0700
> > Subject: [PATCH v5 2/2] x86/MCE/AMD: Fix memory leak when `threshold_create_bank()` fails
> > 
> > In mce_threshold_create_device(), if threshold_create_bank() fails, the
> > @bp will be leaked, because mce_threshold_remove_device() will not free
> > the @bp. It only frees the @bp when we've already written the @bp to
> > the @threshold_banks per-CPU variable, but at the point, we haven't.
> > 
> > Fix this by extracting the cleanup part into a new static function
> > _mce_threshold_remove_device(), then use it from create/remove device
> > function. Also, eliminate the "goto out_err". Just early return inside
> > the loop if we fail.
> >

The commit message should use passive voice: no "I" or "we".

Otherwise, I think the patch looks good.

Thanks,
Yazen
 
