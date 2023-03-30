Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F956CF869
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 02:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjC3A7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 20:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3A7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 20:59:10 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DA54ED4
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 17:59:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e02GO54ZohaPk+k2AtY0n3w2skcyWT1FTGKZZHZRFx9LNXFHW0tuuI+RlVaIDyzuqfzpvNGxNB0FgX/+cgC+r/bjgBpE+klBCA598qm1xTEs/iYGVYChI0hHUIcC0Iht53YQ5HFQSH9+GCR+MyIx+ypMc71rk4pi/+DSXdz9xxm1fpGgCg74WUp2uLwvrJdxvtXVrN/fRUluLFnWvxDV0tHa0y/nXzXk+fbUmkKjtPeX6J5XyKlx/DQqxkd/gNkpYUAaNM0WSkfEOLeK4qiLh/G8xef4SOaZhgShUg70rU6twxHyqhhWGCLBMjv5gLV8HUj/t4c9F4RzXhfChhESnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFe9+4H6AwA1DE+zOQuVCeTxgETAJDwSx5nkWVCKYUs=;
 b=dpyD6TReGfaOMphmc9H8j3AVizw0v1Xnn5UWJDBihq2iC0I/HQolYkmUD8zgyV97cxqtZVnKD7SRwlOWBKq1Lydc25deqEF0QbZkeKeaNQXN1LfEQPfxnHHMTsf6ZT9BGr2Jkpkc5nh5JmZSyCO0RIluSiIRIKCL0vHqU1WqqXA6E1n6DkvIbh5Rs3xrHNGGaQHJtdXS9PdC9nvc82uw/WAxdtcfXODQCh+B8JsfLgen8Jr54K2ZE9Fh3ouqbREdb++ZjhGeFkCP+T44jaOX+UIQGYV4D8ZF0FFWhVRO3RKbTnDyraACZzJ0hXa3z2oFDMnGltS+ZSZ8dNMRoWktBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFe9+4H6AwA1DE+zOQuVCeTxgETAJDwSx5nkWVCKYUs=;
 b=BRVAMvT5ZBwzn2/s4UC/YRkJgh1CZyWxtTcmW/gp/fLy56A0KdlNMRkuApo+J/VLnpO1M0Gyaci3dPaTE46w23l29+AflzUSZkmeLLbegF/8XgjkMEIRH4qWbJhjS/J0gSnQl69YT/7632189i2vEjiKPiu1b6x2tzRNbR8tuyxlsfSm2j5YfZT4zQqJnUE+HvRjjfbppB8i2ZpMzt8sBgE4k+ojdQrLWz2SoapVuD2Ex7eeii+2YclzFSSJRucL97Dzwphaaco403OT++an2MyNya6kuwafr4KTLk0pAKgISnMuIx0zSbGAy6vDUSsoajzgA5sZboHHpYeNUC+n1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by CY5PR12MB6527.namprd12.prod.outlook.com (2603:10b6:930:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Thu, 30 Mar
 2023 00:59:07 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5%7]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 00:59:07 +0000
References: <20230328021434.292971-1-apopple@nvidia.com>
 <ZCOtiZFoxC6w/eoZ@casper.infradead.org>
 <bbc8bc42-5f2a-9238-94e9-b2191e2f8c7e@nvidia.com>
 <87zg7vt75v.fsf@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Take a page reference when removing device
 exclusive entries
Date:   Thu, 30 Mar 2023 11:55:45 +1100
In-reply-to: <87zg7vt75v.fsf@nvidia.com>
Message-ID: <87v8ijt5pk.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|CY5PR12MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f888547-2570-452d-4129-08db30b9f6b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gGTlH69VGvmp/2t3bIwIndTMBOhJ0aSmWesqxJdOKpHs5mI1PJri5nq68mjpSPgugS5EQtgA5f82l1EdzhKcx8IQ2/a4zzgeRs9wbR9ILtR0u1qNgA8r7xrL2OAuzcWEebj1U2DQQOSta89XjnfjOrcfGBoLWOofCE2gymEx2SV9o82CnKGPkz8hU2m1Krwh4J6LPcNIBL/0CV4hhMvFvuC6z/6l+rlm+aTVp9BF/TnS8XuRbB4zalCh1fPtJ+alQ5NiX4YvyZTusuIG/Ti/wYwv9TYUa9jnV3bgD4kZFIR9o+4xvpZa+mA+cp5heqQnugzOMv7sF78CSQ3CV+Jq2mLVql8rDKB7Oyfuo2ZyBQJDchpqYrLVaSi/tRMUDhzwL2MNXZjrNoCPebe619naW/EDHIUM5leyIzRMJx6BIENwRw+kG6JbxBxlfDLeqp+llsKaf+R/k/hwQUiYtSXeM6muqZb2E7ZzxV9T8p++md7Zl0Oe3Cag7kCPTGFt4DcUgfqCeIyR0/4eexiTmEheyo14xkzu2cdAXsxLhl9P354sWl7vU03DbKhv45ps/qOV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199021)(41300700001)(66946007)(66556008)(4326008)(66476007)(2906002)(4744005)(36756003)(83380400001)(38100700002)(5660300002)(86362001)(186003)(2616005)(8676002)(8936002)(6862004)(54906003)(6666004)(478600001)(6636002)(37006003)(6512007)(6486002)(53546011)(6506007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tKspFu/wS6J0ztaVi9USrRaOOb2oqgPNRzmTx8qq2JrL1CemcEA+6h8Zou/k?=
 =?us-ascii?Q?nz+DN16PJxv9qKEw8W92A4QXuA/8JjQuzUPcRUkeDc1QFkBlMwSbSFBbAMd3?=
 =?us-ascii?Q?0AClZI9GNjd5mMKxU1npOlvw8bbKXoxOBaSs88mrJ+tW9wEhNCp+yNjZfiXM?=
 =?us-ascii?Q?URLupS7kv09U3GlyCNcjW1yZ3qmIiLktsCfz57lkkKxx5+A2cWvTyot6ynAP?=
 =?us-ascii?Q?GtOPWtUqWM+HlZDWTlX644jlITc+cuXitC9TnSX9l735vd3CbNVq83QdpnnU?=
 =?us-ascii?Q?QUGFdKemkyTTaKkn7TjvPxZpjK20sLsHH75mt5Wjw+SdN+A4ChnMim6Uytaf?=
 =?us-ascii?Q?37dTPlyaajHGy6DX6ChusmMZ903rgwicTqIafhjLPpR+lLaAAY/GjEnSPEMQ?=
 =?us-ascii?Q?CaT2RPp7eJsx+KY334v7yk3EB90NbP+n2ebUmW7jWf7PqmCWQiXpfli6LQsJ?=
 =?us-ascii?Q?9jDhnfo3Fy3jPn5M9Kp7DqJIAnSGOWmGVIPn149G+3KQWJm3DEOcv3OixZTb?=
 =?us-ascii?Q?O9tqzdNSsiVqjamQ/UHbPHMNm5cF2foFhRBkVR+zODj9BxnvMWX9xmP9aSZ3?=
 =?us-ascii?Q?JC249sE2AMT/I4gMq0XHZodwYqwFam/7QAgzoLUJOP7l4wfXhKkSw0xy1x+o?=
 =?us-ascii?Q?oCWB0gBEnyilr3pCmeEX6oPSbZolepAewQ2FRHpVaVrEtIFvYYZKA1YF7TXs?=
 =?us-ascii?Q?NB07h7kCClXJPNeens3VnoxiHa1ImmpZY6Os4ARNk+VdHNXASf5PvMTert3R?=
 =?us-ascii?Q?yFM1zhE7ALDUqgVIg3ZwxHNRBJeqzqCX1R8RAPrgTT0j5z3OkIydnS6fCH0J?=
 =?us-ascii?Q?gPHJcYtNNICjrajl8Q99zCA5s1apkAbcFTSv4Xl/3jVWYmkGXk26WmdGH/0t?=
 =?us-ascii?Q?IoSCZYxNoWYFx2n4OcXHzgrL3cfgUUPIJOuuRuzqes2lD6DcZHmDpPCPM5Ct?=
 =?us-ascii?Q?MK0dqMUtlDAwtb90SrZkpioOWT0VNMKVe1UfZ+DgRfLpDPO49af2r7qreFem?=
 =?us-ascii?Q?HUqXPFudN04/I6HpTpZXJJZYLLF+OTyeF7KwhZYA/XnbfYZv1ybnl/wDn3w7?=
 =?us-ascii?Q?d8pglESMKPd4RtAtwRhvIDX5+Bh5hbjazyUL0tmTiB5X2YuY/NyJlpsBiuWl?=
 =?us-ascii?Q?NiOzTuVI/vATrgfalB0nS6G7/+23RExHaBjL1iUm1N9dMzoRzNcWOb2FFVyz?=
 =?us-ascii?Q?bDuBA94ggkSV8CgkZb8IM4DerqNvAcbzvVgrdEKW76B8bKG+j6l5b6tVKwNI?=
 =?us-ascii?Q?cfcFi8DinxELVpm0DqHYsgUSYAzfqhUsovYexUj/RYr+Yc/UDubGgyxUxvLG?=
 =?us-ascii?Q?lRNCXtaCvPpf51PF+Plc5zMvOZREL9tEdW63KPTLwYeI3N+CB5J+Vaf2l0OR?=
 =?us-ascii?Q?qpFQSIpuje6mTnNhXlFs1O0DxbwHXCojKSj4GNwFIZBv6DrDnn6XswZEICxd?=
 =?us-ascii?Q?yjjzSRuR6thMNaXwMl9EB4VFH42jMk49OBVgry06G+wE0OpxjZLy3mt8hxzf?=
 =?us-ascii?Q?S+lV+Bw22NSfF7jSZBq7fg66lRyj56IN6HDs/Ty/Od8bkurvbLp1ex71U7Kk?=
 =?us-ascii?Q?shkSOsjnpjeJ3vepgwyNwqbZcqB4xgVkmUcnbp44?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f888547-2570-452d-4129-08db30b9f6b6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 00:59:07.0861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6CPIc6GA8LSt3wOpBlJjtJw++jAnMHH029JBQb8LxTnU801K/zjudktHCnAgZXWYlvfYmP97iv3TgC4xSnL9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6527
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Alistair Popple <apopple@nvidia.com> writes:

> John Hubbard <jhubbard@nvidia.com> writes:
>
>> On 3/28/23 20:16, Matthew Wilcox wrote:
>> ...
>>>> +	if (!get_page_unless_zero(vmf->page))
>>>> +		return 0;
>>>  From a folio point of view: what the hell are you doing here?  Tail
>>> pages don't have individual refcounts; all the refcounts are actually
>
> I had stuck with using the page because none of this stuff (yet)
> supports compound pages anyway so we shouldn't see a tail page
> anyway. But point taken, I admit I need to find some time to get a
> deeper internalised understanding of folios than just s/page/folio.

And looking at this while updating it made the mixed usage of page/folio
look really werid/wrong so thanks for pointing that out. Will send an
update.
