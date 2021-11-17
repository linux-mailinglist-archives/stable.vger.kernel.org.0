Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705BE454A81
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 17:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbhKQQJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 11:09:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25686 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233995AbhKQQJS (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 17 Nov 2021 11:09:18 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AHFlRd6022028;
        Wed, 17 Nov 2021 16:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=z5+aHhp9bWM8ZoMn9iz6HfR3omgHA682Wq8x96d95nw=;
 b=Tz5dLSA4X9R1uTZAhLkO6L//TumpYtW3SqcJGPhT21NCIErCUTDInScUTzWQ4x1FBAWB
 yjIWSGAdPXn9dlMn0FJhDe3ew9EKykP7jQo0zk9ot4znKBqTHP0ZR2xCSlkzEYDS/Ujk
 K7087+46I9xvaH6fuWn5Gmak+MPE/qhErbWE/tb1cts93/w/FgQ4oPHM0bW58yDL9NAP
 zdTX/LdmHm/NywV1E40ICT9Wke8UMvhZNyM/Jw/moPwgSsjfEnXXFy0sgtfodQbh1FCx
 Js26lwWyaGzSyu79yWiTy9/1fdyFmCmF9175WrdD++S4C3mDCJqPWkVlDsmxjkgFjqjk pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2059j6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 16:06:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AHG0ajE093455;
        Wed, 17 Nov 2021 16:06:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3030.oracle.com with ESMTP id 3ccccqawbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 16:06:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obCVJi39PvVwHkcIZqAp79hhmzPyBz1sZVrEdnPDYhuS3NEaLmf0R7NM+rYonBe5ebEpq5jx4grnQQbqXg39yw3gbnfOfS2DWMwDoxJt6NjKkMVQ+RO2Cq9ajfNUtJxVdEUAMRXnVmeECmEmwMm9/bNpdUqFeBjTGbjYhdlb/RVboRmP5HPwKAYUZ9JUYF/Hx1BbbB6OrzopTckqMO2+Sgc7F6Sg1cyTXG42B+ppRabnBB/7qX50kTazx6FUOC6eTkGEY6hgQXtZ1M9QhxazQn5VQwDINVZE0qEi0yfTtOQN661l/0P/QdkuLR6IaI1fcf20bO7+MElsv76w0a875A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5+aHhp9bWM8ZoMn9iz6HfR3omgHA682Wq8x96d95nw=;
 b=N46k9gvewViNcFt6+jcR7TXsE7+9yWlOPJ1AsHT/NI2b7saRx14SdQ6lncTXDnPBKIY3nH9/6Q74VY+gj+XfBGh6+WTNxJ2H3m/bKWmQhTz2BoTlXkUQTuKH4jMHaseI2x8sKU6Sdu9S/EKks+Oe4yCotySgTjs+qfE/6X7pmE2t0Jn/PoWzrVQ4H3QzbqC946qNpKRUkEdxWsMZG8cRCrEdpJJVyROO9D6fErqjLdwxego+WZL1kMgio/rmZ3B0pcZsQqmk9bXZjdMh3T1WdpDlR7xM5/d3vLgtHhl0bF0aEm5Fg/voohORVd0dOTS2rmCAq8mHV+MtZov5jjrreA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5+aHhp9bWM8ZoMn9iz6HfR3omgHA682Wq8x96d95nw=;
 b=H+rrU/xvNEuYuvf11v/+6ROo+nC8o4Olth+GmiEd0PV8qtlwmi0whzm9QQGkrn1olpY5aSIN/D5ATc395wN5bnA+/zJtx6OcjHwQICyyEXv5k8VEPCxR+xMStIwjns1rTHFm72FOgK6J//xC3izjN3lPdOEyaFUY/w0H3HhKev4=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BLAPR10MB5042.namprd10.prod.outlook.com (2603:10b6:208:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Wed, 17 Nov
 2021 16:06:03 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12%4]) with mapi id 15.20.4713.020; Wed, 17 Nov 2021
 16:06:03 +0000
Message-ID: <ed47fcdb-f841-65e6-be70-a12303ac153e@oracle.com>
Date:   Wed, 17 Nov 2021 11:05:57 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v2] xen: don't continue xenstore initialization in case of
 errors
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>, jgross@suse.com
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Stable@vger.kernel.org, jbeulich@suse.com
References: <20211115222719.2558207-1-sstabellini@kernel.org>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211115222719.2558207-1-sstabellini@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::15) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.104.192] (138.3.200.0) by BYAPR11CA0074.namprd11.prod.outlook.com (2603:10b6:a03:f4::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.18 via Frontend Transport; Wed, 17 Nov 2021 16:06:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c3d243b-e3a1-4f12-7233-08d9a9e42756
X-MS-TrafficTypeDiagnostic: BLAPR10MB5042:
X-Microsoft-Antispam-PRVS: <BLAPR10MB50421BD9917E24EFE7F0F3628A9A9@BLAPR10MB5042.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rtSLE6VhOaE3juocxXlqyoeeIAYHuts6OgB1+GsKiu2n89az2gINFxbwUHJTRmxcYRdyqojCUCGN0CwvHe+5Bz4fC1aaqd9QCC40xogD3fTgWDaGGaiSs4Tz4ykeqemdo00WZTNjUJdtT+HB67OM40q+0pjHfcFwQXQnmCCbSHNF9qkWJXZVDkSG0ceIBu7DuhRmH6XF+bPjSkW67pNT1NR6i9MvuFbDyiKtIMeVmDboIsXG3CkXBafJfw7gDjL29G0twP2t2UZUUf/wMz6XrVuq+aU/zdrwv7gMT0FBEbC7t0f9a+ZC34iL6R/BhasrYhT+9GbMCSO15/IUd32ZiC5PTlk5qMR0DIeAsut1nz2jIcQR+tvZ1B9i5kxkeh4kbBJS+b76ba4j2dBlCY5vE+gp7hnONmQILP2B5FkU+tIso+Fr5kYT1u0DqA7LxWCfCyfxUAC7pOauJbbyyjYubF3nrkw2flJ4KE4ludniuF+bBi4M6NVvCp8QLvZrrXnclqkV2jvSIxnYrunNqdqxrqCSAP+VvMRc+e5JFnDDhkrhK03lL1/Wqnt7AMSG//IGR2XHSrjgdBWq7qBloBCouFin0b2uxAE82VzMggBBgl5DVxjrwkkwSTsaN4l+2vwHvTnvnDdZWF9h8a8Gp4mdH1rmrS4JDompZ3Di3bOg7EP0hFUItExbIZM8IP9GGFRfj3nQVQSnveZzVNKd2ji28tN2uiHXoF+i2S5HuvszLha/eKF4vgdyZsfmshYOmeom
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(956004)(2616005)(6666004)(4744005)(5660300002)(66476007)(6486002)(66946007)(66556008)(44832011)(8936002)(26005)(186003)(53546011)(508600001)(4326008)(31696002)(36756003)(8676002)(2906002)(31686004)(16576012)(86362001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDhmVmRJcXNFR0pmeTJaZ2VrdDE4cXdrdUJpMlg2VHNwMENmZWVodHl1Tloy?=
 =?utf-8?B?Mmc5S3JLMFI3QTQvQUR6Qzg1VS9QUXloU2NKWXRPWnMwT0Znc3BucEFxU2Jm?=
 =?utf-8?B?aUp6bUtzUjJ6RmdpZC9HZ2NkR0J2d28xRzkzN3BWZzlTb09iMk80R3MwSHBr?=
 =?utf-8?B?amJzNTNSTjdyV3J1Wktzb0J4cWpZY2JUYlI0Mkw5di8weW04aHJ2KzdSV0E3?=
 =?utf-8?B?aERnaWJHdjZvNno3cUNldGxrUFZGK3FvVnBQSXhPN3Y2QnZFOHdZWFFZWVpO?=
 =?utf-8?B?TitlaGNaSDFvaGVjRE45U25KamI1ZzVFaVJqNzljL2I4UnVGdExNODRlRGth?=
 =?utf-8?B?TlFPSXRFakljU1hsQVlPcldqUFpPenc1UHk5UDhvYkY5VGFPZXE1TWxQUzd6?=
 =?utf-8?B?eGpHcUloK0xoUnBOSHpDQWZSeGdmR250TGJJaVo4bVE0eEJEM21MWGNGOTVO?=
 =?utf-8?B?QVQyS0ZEbTRtSFRoWXNjdVVpQjBPeklGT0FVNVpHZEpXMHlvVTdjbWhNeldy?=
 =?utf-8?B?ZEdIS3U2czlvVzlPSEFjWE1iZ2JsbjBKTmw5RC9LU01QK2hYWlZkSzRSVmFt?=
 =?utf-8?B?YmNQd3hXNnpvaUU3UWZBNDFNWVlpbTNxUWI0MXdMSFhteTFUd2VIRy9Qd2pt?=
 =?utf-8?B?VGh5Vit3NWE1Mkl1bUh1aXVXTDVyck1SME9DT0ZGYURuaVZES3YyTnlPZit3?=
 =?utf-8?B?VTQyWG5ER1ZWU0tFUDN2WnNDWFlycU5VOFo2Z0Rld1dTVktTWEZiaHBDYnhp?=
 =?utf-8?B?YytMVDdTNjdvNnNjckhPcnpXdHU4N0RzLzRUSmhFMFNQNEt6MytDVjlzLzJ0?=
 =?utf-8?B?ZXVpUzlOdm1CVmVhSThWaGVXejVIY2dmZFhlZ090bEJ4U2FMNE9UalJ6cjlN?=
 =?utf-8?B?NGkycStHMXgzaDlLcHpXNmEzUHJwRTcrYy9vaGJBM3JRa0UrTWtWU0d6ZzVU?=
 =?utf-8?B?VHRLQkE0T055endIYlZwYUJkNFBGSWNtMy9ub1RxdGJPTmJiWjJTUXV1Tm1D?=
 =?utf-8?B?b1FUVjlVUXR2NSt0SDErOGlnWjJpa3JaM25GWGxobDBxVmhudnJMQ1ZWM0Ew?=
 =?utf-8?B?SElCRURZN28xZXIwa0cwdEtaRHhoMzZRRnRiWlJmNytveEdpWmU2Qm52VWdH?=
 =?utf-8?B?VDhQWVZ6MmpRYzdFVFVZTVVHNWtKS2JPNUFJMy94VFI1REQ1VkxOR1dMakQv?=
 =?utf-8?B?Z0J6NVVzTU5PTWp4b0xQUUdUeXgyREVqemc5dFJCaUVqRFR2dFFqaDVaanlI?=
 =?utf-8?B?VUdFenppVmNmQnNqaEoyKzMyQ0NlbDFKSXIyWEExK2pPWVhQS3VwU2pvaWlY?=
 =?utf-8?B?d1lGTHlmdU5rNDYwT1BSTmMrMVN2eXhJR3dWRG9BQ0wwZnY0dXd3ZE13NWdQ?=
 =?utf-8?B?ZVZxTmZKbldLQVdRRGM3SEJGV2NRV3BSME1SaElnM1dQemczQlIrQ2R0anBk?=
 =?utf-8?B?cExvc1Nxd0Yvd0pZOXRkblc3Y2pqNGFwZi9sMVlxVEZOY1N5NnF6T2N5YXRo?=
 =?utf-8?B?MHpyVWp6L3VUMmtUcHl6RzZXMHZJdkd2MFVDV0xKMnVSYkRud3lFVWVBODBY?=
 =?utf-8?B?L2lHbDNLNUh6R25UWTYva2JmcTNYejF2Mm1FSmFnZjRnbFpwd1JpdUN3T1h3?=
 =?utf-8?B?MjJJNSsxTlhuTEljY1hlTnFGdGxZekJpUHVqb1U1ZU5SUTRtVUNWMnlOSFVN?=
 =?utf-8?B?QTJYNUI0RDZmUzNrR1RzQTBtbE9xaFZ4eHFsZ3FQT2tudElScm1yN2p0bnV3?=
 =?utf-8?B?WFJmK3B5L21ROHI1bCtLUXJjc2k1UnZnMmZMaEpKak1iZVloc3BjcnZ6Q2Nl?=
 =?utf-8?B?R1R3T1g3ZXdnZHdsdGJiR1J1dERDcm41S2c4VmRzUjZJTkRUOEFGZTNySmMw?=
 =?utf-8?B?UlpGeHU0SjZ0Ni9PVkI2NHVCKyswSHlJTXZFZUp5aElIQ2ZuNGhCU0gwcEcw?=
 =?utf-8?B?Vk9UOU8zMVVTMXRJR2UrZlJrK1ZyYURpWmJQNE5YaG9aOHZ1d0RmNDduK29k?=
 =?utf-8?B?dFRUTzV1QjhBdGlUc2tKTWk4R0RYWERmK0JTalQzbVlQYkp1UW8reFdtTjZ6?=
 =?utf-8?B?Zm1VWlRma3hiT2wxK1d0d1ZjNC9Cd3VmUkpqREsvRXpBYTBESU1wajNodWRL?=
 =?utf-8?B?eERqa01XUVJCN1ZPeEJSZVhaMTgwSGc0bS9UOTI2ZmRUUlJ3Z0tqTy8vVEli?=
 =?utf-8?B?YUVYdmhpVGpHZFcxeENUaXMrT0tBdWxNbXNQKzZxR3R4ZnVWMWlpM2dVZ3Ft?=
 =?utf-8?B?aHVJQ2h5NTR3enBBNHNaR2NCNzR3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3d243b-e3a1-4f12-7233-08d9a9e42756
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 16:06:02.9629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lDtLUKLAVzN2EaidJOcluK2BtDCpVWSmjrtVCvBdPqIFCNF/HMVas2+dIRic6wYW042A/N2Uy6xI9RIsxyKr+6F9uuJStP2GNc+zAHwhXUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5042
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10171 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170075
X-Proofpoint-ORIG-GUID: tSwjEGZwZIg_kvrro00YhUG1delN9QP-
X-Proofpoint-GUID: tSwjEGZwZIg_kvrro00YhUG1delN9QP-
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/15/21 5:27 PM, Stefano Stabellini wrote:
> From: Stefano Stabellini <stefano.stabellini@xilinx.com>
>
> In case of errors in xenbus_init (e.g. missing xen_store_gfn parameter),
> we goto out_error but we forget to reset xen_store_domain_type to
> XS_UNKNOWN. As a consequence xenbus_probe_initcall and other initcalls
> will still try to initialize xenstore resulting into a crash at boot.
>
> [    2.479830] Call trace:
> [    2.482314]  xb_init_comms+0x18/0x150
> [    2.486354]  xs_init+0x34/0x138
> [    2.489786]  xenbus_probe+0x4c/0x70
> [    2.498432]  xenbus_probe_initcall+0x2c/0x7c
> [    2.503944]  do_one_initcall+0x54/0x1b8
> [    2.507358]  kernel_init_freeable+0x1ac/0x210
> [    2.511617]  kernel_init+0x28/0x130
> [    2.516112]  ret_from_fork+0x10/0x20
>
> Cc: <Stable@vger.kernel.org>
> Cc: jbeulich@suse.com
> Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>



Applied to for-linus-5.16c


-boris

