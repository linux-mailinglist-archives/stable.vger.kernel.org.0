Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D50350775
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 21:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhCaTg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 15:36:28 -0400
Received: from mail-bn7nam10on2109.outbound.protection.outlook.com ([40.107.92.109]:60452
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236086AbhCaTg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Mar 2021 15:36:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ou+/mY2Vd4k6D4CfWSgMYSaQPAxyKR/04kfZty/IO/7iB/ycfyaq/5e7Afxsco9n1S8mMNkxgqEO3E4w1h0w9ZtsNobUPnpZefisopGQzqeMCP3xAVpkJ9BtL8hCJc1Z0MjFNToontuUGOQCCTSfDkHOUzfWQMXVGZwUwlcVSJxq4QVan1WI+/6HKsST2lTwkzY4QbwvJcqV8bx1/e9OeOdSz1v2fpVOCHLuFTZoVyR6qiz4ceBXIoJ3HMSXplURnp0VqRPKvbYutB/zIpIhvVphMANsba4FpRzYDu6gh8U3rpUp+byCZCBHlf1lM58vgwOcMiQrB9ViX43qEZ9DiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5E2JKL9NVt8Dr4PDw96jl0LgD+FjBB8rXmfQpiuD3A=;
 b=K8cU/PERPeWQpiGnghEOObzHwIKuhzddvtv1Dpde2MwGIbyYCA1FmRNU++t7puLRjCLBIwgXHZPHjwF0y3IdINpRnBoeEoh6Yx85iByNZS6BZfWJB3N+RA6kw674mRZlyA+2c54iKwWtGe4+pQ8cgrIFIlkfOMVPkCbqRaY1ClaGcv6Qobtfh1ZoVrNyEL+wMDaNWWl96vE2d9u2EXBP+yNyohxdyYyH9twYtBRpPB37ZboyT81kWefVnCPrYCQn6qhjiWD8ZnspPPdMHw75XsKmYGquBs+wpceZhYYAQMZelkDHU2QL3aSfCLAGSf0LE0JsunU2C3Jt/zmnykGw3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5E2JKL9NVt8Dr4PDw96jl0LgD+FjBB8rXmfQpiuD3A=;
 b=XX39wkvvrB1ylSjOwRbYX9tudoCIZgZra4h5H+w442fzxObZhji37UNx6WcvB1mzpSLzef03vWG26g4H1ht4vxnYSC+uNnYxvTBu2yVkc7xTj9V+q4ZhLEM6AqvcGyCIymYoGAFC54B0X2unaWcszL5Ze3E0A+Yi40CbnSWUr1sgTdnjcoeOJP8qjOSFcjZa9Ya5LYbw5jBKclD//I5XgCAvT9/zM/xl27jffaG5sJSHKtBBzAz+mSYDDS5qrns3mpmveFdzF7YMa+E02iGEcqEcIrfmhQUhiO7Li3Mm+sj3Tai1B1hpPmyP+zBMhjWiZKRF03wH+CgO1CJCgA755Q==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6296.prod.exchangelabs.com (2603:10b6:510:a::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.30; Wed, 31 Mar 2021 19:36:24 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860%5]) with mapi id 15.20.3999.028; Wed, 31 Mar 2021
 19:36:24 +0000
Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Kaike Wan <kaike.wan@intel.com>, stable@vger.kernel.org
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329140922.GP2710221@ziepe.ca>
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Message-ID: <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
Date:   Wed, 31 Mar 2021 15:36:14 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210329140922.GP2710221@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.154.216.5]
X-ClientProxiedBy: MN2PR19CA0038.namprd19.prod.outlook.com
 (2603:10b6:208:19b::15) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.40.159] (24.154.216.5) by MN2PR19CA0038.namprd19.prod.outlook.com (2603:10b6:208:19b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Wed, 31 Mar 2021 19:36:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bd103e1-5847-4dc2-9629-08d8f47c44bf
X-MS-TrafficTypeDiagnostic: PH0PR01MB6296:
X-Microsoft-Antispam-PRVS: <PH0PR01MB629685643362315883A0DC4AF47C9@PH0PR01MB6296.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9sZGQYxmy3bmYptJftdv+QRaQEHEH2/T2SgO7pT4s0vadM3Ik49YH3D4FPmoANZ6Mp/BUF2oWyIQumkRV4m0myW5WOHsz/32v6/4VxQDiOU6q4319xuqqCQBO+R1UcBa+728UeMy951xYZ7z16jG4YkVWFQKWbFNgzXGp3EzlmosNVwan3pI+tKeoyr8MdOKiqJuXCZxEhsxFOoSO0o2cvdNlkTQoZw8jT+CeuQpfF0MIj+5ynqFK32pOwKn9h2wwDMICltKXMxP2cDVtwU7Y41c2g8V5dzH9alkUEgYTRMMewuWulcsJalH/dx4wlXZkr0yB7+ZKS73KAEiyiFvZxFBrJTJRqWN2WC6PTc1NqgHsa4TWtGNlqza9cZEOabWeUiad0yFtFnyXeVFKb4pohNA9We+VQtXHq1xE0qD9bdZHxyiLwRsgfmtN/822zDWXy7dE5h6MeIcOB43BmefdozdH398fPgP45ojPz+HqWIfsllghNkuBxjMPSR06Yrb46ejQ32Owo84WLmHpAbHdU0yvigFdr/FtyUulcbrm1AxWZYsviDQ8POKgIIRwOEAyhmJN9fo+e4H5e79AboRrQIGBC4PcdI69izMjeTgrOwKIBRnU2CwPdTdB1Jhq7DGEwtrxtDyrVCi8DUBs8wBcpI6LLlsLjNjGQNnumm44fTBkqY3LTaMCiyUQt9ulgG4f1vuETemtOU0BD8/AZxBYh2iXbWwfR0rQDGgO3gwOLNtja/Kck61Ba1Co6/hAVSCAzMdcWlZKidCl0ld2OPjyTGJMVAOUPRM8hfBQL0IJcs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39840400004)(136003)(396003)(346002)(376002)(52116002)(186003)(2616005)(16526019)(956004)(66556008)(2906002)(36756003)(6666004)(66476007)(31686004)(8936002)(66946007)(8676002)(6916009)(44832011)(26005)(966005)(38100700001)(316002)(16576012)(86362001)(478600001)(53546011)(31696002)(6486002)(4326008)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?alpyWlFXbWFtZDNJTzdvU0RFVTlZWERDLzREMDI1VmRlbTUyM0hZT0xrd0FJ?=
 =?utf-8?B?SEp6MTREMi83MUxpOG5JRUh1VlkzbGJpa2VFZzZuMURtTnVvUGhGRll2dTdj?=
 =?utf-8?B?QkMxa0p3cHI2Y0J2OXRwa2I4eG9DK0lxOFJpbUF3eTZaaXBvOXlrRFUyQmRG?=
 =?utf-8?B?SzJuRDFkR0hXclYydUlKL3B4bzRMMDJzOStKbWkzbWY1KzRkZ3RTSFMwaDFt?=
 =?utf-8?B?UkJPYVc3UEVDRFVzVGRabUFwR1RieFlvQjNFL3NjbkNEbjdDci9zYVpPZlhk?=
 =?utf-8?B?NDQ2bDlOK0JJN0p1Ni84Yk9Gb3ZyK0lnYWJFM0xwbmpMcXRHbFdPK0x0bFV3?=
 =?utf-8?B?eWY0bktzT3RxU3AxUXc3bHVYMEFZUVdHb0NLRlBOTklKYWJzOVBRU1hZOVpa?=
 =?utf-8?B?YWtpNWl6RjMrQXl0MTM3VUpKOFREWTdnS3pXUktjNEtGL3I0TjA3czZTZkZh?=
 =?utf-8?B?UGw4WWY0WGFmQ2ZQYWdRQ1Q5THRqVFQzNi8zYlZJcmY4eXB4VFM1ejNXMXVJ?=
 =?utf-8?B?NEZnY2YvUzRrVzFqejZ6WEVSTTJpNGxuV21TM2VFUXBuK2JRSzNwMkwvcDRV?=
 =?utf-8?B?NUptdXY3dERTQ2lndFZTZnJsK0lmcHd6eHFvaVZBUWdVM1F2eDMxam5neG5S?=
 =?utf-8?B?R2Z0YkVlMzU0cjVRVzd3VHVHNUZtTFRSdElRdTFNVTREM285TzVHenNrWWt4?=
 =?utf-8?B?S2FBTE1VWllNVjljL0VIL1J2TkltY3kzeWpvbFBlVk51U0IwNnRiSVEzeUFZ?=
 =?utf-8?B?MG9ncnk4Sy8vYy93WXIzY1luWm9TZlhkYnp3dVpYK04xMWZiSTVnZmhQRFo2?=
 =?utf-8?B?bENBYzZKV3V0aWl6N3MrVDg2TDVUeWZwcXdTL25scmdjcTVFbEpHdDNXV1Ir?=
 =?utf-8?B?WVpnTE1ZMksxMVYwS1RENS9hZVcrZFFoM0hidmRxSU1ORmFOWWRjYlQ3LzZZ?=
 =?utf-8?B?TUhOYWpTb3AwdDhlcWFRR1ZnMExxRXY5VjN6YjdsQjBhOEtvU1RDMnFraTM5?=
 =?utf-8?B?QjBZN3IybEl2RWlaRk5VcVQvK3hldzBnSXR0WVFLay9vaThEWmtPSmpkWGJN?=
 =?utf-8?B?Y1krdnM4cUM1WVd0OUVvdTduWGZXWDdwM3NWYXc3NE5SZkVkUjByWmpnckYx?=
 =?utf-8?B?am9jLzNPNk5CVmt2eDg5Q3h5QlMzN203Qi9KcW5wZTJ1NEpTNGhiNk9ITUVs?=
 =?utf-8?B?L2x3NW5GMHBtdnN6cVBoL1BhZWhTQjEzMWJzT3lWOVpNYjJ6dGxiaFdWekkz?=
 =?utf-8?B?MVRaaDlhMTZKa3ZkM3dTRTRsT3hjeElXeVVxSDN0RktOVDBXM0pCajN0Nndh?=
 =?utf-8?B?bWxQMUVsMWdnYmVicnZEWFJRVzY1K1N1MUd2V1lvMGtxekhhd01XS0VmdG5L?=
 =?utf-8?B?MVZTemVvdHdDd3UvY0t1QU1Sc0F0T1EvRnRaT3BkOU9UNy9PaHM2YjhSZllF?=
 =?utf-8?B?NW11djJIcXlKRTBBSkcxb2svMEJTSzdWMVZOaTB6bGFxRWo0RTBYUnNHcWlz?=
 =?utf-8?B?UUNXd0FTRU9GUlhuRGJ0S2pRTVQ1a2tLQWMrd2hSMGU2NlpnNFJSeTIyR1do?=
 =?utf-8?B?Wkd6MFRyaFR3UGhFV2FsM2lyeWdFSTNYL3ZWN0tJQmVML0ZCeE93cHR1OG9O?=
 =?utf-8?B?dEo5SWhYdTBFMnlNL1ErbkYvOFhrRVNNUkd0dTM2T05yUis4MzArZjA2SHBk?=
 =?utf-8?B?Njd3VHVLbEpmLzJkNGw3cDBNVVdDVjJYU3l1d0hQVzhSQytQczRuL1NQOXBZ?=
 =?utf-8?Q?pMmMNe2+PgU58uSbUASdK11kpR9QCc97Bqz5OKo?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd103e1-5847-4dc2-9629-08d8f47c44bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 19:36:24.1265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m9fVzbr75tZVuLanJwoaJ+cy1Fx3Dk6opw0bbhcBkxWp8Kp7tfcP9mdOHaYaiGRIZSAAjnn/Yna2XezadyTTYuoWpn8iJVn2pp1XNVgVQRcjq2S+2Oedwfu4vzvFX3Mx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6296
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/2021 10:09 AM, Jason Gunthorpe wrote:
> On Mon, Mar 29, 2021 at 09:48:17AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
> 
>> diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
>> index 2c8bc02..cec02e8 100644
>> +++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
>> @@ -372,7 +372,11 @@ int hfi1_netdev_alloc(struct hfi1_devdata *dd)
>>   void hfi1_netdev_free(struct hfi1_devdata *dd)
>>   {
>>   	if (dd->dummy_netdev) {
>> +		struct hfi1_netdev_priv *priv =
>> +			hfi1_netdev_priv(dd->dummy_netdev);
>> +
>>   		dd_dev_info(dd, "hfi1 netdev freed\n");
>> +		xa_destroy(&priv->dev_tbl);
>>   		kfree(dd->dummy_netdev);
>>   		dd->dummy_netdev = NULL;
> 
> This is doing kfree() on a struct net_device?? Huh?
> 
> You should have put this in your own struct and used container_of not
> co-oped netdev_priv, then free your own struct.
> 
> It is a bit weird to see a xa_destroy like this, how did things get ot
> the point that no concurrent thread can see the xarray but there is
> still stuff stored in it?
> 
> And it is weird this is storing two different types in it too, with no
> refcounting..

We do rework this stuff in the other patch series.

https://patchwork.kernel.org/project/linux-rdma/patch/1617026056-50483-11-git-send-email-dennis.dalessandro@cornelisnetworks.com/

If we fix it up in the for-next series, what should we do about stable?

-Denny
