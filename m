Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2461444050A
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 23:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhJ2VtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 17:49:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20352 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230388AbhJ2VtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 17:49:08 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TJjaXG028580;
        Fri, 29 Oct 2021 21:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xjh3VCLoupmxIzgdO5BP3ClEi4fylUi0ij0RRkludyQ=;
 b=Gp17FPRXp9tPnuppIVk/2SUjCHFJ90mxmzGudoYSfevJ3Dpk1D8Kk6zkjX2Qy+F/T0e7
 pM+5S6pTl4AtOVKkpKOFFHBpWaiWFelpMQxImkga/+kzvB3dVXLNBmEfDBYvVYvP9r3a
 pB6dA/rl4qew2RpLlJkooHsBremeML+B8LonCxAJb0pNd3aJnJASn4DKC9GxBRDldKyF
 C6bw+Nmykh9dpEJxFB2YulOtoF5C4vUXYNjw8QY2yQhitVWsRgEU1SSKQuRSTfGg+8kI
 8aD4b754EMNrZF4LWf8hvwX30CG3A4meTlXmxEVycoESeagS6XfUhOZW6TJuGcuOdXyL og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byhqrhr12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 21:46:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19TLeAsS030561;
        Fri, 29 Oct 2021 21:46:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 3bx4h6fff8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 21:46:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbl6W8qXkjHACMMgc+vQoBdnDOQoOAEQb3ODicDzs2QRn2Q7H8JWBzLRauMLL+rHLcyZT+5K6+lHeR9jdX7Vq3r/ftDJzox4SxtSMrFhljbvNOx7xztFzIANaUtC4ptCo0OnHXQ8VpNk9b8uMzZ5JawfB/46/H2tgjnjTI+LbzEDEkzytXGxlobqy4Ueg2XK7XJ65KQTINDXgaQF87CcEqt90AiwMfAKThtNbpSFcBGHO6xmn+UcRodqOE+DYjqyK1ZPpps1crL7/bm9zDBvbXr7vdqou3ELctPfLTwfu28d+C1tfNgxRwQinwPxsL+Epew3Yie7cXk5OBL1fNRuiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjh3VCLoupmxIzgdO5BP3ClEi4fylUi0ij0RRkludyQ=;
 b=AI3a45GK2ikizd/bdYzKsCDj+i8S6AO/KU/morV6KQ5efzZP3/vV5sK7zlT/TKnmtptHrADJpGV6d7p0MzIszfafJa0SL7YIjpA24rygGk/CLMUfJPw0UkFqeZ8g0C+azqk11OfUZofNcPFO/kq9PZ2TQGaIyaZ0jr172wwut8uhWXT3vTCNvY2kY3nwu8WB+fFLZVz8S0FXq9s8ZNVaVfqHPukyQcZALzT3iqCgY5vz9OWA+RSMlQO9gt/XZ3SfSuzpKd5a+gMRysu5spzwwMlpgiZibgZypDCnp0hFgek7IucCQWIIzWTcbYfx7GpgVnS0IpEuHqf5G8C4/+sqVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjh3VCLoupmxIzgdO5BP3ClEi4fylUi0ij0RRkludyQ=;
 b=qGmbuGooXZYYV4vZ/+Mhhz78eqxHDya/tWsIQqr4+HkOMtQOhuXrel25QZFf6io/lCTyuRb57x0Xrgf/OKIgKEjiCAK9R28IQUXijZ5qalYBIcwss+zSrHl2RT1Q5bjfX98nk7mvdt65NzQP6q2XO5eCPCZJoY15tCwA3eRs8vA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4029.namprd10.prod.outlook.com (2603:10b6:208:186::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 21:46:25 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%6]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 21:46:25 +0000
Message-ID: <11956c14-f1f7-70f0-40a6-aad31a264af6@oracle.com>
Date:   Fri, 29 Oct 2021 17:46:18 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v3] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20211029142049.25198-1-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211029142049.25198-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0016.namprd21.prod.outlook.com
 (2603:10b6:805:106::26) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.111.7] (138.3.200.7) by SN6PR2101CA0016.namprd21.prod.outlook.com (2603:10b6:805:106::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.2 via Frontend Transport; Fri, 29 Oct 2021 21:46:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe358997-26eb-43c5-55ed-08d99b258df1
X-MS-TrafficTypeDiagnostic: MN2PR10MB4029:
X-Microsoft-Antispam-PRVS: <MN2PR10MB4029205E5102D3C5B4BCC0218A879@MN2PR10MB4029.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nJA+QETYhBnlRxj5tSRSqTkjAdo0LMIMhmfch55DYbEXpuvGu9/y1UOLZz9MutEtm/Gs8qWXCc59kJJ5RQ2D0kCnHvT3K19WkOFXHZUPhBCnttvi7GaLSX9IeosMy8jTYYoK6U3aHM6r1G4lPWC4YmDHOatOcfEnMXqvPnOJHSMw1DnSt7vLwnEPoJfDCareNHHKYIpsm0Iw5GY/vBIw3dd5VEz9PcJO1BmiRvBhBUx9OD+Lr267noXeFaJJX/nOV3RxXa4RHtpyfMBO2rB4uh70wOB6QVTlyl7hy8Kav68f1YGc4+lcNXGDvrU3YJTY7WlmQ7k4rAXTA73OuGncWjIhNsJzcHzNQ8LMFpuqN3TmXRPH6QEnbPfT+UjETb+aaSrQM4assQIng8JdYXFpKDr4YFeW2p3Tj+wRpkVFrP/XG/ItKVHbTy2dgHxfdyhWbfjvd3q0+nem1HODLTkxvIgKa52BO8XCVvyf2TQTAa/X/q3SJvskFTuhMuoMm8vN+dxy1JVvxjbdpdOxLVaP/UfW3Qu5yZgmiZ1aNBd+Dik1OyNq88y6qVH1zZZomMewy8xhvlpOFtDyNTciX5uGYINBFg3MTQusa69/+lfCS2CbYbJ3+TmjUt4HGbt600VsHewLxdedwQx1G2R6Xr0Bx80wz68RipZbUvXxxCI4DdZRqvD79vuLmaKO6EOivaE5wAn5yKgO3ZyvGCMSGR2nSyA8FkAnlWpbF1MpEVMM4uWG/hqBTcqYl4/x0hi/oe9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(53546011)(36756003)(26005)(186003)(31686004)(2906002)(4326008)(508600001)(8936002)(2616005)(44832011)(83380400001)(66946007)(66476007)(66556008)(86362001)(956004)(5660300002)(16576012)(38100700002)(54906003)(31696002)(8676002)(6666004)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHFCdE1CZDdYRlI4eWhxUWNGZytNWTNMbXgxa0p6Q01vM0VOVDBFOFNmK0x5?=
 =?utf-8?B?eE84TU0xN3B4cklxRVR6YjZpRy9ndGl1M0laWW9WbnRsdVM2SzAvK2pKb3li?=
 =?utf-8?B?S2RqUTE4WmFuajhxQjcwZHZxYVZIcVJUUW1IdFZycmdlWTBlUDZxcWdNWG9n?=
 =?utf-8?B?d0Zhb1pWWkV2SUd6aVFCMHpCMExEcnBBeVFvSitCZDkra2RQeHNCcDk5T08r?=
 =?utf-8?B?dWlheVRiNm02bHE5U25RM2thKzBHTktrVmlmd0w0ZWFMaGNVYXREMGQ2dTlJ?=
 =?utf-8?B?OU5aUVpCUER2cDhsQlhpbmpnTFpHelZTV3FVZDhUMVJFUkYybUJSdWxqWS82?=
 =?utf-8?B?NnBXZERORnRtZnlOMEdCS2hhQTNLVXJReXZmQ25sVmxtRU9DZS9lMjhYRkdO?=
 =?utf-8?B?NlI1UXRJNEs2R0J6L2JVTzdZQmdsRzQ5V0FJOU9pdnBCM2Y5ckZ6RFpJNGgy?=
 =?utf-8?B?NnZYZzRKa21hQlNTZ0dncTdPbS9pRGM5S2IyWUFzRXdld0UvMnIzTHEzRnFB?=
 =?utf-8?B?L2xzdFZudWE4VVZjUC9tZVRLanorL2djd2J6dW96NExBZCs2RS9Pc2NUSjFu?=
 =?utf-8?B?Yk9jbGNBclg3M0lieUhuOE5ZWEJVRzZGak5ZMEE0TExMNGNmRnJiWG9JalR4?=
 =?utf-8?B?eDVuUXVISjFIb1oxNk5Ed1kyVHF2YktseUtIYjFkM245d3owSCtxQVlqcXBn?=
 =?utf-8?B?bEdQOERML3NmVDFpY0t6RGhyZHphUGJJY1pqOGdYWXBYYlJkcWFQZHJIaW1Y?=
 =?utf-8?B?Mm1DQU9MWTZDUEovVEFnZVB1Um8yZ0xrQkZxQjk0MUZiSGdtOFg3YXNPVmhR?=
 =?utf-8?B?aVR0UUc1dkxZMTFtRU0xS1lPQWNnTUFuT0ZyUEVGL29ndGZvZjdESEMxdWZk?=
 =?utf-8?B?NTEzT1JiTlpjMUdJWDNUdTMxYVp0NERadWt4eFZlQTJPNDN1Yk1TdWFyTXRJ?=
 =?utf-8?B?c3BiejdLRFV6NHpQQ21tODV2UEMrMUl3dHROdEZaNm5LMGNpa2JnU1R4MXRJ?=
 =?utf-8?B?MitGSWN5bGYyT2dnRHo0aXFybnhqa3pmTGN3eGQrSHRHaTE5cnkyaGlCRFpx?=
 =?utf-8?B?S0FGL2R3RGpuSXBHKzV0MWRzTldJQXBCVkxyaUErbFdsU2o4T2NncUlwNEla?=
 =?utf-8?B?VEZaeXBRSWhsL3llN2hNb0xOY1Z4ZHo1c2pield4ckZ4VUhONzJPVUp6UWt1?=
 =?utf-8?B?MUVML3lqUkpKL3BEeCtlNWxDem0yZWEwdE5zUERVTjdGdktZUEZ1Z2tLTEJh?=
 =?utf-8?B?QzRwa09YUnhuZmJFTHlHd1llay9xL1BicTJQWUEyZzlsaW9XenUvS2dlUDVl?=
 =?utf-8?B?NEZvWjZIYTNDUjZEUjM3L25FeGpPTWpWaFNybEdCUFh2eDExTllaZlJYZjlM?=
 =?utf-8?B?VTBJZ21KYnZyVGZISHpmRW4ydjVEQnNzZkZXaVZYS09uSG12QlpmT1lEcTNo?=
 =?utf-8?B?VERaSjFVTXI1aUJCZXhhMWJZVlJkSjJYZjVHWEdZbXEwczdTekh5MmtuZ1Q5?=
 =?utf-8?B?NW42eUtMWmRRQVVnSjh3MnF4cVB0NVI0TlhhckYzeGVjY3krRUNyZ0VwRUNo?=
 =?utf-8?B?aldXOE9LVy9EWXplQWthZEN2dStEN0krSUUvQS9nR1M4TmVKaFV3bkc0NlF4?=
 =?utf-8?B?Z29sekZkZnZhTzNvSER5cE5MWHp5Lys3YjRRbU5CeWRNZ2FyajN6cjVodUww?=
 =?utf-8?B?V05kMk9rL2pNeGFDelhhT3AvZkFBNjZKRlRYVUgrOFdiM05VdEpMZnprMWRB?=
 =?utf-8?B?RW9RSHIvQmN5RlFjUUhNU2FqRXdmZHNPV04xZTUrSlQrZUYxYTR3REJ2SHFa?=
 =?utf-8?B?SnlNYzBmWHVVVko4T24xVHN2V1E2eWlKRENXdUxYMlRCa0x1bjFDMG9rVEZk?=
 =?utf-8?B?VzhOOXdiMThNeEdYdzJCNzI4OS8vZ0VOUGRrdVorSmV3aE5WWHdtQTBDNVZ1?=
 =?utf-8?B?bE9qM29XNlVvT2xEOU0rT1YySmNFVWZWZ2dNNEpHVjJ4NWtvalUvYzR3RWph?=
 =?utf-8?B?ZUFqcE1hazNRMXBKQVhwZGM4eTMxSXRzM0FsOGVZK05HOTlMRnJUdnRBaDYv?=
 =?utf-8?B?WjBTNFdyTW0rT0FIY0NDWTN0QmpDODVmMUp5SFhKQ216WUh0Z3hRWlA1dGQ1?=
 =?utf-8?B?c2tnWlFlZGZqcVM4T3BMaGcrTEJXT3lPSiszaGdhQlM5VXI4ZWlacGRoVHpT?=
 =?utf-8?B?NVBscDhuM1RBVU9FOUNvbkdUSTFvQWJRR0dhOURzTXZRckJXWXRCYm9mMm5s?=
 =?utf-8?B?SDB4bHFCOXJQODZrVFFwY2NkRktnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe358997-26eb-43c5-55ed-08d99b258df1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 21:46:24.8389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VT2TRdoxL967hFSaEZq4CDhXZgCUmSQJBUD59+lMzOvDaJdBdEbVobwct9yPUdc8wEdBpVm7VLvBfvmopjyePVRhFLb655fcrcoxz9kt0kQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4029
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10152 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110290120
X-Proofpoint-GUID: ih75n44LEzAuxc5fujNyjz6BAbENJBSn
X-Proofpoint-ORIG-GUID: ih75n44LEzAuxc5fujNyjz6BAbENJBSn
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/29/21 10:20 AM, Juergen Gross wrote:
> --- a/Documentation/ABI/stable/sysfs-devices-system-xen_memory
> +++ b/Documentation/ABI/stable/sysfs-devices-system-xen_memory
> @@ -84,3 +84,13 @@ Description:
>   		Control scrubbing pages before returning them to Xen for others domains
>   		use. Can be set with xen_scrub_pages cmdline
>   		parameter. Default value controlled with CONFIG_XEN_SCRUB_PAGES_DEFAULT.
> +
> +What:		/sys/devices/system/xen_memory/xen_memory0/boot_timeout
> +Date:		November 2021
> +KernelVersion:	5.16
> +Contact:	xen-devel@lists.xenproject.org
> +Description:
> +		The time (in seconds) to wait before giving up to boot in case
> +		initial ballooning fails to free enough memory. Applies only
> +		when running as HVM or PVH guest and started with less memory
> +		configured than allowed at max.


How is this going to be used? We only need this during boot.


>   
> -		state = update_schedule(state);
> +		balloon_state = update_schedule(balloon_state);


Now that balloon_state has whole file scope it can probably be updated inside update_schedule().


> +	while ((credit = current_credit()) < 0) {
> +		if (credit != last_credit) {
> +			last_changed = jiffies;
> +			last_credit = credit;
> +		}
> +		if (balloon_state == BP_ECANCELED) {


What about other states? We are really waiting for BP_DONE, aren't we?


-boris


> +			pr_warn_once("Initial ballooning failed, %ld pages need to be freed.\n",
> +				     -credit);
> +			if (jiffies - last_changed >=
> +			    HZ * balloon_stats.boot_timeout)
> +				panic("Initial ballooning failed!\n");
> +		}
> +
