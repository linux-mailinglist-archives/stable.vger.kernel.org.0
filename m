Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8984449EF2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 00:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240479AbhKHXPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 18:15:03 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61396 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234561AbhKHXO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 18:14:56 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8MpQPL013263;
        Mon, 8 Nov 2021 23:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jWmTl9CmqbC3uEFtc3W6JUqzGGjj2dgUe07OWvNVsIE=;
 b=mTCPdWHOzLa5WxrzGF83RCiZWy5X6xAeI9vPytgiqM/YXxILTJUWsVzMfBAQvNVNfy/4
 AwBNXDM/lZxpw/QzT/cSXhv8xukrnm1F87L+e5L/lj9dz31cnFeZtIJOZQ//cyvJ2Uoe
 PR08V8euWDaFp+i7EZQf3l48H0ceT96wvbEaWdDWE7LDw8XkV2sGrpFyZeQgA06WEZZ7
 Q23SaBs1UZRizK9tipJajRUZYu5btPR+QFjSQEsGjzqxWBEuefKVUzTI/UHdkW8MTyYE
 arhCZH9CnM4PdjKjwWD2ZZaNwC+hR3lbkyKg2bv+cPU5i0wjl7AkG6joMj2PQRYZN5r/ yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6st8qe5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Nov 2021 23:12:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A8N5xkr181573;
        Mon, 8 Nov 2021 23:12:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 3c5frd3wp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Nov 2021 23:12:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+t6ItyL5QA5urnNmDv4/+qArA0iGFpj1deXtgkwXA4ImyAK/iOefg4VsUJdngKmVJ97rHonBDPzogNb0ep8DtPgD8qEf6bl75II0Vyzwbia8M4QN4UrxjvxhzL9grTuYxbuPrE6ey6hYsD62p7f047WsQHRGLb2qHqeKNAYqRaOQ3iryoi59pVuIaFelhcXMJjCWPshda/XArk19AI+JCd6XaEPlz4AkiZJp4hyc680JqMtQ1lNPCQlHSRT2e/gQazHfa2jHVW2HmyKq3bLf09LiMousEWusiZWZsvvyX1osJ7iJjXpxhuzofy4GP217vkBWcqZfYy0tWU/olumDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWmTl9CmqbC3uEFtc3W6JUqzGGjj2dgUe07OWvNVsIE=;
 b=Be0qWIuPJFTe0xf62iwD/VK7fFLNi/IgKmbChtn7YPaACO3k2kDGYcrCbwu+7gfQwr9jvinjucYTifDHUrOu8pQ3FVNpm4zpSaM6dAyf9IwxzakcaMZRDb55qn+YEMlia8fGfdPCVjzUyDJANO9Z0ApcFx1hAy3VlgMTlA7IrBdyDdcgMVok6F/Wodw4Pu4FDx7pIDFS0fS1ueqOxlfPabgphQadZD/lT+od1lIrnERcUbkrd8UWTzTNs+xBKAlPKpnnUph8uEMzc+80EqoVN2U/NYU6qI4RNo96z4UHdiXNLgp8BE0IAfvDDl1Tods7wHbBtvInbHBPMqhTPkMULA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWmTl9CmqbC3uEFtc3W6JUqzGGjj2dgUe07OWvNVsIE=;
 b=Xo3ltXp+5+6EaorLI/X/8ybToK5+ihYDK2RtmBEYW1jovTnc+28/eNi0lf7awUCW25SaI9BLP3Z9F5Nu0ucfEDlf0kmmle11nYTJT1smSYWZ/61HL4qJHRu8UtZOlhfVthAvwzM2xPZssp3Pb9GhiPeNq0tUpZ8Bb85lSNB/KZw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Mon, 8 Nov
 2021 23:12:00 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08%7]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 23:12:00 +0000
Message-ID: <23d594f0-7bcd-5002-175c-d476dc6c3ae0@oracle.com>
Date:   Mon, 8 Nov 2021 17:11:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] scsi: qla2xxx: fix mailbox direction flags in
 qla2xxx_get_adapter_id()
Content-Language: en-US
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc:     stable@vger.kernel.org, njavali@marvell.com, aeasi@marvell.com
References: <20211108183012.13895-1-emilne@redhat.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20211108183012.13895-1-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0344.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::19) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
Received: from [IPV6:2606:b400:2001:93:8000::f11] (2606:b400:8004:44::1d) by SJ0PR03CA0344.namprd03.prod.outlook.com (2603:10b6:a03:39c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Mon, 8 Nov 2021 23:11:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbd530b3-5d0f-4d55-b0d4-08d9a30d2b2b
X-MS-TrafficTypeDiagnostic: SA2PR10MB4665:
X-Microsoft-Antispam-PRVS: <SA2PR10MB46659A6055DA2AC8A537FCBBE6919@SA2PR10MB4665.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpZy21KOG7FSRZ0fPuhsIYqADHmbldAQSs7DgbrSC2zMCCm/FEGq9h6h39DtqUZKMtIvUqrsK5njKdn7Vt6T/EhJr5gZw91fWGpr2IFxdpkSO/m2j/3RNew+dsPHvpKjyxkt0EPoz9WTbnIfLaVNzeU9Bo30ePhHhHv0PL9KvQGSmRqR9Y+nJNBVzMN35GoJ4XT5ZBAYwMBBl2LPZOK36PFkDgwkPDojyh/ScitfIUKLrnGrzTkwjSmUDr4jVAC0kVR2Z4A8UWfBd1C36rlMiYNEUk0Wr6WjoHKcdaBm0Oe9IzJvRqzathqobLDvOkRRzSGLoFJOVL1pD1JXpuc0n0bhLrVaOs3GekwATAx2E45NNGEF7DNvhLolg6O7I94ZuxW6sc2JL6eG4U1SznK7UT7K29wxFP4rBYdYDMPEViPeDQmMaFONT3scRHtag5Oxk7qxeoqgbna4jBWPOhV8WplRzzo4AxRF50rVYx0oKw1jDvgSv6GVZHEVdVxXbiodD0Q500+z77rkI+Nf1Ex2tB189AmJokAfVuI+EPn0t760j0/pA5vRpWMmY4wX5nUfj585SlkcFQE/Y7eCbb12GRcSVKFpzHrq1zIw0NAaD7HQtH+me8SfW04KeRj6Nq5EPLYppvp9u1SlFFCgEInnPrQjVy8gatfYWzmBi9MGdxWJHQkegZGP0GWKk1HSQRLTiEk0ZnVclCIK2v3C3+/yJh7Jdhkd6e8ygwo40sZ3VUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(53546011)(38100700002)(5660300002)(186003)(36756003)(36916002)(6486002)(8936002)(4326008)(83380400001)(316002)(8676002)(66556008)(66476007)(508600001)(44832011)(31696002)(2906002)(2616005)(31686004)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTc5NFJNQjVFdTI0cnU0UHd4NnlOMGVUamtXVVQ1ck1TZXU4VXdYbVZITUFy?=
 =?utf-8?B?QTVXOEl2ZVNwTlpCWTA0THBOM3hZYkptdmlqcWRTck16MERLQ0llaEhwN3px?=
 =?utf-8?B?c1ZkK3VFZnJvQUR6Rk8xMmtweFRVa2dtdDNHWWVKRm9Ra2RyT1NpamV4QlEx?=
 =?utf-8?B?Q1B5ZTh2MGhjZWp6S0M3Y0xjTTdQM0daTUFvbnM5TkdjZ1lqL1o5b0dNRXNl?=
 =?utf-8?B?M0NrU3pxbEpFUmpXNlZueWxORjd4bXR6NDhSL3NrY0RFOFBKTDMrN1J3NlZP?=
 =?utf-8?B?dFh3MkF3UjVPVGh1T1pUWkVTcEw1dEV4MFdBWUVmcWFCYkdpd3JqVGdaUHN5?=
 =?utf-8?B?enpJQlZMVlZmVWYxSGtxRjd3SThOV1FhSXVKaUV5NVl5R2s3OEFnanc5bkFV?=
 =?utf-8?B?VTlhL3NZdk1RQktKMUM5K2JnMDhlYTMvWGRsb3Zrc0RFZHV4MnNwRlVKSmht?=
 =?utf-8?B?M0J1RlZ2OVFRcnYvOHNlQndMLzJRd25HektDV0k2NHN4Qy9Td0o2STZsVStY?=
 =?utf-8?B?T3BXTm5LbG0wNkpQQjZEWG5EbTNuSWdXSUJ1WUFVekpWdmE0THVsdzBOY2c5?=
 =?utf-8?B?eDJWQVB3dUxjUmdUQWcvNFR2b3V2SzJycDVaN0ZDWXVlN21OZVQ2cG9iVDJQ?=
 =?utf-8?B?WFZNZUdLUEVpRTNQaGFCMG82a3lCSElFN3hxSnlYTkl4bWRpRDZ3M2ZqSGVE?=
 =?utf-8?B?M1pTdERib3JXbERraExLU3pYQ0FMUmlJVHFmTW8rQm9UR090T01uTFZFSWk3?=
 =?utf-8?B?eGZ2VGdKOCtnMXgxR0M5UEJwQUVRTERvZVZELzNzbG9tWmxkTFRJM2o3OXNV?=
 =?utf-8?B?QmJuVm9pazhlZWkyRk5nOTJVdmRyenYyMlhxYktPZDlJN1oxby9hL3hVQlk1?=
 =?utf-8?B?M2dZR3lnQ0VLWGRBa3ZhOHpmSWl5N3lGcmI2N2UwMXJmeWpWUDBkQzdIb05K?=
 =?utf-8?B?R3d2Y1Jackt0b3Q3MEg2bHdzbng5RnBYa2R4SDhVbW8xUStFVXhlVkxTbWxI?=
 =?utf-8?B?bDh2U3JzeDhZaWZITERmUEw1YjBjbVMvQ25CelQ0NDlWNFhJdys3U0Y3cTdM?=
 =?utf-8?B?M2IzQ3VPT09sR00rdExNQVV6V3VCc1F5TzB3SUpuejlHdk0yUmZxRVZ5UGNu?=
 =?utf-8?B?Z0h0a3pEVjlwWmM5blFXVTloUEczaVBGbFFXNmIyWmU3ZmxHWU80MG5pWE53?=
 =?utf-8?B?UERKaHkya0tsZE9HY0ZMRFc0eEN4dUppeElsRmZQTmt0WitYQkFjRWlJU0ZK?=
 =?utf-8?B?UUpGSVJaWm5halZmUm5DbFdzQ3dmekFJY2N4UGFobjkwbVJoeWtTVklFZnRP?=
 =?utf-8?B?b1BLZWdRWDBhd2NEbWpJRE5SbzcrUGN0Uy9xMUZQQy9BYjMrMURNaEtoVm53?=
 =?utf-8?B?aS9ib3BoNE5tMWtFVTF0UXB4Q2czazJtZ3IvbzRYaG9TT2VMV05Xc1JWS1Rt?=
 =?utf-8?B?UVIvd1AyOWNJWWxBVHpKQlM3TXErLzVmMDFsZWlCQ0JjbzBRNjlOa2pNY0oz?=
 =?utf-8?B?aVdxa2UzcVdHTnFuamtEOFBMd1JzWWFkUHZENGNUTHdSKzhSZnlkSWdkUDdj?=
 =?utf-8?B?K3RlKzdIYVoyNW5YUS9VNjBrWjN5L1gva0tqUDhrUk9CYkNYaHVPVUtnTW4z?=
 =?utf-8?B?OWJNM3dSMWpGRmFGaGVxTTNGZEY5OVhrQkNtMmdGRDJZY29kNVBTeW84S0F0?=
 =?utf-8?B?YTRodHo3TjdXSWZwZ0VUZGcyZHRSeVhLelVnY3dwcmxMNW1tZ2dDUjRCdE4x?=
 =?utf-8?B?eTFhcVVKMUlZMjUzdklLL0JwTkpxMldMdmNuaVFOVG5taHo5QXVlQ3Q5cUZo?=
 =?utf-8?B?aXk5MDZjbFZtN3dlbkxJOThvU1U1VGs1YWNpVDBtOTg4ZHM4Vm10U0tSOWZY?=
 =?utf-8?B?Wm01QTJEVnJVUVdjR2E2Y3hoNXRTZ1Z1TlRxRUNlcS9GRTE1eFE0UFdaUExi?=
 =?utf-8?B?QlN0Y01kdFpoT2JKTEcyZS9rVnZYSFhZaytNdGp6TGw2R1QxODBtc2Z5NzN5?=
 =?utf-8?B?T3cvbm1FUGtLTWllRmFYcWh2NEhlb2UxUVRRZUdwa0F3U05vUGh1RE1nYlFW?=
 =?utf-8?B?c3NCemZtdXhMSnZGUzBHbkZrYkFhSGhXQWd1NFN0aFlzdGROSGZCcmdFMzFr?=
 =?utf-8?B?NmJ3K1Q3U3JSTHlVZy84M2FaSUcxRkVwVGtEeTRTaFpjek8vYVZrWXNucWMz?=
 =?utf-8?B?bkdXSC9JWk0vQlJlaGI4eFZUT0M2dzlTdFU5MWdUWWNNV3VGRUxwMTlmTXlK?=
 =?utf-8?B?VURWYVh3RXhFUEJjYk00K3Y5OXdCMGJoRUVxT2JXVHBpWG12cE03TUxBOU1S?=
 =?utf-8?Q?rCOjbNX8muJn7QjNfF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd530b3-5d0f-4d55-b0d4-08d9a30d2b2b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 23:12:00.5400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1bneXAE3/0+wROTLHBQwUqePMWJwGJMdE6h1MK5Q/hTtJ6idUGq5K9P1M9bNddw3vkp3KH/QexReihv9B2Vz3r+X7TPJTac1yfsBodvZwh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=881 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080138
X-Proofpoint-ORIG-GUID: 4eqaGTLm-tLgwENaAbLmYM2d026Z7hZQ
X-Proofpoint-GUID: 4eqaGTLm-tLgwENaAbLmYM2d026Z7hZQ
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/8/21 12:30, Ewan D. Milne wrote:
> The SCM changes set the flags in mcp->out_mb instead of mcp->in_mb
> so the data was not actually being read into the mcp->mb[] array from
> the adapter.
> 
> Fixes: 9f2475fe7406 ("scsi: qla2xxx: SAN congestion management implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 7811c4952035..a6debeea3079 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1695,10 +1695,8 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
>   		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
>   	if (IS_FWI2_CAPABLE(vha->hw))
>   		mcp->in_mb |= MBX_19|MBX_18|MBX_17|MBX_16;
> -	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
> -		mcp->in_mb |= MBX_15;
> -		mcp->out_mb |= MBX_7|MBX_21|MBX_22|MBX_23;
> -	}
> +	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
> +		mcp->in_mb |= MBX_15|MBX_21|MBX_22|MBX_23;
>   
>   	mcp->tov = MBX_TOV_SECONDS;
>   	mcp->flags = 0;
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
