Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D6C456594
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 23:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhKRW2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 17:28:04 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6346 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230481AbhKRW2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 17:28:03 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIM68pL020982;
        Thu, 18 Nov 2021 22:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Md0tz9tREW9RabkkUpcmeh+S6AjifQUqo23EL6a5vBI=;
 b=v2rce0mFfUPz7zXaON4ZPAUfooeThHwufu8BsblJfpPEYOB9ZcIIuqCHe7s/QMOjGiuB
 b0FkNNN/wW7LVq1kPU2nYLrExXsVcMKYoM+j9/x+DvWcW4035rXl3HuAH5u/HCyRq6gq
 IbAwnBwEfp14AjEx3+aVUuFwO8hnPusCRalGkbbhPuskfGpn3Upyy3AQqJX4vd8g6Rq0
 6sBxeUC/ean9ZkzkYTHVNtdkuvQxfmxxY+P49r1p5hyyQzwyDN0S7PYi2r310tnV3zwd
 hzIwS5cTVbqL/uslM0dtmbEoqSbP+8bEvNBWn8/IN0YXDMh2X0eOMt/YRPgcMAg3JO28 +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyt3d1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 22:24:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AIM1A2h136555;
        Thu, 18 Nov 2021 22:24:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3020.oracle.com with ESMTP id 3caq4wu3hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 22:24:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIczXN/aFF66ZSdG3ZnmNPWIiBcb+d5pa91TcClzvEZ4p89ELeK6gc44guzU2UX1OUzPZJRhkuikAM+CXkBHQQ2J9JgdlwGD0whu7vnnfBP+wTzjoDuUID8OHoBkBiuk+EF5r+InytIsUY9Y87ni7M7FyzC3nX8kf0jOCpZW1kPJ0Dvj9cQoYnvVTnILaxFQhExEXc3vxeQxC1qgTOc27K21vDZlGQJJCvJKq9N9v4T0NIN/1J+txm3IJ8zgpYQQtOxAfatEtQnNiseKgIw8LPzLMb6OWJzOSsthSvXzY63zcu3ZjbkfZ/iUliG1/XTxP7MzBmie1GM4jEGucAFwSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Md0tz9tREW9RabkkUpcmeh+S6AjifQUqo23EL6a5vBI=;
 b=Jq+yMCX2t3hwRQuzFq/Pc8jdGKLk0WrWSJKVYiwM4WxFY6c5z1dPrcN88288vs7B2RLopKMbndfj756XgVCqQNWEoZragVRFksUpUiPECfeOlSFn3jd7hSWBRNonfQ+cVt4wBPMiAzrlRjiSY7asdGSULiOHNbkRDNMOI6siNmndO0wbm4OvTMMEDqzU7BLv4lO5kKj3rAckJcVNTK0oUGhj/eTty3+fDdW4cVef3DlwlfbRE+HGB5E1ffSSgTa2KcwTMhy//koLJC8zpIVsvkrfbcJtjXYQKIUE+msUujpkTw3XU2rnV1tAWfq1TZ0kQZoyXmmyx2gpigtb+75SMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Md0tz9tREW9RabkkUpcmeh+S6AjifQUqo23EL6a5vBI=;
 b=TF/QAYxjRUjN7vs+bOkgBG7QtCizZ99XgJYPdTyr3WxManIhX6M8+6eaU7Gpn9J4XGBnE8q30CmcXlLbhj/wbDFU0Wm/FPTXeLN+go/m2RtIS6KH3i/QR47yD15aGdc//yIyiZnr8mTO4To7h+a0BD9k6hpR0RbPX/RN/OyYRV4=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4336.namprd10.prod.outlook.com (2603:10b6:208:15f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 22:24:53 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 22:24:52 +0000
Message-ID: <fdfe4ba4-8f5f-47a2-98df-3dfdb50d8f6f@oracle.com>
Date:   Thu, 18 Nov 2021 17:24:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>
Cc:     Jan Beulich <jbeulich@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org
References: <20211117021145.3105042-1-sstabellini@kernel.org>
 <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com>
 <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop>
 <44403efe-a850-b53b-785f-6f5c73eb2b96@suse.com>
 <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>
 <b0cd6af9-66c4-3a73-734a-3a51d052fac2@suse.com>
 <alpine.DEB.2.22.394.2111181226460.1412361@ubuntu-linux-20-04-desktop>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <alpine.DEB.2.22.394.2111181226460.1412361@ubuntu-linux-20-04-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.108.36] (138.3.200.36) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Thu, 18 Nov 2021 22:24:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b34a7c2-a17b-49aa-e018-08d9aae23db6
X-MS-TrafficTypeDiagnostic: MN2PR10MB4336:
X-Microsoft-Antispam-PRVS: <MN2PR10MB4336203567C3C7B9A73A42838A9B9@MN2PR10MB4336.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /7JyEBx76QAgM4kszIFrRtlyhK3SIeJPdClNSoQE1+10ZyrJ2i/b4Uf3FN+Sz4JCZp/TeIt0SmAhPSPU7x/47and7r5EC4PthnCu+H4BXxx3lGJoC9MPIzzm6+92R3r6NM7q9pqLtqxagoaTlZTtxgWBBIT4GQJ8Fpfk8EnTECkO9SNBK2sBooyRj0J1C5Jz8215RQgMpp+bCb4N0YNC02RTwcnTqhVXaEHDYp7uxle2IlQ95DC21N4iBWZuGoZZhLBTmcjkg6kmx4TaZH8B2JEPrJqce6dllXVZkRPNATLl9rz4RVdFte377lBpWDGXUK/VjQQWd5dpTIBbD8WnGEbBcEAzn3hElkCm9p4oLxZvDY9/JI3TXrGb1703dtjhucvqvS1/3lLShZNcgfqgDqLoluLD8M1VCLH3O+DMQHApNa1KCIcTxZvZ/IjPrqODRbHjK/wfAgU8pTMIPndh5RcvrmVvnfFx9EwNnW8mmg/kLRD4mb1T2GnEBVMlfIZcvzCKhLcrCcFwNZtbbQV8ZDzsUXgzI/rXotxtXK45MM2vSQxZc0xxHNXqyulT/gv3trex2BFy0A7zHX3BmCgIuvk+YO/kxpVKzKTlBuYs4bcM4FBv3Dv+JZBE0oteRXPcj8QREVNFcnzqNktGYmsTuGZ3V4na0tHBAod+JPPmxegF79N5/TmgHQwgxJC4MH096ytAV5wDb244cCCbJadRY9OPZZdnAO+nAsXPE+ZVYGwsB1wWfkEeGPlosdFR98Ts
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(5660300002)(110136005)(53546011)(186003)(8676002)(6666004)(8936002)(4326008)(558084003)(2616005)(66556008)(44832011)(31686004)(86362001)(31696002)(66946007)(16576012)(38100700002)(316002)(2906002)(6486002)(508600001)(66476007)(26005)(36756003)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzVtWGJCQ1lYQ2VTM1l1V29adk5WalRNNUJTWEpYM0duVXBoVVVkZkUzeU5Z?=
 =?utf-8?B?b05vVDlVVEZDem83ZExFNjZFUUNFaHJ0bVF5dk9hRFpMTnJmb3V0c2l5c2dF?=
 =?utf-8?B?dW9Cc1hQSVUyN0lYZ1JqbUF2SUFzYXV3aEswWndueTFoTTNlMHlvRVNOclpw?=
 =?utf-8?B?MlpiRlVVM29XSXNkNEQxWGc5czgrYUxPWVYrMXFjY0FDaVA3U3RvLzBJN0JX?=
 =?utf-8?B?SDgvMmF2RVl2WHgzRmUxV0VyeXBodVQ1emNvOGxpU2c5TUhpNnpPYlloak9N?=
 =?utf-8?B?ZG5sMXJBd0lWTUdENlVWTzJ0QTZycFkrTXl2YlAxZzgxMEJaNUNDNFQ4ZDBD?=
 =?utf-8?B?TEF3VGZXZnBqU1JqWnI5RlhWMUk1aVlycklhUURaeHlOZlh0MjY4NDk1SlBt?=
 =?utf-8?B?dXRaVi9BWS9xNjdNdDFEeCsyT3FKREM2SDFyd1IxazJSc1lndFRWTjBkOGNQ?=
 =?utf-8?B?WWRBYzN4Q2h4NWV2REhmb3JsZXBYYzFyYmhUVGZORlRhUHp1OVJRNEpRRUhh?=
 =?utf-8?B?dGRFV3h6TTFvSnVaN0l6dlVzcGNyajY3Ni9ZUElzb2NWVkVyckpwNGlFc0Z1?=
 =?utf-8?B?V1NjM1RTK2VHb0JwSzgyK05BZEd1c28zZDE5MnIrRm1SYnlkZDRwVFBqdng0?=
 =?utf-8?B?Y0J2R0l6L3BkMUgvWkNTRzg2dTV3Nmt1MlNzem1JSXlCZTN6elIwYkh4NDVZ?=
 =?utf-8?B?a09MZEZWK0RUdFBMWUNsV3Y1cHdORjdtRW9JUkl2TE9XajhLckpjc0ZLUVkw?=
 =?utf-8?B?ZkI4dzZZL05SSDVoSDhzUTNoeFlFMUkyMXdJNUp1ZForWEt4QWRqWmhJQjZD?=
 =?utf-8?B?eXBtS3FKNFp6dWtraFI1b3JPZVNnN3NpMkd3MklIYXljWWgvZDhldjdienRB?=
 =?utf-8?B?KzI0Y1FKRDZTcXIzdUJzYmkzODIxY3ZHYTBuSStieTFwR1MxdVo0d2dGMXh2?=
 =?utf-8?B?TzJrZk54aHcxWWR0N3Jhb1pwSDVFbVVCOWpOWDh4TlZZUys1YnR1WWY5RFdC?=
 =?utf-8?B?M0lLMzZKeUYxaXpOdUw3QnNDbjViTEpRTGViMlJDdHJ4b2tiUEo1V2ZOM3Iz?=
 =?utf-8?B?bDlvMXJpRTRFSGtrZGlmSkdvZTRpcWJhR1dMVGxkWXhNdk1XWk54RjRRNVVl?=
 =?utf-8?B?VlJpL0VKZE02TnNRaStDZnphdXBUaVFyK3R4Q1FTejJCcTlCVjdDc3JlSXkx?=
 =?utf-8?B?OU0vZ1YrbDRWWVd2UmN2YUVsVFlYdTc5Z2ZLODVHcm91UVRIcFl4U2lDQUxI?=
 =?utf-8?B?T1J4WW1FRUtadlhpcHNlL2tMWmdlVVlHSElydFhyZ2d4d1o3MkdlSU9JYzli?=
 =?utf-8?B?MDhqdU43eWdDN0FGRXlGODN4bi83WDJwVXFzd2lBeXpKaEgwRXVhYU9zTEp5?=
 =?utf-8?B?RWk2TEowemVicEd3b0xZUWJGNTNxYlcwc0RVTnFoTE0rbmNDZ1dHUHFWczlV?=
 =?utf-8?B?R3FRUDhZYVpYZWJPSTJFYzVpWFo1d1dYSFFVNXhpbW9WYW5kZFI1OEJTRlJE?=
 =?utf-8?B?eGJjTi90M0tuWmlHNTVhcHVCN1I3dkNGUk91T1FrN1NGZ3IrVjdaRzZubEhB?=
 =?utf-8?B?OUxvY0VvOGhXak5hS0ZUejZLaE9RVElrYzBYYnh5ZklVeitCU05tWmpBaWZk?=
 =?utf-8?B?bDFPUTJXSXZKVzNMKy9Bc1c2SXVmN25KaXIxR1lDZk90RkhZd0xQVWNlSmZw?=
 =?utf-8?B?WWZCLzIydlhXbWJKd05zTm90V25iRXIrYUdKRGZVSmZvZ080K3ZnUnJMbkEz?=
 =?utf-8?B?Vzg5RFJYZjF0SmU3RS8xVTE4Y3p1ZXR2OHN3VDBLZW9PY0dwWnFnakVFTWll?=
 =?utf-8?B?S1A5MVlpN0VxN0pUSXdKNWhFNGxtak1ER0p2NzFzSWowd2o2YzY4Mk9zL0h0?=
 =?utf-8?B?aVR3cUNDQSs1TXlrUWFXU1QxR3czWjVRVjBIMTdiL2xzN3JuQmlYR0JIVjY5?=
 =?utf-8?B?UC95TmpkYndYSVF1ZStCMTdpSzcwWG5mc083N0h1UGNwU3dlWjQxcFE1b01G?=
 =?utf-8?B?YzFnNktEOEZUelk2WmdXaDVxVDJwWE1SelBsalh3NDk3VXB5Skp5bDhFS1VN?=
 =?utf-8?B?NVNvSmF2aTJ2T0hUVzhYUml1ZDdySjdaSE9aMWJoN2ZBY1FSS00wWVJZajFn?=
 =?utf-8?B?cnJBRjIzc0ZVUXN1QUNheVR0TVg1aGhaL3dYKzNJUmlOejlzSUdxSk5VekNB?=
 =?utf-8?B?YUVwbHN3K0dxSHNzRmpGY001WFFaSUQ0eTQ2ZmJIdnB2OGxFSEpqTGxpL3l0?=
 =?utf-8?B?RXp2MVRFeUtRVXZKcUQyN3Y3SVVRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b34a7c2-a17b-49aa-e018-08d9aae23db6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 22:24:52.6820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JvHSt23gyASPAV/t1+L47VGXx42+fGK/HT7aTJ5fNI2IGstY25bh7JU55s4MyFdqsOORAhj0hfcHcN7XOG9jXMDMZxSj4vSM3gyrDpicIc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4336
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111180114
X-Proofpoint-ORIG-GUID: bop7nLiiUjQsyb_RFUVGw23IbyGFwAdZ
X-Proofpoint-GUID: bop7nLiiUjQsyb_RFUVGw23IbyGFwAdZ
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/18/21 4:00 PM, Stefano Stabellini wrote:
>
>          /*
>           * Avoid truncation on 32-bit.
>           * TODO: handle addresses >= 4G
>           */
>          if ( v >= ~0UL ) {
>              err = -EINVAL;
>              goto out_error;
>          }


Since this is only relevant to 32-bit kernels then "#if BITS_PER_LONG == 32".


-boris

