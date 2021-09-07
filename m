Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3E44025B2
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 10:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244650AbhIGIyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 04:54:36 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:34857 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244982AbhIGIya (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 04:54:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1631004802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RjSNe8zDTR31Vpb/Mgl4kveXR1ujks5jatS6oS+jiaE=;
        b=SK5j6fBmbrCqq2qOUEAeAFcDBJCTSIQO5OuYrI1h1Ux7IET0b2AzKhsmDUiSkp3x4z9BjG
        MdtPhMyfrCRwCbDvn5JW8bMomYg+JslFP/HQaSWvoku43w0NI+15Sij0pUt4Rr7hESf9OC
        WTE4KlInv9hLy80S7OVX266dd1Vo9l8=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-5-zpq71WeVOtiN4iZT4ley9w-1;
 Tue, 07 Sep 2021 10:53:21 +0200
X-MC-Unique: zpq71WeVOtiN4iZT4ley9w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJYjzjptGs3fBeR+se+QkIHHF/+owYvhZ3UJ8w2PHcxkZfXxJlP3X709Ck7FM+d0KWuQAJ/GhcJTU8/kZVo0gseliL2TD5NWylVyVLQqJH5MLEokqMZgImWcqGAZX1cVv4kKs4VnfcXxbvQbfUKDuceh8sPJfiPAtG4WFTuu7C9un6jZSonZLwxdXj920vEqwxEyaP09nzUiOBxtTLf45wDOWP4n3q4F4m91gUi0rupD2Bwlrn7OoLVrkcVj+7YHx1WuP/mTdJ4oRCMg2/i2Rd++Dgf57RPFZDCQltg2g0NAXmck+j6eSeNJ7aKOBlduGT9+Vk1Lm9hZTonhDkotzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RjSNe8zDTR31Vpb/Mgl4kveXR1ujks5jatS6oS+jiaE=;
 b=k1kds4hTUGmNqMxue++Kr+Qtnu0dSCjI69dPPNSqGMspCKJ8amHMvT1qGuEWixcP0F1pFrKS4ratn2awMzK6LB/nerzAXFSLPiXOftWEyGui4SgOdmPYCvRng7Z1B2iqelhf3T8rG/Bbnk6551I6f8AKrtlq5iM5E6r00JOOhoro9TzuOP9HBG1JO5JRasmcQExapU94C0HIG+ZXnWDFUCFExoP0BtMWdjHq+BEaGEZ+CVsmjQLojBKFugWOeVi5qh1BEWO3y2CFGx3Rc02KSvksf9lbR4ktUtDzvFISKsulIJqkGx57+XLzs+3koeHKgQMeCyGafK09sumNJwfJHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR0401MB2598.eurprd04.prod.outlook.com (2603:10a6:4:39::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 08:53:20 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::4cc0:191d:5c04:8ede]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::4cc0:191d:5c04:8ede%7]) with mapi id 15.20.4478.026; Tue, 7 Sep 2021
 08:53:20 +0000
Subject: Re: [PATCH v2] USB: cdc-acm: fix minor-number release
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>
References: <20210907082318.7757-1-johan@kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <73080713-d1d1-b93f-a837-a5af02b698ad@suse.com>
Date:   Tue, 7 Sep 2021 10:53:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210907082318.7757-1-johan@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0050.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::30) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux.fritz.box (2001:a61:3b08:ea01:c97d:6ea4:dece:ad44) by AM0PR10CA0050.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Tue, 7 Sep 2021 08:53:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b65a511-bd87-45b5-ac41-08d971dcf10e
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2598:
X-Microsoft-Antispam-PRVS: <DB6PR0401MB259884C36C8550710E7355FAC7D39@DB6PR0401MB2598.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GofFbOizVncHxHrVkyeOg9BCuOObf7aZLJ4dTbhzmDSQaajUiVlkeqiD/F+p7Vwe4+l6sQzCoS8lcFoWO+32OHA8ds68nsjcwX1+tpNjesyq4sbkamEN2J2OOWWHEUqbtS/tu5N8iMHjn0HNl74bll8HRFysvbnRWCJgryTsdfPD9eon2+a5N4E5CsRtQKLNGmoEPcbiEjE3yPWj/al5WfwmHb/v3e0X9iDdf+Pop9/AvYTrCCnTZrcKy5kun3UgRNWhpFcmIYueB12XEvW/rFCoXKEg20xEv5v1XjK9WOn4sh7PgqCvRQv+L7fF/xQJOPnXJKDkDkHJzr+uHP6keIZfbYv/2FEZTmWz5S5N/7WjCyh5URdCihdsumISKfJkQkezXlTG1IdFFEXEcTmuKILu1PTpZ/9K+3Gz2yImLb2rQ5I95Q8pOTrsAduzCzTfdZaMRaJm71uv3+O4Ohmx3GjS530wmn6/YK+IsruKV5RQxzle0NnxpNK9f91Y076lvZixvozGkrv5ADn3CVoa18Z+5lOaIS+XkfR8vXFvFaT6pmG2B3dT0FJFelcyhtXCpIt2x6lxry6M0xsNO+6xmAowh5IneT/aWq1YRvX9RqEtsCHfDJ7FmIX3ullakMtE4MWAY9Rprcm3bE4YAODAtqZi27iK8m6djFc6nTfvpDRKavgyMOGABsvoiK0HprNqPev+xvIjmsigMrw5wpnyiWH+xohbi+oemIzfToQp0j0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(38100700002)(31696002)(508600001)(31686004)(4744005)(4326008)(186003)(6486002)(6506007)(66476007)(6512007)(66946007)(8936002)(53546011)(2906002)(66556008)(316002)(5660300002)(2616005)(8676002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TE5PL1hLV3ovTVJqakZreUNJc3ZjN3ZqNm5ZejF2c1RWN0xidWJkWHpUQk5o?=
 =?utf-8?B?d0dzQ1N4V0Rjb1Aranp4ZzJnTmg0ajdTbExpT1czVDBuZlhSUUlKQUpCcXZq?=
 =?utf-8?B?aklMTGdrclB3L3pRR01FbUl0bGxzdDZ0R2grSHQ1WWZUUnpScDNUMmRyeUNZ?=
 =?utf-8?B?emMxbHNQTVdIRnErY0RKQ2M5ZzZVd1FWOThWUG1qUnBWWitzS2hFSnc5UHhI?=
 =?utf-8?B?YTlnOGdDY2J6OUJEMExiN1A0d09IbUxKaUVKejhON3VoSWw0M1dRdzBKcXBW?=
 =?utf-8?B?NzJaMkNVd1ZOYTJJa2x3T1Q1MTd2a1k2ZXM0T0N5aGRzTDd6RldkSjNLUDB2?=
 =?utf-8?B?bU4yR0NsQk9oZXkzY01paHk1N0JBQlZoV09jdmtMdHR0Sll2eWRKSHFBVHFl?=
 =?utf-8?B?VEhOV1VXeUwyMytSb0d4NHVGWWhUOGhsVDdmLzVucFlQMkNiR0YrdFd6ZkxJ?=
 =?utf-8?B?UGNqWkl6b2RjdzdIQ3ZEK1dRL3U5NVV6ZUk3RE9PbFhKZGI5dCtnWUVDS0Rj?=
 =?utf-8?B?UHE4K2N0ajM1QkdreWNzUUQxSlJyV0RpbG1GQW14cEpraDlNc3BSTzVwc2hQ?=
 =?utf-8?B?OGgvQ05sOTF0dnJ1UDQ3cVpWUlViTmg1aUY3dFI1NFE5WnM4N3BuTEIvWXhU?=
 =?utf-8?B?NVJUUnYrTVc1eXAwcCtUaDhJWkJnelBQZjVpUWtQYmFlMkxwaGNPVG1hZ3ND?=
 =?utf-8?B?QkswbExZRktJL29XcTczVTQrUGljSCt1eGJKd1NqNnY5YU5SbWE2c3F0aDlk?=
 =?utf-8?B?N3NPMThDbkd3WmNacUxYazVCOTFqSTE4S0NXQ1hHZGxFVnpJZ2ZXU0RsV1gv?=
 =?utf-8?B?ZnRsVy82RWJjdWtKUDhOVXZOZkpqOTZRUjI0RC9wV1kxVVBETDROZXRZSHNU?=
 =?utf-8?B?Ymh2ZFkvYS9JVko1bkZPb0lQVERyNGVQVE5RRmtKTkFyVjUrVktiOGEvTlBw?=
 =?utf-8?B?dE9Fek0zWjAwSzFpOWNyR1dtbWlvdmJJWGxCWC9QcStVTk9DdlNQbUh4NDZo?=
 =?utf-8?B?M1phWmNOSnVhNGNDVEZLMkRvSlBrZzdRUTE3VTFZS2REOHRnSTQ3alhabUUz?=
 =?utf-8?B?anJqL0ZqdGxOQ3JXK01KWXRweUMxRkpwVTJDekFPY3dpc1RmMDBYNG8wdEhp?=
 =?utf-8?B?SytMS20zYjVNMVRZL2FYU09jUjZ0LzFWeUswL25lK2JPejBGT2kzOTNiT29E?=
 =?utf-8?B?RlQzZHJVQWl2OTNJVjEySFR3L3cxT1NJNmNEWjFBSGM4bjlEbkNjdHEwVDUy?=
 =?utf-8?B?OVM4WWdlZGlwclVSRytuMmhMTWZyb3NoQ0k5Vm9kOUVCSzMzSzFRZm5OS1Bk?=
 =?utf-8?B?ajVnNzk3ZC9Ec0NvdlZtZGFaa0JXcTMxMFBvbUlER0R5VXlpaWFIRzBjWVFj?=
 =?utf-8?B?RzV2NzFTS2R0ZkhISzM4OXd0QTlxSUpQZzR4QkRHUWQzYnhEZjlIc3VEdW1R?=
 =?utf-8?B?MUdMY0hQTDMxOVNqQUJ4dFhSNEFZVzBpMGNYTFl2N2tGbVdGTURDQTlMZmFY?=
 =?utf-8?B?K0RZR1l0WHpUYmRJc20zeVo1MEZKTjZEUW5LUnJJY2hiMUFja2dSSFM4S2Nk?=
 =?utf-8?B?cHhXQVV0NkR5Q1doREpTTUdWS0FlcXRCVjBGWkUyVExRaFJGbnJkREpLa0pO?=
 =?utf-8?B?MXl5WTdXVjNXRzNMdDBFSkgrRVhqcFJQY25hdkRSRVZ3cUpoYVk1WDRxZ0Nz?=
 =?utf-8?B?c3djb25FdWlUVTVlQjliT0VJckNkV2NUbUtUWlI0QVlpd3A0NlRjU1BnUGMy?=
 =?utf-8?B?RDRrT2dNTVpEbkROMFM5MGxrSndzdmtKeTNtSktsUDd6SlNHVHBzZ09XcWtU?=
 =?utf-8?B?eEV6WWlMMTB3bUZZREhsTk1GU3FrbUpSQ2JJUURlWFpTMFZaa08vbW9kbGZx?=
 =?utf-8?Q?C756L89gC19Z/?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b65a511-bd87-45b5-ac41-08d971dcf10e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 08:53:20.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JVtoq2ZXTiSCdIcNTm2KyGTRzQzUpsSQqk4MmhuukvH2PcPDv8bvTh3ss7zWjT3R/lEXQHtMh+njkddi2/HiCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2598
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07.09.21 10:23, Johan Hovold wrote:
> If the driver runs out of minor numbers it would release minor 0 and
> allow another device to claim the minor while still in use.
>
> Fortunately, registering the tty class device of the second device would
> fail (with a stack dump) due to the sysfs name collision so no memory is
> leaked.
>
> Fixes: cae2bc768d17 ("usb: cdc-acm: Decrement tty port's refcount if probe() fail")
> Cc: stable@vger.kernel.org      # 4.19
> Cc: Jaejoong Kim <climbbb.kim@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>

