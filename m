Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A68B198524
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 22:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgC3UMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 16:12:16 -0400
Received: from mail-oln040092066093.outbound.protection.outlook.com ([40.92.66.93]:20814
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727936AbgC3UMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 16:12:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOeH6q9Pw4UfUolU3FG8E+DTYTwCs6cks2euWeVeEjImp043+97vWCRrz3Vu7+GwV+dMiTjn+6+ZQ+mYxBEtC/rFuALxzcqkdYq799uKO5yuRyf2w/fr9wJrFeNRbkzyCK8qD+V4uXGhCDy12THm/f5FW4Xwx1XrPbK3MkKXbzxXfmNQ36mmw0s3JRuEpCjhOM/q3SD8vrIkwrZJyZ7o71LjDZj5H+i0mRUsPcT+EAEIc6KG3+fgHdWrQCjk75E2YN949TgrZNx9b6bB5xPQ2W1cdyAQrovIoWMgkvx0UsM4IjYaKQkrXWMBFLYUXDKastWAan1EcttdceV1OQ935Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QY20wkbTECKknCtHuEVYYjfKaKwEgR2syI5IO9o9Wis=;
 b=T1dJk9wRgXRrQzWyjtTbov6TY9wZI6/bIPHLtyHh5tc1M97XYgqLtzYZC5zY1xr8sWlLYjhvzf8LhDpYZO76jHSs2xuxrQ2LNPCMtJ537doy1wPoUqrHCHXryH+YisGLxHWE8rOexMpHPGNVjG48rcPTyJnlq8VSIFrV8DLJA9lg0nv26f/QGVP4NwkEBrhz3YfUdhNr+49lLu0zKX2AfEmjEDoHbfbGImcI+P5NHErPRjl+2ZpxAWbojRrdZ5oabeOoaaBSIOWE4S9iaD5XLPkgfMqnj9ODFeZH/uXbAArmffaTjnJEWsoBcYtIh41NYinNkwBZDHoC8INkLoOOXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT041.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::42) by
 HE1EUR01HT210.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::404)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.17; Mon, 30 Mar
 2020 20:12:10 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.59) by
 HE1EUR01FT041.mail.protection.outlook.com (10.152.1.3) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.17 via Frontend Transport; Mon, 30 Mar 2020 20:12:10 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:5C10619DE06FB18EBA2A572034494D5D28086595289E9E30D5A0689264668C15;UpperCasedChecksum:75776C321DD5D218A6B3AD95947316D47F2B43C8009A66B758981C9B6703D265;SizeAsReceived:9584;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::d57:5853:a396:969d]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::d57:5853:a396:969d%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 20:12:10 +0000
Subject: Re: [PATCH v6 00/16] Infrastructure to allow fixing exec deadlocks
To:     Kees Cook <keescook@chromium.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
References: <AM6PR03MB5170B2F5BE24A28980D05780E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rpg8o7v.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170938306F22C3CF61CC573E4CD0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003282041.A2639091@keescook>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170E0E722ED0B05B149C135E4CB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Mon, 30 Mar 2020 22:12:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <202003282041.A2639091@keescook>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0128.eurprd07.prod.outlook.com
 (2603:10a6:207:8::14) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <72b14e08-e50b-3075-1047-0a6510d57c50@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM3PR07CA0128.eurprd07.prod.outlook.com (2603:10a6:207:8::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.12 via Frontend Transport; Mon, 30 Mar 2020 20:12:05 +0000
X-Microsoft-Original-Message-ID: <72b14e08-e50b-3075-1047-0a6510d57c50@hotmail.de>
X-TMN:  [+IieYLSn8lVXV0cd97FHsOILQoLiJBTR]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 17d40dfb-0e09-4ce3-f2b2-08d7d4e6a0a3
X-MS-TrafficTypeDiagnostic: HE1EUR01HT210:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LxuY+xxE9tv/Zd9FzAmKlqdyk3piy55dJunAxgRuNp7kqP+zqWXi2D5dkUwabu58STdmilbi81urjc4zGlTBZB9SvIY81DKkwH0B3W3Mvd9t6uvutOZKdvYD5nEmhGxM/T9BTDbpEkktPbTyeRWvY7nHHu6roxfDOzyN3+lGtR/KJDxB0MnwP/BybIpKdEaP
X-MS-Exchange-AntiSpam-MessageData: h/kaRwQy6v3PPoT/8zXLpPysB4kIPtakBqEuZDwlGZRFHCg/LdOfhCaP293jwFcom8kK5GWlfLhVHtHsxl65sLqKxiwkjPb1mVmUcBF9s/AO+JUt84a5c5mu43EbUry3emf2igtL112TCAZ/N+EJDA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d40dfb-0e09-4ce3-f2b2-08d7d4e6a0a3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 20:12:10.5846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT210
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/20 5:44 AM, Kees Cook wrote:
> On Sat, Mar 28, 2020 at 11:32:35PM +0100, Bernd Edlinger wrote:
>> Oh, do I understand you right, that I can add a From: in the
>> *body* of the mail, and then the From: in the MIME header part
>> which I cannot change is ignored, so I can make you the author?
> 
> Correct. (If you use "git send-email" it'll do this automatically.)
> 
> e.g., trimmed from my workflow:
> 
> git format-patch -n --to "$to" --cover-letter -o outgoing/ \
> 	--subject-prefix "PATCH v$version" "$SHA"
> edit outgoing/0000-*
> git send-email --transfer-encoding=8bit --8bit-encoding=UTF-8 \
> 	--from="$ME" --to="$to" --cc="$ME" --cc="...more..." outgoing/*
> 
> 

Okay, thanks, I see that is very helpful information for me, and in
this case I had also fixed a small bug in one of Eric's patches, which
was initially overlooked (aquiring mutexes in wrong order,
releasing an unlocked mutex in some error paths).
I am completely unexperienced, and something that complex was not
expected to happen :-) so this is just to make sure I can handle it
correctly if something like this happens again.

In the case of PATCH v6 05/16 I removed the Reviewd-by: Bernd Edlinger
since it is now somehow two authors and reviewing own code is obviously
not ok, instead I added a Signed-off-by: Bernd Edlinger (and posted the
whole series on Eric's behalf (after asking Eric's permissing per off-list
e-mail, which probably ended in his spam folder)

Is this having two Signed-off-by: for mutliple authors the
correct way to handle a shared authorship?


Thanks
Bernd.
