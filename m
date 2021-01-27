Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00313052F5
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 07:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhA0GO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 01:14:27 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:27901 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235464AbhA0DTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 22:19:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611717480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIAx60ikiQQYOQQjrJJlart459I8rbWOAQpqNzkAUB0=;
        b=Xe7H7IsLrpXoyYgoLqQnxDt1iDBSv2Dqs4ZrK5P6y9kxO+oyr5ZNIVjF3wYAaOJHqKFObC
        O2Zu/ccltQHmYED4F2zn+f7M0f3m24p7aoOmMhWck2jA9nvllnMxk0hMwp0RsnwCebmH9c
        YSFT5ijaRAg/mfxri2vd0uRUof78ATQ=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2054.outbound.protection.outlook.com [104.47.4.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-29--dFvhWaGPwWFFGJ0Mpangw-1; Wed, 27 Jan 2021 04:17:59 +0100
X-MC-Unique: -dFvhWaGPwWFFGJ0Mpangw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnawU/7RWikxBQqEe9lRNNg72Tr4D9yP2G4tupQGGtx23aMGrX760SproBllEfPh7OYgQNwiwr7EtPWGxA+8lSf04dG3r17clsgRzyOeiNmJLqfyPOfeMBK6lgq0cmrxOrZTmtbntk3a9iU176APONCNpHkzO8eyB67V+ytD2Vp9kib4yizmvUjRyji0Mccz0/LX0S3lcPVx/qSpQyzi1mqmmuvaL8HrQJhFWzzK4XSzvvU1pvxT2ztwXQXUzTtnAvJAAHxkjdB6bAlLSnnyyS6SeldSlRqJIagz5sb33PX+Zs7z9dt764n1+hyPx4c2PvdMaR8UEzkBl2pn2okzMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIAx60ikiQQYOQQjrJJlart459I8rbWOAQpqNzkAUB0=;
 b=Y2OLctzJvoB3YElcJUr0fo0hjuZYBvd4EAhSKzpDB8BEaBDMzeRzn2xKmhTzqFMZhITOb8UWCam0Y+9i4Rgk/q6KUEdVLlEvaKGczafV5I87Jg9gvkzjuA0LUoUqSAyxtOzOFR0iEbG8xgMtuArJ2jNJ2SIBK2ZXI5jTehivNJg7+XwxCG+2Ajqaqv1GHNrg6aFulC1R9QS/f6cWrwD/4+KReIzliQwfHiqKK/FjvFs+Ur4R+tFVFTdB78SeHw0G5PGN6QDyNCVrpBag7YgwcjpOjPnEOM8pMzltWTDdnnKmrfP6GuG05LdRTZAjOyk+fvEe+i3rsau5PK1M4dAEpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 27 Jan
 2021 03:17:58 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042%6]) with mapi id 15.20.3805.016; Wed, 27 Jan 2021
 03:17:58 +0000
Subject: Re: [PATCH] fnic: fixup patch to resolve stack frame issues
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
References: <20210127012124.22241-1-leeman.duncan@gmail.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <31165152-290b-ce04-03b7-ab3d63ea0e93@suse.com>
Date:   Tue, 26 Jan 2021 19:17:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210127012124.22241-1-leeman.duncan@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR08CA0035.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::48) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR08CA0035.eurprd08.prod.outlook.com (2603:10a6:208:d2::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 03:17:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad69e69a-4f27-4e85-e38f-08d8c27225ae
X-MS-TrafficTypeDiagnostic: AS8PR04MB7815:
X-Microsoft-Antispam-PRVS: <AS8PR04MB7815A75986F211463972B44DDABB0@AS8PR04MB7815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZvYQuKCWyPEs6k95IfFa+hyx1pcU+ZA+SddcVhNLT7OHTUnaO7HObUAVERYnODUeeVFMjnCTqJmiN3cpSPyB02IdiMzYfZAH98vyIiAK6u7RC/QtpyPIYVwcXNp4hVypS/yfiCBkllGUwdRlS26Fi7HT1v5hKNkfefw1KTngTvR6KZh5WxkC+NYlGPVIZfbl4uLkr5DqhuWXVwVi/cZhzyBKRcIqfYkukL7TiDvFlQbaJJu7wP0flVAF/yUtNKL6vm7GJUDmqrBl+8fcXuvUYShk2Nawn8TsoBRh9lxdNXhhyr2rlHKPcGbBDz7E2NdhXNk0GWounsCGGMRAR7kRMAuMWOetcx/uDrUyOgfC3CzbIIFQ7zALbyStC7d1nNvIMzY08mVaYZSGqzFsmsV7hrmbzVNW1/T2FJh1nvvXXLaV/E6G8G631J6oLw3FhE6IjF68V36/QQK88zbk3l3rNOEPC9gmYVNUPCBlBgAoJclW/n72BoMXXq85TBl1BIJVHP9++1zd+bMwNh4apOnsMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(366004)(136003)(376002)(346002)(52116002)(31686004)(16576012)(316002)(956004)(2616005)(31696002)(2906002)(478600001)(86362001)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(53546011)(16526019)(186003)(26005)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S1JncWhRY01wSmxINVh6TGdrL0NNeGV3SDZYbU82MlN4MDV3Q2I5NzBzbGZG?=
 =?utf-8?B?ZHV3Qjdienk4ZjNjN0tzSUdzdjRnLzdtQmxyZzVyWS81TUtESFJ6OEVqclFu?=
 =?utf-8?B?enczYWxta1Irb0RKV2xxeG8rQUg0Z3VPY2V2bmdUMnVjd0Y4a3R3Y09tL3NB?=
 =?utf-8?B?V29TZE92MUcrUkpsM3NuQ2g0Z3Q2TEFNTUxKRThzSHFKaDhWTndIR3hVQThQ?=
 =?utf-8?B?QXk3YWt4NDkybFJpUTNPMDNZN0pvd1FxdkRqMmcvQlJldTh5eThIOFZ1RWI4?=
 =?utf-8?B?dEs3UWJSUFAvNkhVUmdLajFCbzh3NFl4TG5OT2k0MUVIcVNRVUlzTXYrNjZ0?=
 =?utf-8?B?OTRiNWoxbmRQODRubVgzNXBMNkJ0T2dKQTFvZTE1QkQ4Q2xEcDJNdmtydFRq?=
 =?utf-8?B?RmxzSXMzYXBobmVoMUtlUGdCa2xJVS9rQTRVYmJGYjhERmxzSzVGVEFUUnI5?=
 =?utf-8?B?cmNaS0pyeEZxb2taLzlZbDk0S0FaM2JyanZWckRsdUpEVlg4di83V0xHV0VY?=
 =?utf-8?B?enpsNzdBQkdMWVpJQzdoSFVnWkhuSTVZK1VhTkoyUk1ZcmpRVzkxMCsrSWJn?=
 =?utf-8?B?OUlQQkRueVJRK3pvZXBLTmNXVFgzMkhUSSsvOFBlYmdiK1NBZUFNNDBiVVE3?=
 =?utf-8?B?ek00T2wyM2ZIVVlCSWVFM1V4eVBJcGI3dnFxQ2RsSzBCMkdRSTF5SnFQZCt3?=
 =?utf-8?B?SldSZDBWNzQzYU5aOHZmYmFsTmhBQUp3OURzYVJvNWRRRVV1dE1oNHRmTFEr?=
 =?utf-8?B?RVFQRVd3bGswYkMycmJTRkNWQjQvcHBQamZzMUkweUVCRW9BUEYvUXdlZkV0?=
 =?utf-8?B?Z28xSyt3NVl4ZFAva0hDSUNTenk5WnpDUzJpSmoxV3F2ZG44eGNpT0xVUkxt?=
 =?utf-8?B?djNLWitlMnZQS0owTUI2VTNCbkxOYmVSRXRudzRnYWJaUFFRYmVRQlNlZGFo?=
 =?utf-8?B?RHNSblZTZDhIY1VHcmMybDdpRjJkbXFOZnZ5RFIyZHB1dzhTemkxRUNoOUVJ?=
 =?utf-8?B?OE1lU0xCMk5KS3V3eUowazBNQ2hWOWZDNlVYWVhqVjk4ZnNWWmJVQU02Yk02?=
 =?utf-8?B?b0tsLzJKM3NEOC8yY1hRWTlGbXU3ajV5YWFqNGFzekZkL0Ezc01mYWZuQ09N?=
 =?utf-8?B?R1pPUExoK1RQbXd1NVErS0NRTXZ1NlRqNDg1bnNzZVZyb09jYjR5VDk4cldF?=
 =?utf-8?B?UC85bktCMFovT3N6T2hEZzNVNUZubFM2YXhrSnNXQndnZUJrdHVmSjh2WXN2?=
 =?utf-8?B?bzU3Kzlrc0tFd2dvYU42d0I3dUdRZ0NxK3dKa3FDSUZRK3o5dlpUUU8wM3NB?=
 =?utf-8?B?VmdNdkJhV2VVZ1B2T2xwNmNUcDJack9WWU9BRnNqVHNMV2VZNzRzTk52MDFv?=
 =?utf-8?B?Uk1sRTdNeVZEd0JiQ3dWN1hTZWJlYVVCNjVIRUt3VEp0WkhxblhXZGtUUnlq?=
 =?utf-8?Q?WptE3DDk?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad69e69a-4f27-4e85-e38f-08d8c27225ae
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 03:17:58.8273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSj5cgcm7myQ7GbDf6hCld6ba0NUh8HNiS0HBktjAxuA7CCp1wKk/LtEUQPfk1McT/liWkgPg93k1ntMbQ3GzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/21 5:21 PM, Lee Duncan wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Commit 42ec15ceaea7 fixed a gcc issue with unused variables, but
> introduced errors since it allocated an array of two u64-s but
> then used more than that. Set the arrays to the proper size.
> 
> Fixes: 42ec15ceaea74b5f7a621fc6686cbf69ca66c4cf
> Cc: stable@vger.kernel.org
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/fnic/vnic_dev.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
> index 5988c300cc82..d29999064b89 100644
> --- a/drivers/scsi/fnic/vnic_dev.c
> +++ b/drivers/scsi/fnic/vnic_dev.c
> @@ -697,7 +697,7 @@ int vnic_dev_hang_notify(struct vnic_dev *vdev)
>  
>  int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr)
>  {
> -	u64 a[2] = {};
> +	u64 a[ETH_ALEN] = {};
>  	int wait = 1000;
>  	int err, i;
>  
> @@ -734,7 +734,7 @@ void vnic_dev_packet_filter(struct vnic_dev *vdev, int directed, int multicast,
>  
>  void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
>  {
> -	u64 a[2] = {};
> +	u64 a[ETH_ALEN] = {};
>  	int wait = 1000;
>  	int err;
>  	int i;
> @@ -749,7 +749,7 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
>  
>  void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
>  {
> -	u64 a[2] = {};
> +	u64 a[ETH_ALEN] = {};
>  	int wait = 1000;
>  	int err;
>  	int i;
> 

This may not be correct. Please do not review this yet. I will re-submit
once I clear up my confusion.

-- 
Lee Duncan

