Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A90696D7A
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 20:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjBNTBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 14:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjBNTBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 14:01:39 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F51FC;
        Tue, 14 Feb 2023 11:01:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIW4mPGLVx0JzzYc5Bobvkt/2tSBAMWYWISrjIzaOJ3RLh3sPNVZCBqHv9ZQB9kxoCktDXbLqG7o2WR6cJcfx2PmMNd8HSef+2OrjtQWHmM7/lqBGyAWGFDSPuIc/pC7+mcV/jCwPIf3j6vVoLhwqUSX+JjwN0pUMMqgYZtriJVWssp4uEQpPmNnHjnkoHQYgLm0uaJ1DgvJSH7wou+lciQjPlY2UwmoMfbq5w2iyI+uU/44OThSy7V/+BQbawUUf4nETTSOq/BtXPAXzEOvwR6VPphx/BeV71nLRUbFgvyTpFWTg/yLJzJrPjDQbhRnCyTQWOUlNm72ePDPoOOJyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4hwhN2NvMmA6idTOESuYWRqWfBsKzeYta5crVleLOA=;
 b=lvixah83XYXfazUuVEDvRfTSKJytbTKXfsu3uRpjPX11cxbS1YudqmBuOR8uGFAYbxWFpt4ESKnCFcz6RaLcT+mHxREXBi5sL32APCM4vSJYaYsknXEhM+DRvSCSOsM8vYiejnLVqb1LzE23yPzSv1sncTUR1IzZz0TkFYlbsLzL98D75JmD3Yk16knKYEJMmvYh8i6ySF0Bq/4eQF83vXwCLjtArkkh2rXnlD0kFKmhPm8O/ZAOfN3yamTsy7tXo1MBM0qNNzfHexSiJHaWcKW+OtBAqHolJwE2xwD8OPKyb4NPRgHajT6++a7J9WWSY7QlPQAlHIAgUDo+lP1EIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=memverge.com; dmarc=pass action=none header.from=memverge.com;
 dkim=pass header.d=memverge.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=memverge.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4hwhN2NvMmA6idTOESuYWRqWfBsKzeYta5crVleLOA=;
 b=PEmwT3XNR478xK1njVfIpvkcttLMKVNzamedOoQSKCQ1NmLzT3D2omqcxR6eMPrQf1ea7qL2YFSNJqpFhNfLwBJriQ7lgv5D1livXfzGAG+iEJcm4G0LImiYSs7Jhc6QhvMtw/+w39B6RZMpo6F2JGTJqpiwGnNQo09e7ihnhMA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=memverge.com;
Received: from BN6PR17MB3121.namprd17.prod.outlook.com (2603:10b6:405:7c::19)
 by SN7PR17MB6558.namprd17.prod.outlook.com (2603:10b6:806:352::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 19:01:34 +0000
Received: from BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660]) by BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 19:01:33 +0000
Date:   Tue, 14 Feb 2023 14:01:23 -0500
From:   Gregory Price <gregory.price@memverge.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <Y+vag3hg3VRNRUti@memverge.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <Y+vSj8FD6ZaHhfoN@memverge.com>
 <63ebd56e639e9_32d61294f4@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63ebd56e639e9_32d61294f4@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: BY5PR17CA0034.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::47) To BN6PR17MB3121.namprd17.prod.outlook.com
 (2603:10b6:405:7c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR17MB3121:EE_|SN7PR17MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ea0f4a5-2795-4ec5-19d2-08db0ebde3c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KieLINZ3mpdMykk3PCOeVPDwmd8J+1M5XcVHXfx8YvdR6QQcmf1GZ+dffaO1uNNeHpPVPEgXU4q8YlWSrQFcB70KjBaHg2lGzOan61Ua9252RPTkgPc+G3M4i3SO3uJV8uYyHVxfYvm612a102PU2Oeiv+m6Jke8r+HQfeT8/B9NXB8Bd1mt5TXhm4bNn3NUre2E/aXxMPkoYTxVmpGQgWufR+bdI8aNqZBHBBqaG4FHs2Bs1ggE1nP1BDkDHLRfb4mxdsgFRLmpkF1ZGslHeoGs1PFmqiBMnjgYdzqcVyzBf17OhrPvecgesz21Zz03iZXdsSo3UU0FenmeVmSrZ9YsSYu8C1Ukz7n1h8DKSGiFGQpYIhO6Z8ZBYqgydyfe9whMQzWkRLoUsPer+UHkJRVCb3pbf8vRBfA57meiRk98tVkWkpvJGqEJggJ6Kp+jLYTHo23GJTw3E/dx1bMhuJB7YKFhUd9yvAbKPg6oMxh+oGt80P5Dh0xxOB6BkSJuw7ujlGgJwNLkYF/RwP8e1UQORigPa1yVp2gvt4ZARuxgd3U+vCELWC6IuLXrx2hyUB/guxQAP2oS5uTrqmz71n8DOXX7FkiRKFbcUz27ZGlBymJmDAGx5m3SaDZ/iC1d0cc+F7EFlcd1XSGcyrAqp/OaBZgmM1kgg+MRjRRe3DhmZLgVtX/qUw8NecCOQNc2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR17MB3121.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(346002)(39840400004)(396003)(366004)(451199018)(41300700001)(54906003)(8936002)(8676002)(4326008)(316002)(66476007)(66556008)(6916009)(5660300002)(66946007)(2906002)(44832011)(478600001)(966005)(6486002)(6506007)(6666004)(186003)(26005)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RbRkXLNk4k8+0KqJ/TTa1FgDgjvArxl4wLld+Fkm6K6gjTdHN24ndEa8l5oo?=
 =?us-ascii?Q?8DKmJz2KwwEy/CmN+9lPitiqJ1E5OZSqwgACIV3CORZ063B/+6U0sEwxEFpk?=
 =?us-ascii?Q?9kWIanLh/92ZeuXSqDt+PwnLqnQmadMd5BhoCmBy0+aJ//qEQpk5D1xJpG7I?=
 =?us-ascii?Q?JzuzGgtv4X0r7Ds6+1m2o2uPehQ4nDVWXE+c1/nye5ZPI7XjgVsTRK27YDXd?=
 =?us-ascii?Q?Nxj1PmgEp9VCWDPqI+IDXqZHCjlx+zjiqx2qaPjYihp8LTEJ7i4C0TDJv55v?=
 =?us-ascii?Q?xm26+qqODsO+dwf49ueW9n5OZOqwHyZEczOhRt4Bqpv5ou/tDwcFZN0Gki/t?=
 =?us-ascii?Q?0vhLkIzhrM1Hrj8agdfF/uiLyYBtbY5UtJgDQH/racrjDAjwRI6nZEaDj5dC?=
 =?us-ascii?Q?0xD/SBIFwSHM7Vg41xVVrn26VOo+gnUdvA2DpMNC6teVr6LUh0JjeQbKDQ05?=
 =?us-ascii?Q?g8RDU6syrlSdHyHJK5fapT37IXfcnCHkTZrRtU3ANiGLXGrY7it6TnlVK9BU?=
 =?us-ascii?Q?Fuv8n0RCll7aasZiTbG0fKLRiIIVkGhUWVQlyxnngHvTq2yVC1HwVTXGMh9S?=
 =?us-ascii?Q?YqpMwZmBcsmVMzHayHPu6JbxCaE0mMlPipV9KW8+eXKMFEyK+9MK66ok6yLN?=
 =?us-ascii?Q?nzfkOW83xXg+dJSevMIdsxeF2rk8CIr/Xoz5IgoE42YN+6MRJ6oJRIQ+dCdJ?=
 =?us-ascii?Q?7+krbFeIHnxfUkUsQhblrVxRZBFX3jqAv9DddxyfA+c329Mlou66R444EnHO?=
 =?us-ascii?Q?XzYBBKYLVeDlGPHg3msBG1/E7q4rb7eb0Tp3AY66pcBurEM6I1ocTCdBevQW?=
 =?us-ascii?Q?J8iRadalkrmAsrhtbyldeDTpgCw/H6MOf3RcgCQ0UUnUfYfgZuuGgGOfFk2V?=
 =?us-ascii?Q?OlnoIGdQ97nIG/7eN67PJrNB+Nj18V9iZben0Eo/mbnuY7+PuQpIVf6XTU3/?=
 =?us-ascii?Q?e2v8b8hmjSW8hpWuOE/mRSysJGZ9OWANvktdDqcQ6pBNkEiybHif9GwDV762?=
 =?us-ascii?Q?OPZWkhtfuNgovOTMHJFCWqG2c4eP+N1KXMNO2nh/+hE94u1F0LUWFxD6HROm?=
 =?us-ascii?Q?ghNn8WHXcYK4Qcq4IBniw11uXjFVJiBlgiO2nPG4EsFAcqy/ry+/Afeabu3T?=
 =?us-ascii?Q?kYU9SNsHCkiKA3Ol1GNFzdT4/fCTSYSwWpvDNkStjMpmbLbYFfoFOiKtPyQP?=
 =?us-ascii?Q?71SLqv2+C9YAkjtyaG4E4PFke2/Tk4uh59toVhmzHwY8wfK7PbuFDuszOOUw?=
 =?us-ascii?Q?y0yCO8Wsc2J6Z+avhGGldZxx9ThFUbpgE1C/J8d6TvA2wriJ8io+IZ/S5JOg?=
 =?us-ascii?Q?xE63NDM+S/6R1Vu9OfuMyjA9TTP40rbV4BzVUf5Lj1hHPyAmkYHytwdmZc4r?=
 =?us-ascii?Q?qirre88nKSHi7fP2MXOop6syQshWvlurxVJPbzfIC6zkkJEEHXHCCDtJ5TQP?=
 =?us-ascii?Q?0uPBkU/9twFfjxPIslB4+QERR9pw9DCnYvlKVsdkSwmua3QtxB90vPLbxqJS?=
 =?us-ascii?Q?tR5quK5pzwtiJLvwbSc+qYSfiO4tUeLm3yfONVtQTSYQWhijuJx/pS218OoX?=
 =?us-ascii?Q?Fh8GulZLeK7DuT73Sr5tR86KBz7og4ZOM1TasjAPA7urGVxYeD3YzfwcsYlT?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: memverge.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea0f4a5-2795-4ec5-19d2-08db0ebde3c6
X-MS-Exchange-CrossTenant-AuthSource: BN6PR17MB3121.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 19:01:33.7481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5c90cb59-37e7-4c81-9c07-00473d5fb682
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NztZD006EkDuolvZhbyK+kjLVhJ4sB+NMu6hDUPGUaNeqZbpzOHh5ljP/S1Eifec+9ACu5oXahr8NqUFf5dV7CxxACot8ASYNc5v2LKcj8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR17MB6558
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 10:39:42AM -0800, Dan Williams wrote:
> Gregory Price wrote:
> > On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:
> > > Summary:
> > > --------
> > > 
> > > CXL RAM support allows for the dynamic provisioning of new CXL RAM
> > > regions, and more routinely, assembling a region from an existing
> > > configuration established by platform-firmware. The latter is motivated
> > > by CXL memory RAS (Reliability, Availability and Serviceability)
> > > support, that requires associating device events with System Physical
> > > Address ranges and vice versa.
> > > 
> > 
> > Ok, I simplified down my tests and reverted a bunch of stuff, figured i
> > should report this before I dive further in.
> > 
> > Earlier i was carrying the DOE patches and others, I've dropped most of
> > that to make sure i could replicate on the base kernel and qemu images
> > 
> > QEMU branch: 
> > https://gitlab.com/jic23/qemu/-/tree/cxl-2023-01-26
> > this is a little out of date at this point i think? but it shouldn't
> > matter, the results are the same regardless of what else i pull in.
> > 
> > Kernel branch:
> > https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-6.3/cxl-ram-region
> 
> Note that I acted on this feedback from Greg to break out a fix and
> merge it for v6.2-final
> 
> http://lore.kernel.org/r/Y+CSOeHVLKudN0A6@kroah.com
> 
> ...i.e. you are missing at least the passthrough decoder fix, but that
> would show up as a region creation failure not a QEMU crash.
> 
> So I would move to testing cxl/next.
> 

I just noticed this, already spinning a new kernel.  Will report back

> Not ruling out the driver yet, but Fan's tests with hardware has me
> leaning more towards QEMU.

Same, not much has changed and I haven't tested with hardware yet. Was
planning to install it on our local boxes sometime later this week.

Was just so close to setting up a virtual memory pool in the lab, was
getting antsy :]
