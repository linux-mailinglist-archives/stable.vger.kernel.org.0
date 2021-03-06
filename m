Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E499232F715
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 01:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhCFAGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 19:06:01 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:49824 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229813AbhCFAFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 19:05:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1614989138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yE8qkyXPCEhR8MykpYHaCV7LoYPtOGzfCXRZohY966U=;
        b=Qlyh1PjfZ7CMWPpumci+rRSFi9QT2B+hU+VwOJh5xGNhlEgJEC67Jz73lsL2n9ggBzugNx
        IzAdDGb8Qnr7+NCSUBHVnCsmJnACFcuthlSGYD85R1fjk6WgkWnONE0+t2rSbbTZvbHW0o
        blw7otu7dJK6dVtYILhp1vgxf/VyjFo=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-28-YVHfN9E6MS-79bdD4lgN4Q-1; Sat, 06 Mar 2021 01:05:37 +0100
X-MC-Unique: YVHfN9E6MS-79bdD4lgN4Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WL7nEN7o5AC3lKuc3DgVaRRWJJuhl9n1zSx0RNv8H4efU+m425DDIBEWrpSy7razaeQloQndkwvlEprclNDJ4lb0Fdgg26/0ucGx819B3CK+PhQTix3MB29WRTxL44qec48tMG5xeakIiQ4F7Ws5iSa7Bs4N0g0iLjH1yJm5Grm9NPAXQN4kRp4204uIKIOsySJnwGIE27yDZVu+mThtpkrK2FPlR0vSEqiq5A58xReq3Wuz0k/DlhZccvBPvI08g+wFePsQK7GLs7FZipZ2Y9LJtxxVQHI1prQlV9O7lXJ8xLI8/KPii4EsbGMtaLB8P5ysdg/X3pDmyh5d2+1a7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yE8qkyXPCEhR8MykpYHaCV7LoYPtOGzfCXRZohY966U=;
 b=Yf3tx661YKHKT58A8M1Fwp/9mfFWEvx8H9FZ5PJh6goZ4yYUmYnczZeeL/FYhcofO+OsJEyZ8y/biyTuT+mxAJ4irnuVx9+u/U+AbMlQHBRO27/4ZrCBJmcJLXlkP3+lGwwOYHFFLTdWzrIdsKbkfbDxXPf65lHoXHNrVf5Trg2f93ZWeGsxW29pNHclg+MVCzb0BlPkv+iecMMNp60vj0EiLrAPH7gt8rgZrYusuHs8NjzsGF/4WJ5eXMkSb6Z7YoL7Jx10KcpxQWiqUoZg6Cdjt78SWIuA9Ws5W4pJPyI8NWtv6dgyQNokj8z1Ab3YM++uqrtkHUSris4R/fnLUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4069.eurprd04.prod.outlook.com (2603:10a6:209:49::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 6 Mar
 2021 00:05:35 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042%6]) with mapi id 15.20.3890.032; Sat, 6 Mar 2021
 00:05:35 +0000
Subject: Re: [PATCH 5.10 083/102] scsi: iscsi: Restrict sessions and handles
 to admin capabilities
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Adam Nichols <adam@grimm-co.com>,
        Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20210305120903.276489876@linuxfoundation.org>
 <20210305120907.364742631@linuxfoundation.org> <20210305224226.GA801@amd>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <7a21cac9-64b4-6a82-fd93-6dfde4383dbb@suse.com>
Date:   Fri, 5 Mar 2021 16:05:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210305224226.GA801@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR05CA0084.eurprd05.prod.outlook.com
 (2603:10a6:208:136::24) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR05CA0084.eurprd05.prod.outlook.com (2603:10a6:208:136::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 6 Mar 2021 00:05:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8dc3830-265c-4ef8-e0f1-08d8e0338f4b
X-MS-TrafficTypeDiagnostic: AM6PR04MB4069:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4069AF1457DF8B04F903FE5ADA959@AM6PR04MB4069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: slkPLnJdpsMfFYNoG7AZL9lzJGWarnHFrYixumQBiWMRm7a1KS68PfwtFygZ+jidOdSQWHOJoKBLd152U7++VuHnkhtsKFwSR8pkibEqRuy1CdEqkDG2/+fFzjVGlj9Yp/rOqxE5J9wfIpy1BWBcTtsLpvGCDJcrgI7VRqdqzhPpITllE7q+n+ZQvTXuFPJ5X+0alpj0vP2wnSg0rgRh9QS1Xivxnp78txdI6aEAMP5Ev6QMuojmi2+FjuYXU3C1we+/DAtiZpxkS8lB+nulUQLApQvKq2K225y04hDI0T2DVzDfrUQm7XsKYf3m8GwzQXPMS/bxaV2AMumuk8F9yo+mXIxJCzr9RY8lO7GOCbZw1DZIfXsBI+C5HTNT+Mmm4hL8s9PNDW1NOeSrj7NT4ALSWkl11IVQtyKAyo/UrJXFsWFyphWXNy00h8iZHYjU7PfuOY0AKFHzzEyz4Auw+rkWePZRAneM2DeMl6VgGugmMK2aFdyqub02QWhnpoEoYfhQQew+ajfSNVSi4dDZS0xzQpPBQegY2N4cCt2x5oRZbDHE6QKRVsBOAmQ4f5i352Osyd7Sr1bQNPLQ8RbLIDpq5dRcOHgfY3kFzbc5EfU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(186003)(4326008)(31686004)(16526019)(52116002)(26005)(110136005)(2906002)(316002)(6666004)(53546011)(86362001)(16576012)(36756003)(478600001)(6486002)(8936002)(66556008)(66946007)(2616005)(31696002)(66476007)(5660300002)(8676002)(83380400001)(54906003)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?JepuHGBReAb1sYc9H949jgtsRtwB9B4je+LG4vi7e9qEkdDCNJhgdoOG?=
 =?Windows-1252?Q?PlNingMdrZG3rHwD49HX8LZQVKvXa5Ws3U5LXLyUWEhmZ19+IsVEN2zB?=
 =?Windows-1252?Q?Q8WMuPp5PqOjmm+kC5MhKsCVJcQi+uBsAuRdecJ/CqHeRSv+1XRxpW0M?=
 =?Windows-1252?Q?3Klkl40Ww9mqSnopguseIOfkzoW0YLHskCPojp+zPwAvNLnX95G9gBY6?=
 =?Windows-1252?Q?UqH57PKJs3/vN9p1XUUfPddpiXOWsptQNn6DERJB1kbIIp7ag7uVsMq9?=
 =?Windows-1252?Q?pGfHEO9MFpDAZ0CFY+R2LHt2/nfpRxzGYTjc8wBUwyTzJ8/RqDPbqUrb?=
 =?Windows-1252?Q?PoPMKitSYFG98RNJ9pt1WthY1AjV8e7BlDktjl/DF3Wtc/q8fZwqfehh?=
 =?Windows-1252?Q?e80kuZVikpKmru1LHpLpRGO4kG7wf0jkbXaDlSKuDNW/QVuR7ae9DXCD?=
 =?Windows-1252?Q?+M0altsKb9MMFl74N+nEFEM25aP4X/1SzT6sQ9G1T2ygjNGUtxhcXDF3?=
 =?Windows-1252?Q?x91reBIfNYQ4MH7EiQ53D/r3lNdNZLUGu33SoBA/sgB1Zs0nB/p6L4iy?=
 =?Windows-1252?Q?M+jlFefpIF9vyPawJbLQ488bmGurYCKjaONDa2H7bkHYjBDFZBj8uB3x?=
 =?Windows-1252?Q?KwF5JKFp8cGk8UGt0+LoKl6EvvOdx1U/LJi5owIavF3J2xarg/dzs7j3?=
 =?Windows-1252?Q?+ZTnRYzeTOZhpgAAobYbtJiJWa/6U2DPmokdzVDg2Uq8y1wJuO8OoteU?=
 =?Windows-1252?Q?88xjUorqaMK7M2wMDVm+ABC5K10mm3aF/RkxqZrE6+vk0S8s3fy1tfcM?=
 =?Windows-1252?Q?R2MDkSm4DpcF56kIl8f3C/q12tWV1nbnlamzlVLbUjwq4okYmITqr5mL?=
 =?Windows-1252?Q?v8c3hrNjHgdOHRBe+Rrz5WhD9P3PPnuKtW7QgNlgwY/jHSlw34sHksAP?=
 =?Windows-1252?Q?OiuHmcOHnEtzJEE+2iCefAjuUotyMjb57V81+kNZbk20VIiGNKfkizgR?=
 =?Windows-1252?Q?cWTfspG/Y0es0vVgbinm2c5NR6cG1GgMVh1PTyY058ByNV26MQw0y8Nv?=
 =?Windows-1252?Q?snV24xLuf0ZzQACL8AC09+YcVPGVF9NxW55PlsIVSdfd3tzQweSgYuTn?=
 =?Windows-1252?Q?eNaWXk+oyiDToQ7+4D3GMv66SqbDENUTBjCeemOVWZ2J8ycYbaZLKKIt?=
 =?Windows-1252?Q?J96GsjTmZESrCFXp8ilgn5Mf8QEA4E4+H0gyGF6p2jjo1ft5VoAi31Ur?=
 =?Windows-1252?Q?/Q03jthqmG5EmW7fSzo64v7A+1oXuzGYYRkjfIn75oaFqI1bZYqUK2Mq?=
 =?Windows-1252?Q?mvbsNMlV6PpBF/XQI3IP0GMD6BKUe/gKnhDe1hrNgcPD7PxL4DopwJRy?=
 =?Windows-1252?Q?+7XMxSunfBNA0JvsNBmT2y2tx1KImp44FHk2wLrsDI2RucN6mh4zsRTO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8dc3830-265c-4ef8-e0f1-08d8e0338f4b
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2021 00:05:34.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SX69OFgyIP+Yv5j3Gu4H21jTRPHAIPeXM/HL0yTjJjD9HEWLbzoHRke4Tl+cNEukUL6wekHDngK3kevoBw2SXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4069
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/5/21 2:42 PM, Pavel Machek wrote:
> Hi!
> 
>> From: Lee Duncan <lduncan@suse.com>
>>
>> commit 688e8128b7a92df982709a4137ea4588d16f24aa upstream.
>>
>> Protect the iSCSI transport handle, available in sysfs, by requiring
>> CAP_SYS_ADMIN to read it. Also protect the netlink socket by restricting
>> reception of messages to ones sent with CAP_SYS_ADMIN. This disables
>> normal users from being able to end arbitrary iSCSI sessions.
> 
> Should not normal filesystem permissions be used?
> 
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -132,6 +132,9 @@ show_transport_handle(struct device *dev
>>  		      char *buf)
>>  {
>>  	struct iscsi_internal *priv = dev_to_iscsi_internal(dev);
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EACCES;
>>  	return sprintf(buf, "%llu\n", (unsigned long long)iscsi_handle(priv->iscsi_transport));
>>  }
>>  static DEVICE_ATTR(handle, S_IRUGO, show_transport_handle, NULL);
> 
> AFAICT we make the file 0444 (world readable) and then fail the read
> with capability check. If the file is not supposed to be
> world-readable, it should have 0400 permissions, right?
> 
> Best regards,
> 								Pavel
> 

I am ok with changing file permissions, but there's nothing wrong with
checking capabilities upon entry, as well, since capability checks are a
higher degree of security than ACLs.
-- 
Lee Duncan

