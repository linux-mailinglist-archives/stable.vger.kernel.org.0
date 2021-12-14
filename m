Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E044748E2
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 18:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhLNRIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 12:08:20 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38844 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231544AbhLNRIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 12:08:19 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEGXxDV002508;
        Tue, 14 Dec 2021 17:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KLIHJQADY73E8imzFzsI3TsbVmjiqc9rtyBek/Cbyss=;
 b=j4ZcnAyh/WY8u3BJ1ZUW6XYwEVBYY3jJwWPd+2FGUxFbbpx89azZDrfkysrGkC+tYyrW
 W1NxrB171JtzmXYaPRx29ZBRSDNZ6f63Ic8DTQ4qdL6/X7jySYWRe/ONBdgvh7nHY76O
 UeAkhM20gmQC4rFnh8mItqnafDsSyNewZ7aAwqRsgTxS7ra8WP6Mq7Pz/GbqxoFByXnm
 5wdFLUeXHF8pL/uEsHeJ7IDklscDCUcuIgj8BN1a+l527rS1duGS4aMk+1BAxC9lqtgD
 IAGj0bcOrQH+kcy7/DyuLbyQ3T8GK89RMBbPLa2jd5ebu1BiWngV+nMIrIrFJeVexDm9 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u448c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 17:07:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BEH5rGY144178;
        Tue, 14 Dec 2021 17:07:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3030.oracle.com with ESMTP id 3cvj1e6562-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 17:07:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EztiQvzK6onx2h5I8JA5TvFLd+z8BshetH//L7nxx/VZH0ovGOdo2cgOON5WmFortdhp7LZTZ7gpPl3+Th6UkRY9Op4rfDjtBapRJFvQ234TI1VoXbsi9oW9S9///P1KnFkJRIB4djuFJIjBl5VvG/bFaPUbsg7+ob2+YQpIvELot3kyUDF0UT0R4Vd+brtU6cWB00ETQltL0WIrG5/3fEgUelALR40ZhhT0jEqi6yOXhExQMskzzUYiLawlRP+HIrI80Xc2lgn/b0RGPSmeT65kdVAhe7UpwDSEHZncPTIpvqMaoTkASTChoEUE7OjYM6r/fR/9FEMpvnBeM7/Sqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLIHJQADY73E8imzFzsI3TsbVmjiqc9rtyBek/Cbyss=;
 b=oDF2nLgbaMnqOuyK2enqFTFZjpffKIf5sAtsm+szO/e1EerAKCtELSODxsY3G67OfnoiWI6JhqzNlmKRknMg+d8QLy4BM7d3Ex8qTr24an4lW636eZeftQwAJ8JGukI2WplPVPxLKM01WbLtdZcFodj8j4bbLzABZ7xg79iBKlk49juGYOGfOCJL9hIw/TlooiNvCdcy9M45A1z6YBF8eMNyme80grqamhufcLh2sXuhQwM9TcxrXlZS4Wqmrff6UTRo8O3gjZEwdO72XTo76gHCcYFvBbD+U8RuHhDPviYNNXTO+rhxgxt7R/tL/uMtg0qaUy6yrRTCnXiUWgb0ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLIHJQADY73E8imzFzsI3TsbVmjiqc9rtyBek/Cbyss=;
 b=eEkmC9aMzOZ2X22Xt2YVpu54P+7Cbw7X7IuQMLws/GVOOEQshjzPMFSBMnty0TSOmCH+10eEDZvSPZkXUXGwEJu2CZGZoVScFBG4pqW9dXtKnzbJx1gbXkncvwLq+r0uwNrgu49e7dt0h7/senNhZm1xeAyT/T0hokVR5bHVxLc=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR10MB1711.namprd10.prod.outlook.com (2603:10b6:301:a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Tue, 14 Dec
 2021 17:07:47 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::54ed:be86:184c:7d00]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::54ed:be86:184c:7d00%8]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 17:07:47 +0000
Message-ID: <dc648afe-6dbe-55c9-ebf6-9334d71706b4@oracle.com>
Date:   Tue, 14 Dec 2021 11:07:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Baoquan He <bhe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com> <20211214163124.GA21762@lst.de>
From:   john.p.donnelly@oracle.com
In-Reply-To: <20211214163124.GA21762@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0060.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::40) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41937d92-5a9d-449a-cf61-08d9bf24403a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1711:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1711A8DBC8BC573E5BC4B45EC7759@MWHPR10MB1711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nyML0UK2qys1CW3XYQSprhCTvlF646ins7OaDyzzGkjTF1XgJcBtvkQuWnUfE3FG6Y8mKvCmlp1n9Ypxe9a1ivR2alWiP2sGlxHMMd9Ggla0QMxBpzaNQCP45nfsslFANmlt7OS9nNFTnxe4KhUfnXBrl47W7uA2j2/nsp9gXsmXTvoUDueCKbLf4g2Aw+LVBtnEgux/lIyYpbOoboZ0fDZEKBRn3GcDoNSKh4f8rBfw97rVc/dgqHcpkAMq3jWyKKVNtOgdJpiykZpnjSxoR2IWrJ8FRyd833BIOc1ovUgDb/gE2YqFQ3ACixTo8VH+vz0/XT45ca+jOzOTqye3+dmSDtZ0Pl5Q6SmvhRUqov8zQRziAs5ZsB0mmNI7tZ5HXZcv2eRt3eBviNjx27FTJl5HSzDxCeBjl5w9O/Z93Sxf/Qgvs+P0BXHVgOyjibLNEdy5v5vzInzyvK7p+XHIP1m914903pFQwlT1ONrFyr8qaNMSIU/g8LXUhJOG/sG0IIxOeBwSBFsSBSGoCXNeQFV/wQmvkmJBoRyM0AT2ek39OhuCfdzcoYcIiKWmmy7UlOAcDbALkqrqSwcTqsJylxZXPJrvCk47vmn4dMx9P8X/5SmPX28ODdhSRAxzJ6yVNC2YKoyZzwhQgCA0Yq7E82htLuo3lFpa2ZnR9wmZcDUOZYahpbNOoc578GVbFr7ft6Gov5UReTOh6RLASfcSQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(53546011)(66476007)(83380400001)(6512007)(66556008)(36756003)(31696002)(6666004)(508600001)(4744005)(186003)(4326008)(66946007)(26005)(316002)(8676002)(2906002)(2616005)(8936002)(6486002)(5660300002)(54906003)(6506007)(31686004)(7416002)(38100700002)(86362001)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWY0U1BSNmVjaVlnQ1lEVkFDRVNLMnRXMkRyUW5qYjhCQi9TREUxcHhsN0o3?=
 =?utf-8?B?V05UZyt1VzFBeGk1YlZzUUFhYUpWZ1ZTcm1CN2MzYUJKM0dac2p1UTdjTDJq?=
 =?utf-8?B?TWxjTWppVjh0TkhvYWxLa3RMVGliNVlaRjEwT3hkSWp5SnNtdDB5YVFCVFRG?=
 =?utf-8?B?czR1T0ZzMXJoR3BsQkVhVzJaZ29hRnl1YlhnNWJuK3RUcThXcnA1ZUU4U242?=
 =?utf-8?B?bGQ4ZE1DRnB3Z3Z6TEV0MlVhZkZEZUFBRGJHODhmQXJMNU04WUlGMysyaVRS?=
 =?utf-8?B?TjJZNmN6czBINWdHaWNabU1yVE5pdlBTSWloNXVzYTZFc2xJbFNOUEo5cTJN?=
 =?utf-8?B?TW5UUy9tSWR3VzlFYmpYYUlkc0NwbkNOSGdWWHgvQTZBZGZacng3c240NGIz?=
 =?utf-8?B?WXpuNUtlZTV6TnNQbHN0eHdpdVp1KzBNK0VKa1J5VHQ0NllLVVBRYkUvUkpG?=
 =?utf-8?B?STRFZklXMHlWNU1qNWFFS1dJREpLUFYwcmtaWUJac3FDSENFc1MzOGlWWUNI?=
 =?utf-8?B?Y3RVT1RQc2M0Q005VW1PVXFCUHl6WUhXRDdMR0FtUjMwNEF3OEZ2TnFVUzVO?=
 =?utf-8?B?MTVYbDc2ZkhLNmQ1d2gyZnpNdDEzMXVVcHhJeldEcUNORUhhYXA4aEI5VFVQ?=
 =?utf-8?B?VlRSTDhVeGI3d3lrQm9uSVBnMGhmQ21ZaXBMdnRNVmpYdGxvMXFWbTA3Zk03?=
 =?utf-8?B?SmJITEE1UTI4OTg4b0ZDZnBlNStZWDRCTzBlQUllclhLOFB0Z3h5a2Uyb0l4?=
 =?utf-8?B?T3hDWC9BNStoQzZacWp4ZHRlcDRXcGRvb3M0SnNvMFZRTEpkQmdBMHZXUlJ3?=
 =?utf-8?B?UHE1SURrVExKV0F6RFdhVUdJWWNnUXVMV0xCbmxwOXRTaWQxb3ZMUC83SHhJ?=
 =?utf-8?B?d3U4SUp3YWVvTVJHZ0N5UFI0VHh0cnpNbDZLd3JBb2dLSE92V2F5Mk1qL0Jm?=
 =?utf-8?B?TTRhUUZNNUFYa3hnVWFlaFlhelVxb1VqeWhHQm8vWEtkN0dDWVQ2Z3Q3aEpl?=
 =?utf-8?B?Z3c4dVd2UWViZkFmSGFkN2JSeDVZRGJ6cGxDTVE2Z2Z2ZEpTc2VHMXdLYmkv?=
 =?utf-8?B?dk0xaFBSNzRMc1ZZTCt6aGlnUENqQnZhUXgrYXl0QjZZRVBMQTEvMHVXU2dh?=
 =?utf-8?B?ekhINkNtVEhLQjBpZnV6K2p6eGFzZU5pb2FkOXdrWHhwUkRoMU5tY3dqZTQv?=
 =?utf-8?B?emRoOGxYbnRlTTY3ak0zZU5LVjRiYTFGMCtBRlp2N09RUGF0WjdTazhFdW5a?=
 =?utf-8?B?M0ZuOHlTSWVSbUM0WjM3N2NYRWlvNmZwYWlSNVpLUit1L3hyc2RjMHB3NU9J?=
 =?utf-8?B?TTlnV1drQ0JKbGxWNUpTbzg5SUNOSmR3eldTcWp3U0R6d1hXOEw2NE5JVzJE?=
 =?utf-8?B?SmtlSllsaWJVRWtiUzFwVzZpLzRlSUx4WlBDMEl2Q0RlU2hjOXhma2JZS01P?=
 =?utf-8?B?bXJYaUhwU21EN3kvSTB5Q3hsOUpqTlBPSWxSME5kcDg3YmdIK3NMY2F2a3dp?=
 =?utf-8?B?eUhSd2J1N3U3TTFzSGkrWjczdmVZSUdDalBPV2hyZFZIeFh5U0V5cmJadW05?=
 =?utf-8?B?cVRxUFoyK2JGWVo5d0FKTnpaam1aWm5ITVYvZ3A0K3QyYWVLNUVpWVZtVlhi?=
 =?utf-8?B?RjdGVVBBOEZHVW03NHNuOFpYWFNKVnA2d0dDQm1GZm8vOXNFTk9MNU1nV3hL?=
 =?utf-8?B?SjBnRWpkSGtOVEwyejdHQ01pOTZJUWRMVEhCK0pSZlhKQjJ2cC82MmZQN3I1?=
 =?utf-8?B?K0xSZmNUckM2MG9RRmxyZGlKSzFHQ3NhSWVpNDlxM1loalZMRUVzZURzdk1w?=
 =?utf-8?B?MnQ3dVBZdHFKRlBiMk5hUDRITFpHdDVoRDVQZFBXVW9XazhhcXpBeGRtWUNH?=
 =?utf-8?B?dy9Jc2cyemxtTUNJS0VNcXVMNUN0WkhjRHhIbys5RW93UEVBRTR5S0lENlpT?=
 =?utf-8?B?dGo0Yzh5Vi8yMEJFRG9lNTd5VzRKU2xhYmo4aEFQdmJsUHRCd2xYcWFjV0Yx?=
 =?utf-8?B?SWxVZlVTN0p4cmtFeS9McXBxNEowMnRPVk5MNnN0TkVCay9HS2pmOCtOaGhI?=
 =?utf-8?B?d2pManR6R2svcSsxVVUwTVJwaERnN2p6N2JtUWJzU1NoVnhObGpvUnZ2MUxj?=
 =?utf-8?B?RzlqRzBoVDdNTXNzc0tOSUlSLzgxMkVKSjN3eGtmRXoyZFFzQzNSSWpkQ2Fl?=
 =?utf-8?B?M05NRlJIajVRSVpValc2aFlMb015S3c1U3lOTTg3enFULzhrNTdXREhJTXdR?=
 =?utf-8?Q?TyxJW7UsO7lhM4t/ToiMQovQ5S89SsCqVKhZIgFCdg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41937d92-5a9d-449a-cf61-08d9bf24403a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 17:07:46.9772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66pDpSvujf6xLzeNXAMB13ou6ZndA3OhkmoHYgBfPF3j/FDep+49w/pzaNA460ggURIakeqtfkpr+quhjAhexKbFV+uFXlLeA5dNsUWwspM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1711
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10198 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=908
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140094
X-Proofpoint-ORIG-GUID: rb0O88XurICMDszhKMMAIttZpas9hGe1
X-Proofpoint-GUID: rb0O88XurICMDszhKMMAIttZpas9hGe1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/14/21 10:31 AM, Christoph Hellwig wrote:
> On Mon, Dec 13, 2021 at 08:27:12PM +0800, Baoquan He wrote:
>> Dma-kmalloc will be created as long as CONFIG_ZONE_DMA is enabled.
>> However, it will fail if DMA zone has no managed pages. The failure
>> can be seen in kdump kernel of x86_64 as below:
> 
> Please just switch the sr allocation to use GFP_KERNEL without GFP_DMA.
> The block layer will do the proper bounce buffering underneath for the
> very unlikely case that we're actually using the single HBA driver that
> has ISA DMA addressing limitations.
> 
> Same for the ch drive, btw.

Hi,

Is CONFIG_ZONE_DMA even needed anymore in x86_64  ?

