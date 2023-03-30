Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BC86CF83A
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 02:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjC3A1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 20:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjC3A1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 20:27:48 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AEC4ED9
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 17:27:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDy01/eHriC+vi9n8+8Lmk62G/4JsNCWPYLyQVDlNTHVZd+3jnb6faJrroEdenfmuXhKA4Uq75l5Q4C2NhL1itCIlao7cQqnAy4uyFHnapW2zEROpjkZqzXIQyqQzmBKBpUHKb+fJTNWTqCQzwz8vhSThESjRJWbmYLq4i2ok6Xv0Ht0S2roh7SUlMiXF9efDOCPWJkz9QWtJjtHCjR6hXc4qcrEDolJ27ukgH++sOb0K71TGRwayu0wZMkrwqK11oP93zJrG2JcDw2FzT+eRJfVZg6gIReaTdB+xTddJnlLANpwkS403JXcoB878qf9ABnm2dub/LYHs+laFQzaLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AFgw3jKORuU+dAmR2+dmhkgAk4CCNTQ560UTrzvr98=;
 b=V5dK9ImM3LpG+VRyHJrg2ls+kZRAQcxP2lOthkp6ACMnfMyLD4KWYqWlcFNHTYcHWLdrGKlcb9hgHNHTOnhPSlZXqsvVpatf7M78aZze3XXx46b/5sqHpqil5n0nLFcOkkXU+HyjtGDNEap0rdoPnRVMKHiYHeDhpuNWbj8w3Vw5+mVO8tr+RsnIr9v+3WPaLX91pfmKVdBK08ACVdkHmCsd9kyEIr1ivPxEg5eRFiAycXa4spHTssw48t5kOURZaMZPbFcH9qPj3Yu5DrHCAcCO3Wz8fefExxW/c0En7UjmvuueZ9ioddgNyjuJJWtQ4VtU6cR2y+bwDa7KYLZSZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AFgw3jKORuU+dAmR2+dmhkgAk4CCNTQ560UTrzvr98=;
 b=VofMYm09GEbxytQTz6hhAV0BV+kKunpVSg7F0uvOteF00Yp+r3OcYQFcjDh8xfvZBQ7ZF78YYMBQwJR4zrY/MhAaTHetUtRhDCOZikXmiu1RMji81rnAY4lhGR4W0qnvcrsPFS1Iroh0XGkfMDNfU3l8X65gbzWS4YfHmbZXrJ3nEIY34ODFJjGqbTauAMKwkbrkHDF8GFbxJcg9veznoKiaUfzdQkZ1WrhvOBqCR9kWJMiZV1N8CBMMc4FFmFmZWfb5KQgxO/5lhBzVsFoVdvc3k7d3NEVGkCSJcKmuykFxNIzaswk8sgQfTt//mnWxka/HAoW9tw4Cy5Pc17XFlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by PH8PR12MB7279.namprd12.prod.outlook.com (2603:10b6:510:221::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 00:27:44 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5%7]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 00:27:44 +0000
References: <20230328021434.292971-1-apopple@nvidia.com>
 <ZCOtiZFoxC6w/eoZ@casper.infradead.org>
 <bbc8bc42-5f2a-9238-94e9-b2191e2f8c7e@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Take a page reference when removing device
 exclusive entries
Date:   Thu, 30 Mar 2023 11:26:04 +1100
In-reply-to: <bbc8bc42-5f2a-9238-94e9-b2191e2f8c7e@nvidia.com>
Message-ID: <87zg7vt75v.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0194.namprd05.prod.outlook.com
 (2603:10b6:a03:330::19) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|PH8PR12MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: 6595a25e-582a-4a73-ea47-08db30b5942e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b53YqUMPZ1KRQmvDtVl6TxQKIwFIbypufRl7dthe5hNFJz/mfM6lQVhbkmAiVOjEoCmlJ61YwPBNzf2VeMvMAFdCjzNFBp+MFsUb1u+2Dz3XOEyBtKxq09Bswtl0dP58cSipQoslNwEooI1GcGPNTwsvuHMdCJjc11W5NOJE1RQFbiTQe/YOTRF5JDSOu++kgsbLSWkUW0qi919q6eSvLV+25iuQ3u6uYqDo+I9mytDVSQ5R2OFQTHnwxCmrDyH/rP3Nt9S/GLE62TaQyyi5AxLenoZTCtCbNdenDgV3Vdr26yTHJ4UbSiVjyiZfB/AgFxb0Bv8AsR159tiL8moceGjXvubKBXi5Q6i/GraKTROSHD2rVI+RU/KZDHtNa1ePJMSt9x7L3+zl82mbGcBJA4msNfT31VarY+cT7/dRZQLch2/sbLPEH2QK6KGB5tb3l5l+g99GPLfecdyvTZXn3U0o4i6eIfF17/564LfnHM1xlhEfsCUPHAi0vz7nW8UDfKzgDjjRpJN2sQl0faG9neRFVGOopuj2FHqjkCDsE4ryEPtXEbGi5WaqwoVBgEQn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(5660300002)(6862004)(83380400001)(2616005)(6506007)(26005)(6512007)(53546011)(186003)(86362001)(38100700002)(8936002)(41300700001)(36756003)(6666004)(478600001)(6486002)(66946007)(66476007)(6636002)(66556008)(8676002)(316002)(37006003)(54906003)(4326008)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kna2zUOxMlCd/wDfniIbr4wjjEMvyfb+j68xoPz3fRCCjqB8bAwDOM62wwGe?=
 =?us-ascii?Q?wo6nN0yurVhCERqug/KrkyiYUuCtampYoe5jLWIjM4Xu0T1sK5e+CmioHnWx?=
 =?us-ascii?Q?VfPK+Mukr8Xjp9AMhrLRBtXgeq6N03NVeoDtYhFukudZU6G2qFlmiF3Dgpfz?=
 =?us-ascii?Q?pc9mnEaPcYpSLErnxMdS9/L+SK9Vhaw5ZiGDiXGfBB879D2VpweMBIauLUur?=
 =?us-ascii?Q?+FZte0eewo3uXMQP+dz9PgYBALRtsn7Bo8AmL4gx4bernr0EI02+0aIL4hqN?=
 =?us-ascii?Q?d5yXMpfCLfm5u/cU329qIomuKtH/bUKW0tlA6Q9ldk/Tc0kPKxZomcjoWhpq?=
 =?us-ascii?Q?IqVfli73jMo7O1kFaaBI8vw1j7sxFeGzMebC+81c5qenMQGQX87kWjXmrD2F?=
 =?us-ascii?Q?PHQjwfspR5ZTT4V2EPNyyg291k04+TrgzsfenFgVQ2jGDyGIHxbdsoKMeziM?=
 =?us-ascii?Q?RravvQ/Is0OR3AP9PCb6i994iOCqUo4Z0tbnjA+h5E2jfewPEmSPyAwUwd78?=
 =?us-ascii?Q?LIesr4V4gkmJ73VMl+jeD2Hv2R/iZw9/8936QuflplzOwm9vN49ko0e0/Pjd?=
 =?us-ascii?Q?beYNokiZbCbk2ckM6Tx+US+lMMa4PxTlJL/KCAPsKiBa9wXAvKWINLWNktss?=
 =?us-ascii?Q?d3vIe1MrF2jQtesd2RGJ799UfyQFfT6qs76r3MSeL82Ekbam65GrGrdRQYpy?=
 =?us-ascii?Q?yn003QMNnczzvKR4YRV09Vrab7+oqetFSH49UVtuJ0WT8qPUKerbMid/O3TS?=
 =?us-ascii?Q?l1wDbkhmoDzJfaKtDwn5DaopEOFlcE1vFJVMhGQbmnJw9GLOCpmkaCECm0HE?=
 =?us-ascii?Q?Lm5Ab8WbkgaYRN8jeTWXvtlBoPbf0CKy3k/srij9Uku0SxnnmoHKTPdgXh9O?=
 =?us-ascii?Q?/kJF9NgC38dgMJ/ETjXLVEyr6tyrAQxFjCpXDkEupZTq6QpraNBYa7PM+eVH?=
 =?us-ascii?Q?v1Z+yit0TLhuSBms/wGWtdNYBcs0cSWlloaijHKZ9hnOLPyIt3oLq3EBOn2L?=
 =?us-ascii?Q?94zLk7pGCZITuijLR79czIQBVsiBqTvi+V66J0PLC4TS36Z1vo3Bn3HNFh5g?=
 =?us-ascii?Q?IZVlk6WC2HjaU3zGDpXTiwVWo+4guPBd4Vhj5cMbFffcMnfPA1+sZ3NtHS3w?=
 =?us-ascii?Q?v1zjjYXLa/Q1KyCpMiVexv3B8a6y0diJbNJcq89KwElNvGTafWBhTZd4vqnR?=
 =?us-ascii?Q?AicxMA5drM5E3FpYxzg9a9vSpC+obSS2O577rWtJ5KjXzjYiv+Spp2b/ojo/?=
 =?us-ascii?Q?bYLpz2jhxT+GKNIrIwZ3LVLYBXTCPfqjo2o7LauM3g/TnBBOE4a+JGkmu7Mz?=
 =?us-ascii?Q?lkV0wxJ5bfnG5B258fv8Hr08Uogz+FY2QWVfY9NyLzjxDw4BRQK2Vh5TiB2A?=
 =?us-ascii?Q?XLUduY2EPMtP2HS5PRYCygl7GaEaIWtCJHQqe+28ZBdN+e2fDayGa/DEYL/g?=
 =?us-ascii?Q?7/jt5vBlvxKf6h4qwTJdE7attAnNTrIEOFCBO0Pt+xN4613mfe2PrcdZN78t?=
 =?us-ascii?Q?Uk9ZSi1fWhqxquGT+lpVnNwSwgKSvEKfPotgSFpKtZhd1VOGsqwPIcixeUP8?=
 =?us-ascii?Q?+bmuI3NGgTRzyp12s8lpRhE8JFOoSVXbVuInSPcu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6595a25e-582a-4a73-ea47-08db30b5942e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 00:27:43.9581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4uaMqKSF4aPIC9yPwQSidclleTxhcZJ7V8kdjCsyAy5AJM2awupjiyC1ipLN1qpTfepwlK/U1xecUtESjK9D8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7279
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


John Hubbard <jhubbard@nvidia.com> writes:

> On 3/28/23 20:16, Matthew Wilcox wrote:
> ...
>>> +	if (!get_page_unless_zero(vmf->page))
>>> +		return 0;
>>  From a folio point of view: what the hell are you doing here?  Tail
>> pages don't have individual refcounts; all the refcounts are actually

I had stuck with using the page because none of this stuff (yet)
supports compound pages anyway so we shouldn't see a tail page
anyway. But point taken, I admit I need to find some time to get a
deeper internalised understanding of folios than just s/page/folio.

> ohh, and I really should have caught that too. I plead spending too much
> time recently in a somewhat more driver-centric mindset, and failing to
> mentally shift gears properly for this case.
>
> Sorry for missing that!
>
> thanks,

