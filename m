Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B2F470F95
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345526AbhLKAvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:51:08 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14148 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345515AbhLKAvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:51:08 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BANhjFO012859;
        Sat, 11 Dec 2021 00:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jRRZynkeiDfsyhXjA6TFGTv6xSoyW7P3MlF8MKByi/I=;
 b=n6ET3Fr39FqM6gTpJeT/9+8mpBtXEh0FvCt3I0n3YsVBTpi6ZKCNqXagdzppGtsatMP3
 8mbXDziGp6ZymPWW73Ru+/49l/SWYRfYwJFK/EtuqRrEGo2bhq3WPQSQK5CFDms1z7fE
 xEv/bZdbWVNmNX5i4s17tEELNBx1lwDi7POgX22d2FZJHWMDgHVfcYCAgtVruq6EOSlv
 1GoFRYJQGRj9eFDAsXgjl/BpvVMM9I71tO5X3MAS33JnzRs/0jrrXYeSs+KytI612706
 vozUEkxv6uAhIfuI2EZD0bx4mE1hp7I6vEKiJxLD3JFjyY0zvvsJb35m2FLZ+4cc1fv5 FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cve1vgakv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Dec 2021 00:47:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BB0kHOe112107;
        Sat, 11 Dec 2021 00:47:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3020.oracle.com with ESMTP id 3cr05a0614-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Dec 2021 00:47:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWGR5o1tdIO9dfUDBvqwSb7++Bk27SwpjF7Vy2nYVVtnSNK7KMOO/80yoZb7oOvn8n181MIRHMrDi/AcqeAd71Ml/EdDhnv1mbak0VBE5OoNe+Wck5x0WlmKru78NucRiA20pMGcnFlrPkX03MYZ3idinrgnhpX6Kw8IVh0rur+H3C7gyMF78iP2G6UwRXgJmIErev70bPcDDzGAS/IpdjOj13PsEK1zkqYwhdQ68Jod2a0vxSMrS6PkvFKaWa+mPgnKjYEFoup2peoF52+NEhYtZeqs/tq5jV9WcijsNenMqA3s1gdAdYckbp9AI5ZsWpuRPBBYnylWDu6JseVcuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRRZynkeiDfsyhXjA6TFGTv6xSoyW7P3MlF8MKByi/I=;
 b=Re6LvqsclUT9/jVaZqei0DWNFyxu5i8BhH3wWIVevv7bAqgdn4WQp2oP1dq6bLBEg48w2f5w06VCiJ+bnJx5K+5NE/ztHRfheBZMjIOYjijbzvkr7UdF9x/BWkwvEJbwSJcja+080PEEqC7ppPasuxSlJzrUqMY/P6+nkSOKCmUYV7CoaUxQym109MIFg8gA6ifPlEfBGrUuBqEuSENFAbNW1vYUNiGtLDgN326De94h37l+M+baXIiEi26fFWA1tmITn87S+TSqWTS9nRViJUTqUlfZYnZEe/GxbTklKJAxmA63i0TUQ8MWf2zyoenic6dJTHTNXlHQGmejc7EUTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRRZynkeiDfsyhXjA6TFGTv6xSoyW7P3MlF8MKByi/I=;
 b=NBBdWDnVpv9u4lM8EMjGGZDj155q2XKZNMKeyLqoKiXR0O6EHaE/S+otDQ7c7CxBVTYQNP6DTUQGHEG0eIapfYUcsXJioLSvHnqA1RPrrxCnw+80RzF8/oXO8PKWl+UjDMUzzU0quyYM3TAb3ImVP3ABTxGsp17RztXmrESN3H4=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BL0PR10MB2785.namprd10.prod.outlook.com (2603:10b6:208:73::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Sat, 11 Dec
 2021 00:47:12 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12%4]) with mapi id 15.20.4778.016; Sat, 11 Dec 2021
 00:47:12 +0000
Message-ID: <7d113a50-5efd-d45e-04b9-a29023092518@oracle.com>
Date:   Fri, 10 Dec 2021 19:47:06 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] xen/gntdev: fix unmap notification order
Content-Language: en-US
To:     Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     jgross@suse.com, sstabellini@kernel.org,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        stable@vger.kernel.org
References: <20211210092817.580718-1-andr2000@gmail.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211210092817.580718-1-andr2000@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0015.namprd02.prod.outlook.com
 (2603:10b6:803:2b::25) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8dffe1f-896d-4998-8b1f-08d9bc3fc4d6
X-MS-TrafficTypeDiagnostic: BL0PR10MB2785:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2785E04155ADECA7099BF23B8A729@BL0PR10MB2785.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hG21/S96hg0eQZ1/+7Z2osTJvhN4XxjA18oFNal6nwdX2vqpQxTytpwNVIc0VNu+nNveb1blYR5o6EUSoBs4gJDoTI1N/aLdmEoDoQ7zEFrS/s/MOU92GUIR4DT1zp+3Gw+COx5Dyc6KXnp4d8iEDthHgly9MLPII/wjZEp76Haa5Fd/noeCYUU1ItAW4NR4RU2NkrtPYCwFWd2jk5+L5kjAPabBVDEZAzXdNCmQI5+KtrWo+WFGE8QOFCHLLsBCLR+8oJYBbTFoDLzAvdSKcyBd/gqstm26g3PocNhEmSaQCuYXBVYy8wON3wWDJljwV2lV+VGPi8S7kii/3Px4Ud/4a3IzUTXeEmVjJG8NocdI5BUEMTdavR00QlF9w9lq9PIQ1RgrglvhdYCqDoD9QKDIW+gQlY1kE1pAl0FlweCy3CVCHXey5fSIXIT9Y7yQcBLfStounce8+4t2mn8/SAt+AEhiJ8P4uPj75Q1rWC6SuZjcNLIyHyZ59f1KvjduZYVRkP1RUk4TDD7PFnShtRETkWTaReRYvmPqk01+KKFxYgr5nYzJyORBvwlWATcMEgjWnn1XKi2MUR4Rz7OlEurzvK/V235PjKYJyLbVkFGR2v6WjeQOYkDVCdxZfqYPABiPcMdjw+HtDsb/4DmZuO1c2yL5IvHPEXeLUGzV5eFCfnBJgMqnt1QuuFyoITOx6CPJB5cKmOJs+daghon0ZNs296oTMpKiHmdrsQWHHAi4lEimqkOzrl/TJcNh2y/u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(31686004)(44832011)(2906002)(66476007)(83380400001)(15650500001)(66946007)(8936002)(5660300002)(38100700002)(4326008)(6506007)(53546011)(31696002)(8676002)(316002)(6486002)(6666004)(508600001)(2616005)(6512007)(86362001)(36756003)(186003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFMyNHZyc1RQQktFbStsYmxxbWQwRmRTUlhmU1JKbVl1THNraWVWUWdKVFFj?=
 =?utf-8?B?b0RxOGcrSHNkeVBXSjZpeVZSbzR6a1NjODkxb3UwRGErUmdWcmRNMy9GaGNM?=
 =?utf-8?B?alBZckNpNW9EQW9UZ0dlME85cTFaOHYzMFpDTTRpRWwycFNyQTFoUE9KT09h?=
 =?utf-8?B?Z0Q0a0tZeVZUMVFua1ZWRXc0U1JYRUNJdyttZkRDOFdKY012dks3bm45NFFH?=
 =?utf-8?B?bHlZV0E5UGJ4TXpQSzlKODE1NzRNMWZ0NDUwZGprcUV2NTU1MlZTajR2Q0dP?=
 =?utf-8?B?UzZLOXN3WlZ3eU1YSkdkb2xZMGpNb1FGWWZESXJTbmRSME9Xb29LZDhPSWEv?=
 =?utf-8?B?WTN3VXFrUkxnTXk0RDc3bXdkbHA4MDQzU1JmZGQvcThYY0ZsbGJUUmFXTmtw?=
 =?utf-8?B?RlpJYTh1cGlIMHowZTdpRDVEWVExRWJxMW5QNjd5YTNuYkppSG9TeHNNTVNE?=
 =?utf-8?B?TTdsbDRUSk9zSy9ERGl5MUw1QmJsa0pZZFZ4QzlPSG54dkRYNkxsc0hpRUxi?=
 =?utf-8?B?bUVpQnBsWTA2SG93WmUxVUFYWUJnTUNlUzlSa0kxZE83U2tLN2JHbUxUMHgx?=
 =?utf-8?B?RW1EdmpjRTBnZjlUWnhBL1c0VjFVekRCQzY4ZDdtcTJBNHFSd1ZiZ3VpMUIx?=
 =?utf-8?B?NTA1NWdBeUpQY3F4TEQ2aHdhRVJJck14TjR5NHcwUWFvVk9UY3ZSQlRSVE5U?=
 =?utf-8?B?Ky80TUF0cmJMWng2bTY3dXk1TlFJUTNRcHJMdk52bHZJODRyVlpJZEIvWHFF?=
 =?utf-8?B?dCtwbWFweDR6Wi9DMHRwckNYNnJzelNrSmhDOU5ETjVPOUx3dkZNSVd6QXps?=
 =?utf-8?B?Rzhzakc0OW5YYU5vZEl6V2NjcHZiNkxrYkRJTnl5Q0pTTS85ZGFBTk90MnZX?=
 =?utf-8?B?UU9mTnpXWUNZckRId0NKdkNyMUU5MnArNmhNN0xrWGZNWkFtWTZXL0ozTGpJ?=
 =?utf-8?B?R0hMQzlOOEFzbDBKN3pSOUJSbDhlNEtidHU1M1JKZHpRdTgvVFJRWjVlcDQ1?=
 =?utf-8?B?c2Jqc3ZHb2UyWnVrVWxmM3lCMmZIdDNPY1ZqNmZNLy9Pekk0emlGQWpNQkR6?=
 =?utf-8?B?bmQ5WHZFK0Fwd3hscncwamdDMXlmNnQydHhkQWNKRm82eW1xRnovQUROTVN1?=
 =?utf-8?B?eVdPK3dnWXpoSlhMSE1pRjlFWkZVRVQzN1M0blUvU1o3c0hiZDFoZzZFbit0?=
 =?utf-8?B?TTJtSUY4Y3F4aUtHQ3NtVDZVT2hSQUdXdy9STUpHZE5nYWZwMjJqRWFHRFJK?=
 =?utf-8?B?eGZCdnE2SERrVE1NNmRvdkVENWJmY3pCN2x3VVJhMitMYnlLNUhxdHd3bkp0?=
 =?utf-8?B?WUNWR3VtK2VxakhFOHRBK2xjWS9PdkFDVzMxS2ljanQzQk4wNDZ3c2xGc0xE?=
 =?utf-8?B?allETVdQWU9rbHk3NVl1K2NRVk1PeEJ4WmYyQ0RORWl5YVFac1A2a0Z0bWpy?=
 =?utf-8?B?WHBwNHhWZEZ0dHZ1SjJXWmI1RThIWGZBTUdjU0s5bTlNbGVZbXNnL3lSbWVu?=
 =?utf-8?B?YlB5L09keDQrVXF2Y0FuZXdmejZIOFdobk9iVTFJekw2YmdkUTBuUVdDUFI2?=
 =?utf-8?B?QjkwS3VMa1hzNVcwbzR5Z2Q5WGFTTWpMS3Jaem00Q2FiRElWS1hZNm4vNE5u?=
 =?utf-8?B?bTlzeFBIYmRmQmJ2YmZMSEg5Y2J3aHlqVTBxbUw0T1lMQVNGN2x3Y005SFhi?=
 =?utf-8?B?RjhVKzUwUFc0SUdMa0wyVTdjUCt2RmFyZWw1VXlLbTJZRXZXcXlFaDk1ZFpH?=
 =?utf-8?B?T3pkdGY1UFUwbG4wSlEwZlZ1Zlp3QVN4U2VheFZyUHhyVmpsOE9aZ2IvM05Y?=
 =?utf-8?B?Nml2ME41eEdoeitqQmxWUGxVSnVQek0vcUpVY0swa2YvZGU0QUtoeTJZSldL?=
 =?utf-8?B?eWxYVzVMUUVQczlrY0d6K3NuTmpUMExTOHBYSEtGTU83d1A3U0xIZ1hYZldp?=
 =?utf-8?B?VndickdCZ3p0b04wSk5kTHQrLzNPUVMrRmtBQ0FFdEV4YWd5TE5HOFc1SUZJ?=
 =?utf-8?B?eDhJS3VUejYrVGtCbXZvTlFkU3lMRmJEQ0U4T0F2WTYzVkpjRjl2bi8vQ20z?=
 =?utf-8?B?RjVwejVIYk45UG1zejRnWXJnblFQNlF4WGpsVkFRWTIveGNnRENXU1FDS2E2?=
 =?utf-8?B?K0t0SjJFZHZXVHpVSDQ5ZHJEdy94bkJnVnZzSlNWcW1xSlJkRDFPR0JiNlNs?=
 =?utf-8?B?aVdoTWZOZHpBQS9EMnYzM1Z4ZEoydUxySGRIcW1uWkEvQTRXdUVjeHhZTHJz?=
 =?utf-8?Q?ZYQr9kHO+AF7Exd75l8UPi4unPKVEUp6PN6X8nynAM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8dffe1f-896d-4998-8b1f-08d9bc3fc4d6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2021 00:47:12.2435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yl9OsHMNy00jvK5+I3EsJWRnA0tmv9LLN1bEseKohsbsmZb7nCGwZZOnvhpj+Az33HuaXGgfEq5ONbiH6jcxxF3e4HLon6V7BoVKKz30xtQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2785
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10194 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112110002
X-Proofpoint-GUID: TWGs4aqLsOq0i3R41SlAq0tg-krBIW4K
X-Proofpoint-ORIG-GUID: TWGs4aqLsOq0i3R41SlAq0tg-krBIW4K
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/10/21 4:28 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> While working with Xen's libxenvchan library I have faced an issue with
> unmap notifications sent in wrong order if both UNMAP_NOTIFY_SEND_EVENT
> and UNMAP_NOTIFY_CLEAR_BYTE were requested: first we send an event channel
> notification and then clear the notification byte which renders in the below
> inconsistency (cli_live is the byte which was requested to be cleared on unmap):
>
> [  444.514243] gntdev_put_map UNMAP_NOTIFY_SEND_EVENT map->notify.event 6
> libxenvchan_is_open cli_live 1
> [  444.515239] __unmap_grant_pages UNMAP_NOTIFY_CLEAR_BYTE at 14
>
> Thus it is not possible to reliably implement the checks like
> - wait for the notification (UNMAP_NOTIFY_SEND_EVENT)
> - check the variable (UNMAP_NOTIFY_CLEAR_BYTE)
> because it is possible that the variable gets checked before it is cleared
> by the kernel.
>
> To fix that we need to re-order the notifications, so the variable is first
> gets cleared and then the event channel notification is sent.
> With this fix I can see the correct order of execution:
>
> [   54.522611] __unmap_grant_pages UNMAP_NOTIFY_CLEAR_BYTE at 14
> [   54.537966] gntdev_put_map UNMAP_NOTIFY_SEND_EVENT map->notify.event 6
> libxenvchan_is_open cli_live 0
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>



Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

