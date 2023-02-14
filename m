Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA65697016
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBNVwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBNVwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:52:06 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A38B2B084;
        Tue, 14 Feb 2023 13:52:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6otaKp62VDiAj6DsS7BzNNFYoeyvs+5vKrhBSYV+QZMfqJ5FcHDHj107s1F0Kpdb2/RpDzbiWnyRpjnazJY9u9cXYT4HirSGSHvev7W18boZnRSVrBPbsFGW+DaNTdc0I/8w/kSIdhdQtIz/+TSafH4cfzGrm4huABFVTjMTYMxcz8yA3Y2VHQ7n3gVWu6oMW3hGd6kF/o05GsrjMv9NhJRUHW2oqgdhAK99wbPyKxvVGIAkoJCDzpQP3lOM3eFVUx+0Dtcrdo4Vn2MZawtFaPfTgFZzAwbmQ5YNFKmEagpo9pV6BSTJzR5Dde+QFB1fGM6EF+6tv9CvyJwZOCCxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NxE8mXPGls53TC33ZvbA1k26bwyJ5nVrNidqnk+TnI=;
 b=kiWCF6qKIhDLBZASsbhmMzC3aeKcslsVs7BZPJTeeBP+NfYVuyfYTlb2qPehXE93E3673BZFzI0YUBl3Dx0j4madGa+ep1vHa1b1Sl6nMV8y689H3cHuyfw870vDj/cOSnRiVe9Le9DYsc4OlD1bhMNxdxvv2P08hB4oitcT1HdA+PwYY+pbWV0G13EBFAgMnEY+iT2/PaNUn/nRdgRL8W11YNIJ8kui2txzvHtl+fHdqXFK3hoGrEUbG430D4JuSREfu8xjQ8c8aDeiPoOb51jIFxKFhDkYl++uGuhBkdLAYzy8AO7K7HS8wfE/dW2Y9i4TMy7FIBbPYACB9uk2aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=memverge.com; dmarc=pass action=none header.from=memverge.com;
 dkim=pass header.d=memverge.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=memverge.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NxE8mXPGls53TC33ZvbA1k26bwyJ5nVrNidqnk+TnI=;
 b=w5a6c+NjBfxOzyByyn4xt3eQJxP1NwyFtpU8bt9grU1NQnJPUcIRiSZo3XDUGrIHQWFjyBTUNtmb1Dw82wtW8YpJzlWu2WnUIPVNmjXHSCTIDQa6l5Jpy2SoGeJV6cixlBUJH6PNTWnSPOR0xr5aUWXpJHh4AOMF9V+UUeO+Nf8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=memverge.com;
Received: from BN6PR17MB3121.namprd17.prod.outlook.com (2603:10b6:405:7c::19)
 by CO6PR17MB4979.namprd17.prod.outlook.com (2603:10b6:5:355::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 21:51:59 +0000
Received: from BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660]) by BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 21:51:59 +0000
Date:   Tue, 14 Feb 2023 16:51:53 -0500
From:   Gregory Price <gregory.price@memverge.com>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <Y+wCeSig++c3ACkj@memverge.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <Y+vSj8FD6ZaHhfoN@memverge.com>
 <63ebd56e639e9_32d61294f4@dwillia2-xfh.jf.intel.com.notmuch>
 <Y+vag3hg3VRNRUti@memverge.com>
 <20230214211824.00007f91@Huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214211824.00007f91@Huawei.com>
X-ClientProxiedBy: BY3PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::17) To BN6PR17MB3121.namprd17.prod.outlook.com
 (2603:10b6:405:7c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR17MB3121:EE_|CO6PR17MB4979:EE_
X-MS-Office365-Filtering-Correlation-Id: 34e6283b-0fa1-44b3-29b9-08db0ed5b29c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h9Km+wJUYlpUbXpnPvW4WSqSo2jJFnPEWKTQmR6qW1ocfDIiqFgvmEKhQrsJX+/xNeyweOS2fXRUUN2zTZs45xD5KakocF8YTCR2fmXg90T0q0RUafcHt5DRr1DLDzoY9H+1MT8zQ1AHkoyydc+WTJOEUSLkugPV2SEVHzxU0kL6SLsopaVdEZWpEgJKnQOyTCc1E7t1nxx0ypaUd9DLULZLalGPB08S9A+Xk40QGplVLISBX+PktziF2g93QYqtS1T8jtgNb8muRUwgyd0asVHoCFDTq2CwpE4nthojG1i4U6j2rdCVWV7oNucM9ednQ/H4eMGvz6uSAadrFWocuOANCtvW00csD7d1i5J4vRMVdsv+AFyReUAus0Xy9D74rCLl6h3zYXyToA12LF3qRfgHXNDD2C0PJ1gBkbUN+2UOKTruD8su7W5IV1ZDqp4CS0Uvz5+x/MHuAjuuQ+G2cdxboWyTxCeqaPU7uQjVCULWMQmNFHXmTsVy3DWI1lRDlLIFqsaWF/YgMKoadOcgVCw605LZszpJXJCE2uB2WE5mcxAmKHIBOmw7Xzsq9Rp3TJ8y1eMXXbJIET7W82y47KapS/8L/3q/QeEj/jBLtiuDnw6VXZLD6DRkFMzk+jckE24fUVRF2ENFhLwAUJwzGWkUPmNTA1te5/Bd8bDFQoY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR17MB3121.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(346002)(396003)(39840400004)(451199018)(66946007)(38100700002)(6666004)(66476007)(5660300002)(478600001)(2616005)(6486002)(966005)(41300700001)(36756003)(6916009)(4326008)(66556008)(8936002)(8676002)(2906002)(54906003)(316002)(83380400001)(26005)(86362001)(186003)(6512007)(6506007)(7416002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ygSTK4lv0esfyVSK5eSuhZju0a6mhfRyliwrOpuZ0N0iFJolGqs7uij7bs4c?=
 =?us-ascii?Q?ztCHR6JkZUGkPRu233gea9jpZ2nt27AuJ5MzEnxUo6H7A4eD7QKBHuK+H1Fk?=
 =?us-ascii?Q?ll9NK98V45kdcgyEuQzzzG0uaMEckdeXiYtkW/PqvKtqIeJydf8rM3+ixtDF?=
 =?us-ascii?Q?YqBXUER+FNM0/Fntvu1qU3VIw9h1q3YOabCPX8SYQM0A5uR0dt1whKBIbMN/?=
 =?us-ascii?Q?AgG21vHuBdnrG61NqH0FDoEpNqzigPPj9qarQ0GWc+6BUdOdA9XrOI1Qp3Bx?=
 =?us-ascii?Q?YBbz3wCIyn9CfdgAB8u7ieKzqBCnGM/cA87C8jbNQoxwaZ7AiDkzAp58ZU9s?=
 =?us-ascii?Q?k1XXMY2xDkMPZrVwe6DELXfnAVD/cFK5OdSp25hlfDmM8W2QHqG090aE3V6m?=
 =?us-ascii?Q?6xxLJLh4DQNVvNyKFTzx9YZQHh4okCnOae6qzJ3z+UEpjmHIWKQvUPhbBltb?=
 =?us-ascii?Q?HG8lnGQsEYuFu8irwnzHD+o9LxyacbvkEZd+Y0JS9COmwjRaH6qbNNUL2Rj9?=
 =?us-ascii?Q?HhhinKsxDM9zEjtaukb8eWOtV541PyB4/ehm6nHR62UPnu+DsU/gFq+JOFyK?=
 =?us-ascii?Q?cskn7p8DFHf//6l3dyuhUmoCDagQJvsNZBVqDt+I9xre8+6KkKIRrJezinHa?=
 =?us-ascii?Q?mQO+exYuvKKIuposk6Cn0pJjskfAan8Uhw7JSv4Bn66Q6N0cJ8YAUv3pU5ZY?=
 =?us-ascii?Q?cjpqDseOfWITpi/Z1csbekHQpF6wKATiF+s788yZA3jaPPyVns01rLLUy3uY?=
 =?us-ascii?Q?lwTDlpKgUmD9FRCMh9CHAmkq8s8G+eTYWVxQpMnz7PrFILyF7q4mDYKt5EmS?=
 =?us-ascii?Q?d75VlILNhSifl95HeOn2PWPX0pK+p0o+rN+onvWP7XB9b2xAxp4rQCU1IM+v?=
 =?us-ascii?Q?r7KlSpGwGjZeQJMjQ6lB/RcZIBpwm6EYj+xKqJhNOppkdBUjBe1JKuYxwZE/?=
 =?us-ascii?Q?oYixGvtaSBFKYRw2T9xLXPuelajekg44zimxgj/nNl6QXdcIe3cueIslu/7x?=
 =?us-ascii?Q?Z7ShOxRacckT+WD9MQJipCYzA4OgdJWvqRKvNYcAjGr6Tzohs1ykK2hOcFW5?=
 =?us-ascii?Q?rqCqberR693C09vsHT7F8YCLeLRbL6BidrlM6Nm31rLQ5NKWU0o53JyQ1QtD?=
 =?us-ascii?Q?mnnVbfvxaIGpPEYXgnFkM4vVqkxuqAO9Wn+FnQsnznfCoEGfD0iVq8hB4+mC?=
 =?us-ascii?Q?pe83ED//NQ7VYIf6q2ilIhSO2lKdqBdMBGp0De6+hsB5uxqCRqc4/MszUWdj?=
 =?us-ascii?Q?u++KxPVzV6uUPalHYK6vl/9GSHAScRk/PCNA4B07MR4ITtOp96aTOPeEZW/5?=
 =?us-ascii?Q?UVSOjs14qoZYauWmApQYsyNnN3d7Tk5zZRHy1tuQzO9Y8jg4oCDB+c6EVG/f?=
 =?us-ascii?Q?3vCLpyyR0d9MfkRo2I0LmXE7Wz2qD9oCNAwGKESgLa+STPzPXORMS+qSxmht?=
 =?us-ascii?Q?S++/4r4U9NIWsQ3UZZeMpRMSZS7ljxkdtzoN7nZzETc2kpRddyndxhyUPnj7?=
 =?us-ascii?Q?dpbMqz/orHCqvD80DukoGwfXM3ZP/RfpSJqFlaLnTBsi/qFsQ386adL0obVu?=
 =?us-ascii?Q?feqiNrA8nITgI8ptarorpLBpphvXmjZPHhEUMxZfgJwEFtUv560M3zDEMSo7?=
 =?us-ascii?Q?oA=3D=3D?=
X-OriginatorOrg: memverge.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e6283b-0fa1-44b3-29b9-08db0ed5b29c
X-MS-Exchange-CrossTenant-AuthSource: BN6PR17MB3121.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 21:51:59.2333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5c90cb59-37e7-4c81-9c07-00473d5fb682
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOzdANrwcqUk1Y7pnfuc6nAQfmJH5lb0IsKgslj66/et7jejAwKe8/TdGUDJV601pmuHjZvM94f0nzYlS1ZDyo0Namfh4YKphzitXbbe7AA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR17MB4979
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 09:18:24PM +0000, Jonathan Cameron wrote:
> On Tue, 14 Feb 2023 14:01:23 -0500
> Gregory Price <gregory.price@memverge.com> wrote:
> 
> > On Tue, Feb 14, 2023 at 10:39:42AM -0800, Dan Williams wrote:
> > > Gregory Price wrote:  
> > > > On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:  
> > > > > Summary:
> > > > > --------
> > > > > 
> > > > > CXL RAM support allows for the dynamic provisioning of new CXL RAM
> > > > > regions, and more routinely, assembling a region from an existing
> > > > > configuration established by platform-firmware. The latter is motivated
> > > > > by CXL memory RAS (Reliability, Availability and Serviceability)
> > > > > support, that requires associating device events with System Physical
> > > > > Address ranges and vice versa.
> > > > >   
> > > > 
> > > > Ok, I simplified down my tests and reverted a bunch of stuff, figured i
> > > > should report this before I dive further in.
> > > > 
> > > > Earlier i was carrying the DOE patches and others, I've dropped most of
> > > > that to make sure i could replicate on the base kernel and qemu images
> > > > 
> > > > QEMU branch: 
> > > > https://gitlab.com/jic23/qemu/-/tree/cxl-2023-01-26
> > > > this is a little out of date at this point i think? but it shouldn't
> > > > matter, the results are the same regardless of what else i pull in.
> > > > 
> > > > Kernel branch:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-6.3/cxl-ram-region  
> > > 
> > > Note that I acted on this feedback from Greg to break out a fix and
> > > merge it for v6.2-final
> > > 
> > > http://lore.kernel.org/r/Y+CSOeHVLKudN0A6@kroah.com
> > > 
> > > ...i.e. you are missing at least the passthrough decoder fix, but that
> > > would show up as a region creation failure not a QEMU crash.
> > > 
> > > So I would move to testing cxl/next.
> > >   
> > 
> > I just noticed this, already spinning a new kernel.  Will report back
> > 
> > > Not ruling out the driver yet, but Fan's tests with hardware has me
> > > leaning more towards QEMU.  
> > 
> > Same, not much has changed and I haven't tested with hardware yet. Was
> > planning to install it on our local boxes sometime later this week.
> > 
> > Was just so close to setting up a virtual memory pool in the lab, was
> > getting antsy :]
> 
> Could you test it with TCG (just drop --enable-kvm)?  We have a known
> limitation with x86 instructions running out of CXL emulated memory
> (side effect of emulating the interleave).  You'll need a fix even on TCG
> for the corner case of an instruction bridging from normal ram to cxl memory.
> https://lore.kernel.org/qemu-devel/20230206193809.1153124-1-richard.henderson@linaro.org/
> 
> Performance will be bad, but so far this is only way we can do it correctly.
> 
> Jonathan
> 

Siiiggghh... i had this patch and dropped --enable-kvm, but forgot to
drop "accel=kvm" from the -machine line

This was the issue.

And let me tell you, if you numactl --membind=1 python, it is
IMPRESSIVELY slow.  I wonder if it's even hitting a few 100k
instructions a second.


This appears to be the issue.  When I get a bit more time, try to dive
into the deep dark depths of qemu memory regions to see how difficult
a non-mmio fork might be, unless someone else is already looking at it.

~Gregory
