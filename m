Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FBD44633F
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 13:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhKEMVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 08:21:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2100 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229468AbhKEMVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 08:21:17 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A59xO6D022776;
        Fri, 5 Nov 2021 12:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=x8/rz+OH4OwGFbijOPoJfOcgZgB7bM1t+vg5tMMe7xE=;
 b=ztW/ajhUmrYMP/zRLEOypSoyr1I/SGAPAOF716bkMiuOCigPP045mxniaWP59YZyLbSZ
 c6qDPXwlbrb8Znyqrlb36m9B8DIp2ENiHdKDRG6fgYB1cDHXRKetQTu7mugYdHP7Spfd
 rw8DzY1Dd3KnRua7UiFUDV5P4mTjc76p/yiPYOLfOa9RB3BBWuoJPgUs5BOL9ufFerz5
 gUcenSMBKtCH/+RJYdKsHqTAcNrcFYHLXjSoHsXugrnSbxjFYqxlxvXrKF6BR48pKM1i
 zk6/oR2aN5+Ty4MrGg803/o0tQRNVsZyCY92N3d05R2AkfQbwZlxL1pmhuMiRo09wogU jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7f24qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 12:18:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5CAQnB077370;
        Fri, 5 Nov 2021 12:18:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 3c4t615jkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 12:18:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGCq5y2MTQKorvGqHlA3hhCaT6llmjosfiy89RkYEWD1/JAmQz7LtWzB02MuKd1RCcVZwLSHIMhPiupcKVPI/slycCl9kL2B2PcS1s7WNX2yH4ZLPSPa7+D1gvubhLpuf0kY+PqyFmLLjBqRWXDD4nE0UuyQ+fy7vJC5MsU43qyhMIPave9Z8y7gDlUJHfYh9Vc99U8y6pgn/MsopY6RfaCkzLO9+FTTt0r301JGxrH9T3BTg+hjDEvNh/KaJN/lBFHInAlF5ert+gle2Sa8br/onwZL7DpG+vFLGaWIBr4+tdZd1fyx/kjII/Sbdr70qrkkSVJuRTfKf9s8NdTp2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8/rz+OH4OwGFbijOPoJfOcgZgB7bM1t+vg5tMMe7xE=;
 b=mxOABSZIbXdYxv90cchRUKBFAj8T8oNcMVnXi8RrGYGWjnHyoqVRwPqS8iKy4YBFVlPa2fKV3PXCrD4EP5ylCQY8DAqcj9+04/KfFlu5zMY69yVWq2GSJwfWSu35EaJ2IS2gVlxBasUiXgdrWcMuSa7ZE3SRaKSw0XEf+06HnJgXd2X4WN33qEU3HVLu1hoHDP74hNZyLTwiXUpzLgwqAujoVIF1cGkq11Ja1FXU3NBJkxCi/NLsb7nv8sfJT0gCPTZQca8UQKUhSLnfNqYl6Fuu+X9ofrLb+DsVTu1nBRdIHjK1yUqJqfZDJKqnsojC7CGc2MxltUd+bpQ2GUI6SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8/rz+OH4OwGFbijOPoJfOcgZgB7bM1t+vg5tMMe7xE=;
 b=IEMJYHASUnKvN944aAFpvT9LMPPA7UJI4rf7nIHx1PW6vOBaWDe+j05vco3/E0gJZEjw0TlUWn9jSyJZzPX408aRkCauuH0/wrO3ZCKbaL5pFYmgoo9tCRKdsp+xr3ATknKZwbSZ7iv2CDNrMFRPFW8iT0G6fsqCvVyIZxiFkXI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BLAPR10MB4916.namprd10.prod.outlook.com (2603:10b6:208:326::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Fri, 5 Nov
 2021 12:18:25 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%5]) with mapi id 15.20.4669.011; Fri, 5 Nov 2021
 12:18:25 +0000
Message-ID: <b3c448fe-b37d-2df4-093b-e09c8543be83@oracle.com>
Date:   Fri, 5 Nov 2021 08:18:19 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v4] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20211102091944.17487-1-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211102091944.17487-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0019.namprd04.prod.outlook.com
 (2603:10b6:803:21::29) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.104.120] (138.3.200.56) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Fri, 5 Nov 2021 12:18:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6268cd14-b3d4-4601-242e-08d9a0565db3
X-MS-TrafficTypeDiagnostic: BLAPR10MB4916:
X-Microsoft-Antispam-PRVS: <BLAPR10MB491674CFA3883408AEB995658A8E9@BLAPR10MB4916.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDLclJIrSktbVGwjKwqWJ7n0IcRLH3rECprOZN+Q9k0dB95SI4t2E8AteglO3gxFE//nK1+wrdubGl5iayVnOBRH7eosIcbMHsxK78Fdob6oWdGQ7nT4vqHuSP9ma36ZiFdpAy8ZnyN12zRznke4yUq/0mF4rcT6rsu0/X+vqmIHlvKo1tRf7mwtPfCdthaWDUXdyCrR/ABG1FTC36I/Y+STjYEyTibSSAXJVysFMjFKjlodAJGjugLyqVFBAaHqvWdfAd+fLiM3yK6WqB8qBhEK52KTJTg+wDEKV+BsqkjV60WlY9Z0lcrFPd5Ron7PCfUfNp5hph3rKNTRwYNqWTU7bunJZzEVfgV3uVUbWq3vq/72aqEhzX19Nj3xbZjVwW8zbik+MHf+/Q0DyVLByB2mq3qrYD0Dh4qq4uzRJxBUaom0oOod8AEAZ/quw19T6oqod9lX7rbA5QwBqDN5D3qp96zO7XbKnz6Zdrk9D4v9JC1tFRm4BQjoXCbAgwEviVtVixldH0nvm9s1rii0Jdlwz6/TAUi59RhChrBVhh9wO61zP6kcvT7ABpxeYVsA36Ml9uFy7umhcc9YHsFb4tD53+C/LSvaJ+XXF9Ivn0JEiKqlNGyjw7FPDvcr2apuXn+zHcaf1TKV0hJfKUqs5fpIyoIpksgi0mYthFnvLEhbm+fNQR6xXW+OZ/PHhS7FOzHnE/doNNnrr97/EwPk0ttbteUd/QR3UUswMcxZCkk27nK+XatWGkULAnpLKScc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(16576012)(83380400001)(31696002)(6666004)(2906002)(956004)(8936002)(186003)(86362001)(2616005)(5660300002)(316002)(54906003)(508600001)(26005)(44832011)(66574015)(53546011)(4326008)(66946007)(66556008)(66476007)(38100700002)(6486002)(8676002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tzk3Vm96a3BGbzc0RGxDc2dwdGoyQlRveVJtbE16Mmtmellnc1NtS3N2MEhi?=
 =?utf-8?B?L1N0eVRuRjY3a2dQVXhZVFZmempTc0YyMENiN2lIV2syZEdZUEREVjFiYVVr?=
 =?utf-8?B?U2hOeFpCdHoySUsrWktwSkt4bGRxMnlUREJ0TXB4TzRGcGhoQ2NKNTdRSW1h?=
 =?utf-8?B?VTJxa1BUbnpzSnFKMVJFdkRCTE1vREI3NzNrWFU3TkpuajBOb21mdW5NUEVo?=
 =?utf-8?B?TXpYUXBBUlVwa3RheWFJRS9lK29iKzZqTm1IVlNrKzJQWkpRZUhzQVVtWWFj?=
 =?utf-8?B?aVdsRzlVSXNnUlZ5WHhyZFdjeTNKZVE5VXZGWEtzak1xamVpSG9XZkxkY1JF?=
 =?utf-8?B?Z3NyZ0RXYTBEMVRSd2NnblAzMjY1Uk9McXBZdEJXZnlxZkdXeHg2WmlWdVhM?=
 =?utf-8?B?M2V5ZU9LeHRMK0UwSXNCVVNDbUYrelo0OThYazc4SFVEVjFVVVFsRVQ1eUhv?=
 =?utf-8?B?UXFFMGltMzJMcThtbzRUSUJ3R3UxOUVDZGZPdit4SnVUQU4zaVMxaE4ySU1r?=
 =?utf-8?B?TzVZYUJLYkFuVDVldWJSdUptdTdkczNNMitlQjVDcnNQenBFOTMzRFRCa0ZJ?=
 =?utf-8?B?aWVaSGVqTDJCUFpBdnQrNGVBOVVKZmxWSVFEakl6dUNBeEpuaGk4ZUVndExH?=
 =?utf-8?B?SElZQ3paVXI1U0Q3Qi9GOHo1eGc4dWFmZUVIK0hVSTFwY0E4dm1lY0xZQTNm?=
 =?utf-8?B?UTJFT1JkNkEyek93SnRkdEgxSEFBUnJYNnMzd0xNVC9HZklLeEhHS3RQUEkw?=
 =?utf-8?B?NUsxa3RTdVB2VXdwRWNqOFN2RFNmK0N5RDNJUnlBVG83MXFNek9nYWpWc1hU?=
 =?utf-8?B?WHVtREdXVHZqUUp5akRseTJFb0M3dUdESDQ3WW1QTUhFYlNCUUtCOEgxN0U5?=
 =?utf-8?B?NXo0YmJ4N1BVdldIWGczdXViSHMzT2FWY3FjSUZhSjV4M2g1ai9sOFpwQyt5?=
 =?utf-8?B?UXB4T2czZ2ozcHdEVlNjWlJFbVprMDUyR3lQYTJrTHRWZERmbVNBMWQrdlB4?=
 =?utf-8?B?SFdEWFNzd0JOK1ZpQTFGZTk4bnZiWnZkbm9ubW03a1NUN2ZMOTRuVkRsS0JI?=
 =?utf-8?B?VDVCUlYvL0RpSjVQVnpzSkdmSzhmWGEyMlF1ZjRPZkI1RFpZTnFUb3kyMndx?=
 =?utf-8?B?amZ6YWd4d2tscWt1UXBWZEliN3E2MGVQTDhKbnQyanNuRHJmM0FIN0dYbkND?=
 =?utf-8?B?MFhicGM4YWowK0RHZlJIR3lPVUYxRS9uZVB5VWIwNUNISWZocFFtT2UrcE1D?=
 =?utf-8?B?T1VNK2JJeVBFT2xKajVIR3M5Z21DaXpFMkVmblVOaGsxN0VKQWNHTzZBdGlF?=
 =?utf-8?B?cDM1bS94T1E0NW5Md3lwazVqODJTNzR6eFhCeU9tYVF1ejFpMFFnT0t1WnNH?=
 =?utf-8?B?WTF6dTJKTVR3alhaeDJ3UUhkMUJLUHp5dU13QzVnRFpIaFA3QUxBc1FZdzdn?=
 =?utf-8?B?eTVGc3VTT2I5RnBES2RncWZKeHM4ZDlsZDFQYjJnZXVRTngwUWFyeDlldlRw?=
 =?utf-8?B?OTlNeE00WERnZ0E4ZXFVODFNSEFGMXV6ZWgxYkl6TkNYOHc5Y3JINzUxdUhM?=
 =?utf-8?B?Q3ovK2s1VjRBeDhGWnB6bkxjeU5uZGRkQTdyUFR4WUJOcjE4cWV6YU9sQ2Ra?=
 =?utf-8?B?UFhRMmtRZU1XTEVHcGZnWWdxOGdqbHpsMVJMU0pnWnQxY3NCRUVvMUNiTGx2?=
 =?utf-8?B?RnJhb2hoaGZDd2ExYnlwMHRqd2ErZ2cxUVZQWUxIRDlUaDBORDhoMGdCdkVm?=
 =?utf-8?B?anNzdEFKSlhlR05VVFViZlVWdlI4b0lpd0RHRk5acUh2Y2ZsUXp4a0poRmNk?=
 =?utf-8?B?YUtxMlpzUFdpbi9OQnFHaitweVFlZmNXSm9rMEIzK1Qzb1l1QTNWMk12Q1lT?=
 =?utf-8?B?L0huaEZFN3VmWHFWV2FZMVgxb2pjb0ZCZVQwcnBBVDVITXU1cXQ2L0lMeTBF?=
 =?utf-8?B?N3YxTHJUNjVZNk9DdmR1QkI3MFFna0ZZZFYwVHlGdG5KWFhqNkY5cnlwelI3?=
 =?utf-8?B?ZzM2VUl4UUtMUktSOC9qWXYxNkFFakJ0QmVoOXBvU0lIOEI3NE9WZUxVaEp6?=
 =?utf-8?B?dnNwRy9NSlNEbGZ1bnVia25JMWl0cjlsT2tSZ0JvUW9yNGtESzhzRVJaWWli?=
 =?utf-8?B?L1VOb3lRSzZuOXhYTlJGMWRXclVhZmQyWWgyZUYyZ0xwZk5EZ013TXBKa2VG?=
 =?utf-8?B?RkNCOE96WkErdkx3dDYzeFJuMlJRQlJveU5vaXdRRE9zRWhXam1ySTRoQ2lH?=
 =?utf-8?Q?0/K66zyMJBX98qcVWT76ZVODETLOjy3gGQJQfzQEyM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6268cd14-b3d4-4601-242e-08d9a0565db3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 12:18:25.1638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: il6hcuNbbF2DHDx+1YHdyXYwRzD70//qT5foNlexqZsJ2nTMggDNzU/ImdyRPGxXlOHKqhmKBWbggEYg/1rVQ9dbmBfHHm/lCBG94zVbMGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4916
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111050072
X-Proofpoint-ORIG-GUID: kUhmW-FhLCPmwZMmwFtjT6B9KNv4nZgo
X-Proofpoint-GUID: kUhmW-FhLCPmwZMmwFtjT6B9KNv4nZgo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/2/21 5:19 AM, Juergen Gross wrote:
> When running as PVH or HVM guest with actual memory < max memory the
> hypervisor is using "populate on demand" in order to allow the guest
> to balloon down from its maximum memory size. For this to work
> correctly the guest must not touch more memory pages than its target
> memory size as otherwise the PoD cache will be exhausted and the guest
> is crashed as a result of that.
>
> In extreme cases ballooning down might not be finished today before
> the init process is started, which can consume lots of memory.
>
> In order to avoid random boot crashes in such cases, add a late init
> call to wait for ballooning down having finished for PVH/HVM guests.
>
> Warn on console if initial ballooning fails, panic() after stalling
> for more than 3 minutes per default. Add a module parameter for
> changing this timeout.
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>



Applied to for-linus-5-16b.


-boris

