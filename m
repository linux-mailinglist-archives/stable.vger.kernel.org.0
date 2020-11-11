Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EFA2AF252
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 14:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKKNiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 08:38:17 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:39411 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726854AbgKKNiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 08:38:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605101880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=xI3EIDeISKqQr6pa8p3O3K1vkhzbauM4ZzBLjxLAaeM=;
        b=k11OouuPqTld1rHJjh0dcWSbYOgI2NS+W6591AEWU0CQKOnQ3HxX/dKNAapbE3173mdiaj
        MoFqTCkRirI1Oghn7UHQsEMpeuIERbhQ7UFupYDYrzOpiK1aSUz35cz2Kzs2LN1AKhCicZ
        dCmm13Y09xyhT91C5lPp9hD+N4WsBZs=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-pS4LqmWPOK2FirrYE8Iflw-1; Wed, 11 Nov 2020 14:31:14 +0100
X-MC-Unique: pS4LqmWPOK2FirrYE8Iflw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jB5nwyefpEinh4WYDAmSQjk5jqsC3NjnWNIdBkoHlbPkDHdHipFO5W+LAQcXkmpukW0j6Dqp62xK8fopBEj/ysG7LR/dQf871kNoQayszQiimSVybo55p0HJWziPVwFcWpI1oVVLfBg0kl9SJMm92PdV9IYmhFQFtbPQ4tOBUoZQiQjTzAcjZf/gZh0Fz19/Xq/bEzPF5AnewitgN0kAay2PNiPKD+4ny8yOjF+UgkOXo8MYp37KNNjHWAYtffqYbGXFuNoQcmP2lhmDw1m0SQsdBo5adXkEkZuxYzvsLByPV6MND1ZL7x0SaSdY7uFPCr/eUs0ccsOir11QX1ldVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4c4EROxzyW7xzpZSSKYq1YdN5VzkkQCD8J2mSvLpwE=;
 b=eqx9oNPuSMLlaBz0VbQMrWtsLfBl3M4yHREgQtciKzSeI6fTFDaoyYWFHoB8YFU42LDCCWLk4O/VIU5bXXfbtkc14vlhtUFMb+BPTfmOTjMa9z7tjPAgiBpiLtmHTY1FcyHs8rrmjMduSTAsQ7RcW3gFkSkW9MXWTZICc3jDEK+w4VGgbGuQ+GGzwY8enDKFEm6HJPi003DTqx4mCNCavfvLoCDmoLs75VbUD/KgKSNu0fbGzx2WZK94U2q7h0+vCz/AQuhs7XD6vyeFDB18HpjM8+J6ld0mA/5hxVdzkJgQQWFVxWDC86qIZqSfsWJhx2a2CwEAo4K80b4o55VTgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: codethink.co.uk; dkim=none (message not signed)
 header.d=none;codethink.co.uk; dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7533.eurprd04.prod.outlook.com (2603:10a6:102:f1::19)
 by PA4PR04MB7551.eurprd04.prod.outlook.com (2603:10a6:102:e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 13:31:13 +0000
Received: from PA4PR04MB7533.eurprd04.prod.outlook.com
 ([fe80::545:8a04:2a5c:f4c7]) by PA4PR04MB7533.eurprd04.prod.outlook.com
 ([fe80::545:8a04:2a5c:f4c7%6]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 13:31:06 +0000
Subject: Re: [PATCH 4.19 29/71] btrfs: tree-checker: Verify inode item
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
References: <20201109125019.906191744@linuxfoundation.org>
 <20201109125021.272942487@linuxfoundation.org> <20201111131340.GA28106@amd>
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
Message-ID: <0a9548c8-1866-fa2e-59a1-54be518c3fc0@suse.com>
Date:   Wed, 11 Nov 2020 21:30:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201111131340.GA28106@amd>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [149.28.201.231]
X-ClientProxiedBy: BYAPR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::34) To PA4PR04MB7533.eurprd04.prod.outlook.com
 (2603:10a6:102:f1::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by BYAPR05CA0021.namprd05.prod.outlook.com (2603:10b6:a03:c0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.22 via Frontend Transport; Wed, 11 Nov 2020 13:30:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2acc6e63-ba41-4dec-35af-08d886460adc
X-MS-TrafficTypeDiagnostic: PA4PR04MB7551:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PA4PR04MB7551C501456FC142ECD96966D6E80@PA4PR04MB7551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PHzjgkM8egli67qoZEAcMyigW+gelRdsfWrLdnUHRyOs6Q/yIvS8f2Bkz6L0KKPcwG+gIZ2D3izriFZe0hoDfIGc0GFrMHSxHRJcuNT0esYXizu19rX/4EbNyPo3TMIu/uK5LmXtYnZc4j+Z0bb4GZPbLRX5xz3Bkb8aXVf4p7Wqm//fbX169yI0/rIVy2HkM+f8a/N+RAWF9PT5LxNJ3hRxmY+hm24XzeZ/7UEX0adwXT0IHFWbr2PcaTfpQUoXonowlBklVTpwmQLkawwTSo5rZJN9BKQkM3iONdlsKCdZJikGn6/VGTGl2j/ErzIvfeA+xa/Lq4lAwwNKqmjgDCJsrl7Fav4yQPk2QQ4A1iuPGcqpSFw3nUaWTtUnWnULEkp5URCf78nVFhsdgEaB/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7533.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(366004)(396003)(346002)(8676002)(26005)(2906002)(54906003)(478600001)(86362001)(6706004)(8936002)(110136005)(36756003)(31696002)(5660300002)(66946007)(66476007)(66556008)(52116002)(186003)(16526019)(15650500001)(956004)(6666004)(83380400001)(6486002)(316002)(31686004)(16576012)(2616005)(4326008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jHqyaIaCbJEruz/koVRkJpPRlvSVi091TJeysGWotVMTXGHxD5UsGgHMLNIhotvspzNZG6jUgzX8tjsBKJgYsrOiCs+j4da9Wt7YmE/6Erb0IXMXJ5tTJzfU7a+xSZhFpCterSjVv4CAZNCLZTSwEhshbrk38/aoAc9s9RVdOscjf5SlWLNVRRxDXh0dZLyO2FdhT80vUWgMbLiOL84g9G5ohoUAO6iMRj0uthV/kCrOHj8/gCibWLfWXF30t3kU6Kt1y4PRMgQLlVTFqvf48r/jqZUFr3ldSx6lucLTHhxHyFFScKWE0yFU+AFgaP4iTaCt3ciq2KXWZcpXpEfuEJRk54Mz36KjFw28F9GXomxPhcYYCdqtjNbpS51pClBRO9kUDTb4BJW6XUhSu6leeBVHyJGxui0op5E/oEkoS7YWQ78yWBVWpPafqYJjHmjHpNJvYPFolCmO47tB9MI3/fVRTxuvydK/A0cx5+eXhKLex+KM2yHl56HWlRwplvs0JYZvSuywTsgyWirutPqlfASvygavLojJPXb6o8zySPftrC3VWGo8GGV32piAPJ5VGDHwvtOCOzusheb/U2a+GcYH5wKVcd/cCcEtP3SPSdVnb8XDEkxuJMYmVipjrnAyYCpHi2Zm8mJpxTXoDOaO+ISogwS8PwUfjf9iyOgk5wh0ROHLpbNVZYaDGzWoc0izxDaks+vf4W2Z8NazcgIOxa4i4Ck4kTacE97cO/2rZf8drBk8pvxACxGIYH7a7XvD3teuU5S908p3QlxZKVGJ57rdvYo6ZuXojvVZG5KSFsMfmEWFEa5cAY3g+wP/3cWac9/GHMX4ZFq7A2T74OKdmpJaDkskP5eR3d7JIFk6rHf4HM22DL1fjaWVoqqKU55Xf+pjWmltBMwiyA786XUUrg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acc6e63-ba41-4dec-35af-08d886460adc
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7533.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 13:31:06.2226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymGrYfQYUGFu341BfIG+oTk08F1A9ycPwzW76BDaLGcjfqael+vZu3nhkExCzNdQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7551
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/11/11 =E4=B8=8B=E5=8D=889:13, Pavel Machek wrote:
> Hi!
>=20
>> From: Qu Wenruo <wqu@suse.com>
>>
>> commit 496245cac57e26d8b738d85c7a29cf9a47610f3f upstream.
>>
>> There is a report in kernel bugzilla about mismatch file type in dir
>> item and inode item.
>>
>> This inspires us to check inode mode in inode item.
>>
>> This patch will check the following members:
>=20
>> +	/* Here we use super block generation + 1 to handle log tree */
>> +	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
>> +		inode_item_err(fs_info, leaf, slot,
>> +			"invalid inode generation: has %llu expect (0, %llu]",
>> +			       btrfs_inode_generation(leaf, iitem),
>> +			       super_gen + 1);
>> +		return -EUCLEAN;
>> +	}
>=20
> Printk suggests btrfs_inode_generation() may not be zero, but the
> condition does not actually check that. Should that be added?

Sorry, btrfs_inode_generation() here is exactly what we're checking
here, so what's wrong?

Or did you mean the next chunk of btrfs_inode_transid() check?

That error message is wrong, and we had upstream fix for it:
f96d6960abbc ("btrfs: tree-checker: fix the error message for transid
error")

Thanks,
Qu

>=20
>> +	/* Note for ROOT_TREE_DIR_ITEM, mkfs could set its transid 0 */
>> +	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
>> +		inode_item_err(fs_info, leaf, slot,
>> +			"invalid inode generation: has %llu expect [0, %llu]",
>> +			       btrfs_inode_transid(leaf, iitem), super_gen + 1);
>> +		return -EUCLEAN;
>> +	}
>=20
> Best regards,
> 									Pavel
>=20

