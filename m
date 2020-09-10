Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00ABE264E5B
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 21:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731425AbgIJQB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 12:01:29 -0400
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:37280
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731474AbgIJP7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 11:59:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGYTp0dzft4c5Jx1y4P+K1bnZArEK5ksnvmAtCsg25KNqVgZKsupjaWpYUArp6E1YivgaCwMezsucEafNlWyo0Kq7i92Or0UI/1QIboqBqWcFigveVMYFckSZ7ILf5Bmb65IUwU2eDjsbgYFxuWx8aJYvXhqUIMJn1IbIyK8RLare0pWzoMyHfkWKZvyWFWm8JNBYMv+M4JnlX0ltCiWhb783Zi6Bz8A2lCALQIi6ntaLhlEMvEsQW1uLRXjAMAhGYCOGBGEtSY7eF+/EnqAF8PWDEAFP+3d9OFBqjFhWGrTXKdwB8PFYLIy/FTD53TbrxmE88BraoadqUl9EhgCpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SZiYneRR12R0/0MLY/QRWiIQzBl/qo+sYWrorOMau4=;
 b=XaAozGnJ3OsXaJEc1iR/0C8y2jhsTVjV56iAE4ke63ODgiQYcV/sSPzQGPZBWDumyMmvQ0yDvrn1Z4aAm/G16HQmV4rrN3QwHrQ7P+6fbMnhd1vo3SsOV1wXDa3imXsxlB/duAGjBIw7rlK1dDC4aZGosxY1Ahh+9SA9jwivpZ86FQRJ3Ds19yj0KBV8xDTx3bPxYlpPd4HYInvya856j9A3R1sXzZWyjWRAz7WbY3CZ6xROZVgbYhiiiyOcYa1ugj2t/SCe+Z+PjhI65+DHdbTyWBGYRjhymli+BxlyeiCAd7afDH6Pb9pjRzzF3RMIVrByKLxUTTdY3i3ZX2d8bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SZiYneRR12R0/0MLY/QRWiIQzBl/qo+sYWrorOMau4=;
 b=nVqtDcdWscNVdnPJYYyQlmSObTnaKD3GMBv5WFHobtOeHyo08Xr3yNOnafExKcOqtAJSxJBYW+NrVLWRrMNaxVcU1dc4LJZNbxk0BHqFIGkjtF90o/MdjCx4xjN5JVQBq1XJw39kf3RvpgWvLVdAchNngWy/+ncoj3Q9zpkaI9g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN6PR1201MB0081.namprd12.prod.outlook.com (2603:10b6:405:4f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 15:59:02 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6%6]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 15:59:02 +0000
Subject: Re: [PATCH v2 3/7] arch/x86/amd/ibs: Fix re-arming IBS Fetch
To:     peterz@infradead.org
Cc:     Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Stephane Eranian <stephane.eranian@google.com>,
        stable@vger.kernel.org
References: <20200908214740.18097-1-kim.phillips@amd.com>
 <20200908214740.18097-4-kim.phillips@amd.com>
 <20200910083223.GY1362448@hirez.programming.kicks-ass.net>
 <20200910085036.GD35926@hirez.programming.kicks-ass.net>
From:   Kim Phillips <kim.phillips@amd.com>
Message-ID: <f44ffa72-815e-925d-101c-c096a3879990@amd.com>
Date:   Thu, 10 Sep 2020 10:58:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200910085036.GD35926@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0013.prod.exchangelabs.com (2603:10b6:805:b6::26)
 To BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.252.17.193] (165.204.77.11) by SN6PR01CA0013.prod.exchangelabs.com (2603:10b6:805:b6::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 15:59:00 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a29b14a9-b6bf-41f8-5832-08d855a26f8f
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0081:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB00819F94CCB38C990A634CE687270@BN6PR1201MB0081.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qhd8jQ8OeBibWMsav/L6WXFq9pwjjIJgVw2wJZD7coSJ1xAEE+/QgGAFCXZ18UnD421Nm+AMwY/ovntMX9MquODsALZiNhOw0t0na2S2qdlNXwQOKd2DlmfFcwzHreE5aVvtMCZ9tPeqTwffN6NJvk6rDzA2Bcy/5Y3advciNdv4EE028rQTfxelvdjyhzo1xyPZho41DYuOGd2BdjGxSqijDgUNv0p5Og2VFdLfOnuJKD2f1Kqc48UqL89/GhJVkf7NsBC8VeicizXRYIaHmY6JqjbDVHtohyJX5zzQGrSz5ArfhJOdH7vg7zHOp+BVNyf46f5BeODHyJAri74BcL+7za/zg409n3uynO2iCj3I9Xds0B8B9yEONu/nslzy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(44832011)(5660300002)(186003)(16526019)(31686004)(31696002)(6486002)(26005)(4326008)(8936002)(7416002)(83380400001)(36756003)(478600001)(53546011)(66556008)(66476007)(316002)(16576012)(86362001)(956004)(2616005)(54906003)(6916009)(2906002)(8676002)(52116002)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BTp3kV4/yUElUE2UcZjHpjY56Ratn463npS7kagysstMiGWJ46vz9Izg5dBzewXmhUIGgP6ibUhbM8IQndPxqrRBVTtelykLcdfnaP6FGs0UuN7oxxdu9/TYJGfasw7d3gSjb+lQm7Ee1tJ0Prv7DxQkYJ1mB4reLnBpNtbqP5EVx0jeJ6d+t3R4NPqPUXh6WziRwLoJ0/N4QctGS7gbcoHvg71kIvj8eLylJnPd2EiMty8Yw7xpBZfh06tS8cqGBg0XUsEEr51YfPBBCEa/F37Le87vYDA7uQNNPmMmBsm+dnDMomfwhkZLv8I6kP18Vp2+W5+ORETZyGOYt1GXnO3CYfx1Lm/CynVnAn3gD+L0e0JHvJmi/86jv0kE9AWw79DHFljZZB4grJPUi6iwZGbS+rGpcxJuQ6fyj8mM6MU8ZSJ5lrU00gf9PRPlvW8xcujaXrai/yTPX9NmvakEPFdZ6CL+N2YxFmbWmIVuMBtN3+nzkFFSfHqfwq14/rT3jjn0HujJJ3hFnVWeClSN9KxAzv5aIQTKLmicBDR4pA98hMQeQZDNOd+X1oa9uTO/RA6sc3S3qkMss0dubJl6GGCn0vcpxjX5ozNyFUxHAeBNOPzQtP0VP2Ew8l+lLXD5uIbu+8m0X3l6Dktth6FrDA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a29b14a9-b6bf-41f8-5832-08d855a26f8f
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 15:59:02.1191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zaqhDgP+xY2yackfYVePff0josiARNkvkIOGj787otanle1I2rPLgC/Qg4Y/eb1ivYbYXDfxG6Agsja1lOOzSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0081
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/10/20 3:50 AM, peterz@infradead.org wrote:
> On Thu, Sep 10, 2020 at 10:32:23AM +0200, peterz@infradead.org wrote:
>>> @@ -363,7 +363,14 @@ perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
>>>  static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
>>>  					 struct hw_perf_event *hwc, u64 config)
>>>  {
>>> -	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
>>> +	u64 _config = (hwc->config | config) & ~perf_ibs->enable_mask;
>>> +
>>> +	/* On Fam17h, the periodic fetch counter is set when IbsFetchEn is changed from 0 to 1 */
>>> +	if (perf_ibs == &perf_ibs_fetch && boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
>>> +		wrmsrl(hwc->config_base, _config);
> 
>> A better option would be to use hwc->flags, you're loading from that
>> line already, so it's guaranteed hot and then you only have a single
>> branch. Or stick it in perf_ibs near enable_mask, same difference.
> 
> I fixed it for you.

> @@ -370,7 +371,13 @@ perf_ibs_event_update(struct perf_ibs *p
>  static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
>  					 struct hw_perf_event *hwc, u64 config)
>  {
> -	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
> +	u64 _config = (hwc->config | config) & ~perf_ibs->enable_mask;
> +
> +	if (perf_ibs->fetch_count_reset_broken)

Nice, we don't even need the perf_ibs == &perf_ibs_fetch check
here because fetch_count_reset_broken is guaranteed to be 0 in
perf_ibs_op.

Thanks!

Kim
