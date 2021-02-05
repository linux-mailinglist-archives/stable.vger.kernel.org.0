Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DEC3109A1
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 11:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhBEK4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 05:56:10 -0500
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:57093
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231828AbhBEKxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 05:53:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV65Ifknqd/6AIfgEN8IpzOyj0cfaDiZvo99rA3Tb+HeaLa6huy60fJZ9z50F208rFiF4Np/Sl7kh5KLFdsUTrpskB1nzM98QHReBDeGHgpsd2+82aAJ0MWNNCp5ZhSznSOFjIsAx5SUQPG0MbbBKNXqELbWxHSlhgp4Y6ij70RDw/zMoOKhYE0UhGMBE1fKOumJbqnx778y8MOXEqLRMmcYCEDmSMiuXUrvo4b48LP5jX7gTYIsnRd7qj8zm4yth0wZjAJYFxuZLjCUTFAspFQNrkKGsifBYFcoI/Uxq/2Se69Q6aVnc+7Clqpqb903A8DmbcbaVKfl5rP8IH5fqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKQAdpPEYJxAFZJMx1myQXwtOlozeVCiR/JY56vMfVQ=;
 b=YQ7l0zG+VPW/UUK9e3JMg43ECj+QxcI/p3dMasPcJFsL+COaUGkVaAjZpTyvw5M9SXVd0IAkC89e/bpJtzvNjV2bTnKiyRIupy2bfkg67dbD+TNjFNMuEE3sVrDkt5ByFG40ZNj0boD3eJvtjLu0fguYJQx5b/ASWGyBlFBmpzA/kU3Btr+r9wrOUncOg01gL0ffaHZatHkHIX0BSwvqc7sTCwsRKZ/AKqupj5LALr7Gu5PluQAMIS98SL7s8iG6TaGfdmB3UmXfki2IJiOKVsNWDWOcBCV9c6FXBx3aRk4CYyGhyusw3UCA1rjy5Q6ghA9Y03DJ13+KRNMqbeJ++g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKQAdpPEYJxAFZJMx1myQXwtOlozeVCiR/JY56vMfVQ=;
 b=hRQ82ubpqJ0zV3DpYyCJ0G8SWcbB7HatIGHW4EJfriBnJwpQ8Eo53wToy3syzqE0WxWcMX5vqlGwij1RbJFvifYKlZDChPMmflF+R3gzpoyofEFPOHff5RDy6sdx9K0gHix1hSnN6J3MQPkL5OysT6qwro/SXvqnC6J4N4WRRYg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kunbus.com;
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:a0::11)
 by PAXP193MB1247.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 5 Feb
 2021 10:52:59 +0000
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73]) by PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73%5]) with mapi id 15.20.3784.022; Fri, 5 Feb 2021
 10:52:59 +0000
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
 <b36db793-9b40-92a8-19ef-4853ea10f775@linux.ibm.com>
 <f5ad4381-773d-b994-51e5-a335ca4b44c3@linux.ibm.com>
 <78f6bc5799c744dc3fdb2f508549cedf76ac1c1d.camel@HansenPartnership.com>
From:   Lino Sanfilippo <l.sanfilippo@kunbus.com>
Message-ID: <c6c3a432-0949-6755-8955-3d002f66184e@kunbus.com>
Date:   Fri, 5 Feb 2021 11:52:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <78f6bc5799c744dc3fdb2f508549cedf76ac1c1d.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [87.130.101.138]
X-ClientProxiedBy: FR2P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::11) To PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:a0::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.23.16.111] (87.130.101.138) by FR2P281CA0024.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Fri, 5 Feb 2021 10:52:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a02cd6a-ced8-4acf-aeaf-08d8c9c433d8
X-MS-TrafficTypeDiagnostic: PAXP193MB1247:
X-Microsoft-Antispam-PRVS: <PAXP193MB1247AC39B1BB79E6D1B69E29FAB29@PAXP193MB1247.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mhEpWWDuZIYB+bH4wn1lMwWtkGzsti2cYLzDkbHw6MgAk5ojXjYoOtGOUtt/itY7R1eca7gE/0Kb8qfLiDWygOAmeR1SUx2bCqlPBzGACQvj2KlXLvpJk7TQjFEiVfEZk++z2WEQKusoxhvMNntgIIweSB6HS6VSbWtGnb6eN8CLXbtPC0I/cdffSXPrp+HOeSyUr98Atb29aB2hzoAtIiyrBuc6lqqiq/tAkI4GlHraU4ux1w9g4FFuhkCqDECspMKQxvyxq5FBlCDBjMucN/2rNWyM9M/AEASZwQAic3wivN8O71jYMA6n/lcEoYH2yxUGl1ukzfsQKvQLl8a80pAy2wWdJmpjrACzCDnW4Rk5mNZSQlK92/EJfM9uMG4goGOSsTf2pDEPNVp5jEY8h/o+NhqAwQgsUP4an+5tZoUXmM4U78Jpseg8mFGiAhUhYWDLSCyVB6Jfh36IVhqKsFypqCS7qtrt1+g4g6QJm8JzI4VvdkG51ToLJ2FhGhMO2c6tceFyEFLQq5DkzZtFQW+9DCXEKcV5UDV30RV/O2pqr7Ly5qlK5eDeWfO5PZvySmhBtOH76pkLmJSve31oUQtsFi8Naf2sT07KXHz2+5I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P193MB0894.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(136003)(376002)(346002)(366004)(396003)(52116002)(6486002)(4326008)(31696002)(86362001)(7416002)(8676002)(186003)(26005)(53546011)(16526019)(2616005)(66476007)(36756003)(316002)(16576012)(956004)(83380400001)(31686004)(110136005)(2906002)(5660300002)(66946007)(66556008)(478600001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cWNIYldib0VaS2RnYVQzRllxT2JKb0xDMnptdEpMeWpvdWJ4UUJ5Q1hwSGI2?=
 =?utf-8?B?WXZibU0vT09sUUNRaVZ1czJUUElUWVQvdUVDa3hEUnZSNC9LWnh1WCtuM2Z5?=
 =?utf-8?B?Wmg5aWNjb2dPWnpZb1FEdCtZU0s1bklFemovekhpZlppMWFsekY5OG45ajJj?=
 =?utf-8?B?Qm9tZkRuZWhwWlAyS3k0SVJYUG0zSUx5ZHhDY1l3R1NxclRWeDBwRHY0MXRp?=
 =?utf-8?B?b2xCYTlacGZTOXNlcEN0ZHRXVlVacStEZCtsMnViU0MyeTQrQjcvbFQ4aysx?=
 =?utf-8?B?UnAwZHMvMFZxV0kwRDRlRkhuN0N0RFBwdlFrN0FlSW1TbERGU1FuUVpUaXJu?=
 =?utf-8?B?QVpYVUtUalkzc0sxT09vMWlmWHNueW5wVnIvZUoySk9sUHFnb0x6ZjZNMkNu?=
 =?utf-8?B?NzhmOHNqSVcyQmdBckhKeEs0dGd5ZUdjZTJvUHJ3UG93VG9LR2ZqMHMvTGFC?=
 =?utf-8?B?a1EvUGV6ZlF4TG9CTkd2NjhsVElyYmhCRktSTFN1OWZTWGd1TlcyR0lRY3dv?=
 =?utf-8?B?YlpYUVB2UXlvbnNVN0EvZUFyM1luVktMc3RrT3B2bExubXJJK0FMc0YrWEdh?=
 =?utf-8?B?YnFOditITVdOeFdEaVVKYkQ4eDlzUiswQ04wa0xiVURWNEJaWS96bDhja0pt?=
 =?utf-8?B?WmNIVE9aTHVyMG14L0dmL3J3ejQ5cTF5ME4vZzh0bGcwQXVDckZwYms3YkM1?=
 =?utf-8?B?Q1pmSFBRWGwzY25ubC9EdSttMmlMbHdOT0NDc0FINTRrWk4zQXEyczRULzlK?=
 =?utf-8?B?TmpHWUhlSXhkN2ZLWk9Vd1Q0T21UeUIzcVpkU2pNRlkyVjNEb2QyaFBjaS96?=
 =?utf-8?B?MnBENE5SZE1EOGVsYWtKT2ZKR2tDZnBicWh3MW1mdmNuWTlxVXV2ZWlNcDlv?=
 =?utf-8?B?VTFDcVVvTFBVSmk0ZjBQNVdnbUsxMHMreWJEK2d3MlQzdjRXTWppOTlyTlk3?=
 =?utf-8?B?NGltQWE5aWZXRW9WNzUwMjk2T1FEWUxRSmNzVWExSGs0MHNIQzJtaW9pb1pZ?=
 =?utf-8?B?ZXlsS1hkd2huSXhjSFd4UkdNeEoxbUpodFVWNlAweG1KVWdsbk1HOENlTHRU?=
 =?utf-8?B?QkFOVnJzZnByL1pYWWZQci82TWdicGx1dEw1NzZOWjJmZzlBZnRwR0lWY1Y2?=
 =?utf-8?B?L2pIUGNvNTdmZkl4ZXpEd0Z1UTk4VlZVUVFpeWFHT2ppdURlZlR1MllwaGRk?=
 =?utf-8?B?NXF5U00veXlEbzBuVFY1b29Xb0VKSjZiTStVUDYyTTJOZUZ5enF1SDNrZkNo?=
 =?utf-8?B?NEU1ZDF6cXA0ZEdzMlN4eEVTUDBKWGJRZTVnUDc3dVllSFRjeDdBcXU5ZzM4?=
 =?utf-8?B?ejRSK3ZRVE1iMHVoTkN1cElsOEUvaVh2ZmdidWt5SG9lcFJnMlVIZVlVa0x5?=
 =?utf-8?B?VEx1c1dwUEJNZmdqVTk1S0xPSTFUUk9yMWdSNnVOVXdHYkowT2trdzlDNU5H?=
 =?utf-8?B?eXNSMVdtVFZKcGlwRmt1aENrRE91d0RQU2QrQzlOS1dOdSs4VUR0SGordTBy?=
 =?utf-8?B?UzVhNURoK0tBN21xTjUxT0JyQVJ2bUR5YVFYbDFrWFQ3eTFKaklXdlp6LzdO?=
 =?utf-8?B?SkMzcngzVmRaUVN2S3FTS1pLYW1PbFErNjF6R3FoT29VRXdiUmtudlNiNnJG?=
 =?utf-8?B?MUtpUlQ3WWhlZk1vNTRGMjFNbTd4ZC9jNjZQYllZWG9aeVBCZUhQUm9wTDht?=
 =?utf-8?B?ZjBYWTQxZjBRbTlmbVVjOUZHMVd3UDU4aVJRYnZaSWpIUjVvN2U3aUNuUVJY?=
 =?utf-8?Q?q9p4eU75RcIU40FVxZSpDLc+KrEc+vww88l94WU?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a02cd6a-ced8-4acf-aeaf-08d8c9c433d8
X-MS-Exchange-CrossTenant-AuthSource: PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 10:52:59.4452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TYgdF1FUOn4ef7nOuowFXX9mplUQ+7sYaxYvkvbB9bK9Uca5YoB0OwVLI7Q2fcyosvA16VRKH7KYBmLtBVMeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP193MB1247
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 05.02.21 03:01, James Bottomley wrote:
> On Thu, 2021-02-04 at 20:44 -0500, Stefan Berger wrote:
>> To clarify: When I tested this I had *both* patches applied. Without
>> the patches I got the null pointer exception in tpm2_del_space(). The
>> 2nd patch alone solves that issue when using the steps above.
> 
> 
> Yes, I can't confirm the bug either.  I only have lpc tis devices, so
> it could be something to do with spi, but when I do
>


> python3 in one shell
> 
>>>> fd = open("/dev/tpmrm0", "wb")
> 
> do rmmod tpm_tis in another shell
> 
>>>> buf = bytearray(20)
>>>> fd.write(buf)
> 20


The issue is in the TPM chip driver code, so AFAIU it should not matter whether its
SPI or something else. Maybe check again, that the file is still open when 
tpm_tis is removed and the write actually comes after the rmmod?
Also note that there are some sanity checks in tpm_common_write() that the written
data has to pass to get to the point where tpm_try_get_ops() is called, which 
is the call that eventually triggers the bug.

> 
> so I don't see the oops you see on write.  However
> 
>>>> fd.close()
> 
> And it oopses here in tpm2_del_space
> 
> James
> 
> 

Regards,
Lino
