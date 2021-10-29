Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599DB4405D8
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 01:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhJ2Xr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 19:47:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32570 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230325AbhJ2Xr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 19:47:28 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TKrRNH014448;
        Fri, 29 Oct 2021 23:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gfoXfXhQS40ektirZEXsfnYNyX2cBA+sq9UE/J+mvvU=;
 b=fxDrdSSml5meIqUyqsYBc0BbAQeBQcWnH7HVHD3c1/MnKOIQ45Ot45c5nu55gO8EZOKd
 1WKqgZIgCpbkuu/eP/n/tUtWs6fm5PMUsibCMhy2Rdk8i+xnAZ4DxU/BMUylqCKAAp4X
 +W5V9R4eIHJHgPn1IHed14B9Z4DOtLaAwYEl/asPdHYizA36PjeA5IqaRxCYVneQS21t
 GBibAOgvWbPlm/zQQosTqE/+IzCMq9G1qCqPiyXvSj6o75jdyLshdgiUN8WPHkUlU3BV
 E8G5niVaFP1HGkxdIMBX/qviBwSAITSWQXU+NyMhETpW8Zi+2agx0rQVnN9nRO6mvkQs xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byedauej8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 23:44:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19TNfgPU182964;
        Fri, 29 Oct 2021 23:44:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 3bx4ggmfu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 23:44:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vo77w0zdKOd+qf/9/b2ecr7mlgNy03KUlUwZmHY/JvoPtPOgBh4B2ZcaBmB8GKmZ/IFGfhpQnTPOcQgIvx4yjde13mGDU4sEzDEJ2Wg8AQLUaNmSOEionDx4AgHcLsS2qpPu7Onl+DGOnFFQkkE63PV2Rrj7/8KIzZoz54FNU00qVij7TvqIWmWmaVmw5o5RXJ5sg1H29zcbuPrTUteQcZUdo6rjqT1VD7Fm0vDnloAwYwvamuncOROkZ3CYX6fPB0SWAnsjAOgjQ4w/Q35QDXqiF1f1jylKzv4MeTEbxdJTexxbRFxDqh3AsdkkhfBDib1lUqxxkILduvgvClJBZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfoXfXhQS40ektirZEXsfnYNyX2cBA+sq9UE/J+mvvU=;
 b=eSgQB0hJtZKCEOGGcskFRhOtmtQwJ54feV1JktURfBsqndsyOetDlrjtTpC8+Nu/yq5ebz4eleS226khvxGBcDoi/gPXHKs5pOd0oIkSEPDz/Sjlf6DV9P3D2k2/lemChYSk2djhV5/Ur3R3ZCjKEbrKtdxhMcTnijqXnjJnWSG/TRnFlSNrH1JW4M36pa7j7Sj3a5UubRE3NQ1zVGIbJeZMVvQAKKoK+6Oox/+71XH0gKSk4ptCrnhJkT2Mv650WEGRTd/lWnoXnhyiHxkiPhWw/Te1QXj12SFSOsxPbcr/huyXNEicpXdMTBeM3tqzQDAJG51UHZjYSWps4LM5TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfoXfXhQS40ektirZEXsfnYNyX2cBA+sq9UE/J+mvvU=;
 b=LUIy6ndIXIxtU5TSlwRycpVjCKa1yMbL44Y45MnrBretuu/UyuLHn0wTFwjGj0wLNnwnXgd8SVTrQ/yTDuKRVde4rL82sw2uw5knoqCG+SXRFvT0X99WxUwmNAlRJRqzew9p8prp6A5MZslOcbZkMmgLwW1Ry+iH82t9mDMUU/w=
Authentication-Results: invisiblethingslab.com; dkim=none (message not signed)
 header.d=none;invisiblethingslab.com; dmarc=none action=none
 header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BL0PR10MB2977.namprd10.prod.outlook.com (2603:10b6:208:31::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Fri, 29 Oct
 2021 23:44:38 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%6]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 23:44:38 +0000
Message-ID: <2365e65f-7431-4bf5-4ced-5e146776b9ac@oracle.com>
Date:   Fri, 29 Oct 2021 19:44:31 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v3] xen/balloon: add late_initcall_sync() for initial
 ballooning done
Content-Language: en-US
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20211029142049.25198-1-jgross@suse.com>
 <11956c14-f1f7-70f0-40a6-aad31a264af6@oracle.com> <YXxzQhPvgAOkhGg/@mail-itl>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <YXxzQhPvgAOkhGg/@mail-itl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0194.namprd04.prod.outlook.com
 (2603:10b6:806:126::19) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.104.68] (138.3.200.4) by SN7PR04CA0194.namprd04.prod.outlook.com (2603:10b6:806:126::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 23:44:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b67a4139-008e-493c-c3a7-08d99b36122c
X-MS-TrafficTypeDiagnostic: BL0PR10MB2977:
X-Microsoft-Antispam-PRVS: <BL0PR10MB29773A9EC8AD089AEFB0E6A38A879@BL0PR10MB2977.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJqU/o8w7ldM1DNzXEXoWODFiPGdJNGkNZIfKdAjEo22/sNjhyMMMJPbA0GHSqlEIrJiXok9ZkAZOSGQ3sRA9FX4n3xSB+WTvr9j2Z2V+yXTawHoSac8lvNFXLaqjPcsMr1k/iJvO1h8UrHFD8ysHQKCw8t8aCy4rPhru5QspF37pT6fuZF9EfyADwK1YnUbDoPQlp9jikdz3pNRyJHxnip4RM81UzMa7APUqek67XXiJcxQffOXofQUwmbo4wi+EjqwVf4+C1lOITm4V5bAfbYSAmOdTW0xueTcTvoOLILZIUJH39lvGhnx6E/pITjNb4r8/0J3yPG1cqERb1+LQpjzBm4lcHOsJi/NOB1QuiVKH4H+MjkYqLWEJRZd//Qcs7Szrz/WBAomvWNRj0U1TGYlaYiQ8woA2bMVRJltmUgmXxUY86fYUzqJTulbkdZK27bugrBD3gTjmzMHviMfLEmXCJfMZsAnzqIbr4HCj/BFPzlUku4yx4eKARO7HG/tM+sY7NDyOquNbkczn+CgfMCVPOf2iJmplUrkg9X9JjVDYKEf4y4EXGOreGtH9Za+1R6NG/6RqY33w8UL+XSpsujVqZ3VaUia7ki7iKLo5gmDMn4b9PWktgvh0AC4MdAjOl7an9i/7m4niDQhUbeBxzqK5Fa/nPg0zdoD089UYl3UUcHm77LHYDPM3tmx8oJdT3SiVagGd9PBV7vUttQZrKwx84QNaWOcOh0mbM9jyrjFcfGovG0knH3+zrTpba2i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(54906003)(8936002)(31696002)(8676002)(83380400001)(508600001)(186003)(6666004)(6916009)(4326008)(26005)(66574015)(16576012)(44832011)(2616005)(6486002)(86362001)(31686004)(38100700002)(36756003)(2906002)(5660300002)(956004)(316002)(66556008)(53546011)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M29NN3JITjBDZmx5Nmd5MVFCeno5TjBFUytxZE14bGxid1ovT3BHSWhYQmgx?=
 =?utf-8?B?ZFBVZVRFcWFDOCtlV2I2d3E3em1lZXA3N29pVHp6dHhnNGhTUlFIdS80M01H?=
 =?utf-8?B?YkhhTWNTaHRqc3pudGpYZUQyZ0pwVUljWkcwQVR6SlNjMzV6QkdTVnBTamx4?=
 =?utf-8?B?aE1jSzdwMU1HZTBwYjJCWkxMUmFRaTcxQkxmQVEvZHlkUEpORW1oV3lQSWt6?=
 =?utf-8?B?NlhuT2g0VElvL21xUzFEVFF5cHdLSnRMQ3FESFZNc0p4ajQ4T3ZRU3FoZXRZ?=
 =?utf-8?B?c1FPTkQ1RURpUTJjdWxHMmphbEY0RzhSVEVqOW45YnpocHV1M1dJanpoYmNG?=
 =?utf-8?B?Nzkza1daNjRDalpMUlpsdlp4aDY3UklpNUdxbzlaSkN2T0g2enliUFBKZTdm?=
 =?utf-8?B?QjZVZW5rcFBnTkhzSExFeUEwcWhIc1Fac1JROXI1aXBXalJ2clFSc28xOTV4?=
 =?utf-8?B?SUdxbmRCZG1DbkgyMTEyZHF4NHJoVGgwSkJWL0EwQlc0SmxkcWZ4eEdVUlFU?=
 =?utf-8?B?ZEZxdDVhM1ZPNlJPOWxTajd2enpCR1FoeThMRUpYOGExeXphd0pBQTRkbE42?=
 =?utf-8?B?QzFwMEphTEIzdVN4SEt5dTdSMFYzSC8zdytQLzRyVlAvdG4rVFhZdkZ4ckVD?=
 =?utf-8?B?NE4rdjAzMGpDVjZzZ2ZGSmpGU0k5L1FFYnR5dWxpUlp3dXlEVWxORC9Xdm5W?=
 =?utf-8?B?eWxUMUMvNE9xRExnMnFMRTNiUkhKallVTDV0TkY1cThiQTFndW1pTGprditI?=
 =?utf-8?B?dHZCOElyMVdBQm42UzUwMUNWaDVPZVB2UjRHb2RXbUY5RjM4SEtvb2NOVSt3?=
 =?utf-8?B?bG52enRXSVY3ZU1peVRZU1BEREVlOUU1UTQ2clJjTkdJeEhCNW9KdkExTW51?=
 =?utf-8?B?bGRrN05ib0lESzVmNWhGYURadW96eUhKQzlCOSs0YXpOL2pHNzliNEVkVGlR?=
 =?utf-8?B?MDZhaGJPN1ZUbC9aWGljZlhtWkZURzhGUHFzMERUQTlxY3BuaU1jajNHODZp?=
 =?utf-8?B?aG93VVg1SWlqWUxMdnlvTmFRNjhYMWx1MjlUb1JMUkcySEJKZVVBQmYva2Y0?=
 =?utf-8?B?ZDlLdGF1YlhIV213blZlbG5PWVh4enNoNk55ZEJkTW9meHFVR1NiNWdDRnRn?=
 =?utf-8?B?ekdadVUvaGdWdm8xUEE0SlJtZ0FlWTlyR1BwV256ajdyY0lnWk8rSGtwRVZq?=
 =?utf-8?B?WmxZNmlOcysveGxPVHpRaFVjV3R1c2FEKzA3Z1duK25UYnJRWVJBQTd2M1hm?=
 =?utf-8?B?UUZEM1Zjb0lFdHlUVG5Id1o4MGxROFRKekwrT3MxM0lKcFAzVWpVQ05aSUEv?=
 =?utf-8?B?V0E2K0FOUVRkdllDa0Vqd1FlR1V5UDRRbHNkenEwSlhscG43ell2VlNya1F1?=
 =?utf-8?B?TWtEQ0VhSDBXczFnRTF4Rk83ZVF2cGtiSE44bjcxL0I5bDJwc0hHQkIzREVT?=
 =?utf-8?B?cUxLZHJHQlhlWm5ub0hoRmhTejlWcXRocU1pZDJKc0pWWjFwSzlTejZuNWMz?=
 =?utf-8?B?d093L3pZcThraCtrZFZPZndSYnZPQWRmNEFFU3V0cWFsaFBKYzlhckhWZHJL?=
 =?utf-8?B?dCtNc1B1Zm9GN0szQ2dQZVoxcWc5cEFTQ0F6WmJuMlJPdDRRN09td29FdFFW?=
 =?utf-8?B?aGNqNVBkVkVNR0psU0ZubllvRVlnbEJhRHdTUXhjTllJdlRFTkJSUzA5bFB5?=
 =?utf-8?B?cURTRHFiUzhvNW96YlFzWVBRd2hKT3lVQ0FnblgyRUJ1KzdOYXRoWHBEbkJE?=
 =?utf-8?B?MmhsQUdPVnpmMkp6WFNuZzFsZno4OFVxSnVTMkZmUFpjSzBnYlJOSFNPYUp1?=
 =?utf-8?B?LzduV0FXQXNuY3JVcGNtY3JhdFVWeW12TTFxT1ZNdGZyTjVuNHZVcEZrLy9D?=
 =?utf-8?B?MUp0TXZUMlI4ZWFJSWxKbzd1T0kxT3dIYTNLWjFrNlMxeTdqUk80OWk1Um5a?=
 =?utf-8?B?MXBLN01GVHB2SUpNaDlsbjl6anFORS83QUh4VXl1ckZjZVVPZEovU3FQb3lS?=
 =?utf-8?B?N3VVdjhBbjNLN2RQWWUybEd1aTlJRDNjTEw3MndVdk0yMHN3T2NFWnczaURr?=
 =?utf-8?B?WHhFTXhUaGJ2dy94T1hMTnpvWWhIZDJ3VUJRSXFaOWhuS2d1aDliZEVnNkJa?=
 =?utf-8?B?dktZREVQOWpXMjBydHczcUt2OHJVbjEwWGJERnVMNC8zSEF0bWNYNVhUT2tE?=
 =?utf-8?B?MVdQdytHM2ZUUXVveVJ0YnExMnVxbEdDZW9EOVIxT0xSZGM3RlAvQXZ1SGVw?=
 =?utf-8?B?T2dFM3B3QnVJUWFnZzVaaU9KcytnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67a4139-008e-493c-c3a7-08d99b36122c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 23:44:38.6641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LRe775WjO5CbYv++uDmqhkY5Vzl+rJSrhepyzVDEkIZfqyEMJkonOnDIQFJwR63ckcNJl0CUXkL4zt5cQlrZU8t70xHxwsew6z2HTHIc0/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2977
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10152 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110290132
X-Proofpoint-ORIG-GUID: ZdwsPRhlKtE41Lc6f9wfC1qV2NmtRETM
X-Proofpoint-GUID: ZdwsPRhlKtE41Lc6f9wfC1qV2NmtRETM
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/29/21 6:18 PM, Marek Marczykowski-Górecki wrote:
> On Fri, Oct 29, 2021 at 05:46:18PM -0400, Boris Ostrovsky wrote:
>> On 10/29/21 10:20 AM, Juergen Gross wrote:
>>> --- a/Documentation/ABI/stable/sysfs-devices-system-xen_memory
>>> +++ b/Documentation/ABI/stable/sysfs-devices-system-xen_memory
>>> @@ -84,3 +84,13 @@ Description:
>>>    		Control scrubbing pages before returning them to Xen for others domains
>>>    		use. Can be set with xen_scrub_pages cmdline
>>>    		parameter. Default value controlled with CONFIG_XEN_SCRUB_PAGES_DEFAULT.
>>> +
>>> +What:		/sys/devices/system/xen_memory/xen_memory0/boot_timeout
>>> +Date:		November 2021
>>> +KernelVersion:	5.16
>>> +Contact:	xen-devel@lists.xenproject.org
>>> +Description:
>>> +		The time (in seconds) to wait before giving up to boot in case
>>> +		initial ballooning fails to free enough memory. Applies only
>>> +		when running as HVM or PVH guest and started with less memory
>>> +		configured than allowed at max.
>>
>> How is this going to be used? We only need this during boot.
>>
>>
>>> -		state = update_schedule(state);
>>> +		balloon_state = update_schedule(balloon_state);
>>
>> Now that balloon_state has whole file scope it can probably be updated inside update_schedule().
>>
>>
>>> +	while ((credit = current_credit()) < 0) {
>>> +		if (credit != last_credit) {
>>> +			last_changed = jiffies;
>>> +			last_credit = credit;
>>> +		}
>>> +		if (balloon_state == BP_ECANCELED) {
>>
>> What about other states? We are really waiting for BP_DONE, aren't we?
> BP_DONE is set also as an intermediate step:
>
>                         balloon_state = decrease_reservation(n_pages,
>                                                              GFP_BALLOON);
>                         if (balloon_state == BP_DONE && n_pages != -credit &&
>                              n_pages < totalreserve_pages)
>                                 balloon_state = BP_EAGAIN;
>
> It would be bad to finish waiting in this case.


RIght, but if we were to say 'if (balloon_state != BP_DONE)' the worst that can happen is that we will continue on to the next iteration without warning and/or panicing. Of course, there is a chance thaton the next iteration the same thing will happen but I think chances of hitting this race every time are infinitely low. We can also check for current_credit() again.


The question is whether we do want to continue waiting if we are in BP_AGAIN. I don't think BP_WAIT is possible in this case although this may change in the future and we will forget to update this code.


-boris

