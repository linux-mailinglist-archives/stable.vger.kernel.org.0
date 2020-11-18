Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB832B8245
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 17:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgKRQtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 11:49:19 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:38895 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbgKRQtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 11:49:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605718156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFAZ2glMe4fb0ZZ/IpT7cU/87KXmO1qMUmV5wr2JiGo=;
        b=JjH6C5tge/L4pH+R9YWpUBBzCQ6O89ikU2Aht7d+QdHNqI+A26x5v6ggWZVkO65fOoeis8
        zlqFzE9dxAYyq5d+QAlryo1kS2GebratlyQCmPa4yz/bSOFvqwKNnwEvKZN+4qmPDGAW6l
        8UNC5M/RjaNJEfX2vWoZZtXfPYc3Wik=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2051.outbound.protection.outlook.com [104.47.10.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-2-KhHlFzPXOd-0LP6DinC0lA-1;
 Wed, 18 Nov 2020 17:49:14 +0100
X-MC-Unique: KhHlFzPXOd-0LP6DinC0lA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIXp8mowr9YCHxVxT/PGJrP5rRF4ur0R95ByKIg0uu6rJ2AN6l++WwypamU4QBrouOALBntdBtIbbNbN9ISPyKZE+CSkhBHlxoZUSLhOktcgqC1Jl5GA9uw9HXFmpUGUbkw6Cxp0ZO3CkpsYtu+Re6s9WI/3mCfQq6zO2unjleqZAkKPkVhByi0ajhso+lhUeX0LkugtXth2IPtiLbUCc5fWDh/B7E+m6L8hy7W0bV1VVhHn1yq8dDtTBh58qgSNEcMMVuvFehqELKyrBjVzfVQeGCVT458sojaPWrwhYv0/fycVYkkvTlM3T9ZznSKanGVyl3JvpVlpCjpH7DU9dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFAZ2glMe4fb0ZZ/IpT7cU/87KXmO1qMUmV5wr2JiGo=;
 b=a++XMGann7FSD+FMg6xOl5OUrYxZK2kJSxJlPJffDt8cN0/q+0kq/1BbSAgEAKY1B5WiJPDrnpOAnHd1dqtKDR9h69habMrmgKqA4tBXUJX6+NdRtmXa/bJ5529buwSP33CYXY263ax2YSjjysv2c0kP20pyHHtq2/6SdSLDQMMJWvATUQvlj1XutP5tm5ZkHazK3uCOQBf343fQ0SRhkywD16lf1wW/gbXpd7+sKthmNcxUDlKsWR0vXhdNiojFspFoxMByokpoK7C9aX3MZjWgGp/amsAlVQXmqg63ZgWueetq/aOi1nuoqwQ1/B0w74ys2yA3uGvbOtXQsVaw7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0401MB2280.eurprd04.prod.outlook.com (2603:10a6:4:48::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20; Wed, 18 Nov 2020 16:49:12 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 16:49:12 +0000
Subject: Re: [PATCH v4 2/2] md/cluster: fix deadlock when node is doing resync
 job
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de,
        stable@vger.kernel.org
References: <1605717954-20173-1-git-send-email-heming.zhao@suse.com>
 <1605717954-20173-3-git-send-email-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <4b617cc2-e06d-9221-f3e8-6dad9f0fc94f@suse.com>
Date:   Thu, 19 Nov 2020 00:49:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <1605717954-20173-3-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.135.93]
X-ClientProxiedBy: HKAPR03CA0011.apcprd03.prod.outlook.com
 (2603:1096:203:c8::16) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.135.93) by HKAPR03CA0011.apcprd03.prod.outlook.com (2603:1096:203:c8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Wed, 18 Nov 2020 16:49:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 090a5ce5-5ba8-4429-d7a7-08d88be1e055
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2280668AE61C255AEAD57BF497E10@DB6PR0401MB2280.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cgO+RPWywGG8DF4V4qMl+Fq4qYcY4spTmLCdr+OcSg4VjtuX8YGJ+85oiUwoFhcKx7C+PPvFvttg/FWMLGuFAD0dKO8UuZ/yqsMIahQxK2uvhoYiyLwFQR7kKWqdndkOcsmCAwqH7mqBbEGk8jo70MUczj0qWRv23PCAs8OS7CSl9QRJ+RUMncEej8jTJHaeSArPITsgS1g1Ei8h55H/W+VltGCNrm7e0RB8BcVF0TFyozuTgbnERQsSfyIGYMPMDiAZYPcm1FMVdsJadIBJ6UjCgDZNF9ij9+ZcIiOf54FhpIiBtq8HLHu7KvoC8U1Q0r4hSLbOwkLHeHVwUG5ndRD4guATciIFLUAq6cpNjGidiVo5gLtIS3V1EVJZqqvQ5EvJRDbxugCL8hDhk0fWcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(366004)(39860400002)(8936002)(6486002)(6512007)(4326008)(36756003)(66556008)(66476007)(8676002)(2906002)(83380400001)(4744005)(5660300002)(31686004)(8886007)(6666004)(66946007)(6506007)(52116002)(31696002)(186003)(2616005)(53546011)(16526019)(956004)(86362001)(478600001)(316002)(26005)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LCM/zxQt4zZrZGli3XGGWEpe7Cu4yxYCrynPILhaedgpDkTN8doJuU2+NhljPo++oTY+mNEOKwP+H1xNk9ytMNNHPjW0rEM9m+kntA0DxzMzq6nsVPWh3qga4TeILTp61Iq7/ih7yBLWn/h7qe4LD6DCZYAbqcjBECnACEUAVmBO2KVH2YaFkW9MC+MWkqivv0QUohEiYyfOfdUsyUVXGA6rigC53vTnS8cevPS9LwZblutBnKWGpMKKGljYwy0aEyyxakllgQL5wNGVB+XEJ6wuJcGHw2AIsAJdW2cKL62JuudlqVKgvDSvlyntKb9i5pugq7qHwQTtD6bcR2Xo06/XIGw6jGGq1lX7cny7V7HkgNST+idICqS8jpiZ4kr4voy07kUUpMhmx5e/UJhFaji03uIgZMhGZ09aWR+vuG7iJlJigq/BeOJVY+Y8HvdLJQPvkmW4i7aqh+FiiWnA86bOVtJzz7zFXnW7S9IQAbT59KCjeZXlFEzQn71jIVfhlFzsZuYYoah+X8m7SEvbm5BHYpA7CcTGZtNqTgjKhzIKpClHZyIZozD6X7U1gM2v02R4wBVVtAzg/maUerkwXv9NiTxTcRv5/CSY/NVbERFmVY4FMOTaae3joAGzKlCHX4EQWLFcvwEgwQZ9pYCTpQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 090a5ce5-5ba8-4429-d7a7-08d88be1e055
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 16:49:12.1819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CNKAyqVgTI8Laff1gs+ou2EjYdvzTlGpkkjkgtrn8Tf8hwC6ucFK3oGciHXc7CldgMnlL5m7rkwh6EOlxIbBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2280
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/20 12:45 AM, Zhao Heming wrote:
> md-cluster uses MD_CLUSTER_SEND_LOCK to make node can exclusively send msg.
> During sending msg, node can concurrently receive msg from another node.
> [... ...]
> 
> Repro steps (I only triggered 3 times with hundreds tests):

sorry to send v4 patch so late.
I spent more than 2 days to run test script to trigger the deadlock.
The result is I failed.
So I wrote "I only triggered 3 times with hundreds tests" in commit log.

> 
> two nodes share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB.
> ```
> ssh root@node2 "mdadm -S --scan"
> [... ...]
> 
> At last, thanks for Xiao's solution.
> 
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> Suggested-by: Xiao Ni <xni@redhat.com>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md-cluster.c | 69 +++++++++++++++++++++++------------------
>   drivers/md/md.c         |  6 ++--
>   2 files changed, 43 insertions(+), 32 deletions(-)
> 

