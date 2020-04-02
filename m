Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DA319BCF0
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 09:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbgDBHnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 03:43:16 -0400
Received: from mail-am6eur05olkn2063.outbound.protection.outlook.com ([40.92.91.63]:14464
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729030AbgDBHnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 03:43:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2cUts5N16McRkteTSJ4tPxLs8Gq2KfmcQbL/xiRX18vgKFEUGxoUfHE0AQygrHTljDRlY3PknSNTlE9Vp27/ZJouN868WZZu9Wy46QbUpe/n9a2Mwrz6zjU/9+kEJD5Anfa3mCEeeLyS35DIa0NuZM/RAdrPzdsM/gPNhkeYGN2aasS7gNo+1fowto9MGTablBHNYNuG1Kc4JuAzjY5SLLqvzFmxCtLIG1abrbs2N6H2lYI17nQ82dmuZVn8O/oluFbHT1JCR4Hrn6ILkzU/Hx6FSfV9d48i8KEXyJ3G+BGlaEwDkNbeDlK1CtCExMaFy7EoC3bTiJWHpy6t+4O6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lHvXv2qvgTocqZUByXvhXUr/SR9rYM63nGCFas6UBg=;
 b=cAK4GUjCNakS5D1bMYhycPMPMSPHem+rT6iHb/CA+LvIKxbahY77uf2xDaNAhSjDrQp5tEfGTNnQeKTRtZWmHWfxvo6jrPFBLicsdCatdrFycySucygb2FVGwSiy0QtaTjRnwfEWnh+wKZ8JSMKIQaY/vcgjIrm4QqTfdZEUgNrrJwcyCGWX/qGh7dG/b5bUDby9OS9y4CDG14TA6YMzMwJLXVMthP2Cn6joe7cQDV+PScVz+v1vA83bpGKzW8x/48+LfghVB2bHcdSnvIZTMi2iyKOy6JKHBmRwKXymmIk+mb2KU3jIN1TlGeDL0FSD1Ow9cYVq6483fuIz9Rfrfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VI1EUR05FT049.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc12::4f) by
 VI1EUR05HT254.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc12::409)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.17; Thu, 2 Apr
 2020 07:43:11 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 (2a01:111:e400:fc12::45) by VI1EUR05FT049.mail.protection.outlook.com
 (2a01:111:e400:fc12::225) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend
 Transport; Thu, 2 Apr 2020 07:43:11 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:192060CCA2EA40A98D1833EAB84E54207B905DDD96D0AF8A4991279F38F33890;UpperCasedChecksum:8C384A884F3961336F28F441EC3CD3CDD96C2E4AF458357192D86F2FA015439B;SizeAsReceived:9765;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::d57:5853:a396:969d]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::d57:5853:a396:969d%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 07:43:11 +0000
Subject: Re: [PATCH v6 00/16] Infrastructure to allow fixing exec deadlocks
To:     Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>
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
 <AM6PR03MB5170E0E722ED0B05B149C135E4CB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <20200330201459.GF22483@bombadil.infradead.org>
 <202004020037.67ED66C8B6@keescook>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170F3FD73A0E7A82AB25B96E4C60@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Thu, 2 Apr 2020 09:43:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <202004020037.67ED66C8B6@keescook>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR0102CA0050.eurprd01.prod.exchangelabs.com
 (2603:10a6:208::27) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <9c2954ac-e6b7-4a0e-14e1-c265c24dccb2@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR0102CA0050.eurprd01.prod.exchangelabs.com (2603:10a6:208::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Thu, 2 Apr 2020 07:43:09 +0000
X-Microsoft-Original-Message-ID: <9c2954ac-e6b7-4a0e-14e1-c265c24dccb2@hotmail.de>
X-TMN:  [88Bzfcadfsi95ESOfguVOxLRuBSSerjb]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 69f7d8f5-1a26-473a-4ac4-08d7d6d97e4b
X-MS-TrafficTypeDiagnostic: VI1EUR05HT254:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LTn5N5b/BBeabhy5oIJokULLKJzCeEdlYW0Jhlue1ce0xKjwAWs6bSP32JFc6SEimOD31h0fTAw3AJD9xEy6hUba2K5qd74MUUV+mOKeFhl7Q81qqvmxz4g/NXayKbqQ0p8uuyMXx3PM7BOXvE4SbPVIyiDlzBt5mI4GJZ5pVclJjhsjEHwD1cGX+kJgDUQuTv+/7AsqnbmbVkX6e6fcPPexXCsIdqJ7Hk6eHwWaTEc=
X-MS-Exchange-AntiSpam-MessageData: GXUhajBQ2ipAr/3zlk2B/izhvu+V8/q1X7GmsJV/bskG3kIqU53msJfIDErUSQFzFlg2rw5RYTAOhdMVmRrD+eTGFp+XDbquK+dnpFj5GnHPFficTwyQ7kAc5bc2eoh9g9tuHuhLCIYD49zNr3vlcQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f7d8f5-1a26-473a-4ac4-08d7d6d97e4b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 07:43:11.4503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR05HT254
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/2/20 9:40 AM, Kees Cook wrote:
> On Mon, Mar 30, 2020 at 01:14:59PM -0700, Matthew Wilcox wrote:
>> On Mon, Mar 30, 2020 at 10:12:02PM +0200, Bernd Edlinger wrote:
>>> On 3/29/20 5:44 AM, Kees Cook wrote:
>>>> On Sat, Mar 28, 2020 at 11:32:35PM +0100, Bernd Edlinger wrote:
>>>>> Oh, do I understand you right, that I can add a From: in the
>>>>> *body* of the mail, and then the From: in the MIME header part
>>>>> which I cannot change is ignored, so I can make you the author?
>>>>
>>>> Correct. (If you use "git send-email" it'll do this automatically.)
>>>>
>>>> e.g., trimmed from my workflow:
>>>>
>>>> git format-patch -n --to "$to" --cover-letter -o outgoing/ \
>>>> 	--subject-prefix "PATCH v$version" "$SHA"
>>>> edit outgoing/0000-*
>>>> git send-email --transfer-encoding=8bit --8bit-encoding=UTF-8 \
>>>> 	--from="$ME" --to="$to" --cc="$ME" --cc="...more..." outgoing/*
>>>>
>>>>
>>>
>>> Okay, thanks, I see that is very helpful information for me, and in
>>> this case I had also fixed a small bug in one of Eric's patches, which
>>> was initially overlooked (aquiring mutexes in wrong order,
>>> releasing an unlocked mutex in some error paths).
>>> I am completely unexperienced, and something that complex was not
>>> expected to happen :-) so this is just to make sure I can handle it
>>> correctly if something like this happens again.
>>>
>>> In the case of PATCH v6 05/16 I removed the Reviewd-by: Bernd Edlinger
>>> since it is now somehow two authors and reviewing own code is obviously
>>> not ok, instead I added a Signed-off-by: Bernd Edlinger (and posted the
>>> whole series on Eric's behalf (after asking Eric's permissing per off-list
>>> e-mail, which probably ended in his spam folder)
>>>
>>> Is this having two Signed-off-by: for mutliple authors the
>>> correct way to handle a shared authorship?
>>
>> If the patch comes through you, then Reviewed-by: is inappropriate.
>> Instead, you should use Signed-off-by: in the second sense of
>> Documentation/process/submitting-patches.rst
>>
>> This also documents how to handle "minor changes" that you make.
> 
> And in the true case of multiple authors, have both SoBs, but also add a
> Co-developed-by: for the non-"git author" author. Specific details:
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by
> 

Thanks a lot, much appreciated information indeed.

I personally like to play together :-)


Bernd.
