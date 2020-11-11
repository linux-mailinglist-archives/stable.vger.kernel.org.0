Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256A72AF30A
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 15:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgKKOFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 09:05:24 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:40373 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726207AbgKKOFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 09:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605103504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=2EqwU5lyCpw3yx89pS33vjhQ3E6HsFpgD3u5rpGf9L0=;
        b=XqOWW2388lE804X/YfZLUGli3hyNpAitJoKKvprYsm1+kbyaHjyxIvL+DnWVYZrwHMu1IV
        1MR6B4eoyxobrt/wVhVAxgvsipg8VbluM445Sw5cdbu6tYXTnF559kXpdnMcgNUk5m10Vd
        kO+9Teu8Ogvk4Y14E4CGayAk8By7T4E=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-zn8xl2GJO_GqV_ayeGURVg-1; Wed, 11 Nov 2020 15:05:01 +0100
X-MC-Unique: zn8xl2GJO_GqV_ayeGURVg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yz4qLdjfngpIc2wgUoiXSharoCswefeBT17F7WTZPollQkljm7PTGO/fnWdCiRfqrk5SzSi30z4UA4osgQWLFdaMJq+a7hQJFGsGarSI/OZq2HZynlHX59QFRj8LunwCRDDwlIMW/u+RZzEkePKN/H5U81lZnKHxqaCIErX6FKWJafmlFB4UR6Ko14H2d2xVVsZHVHIA1G7FMfjqYxZO4LEyx8Mmg/p0bq77lvuCJDzUavD04Vk0qgAvGbGfCAUKU311dSVd5oqU1etpVm1ypuXTl9IKIDCtok4L778b/xiuWG839J1icI+kmkD91hjtUyAm7nFb+V3mbx8n3laHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9eSEc/2xwWIriSOL7DWoa4dyMxgeIS9EoINZYCBKC8=;
 b=Wdt8nr3TUSRzhA9RtJIep+V1/y+nrfqvetpE1i4cM5uDvSGxwA2S7TuyzkF8JL7oms7wRZVthefRl2YnrGSEDLNaPXMJ3QbSGJ7vE8n9HVZqYWR+qjy8rP/ChScGZWk2n96BLPh7vzuMHZAIOHPYoYkqp5jZz8HoSt7gRiYpuj0FC7hV6YeR+Db0+Kx2aswBjAatywMqPDMTmSckmtRfWsL0QYdNLtVwm5wB3cWqk46glnhqwyegxo405J4EYYJsvE8hlZQH0XUs2nou+tDGsEUMH6o1q3nsAKisnNx0cjkpD1oLa0v7QSOMbjBqAR2sypz4UYa+elUL9OOxzwh7bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: codethink.co.uk; dkim=none (message not signed)
 header.d=none;codethink.co.uk; dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7533.eurprd04.prod.outlook.com (2603:10a6:102:f1::19)
 by PA4PR04MB7551.eurprd04.prod.outlook.com (2603:10a6:102:e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 14:04:59 +0000
Received: from PA4PR04MB7533.eurprd04.prod.outlook.com
 ([fe80::545:8a04:2a5c:f4c7]) by PA4PR04MB7533.eurprd04.prod.outlook.com
 ([fe80::545:8a04:2a5c:f4c7%6]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 14:04:59 +0000
Subject: Re: [PATCH 4.19 29/71] btrfs: tree-checker: Verify inode item
To:     Pavel Machek <pavel@ucw.cz>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
References: <20201109125019.906191744@linuxfoundation.org>
 <20201109125021.272942487@linuxfoundation.org> <20201111131340.GA28106@amd>
 <0a9548c8-1866-fa2e-59a1-54be518c3fc0@suse.com> <20201111133820.GA29099@amd>
From:   Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0GFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPokBTQQTAQgAOAIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJdnDWhAAoJEMI9kfOhJf6oZgoH
 90uqoGyUh5UWtiT9zjUcvlMTCpd/QSgwagDuY+tEdVPaKlcnTNAvZKWSit8VuocjrOFbTLwb
 vZ43n5f/l/1QtwMgQei/RMY2XhW+totimzlHVuxVaIDwkF+zc+pUI6lDPnULZHS3mWhbVr9N
 vZAAYVV7GesyyFpZiNm7GLvLmtEdYbc9OnIAOZb3eKfY3mWEs0eU0MxikcZSOYy3EWY3JES7
 J9pFgBrCn4hF83tPH2sphh1GUFii+AUGBMY/dC6VgMKbCugg+u/dTZEcBXxD17m+UcbucB/k
 F2oxqZBEQrb5SogdIq7Y9dZdlf1m3GRRJTX7eWefZw10HhFhs1mwx7kBDQRZ1YGvAQgAqlPr
 YeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4KXk/kHw5h
 ieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T7RZwB69u
 VSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9fNN8e9c0
 MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD/dt76Kp/
 o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgBCAAmAhsM
 FiEELd9y5aWlW6idqkLhwj2R86El/qgFAl2cNa4FCQlqTn8ACgkQwj2R86El/qhXBAf/eXLP
 HDNTkHRPxoDnwhscIHJDHlsszke25AFltJQ1adoaYCbsQVv4Mn5rQZ1Gon54IMdxBN3r/B08
 rGVPatIfkycMCShr+rFHPKnExhQ7Wr555fq+sQ1GOwOhr1xLEqAhBMp28u9m8hnkqL36v+AF
 hjTwRtS+tRMZfoG6n72xAj984l56G9NPfs/SOKl6HR0mCDXwJGZAOdtyRmqddi53SXi5N4H1
 jWX1xFshp7nIkRm6hEpISEWr/KKLbAiKKbP0ql5tP5PinJeIBlDv4g/0+aGoGg4dELTnfEVk
 jMC8cJ/LiIaR/OEOF9S2nSeTQoBmusTz+aqkbogvvYGam6uDYw==
Message-ID: <c6dd6263-85f8-6728-5a19-6e19d972ecb8@suse.com>
Date:   Wed, 11 Nov 2020 22:04:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201111133820.GA29099@amd>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [149.28.201.231]
X-ClientProxiedBy: BYAPR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::44) To PA4PR04MB7533.eurprd04.prod.outlook.com
 (2603:10a6:102:f1::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by BYAPR05CA0103.namprd05.prod.outlook.com (2603:10b6:a03:e0::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Wed, 11 Nov 2020 14:04:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6caf3819-f961-4d02-368c-08d8864ac6e5
X-MS-TrafficTypeDiagnostic: PA4PR04MB7551:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PA4PR04MB7551E8B7136341B2E89F5574D6E80@PA4PR04MB7551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UbHEkFnBJdJHhNcf8v8Ma1sz1UVoFEZBWrWAPbI0lMuN5+hCJzTNXtrGslwecAIXT5ifT4W+Uy8f2uRjJEEEDEl/KvVa0jtAhFDo365pAWTdqsOO4WlwGA+yb8mxe8GG2dzBz3F7/VlmjkUkfnAeqo+RToxO5SGjY2sL/3p1S9lBmyKtRTmC9HP5RLEQiWxXDhOGTfYpMgoDi7j1lzKMLASgZTOzBnBmE87FD6rDo7N8Qez0t2C76TEjjO9u781fucghJBU9GxiViGgSgw7SUJAqQHrZYBhq72Ls5XIE9xvLKg4vkfMcyWAQGoT9LjYy/TErEZ6FH0vj20hyvUDaldWum6BxQ0f26hmZiOvx+CSUgxrpOucKiyuPfmzpZLHmasTVQUOKcllRDkw90N+8oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7533.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(396003)(346002)(8676002)(26005)(2906002)(54906003)(478600001)(86362001)(6916009)(6706004)(8936002)(36756003)(31696002)(5660300002)(66946007)(66556008)(52116002)(66476007)(186003)(16526019)(15650500001)(956004)(6666004)(83380400001)(6486002)(31686004)(316002)(16576012)(2616005)(4326008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CMp1K8XKKlHbUCUNjD+1MFS/otPKN59UeCm4R1KE40o+uMu4EeEibyyODXuNCOdK+3H5Ty8c+xKMq9CsL2jQ3A+eZzvn3tYTvv6rMoYdds6sl8oGO83huTd2zQcyt3L6oRYHNro+yvFuyJjHCO9F6JFCkUtJ6Dw1yFF9f1St2zJPL2WLBxG7vh5Xy/5e/73UqK23FiaebyMka9p7XJNVCQeMV5VJi43apcc1dIfvRN/Ou5ZGI4CfJ7/b4G3vxd/pX12GHacA8EdcI+2BRyzh97gQhiseqLO5z57FHinJ8E88ekgFXAVUixDUTqH52ZuvUulh8iR/u9kvPv9NlEIw9N5Xg5ni/w5EWWs0fouyBQhBSh+bQK79Y71xT7m6Kc4WG0FNOZyL1xF7D/l7oAv9HoBCGNXmu9+v6Ehed9p1mK4P0P1ztY9OvNuwJZiJRVuhEIpULfDvgp4nIIDB3H7ExCe7L4jgdyoKIalEPgULsjwCPb2JswZrdRIdyyFfZh4hoJhnoj0prioHq+oyPFXlFbbH516UXEULBU5xbuSpsDTdDXLPctB7vLH9SHCDx8D4UVpTGz8fuizZdwk32Q2D9TmK/i4qs1g7VbCLIOfeUQctBuRjaeGR1Yd3Bt1GAbkuynEyGkQojvNCvECTz7jdzaRoUj0jWXupugetKfvzhUpZqu+6EjTDAhytRkskz7C+cWUuO0JE0oKGaH1cyE727ABYuOr8rNH2IZCYRdTG8aeDVjrshdap+eLGSlaIfI9Ffa6WsMZjWaoTwiRAn1wbAra7eRB8jdDA7Z2Mi5As28kLISyTLgnSlYcXpF5adLRvPWOrFep483N+/hkwdx+IA8TvRnUfZoanzycNtaYoYOLiI6zxy4VbM2mpemG6x/1RRs3JODp6GOs5aYWgyrdhuw==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6caf3819-f961-4d02-368c-08d8864ac6e5
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7533.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 14:04:59.6473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/sZeKeo4Ceb0oNDGGT8ePil0A5ozuupbChp295ie+uIz5Q4lrFhERj4XzCT5Xnd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7551
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/11/11 =E4=B8=8B=E5=8D=889:38, Pavel Machek wrote:
> Hi!
>=20
>>>> From: Qu Wenruo <wqu@suse.com>
>>>>
>>>> commit 496245cac57e26d8b738d85c7a29cf9a47610f3f upstream.
>>>>
>>>> There is a report in kernel bugzilla about mismatch file type in dir
>>>> item and inode item.
>>>>
>>>> This inspires us to check inode mode in inode item.
>>>>
>>>> This patch will check the following members:
>>>
>>>> +	/* Here we use super block generation + 1 to handle log tree */
>>>> +	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
>>>> +		inode_item_err(fs_info, leaf, slot,
>>>> +			"invalid inode generation: has %llu expect (0, %llu]",
>>>> +			       btrfs_inode_generation(leaf, iitem),
>>>> +			       super_gen + 1);
>>>> +		return -EUCLEAN;
>>>> +	}
>>>
>>> Printk suggests btrfs_inode_generation() may not be zero, but the
>>> condition does not actually check that. Should that be added?
>>
>> Sorry, btrfs_inode_generation() here is exactly what we're checking
>> here, so what's wrong?
>=20
> Quoted message says "(0, ...]", while message below says "[0, ...]". I
> assume that means that btrfs_inode_generation() may not be zero in the
> first case, but may be zero in the second case. But the code does not
> test for zero here.

Zero for inode generation is more or less in the grey zone.

For inodes which can be accessed by users, inode 0 may cause small
problems for send, but despite that, no obvious problem.

For btrfs internal generations, it can be 0 and cause nothing wrong.

So here we don't check inode_generation =3D=3D 0 case at all, or we could
lead to too many false alerts for older btrfs.

Thanks,
Q

>=20
> Best regards,
> 								Pavel
>=20
>>>> +	/* Note for ROOT_TREE_DIR_ITEM, mkfs could set its transid 0 */
>>>> +	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
>>>> +		inode_item_err(fs_info, leaf, slot,
>>>> +			"invalid inode generation: has %llu expect [0, %llu]",
>>>> +			       btrfs_inode_transid(leaf, iitem), super_gen + 1);
>>>> +		return -EUCLEAN;
>>>> +	}
>=20

