Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86A3403BD2
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348854AbhIHOzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 10:55:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8060 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233754AbhIHOzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 10:55:45 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188EqxO2013120;
        Wed, 8 Sep 2021 14:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=R9CyFc89EI4mmm0TQEqBL19rGkf/JvNABOb3GOn/r5A=;
 b=RJWapuPcRb7dK7JLYWYhl+SPp3Bs9fPoGaJeNETVCxU2fULDBt+Mzfe8DlAkt63CuuWF
 dIOv24wtv1ZBjU5Yt/n8CqYCkT1fFq1tOi/KmfwoaY7aoCzFlKtDCGsNCxMDNpw6gSEG
 vFhLJa8kzvtEkO5y6ql9aMpIA1EqjXWTpQ+dUtPITyCodZfx2UhEfqmob7RYD1r1n8fZ
 gONIKku9MPmtNdhAODHWJv9MQk9ohQ4RIXnK0mPNTdyHEuK1bZBQ4ZgO36sYQx2VVGMM
 ipKbk9GSXuY/tVHi/uTBJUf8e7k5V88eC6C+7AOeTkC+lRFDXQdrt8UkV/RWeU0PU+ZQ EA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=R9CyFc89EI4mmm0TQEqBL19rGkf/JvNABOb3GOn/r5A=;
 b=OoHcIVPIz+jqJ3N99214gI4DWgHUBJ5Q+8hdPsFwNRQueEDBYZp6yeV/tbmhT2LpqtAU
 4qy3NhCi+aw/8IzTnU7nIA3BY4KWd11wrM5zJGARv6l2Y8WEj3wuYA65BNeR7MmBz4PK
 Bh36crNjnqWv1iDYxeC8qpMAsX1XqeuOIP+BQwUQmjfphO5wJGGOq7pDwJ0KFVTSWFVq
 KMn18yj0f7U77+5F6YiFG2Qmu9M45TSKYrPSS8E0JxvfVBgAme/G1Y1tmrS32poiuOFG
 scdnu+cQ02IsMxt7Q9NLrN1Yfhmlo5B8FoZiMAgLfpqHZWop2Rh+ldBVkVI9vhvsvfQd BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axcw6b1d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:54:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188EoMJC159962;
        Wed, 8 Sep 2021 14:54:14 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by userp3020.oracle.com with ESMTP id 3axst3xexg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:54:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JatBAAa8Al7H/EPuRuKb1/ulkUmIOM7Tsvj/wePVUSrNTjsM36mNZ6UbEGCRGQVK7036H2BZj3b2K9mp+Izs2W8jV/AYxwVEQJyDyuiJI7pjDY2KAYAgC2wWUbKr252+WQAInail8b4o1KrJZ5ctPItIcuf65BdG6UQ2p7NunwOuSS3x8HmBBDKKmYh9SK2aRXXhnRSAIKTKcMBYj0yvS4fMLJwMcySLHQVnPR2fcpJUY3PnxqRlWM4zOrpxnToOgz/0PCYoerIGklP6sYfWsiRMUunA4cSlL7xWSnfQ4XX7FdhGkGa3i3XJ0l1GIZ9uo49YtZ+bNCY4eP7Y4/2sMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=R9CyFc89EI4mmm0TQEqBL19rGkf/JvNABOb3GOn/r5A=;
 b=CGuRI04im/M3G8H0gfR5UmtJhSugMLh7k5TFxcZeIdJAHRIfgNTMy3b130D8RRM5fzjLl2YlreXYkH2IoXCvuJIpC3YlSzGLlHNbvsC141OmwWL+iNJ+pywpPca+RZ2+zgUjg0UGmVXtnlKiZEeSA+qmJcgRnz+vT3HCi1nnxbLSKvKWeOgQyMOqDmInWmHjVgdTmwGeDzhIPyYJiCJivCRDCpEXwEWOZ6tfJY5+0n1J5S5y71fkBb+8b9MYVvXGxXXFWJYZriWLdgXJ/bilFUdwwnl/SEHenNK15Q+1pJQJhr3A82zUesvWQHFrGTyrjXRxfGSPGEoHX0rtHUuMVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9CyFc89EI4mmm0TQEqBL19rGkf/JvNABOb3GOn/r5A=;
 b=sdIvNrp4+X4ATfxFezfasklSsId+ofFvV+w4gMNmyFAO97GLn4xYN1pd4WGSO8gZ1IxxawE+FwhLiASoLe6g9EZ0brBQT52JWmeDCL3WcidgAQFm77aBxpHHMvC2yl6cgFlnu5NwzXcVCXhlDJVaMLO3x+U15oluBpKA9MILXd8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BL0PR10MB3444.namprd10.prod.outlook.com (2603:10b6:208:73::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24; Wed, 8 Sep
 2021 14:54:11 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f520:b987:b36e:618f]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f520:b987:b36e:618f%7]) with mapi id 15.20.4478.026; Wed, 8 Sep 2021
 14:54:11 +0000
Subject: Re: [PATCH 2/2] xen: reset legacy rtc flag for PV domU
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
References: <20210903084937.19392-1-jgross@suse.com>
 <20210903084937.19392-3-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <b2cd2936-7ec4-e0b2-458e-51c12a3f56aa@oracle.com>
Date:   Wed, 8 Sep 2021 10:54:07 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210903084937.19392-3-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN7P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::19) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.115.194] (138.3.201.2) by SN7P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 14:54:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c67d3e7-3179-4284-7f7a-08d972d88477
X-MS-TrafficTypeDiagnostic: BL0PR10MB3444:
X-Microsoft-Antispam-PRVS: <BL0PR10MB3444ED12E1A5C04A32E24A178AD49@BL0PR10MB3444.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gl7oYKj8lVelmHxOmcoOcSFbYLyhAOlcd8nxrPtF4ibotx8wNSjAEZ/6sqKlp+5XBPBTekMBa45MlcBZyTzPxoIr6BP+ObepOgRZFpm/fZOE/RbReOqzM2WgQ/amW2c+J2RXhNQgTlbuHCPinG7MYr6Bm8r1r56pB1L2/BQeGLqLwc0pvfuMTRxC2P75V4umdKSIBKbTtt7slnn21zy/SJ73M3owM6iyeeI334xKZ5JBbOXu9dNhyK0YYwZJx+7tkr34GgPDLC8p9Br76SeOEHEyvnf9IVqRpw97Di9dEa46iTrrLuN7Pi4LdjR8WfjEECQOabNPVB4mbErdOHZDDJbCK/J3+hTDTwiHSGJ+BK3IOfTZnpkkurQM7iHj2iqcJNqejxFSRuJGeqdVf3Qt7Cw19b9xVKcNlIxkr4f5DG6Dt30vnLb+ZeAKeiaMNVwSArHfaPCQFrJcow4lNyeuMZNvK9NX66seRn5q5smuMal5u9QE4iQaKg9op5Bje8/m9nMEZl9R0tyagSmEMxsCzcctC1+a3yJhfhkz0ykvSsGcBZicvXh+KwVmvH+28RuoZVG6z0b6CEOtidfI6Oh9CzPw8P3cxIgv+o/w0OTz4w2082jSrLjPYUeda0JksCSvaogmaLPSLjsAeT111munmDVPAHEYPLmaz8V5k/VZZvBcWJq8sAzB4uTa/MjtR6U6Ius69aMTbukBPY8buHvo8YG33dPmE/FUfs57q+7hAak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(45080400002)(66476007)(6486002)(54906003)(31686004)(44832011)(66556008)(16576012)(8936002)(83380400001)(26005)(2906002)(31696002)(8676002)(186003)(2616005)(4326008)(38100700002)(86362001)(66946007)(36756003)(7416002)(508600001)(5660300002)(53546011)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmJ3WmE2ZjVaUE15TUFiVFFQV2dvUTFiY3RIc3M2RGNlTEcxNlBjMDdwenkv?=
 =?utf-8?B?aXl6enFldUJ3YTVXRWVCVFo1aUNCNzNuU1Y0ZFBqakxoRWVETG9paEFKdGZU?=
 =?utf-8?B?QUF3T1F2SVNKVy81YnlLSEV4SG9OK1U0czZBYlQxS3hKNElZTlNhdTVORVMv?=
 =?utf-8?B?ZDJpVjdaamJWL1F3R0VmdzRJQVVjeno2K2Y4bzVuZ0lRcXJQajB5dUw1MktW?=
 =?utf-8?B?ZkxRenc1TlVtRGc1RWk3TTFXS2c2L0hTVC82MDRnR3hjTG5tVFI4ZndjeWx2?=
 =?utf-8?B?Z0VGV1IveGVRYnZrL1R1UzIwb1MzQ0FVMTh4QldaNHhzdlh5dnh5Si81OVk1?=
 =?utf-8?B?Zk91NzIxVkd0VC9GTXMveXNxQjZ2cVdTeGpiTWxweFF0REZ5MjNXWmEvNUZ1?=
 =?utf-8?B?VHNMZjdMOUs1Uk12MDVBUTZrRnRRQ2F1R0diS1g3Y2lXMk1wV0Nta1ZtNkJW?=
 =?utf-8?B?VlJ6cEFiaGppdWFHcWNHbWlxTlhnUk1EZm8vYWh6eVlEcFFVZTJKUis3RlZn?=
 =?utf-8?B?K3gvbkdNYUV6MWFEcWZtdlRsRks0dTgzejBncGg5WC80VkJ4bm82WHFrc1BK?=
 =?utf-8?B?bkdRSDZaWkdScVJSeVAyL3lmOUpMYmlwVnI0Q2V0YjdGdGhnMzFnc2YvQ0FD?=
 =?utf-8?B?ODNmQlJFWjI1Wm5MeDhnaWxMZzltY1UrVVNWQVpLMnh5akN1K3gwZFU4ZmZI?=
 =?utf-8?B?QWlIRWt4amFyU1dXd0pRRjFIb2E4TXd4ZHl4NGlaQXpOTCt0bysrTk1LVzBG?=
 =?utf-8?B?S3FSTWN1QW1wWWZTWmFOVGhpbzFxejYzOHp3U2pLS3g3MUZHejlGTzllWFky?=
 =?utf-8?B?ekozKzhBcllQUzhzT29EeGM1YTdTdlhRSVFUR3FwZm9BQ2JicUxQbm9xa05R?=
 =?utf-8?B?dGZreElZWVBkY1BiRGZ6RC9zb2dORjlwYmVHc1R6N1RId3pMVVpYL1ZmNEdW?=
 =?utf-8?B?eFlEZFJ5ZnpNaXJPMUc2VUkwUUxaZWZZM1dYcjgwcU5GeUFWM3hwOTVsTFJh?=
 =?utf-8?B?dzZSU1NwdlNPbWFxZWJCTkl2anBMV2FueGxSUnREZWdqM1VUQXFUWXVBdzBW?=
 =?utf-8?B?ZU56bnJjT0dtajlmazRuSXlXQ2NWMkhWQk9lVU10eDV6T05OdlREN284Q0VR?=
 =?utf-8?B?b2NKNWtFMFFUc2FiYVRDa2ZwMmgzaVM5WDNaYmhlc3BNQTlJam1QTFc1TEdB?=
 =?utf-8?B?UE5ZODI2Qy9WeVNBM1dOTEJwZ01XUDVrakM3TGhXVzlTYlViOE11RjV0SjRY?=
 =?utf-8?B?ZGdsTHpPTEx3QXl6dEdkRWNQcUl6VXNBRG1reUtKVHZpRWlKek5iNmJFN0dV?=
 =?utf-8?B?bngySEZQVVVzNmw2UnpkSFg2RUVCejEzSDdPazBPQTdpS25zVkV3bzRMU1RF?=
 =?utf-8?B?NjRlbGpSUWVOcG82dXJMYWQrT01UYTBPbDlDaDFVcHhCWXhmZFlES2tlWUVC?=
 =?utf-8?B?YkYxTjl3QmlLLzBLaHFRbGxFc0g3d1NwS1RMR3RWZWlEb2VmelRCZlVydjBo?=
 =?utf-8?B?eDEwR29jQUZWZHR5NmttdE5UVDRIUEk2bWNSREEwWFRGeWFyOEloczdNNUpp?=
 =?utf-8?B?NXY4VVl6WnJwbytvRzdTLzlzcENiZU5xRkhqS3pRUXRLeGhoVXZyaVRTK1Ux?=
 =?utf-8?B?dnpLS1BBQkNvOWdrVnNDd295T1VXcnJ0WEd1VXNHQWZVc3E2TGtibjFpclY1?=
 =?utf-8?B?NnJXNmI1bFVmU29VREl1aUdpSWRBNnp3endIN0RJNU8yN1FoLyswS2xJdWVK?=
 =?utf-8?Q?RolcjRs08WzEtLzjiX//bpizM7Ep4Jk4NIYKF2y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c67d3e7-3179-4284-7f7a-08d972d88477
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 14:54:11.2224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRLXF+EPkNc+8N4+wrckUmzNzw6wmUKX47qx1iM1qj71KHEXpzkBfkpVqixhoI4FZdeCcSKvzyMkI1AsP0rVnUWo1EHuAJarqO9Fle6pkXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3444
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10101 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080093
X-Proofpoint-GUID: 7U7S6iHGs1PIrquqq2ApWZHCvSLEFWlN
X-Proofpoint-ORIG-GUID: 7U7S6iHGs1PIrquqq2ApWZHCvSLEFWlN
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/3/21 4:49 AM, Juergen Gross wrote:
> A Xen PV guest doesn't have a legacy RTC device, so reset the legacy
> RTC flag. Otherwise the following WARN splat will occur at boot:
>
> [    1.333404] WARNING: CPU: 1 PID: 1 at /home/gross/linux/head/drivers/rtc/rtc-mc146818-lib.c:25 mc146818_get_time+0x1be/0x210
> [    1.333404] Modules linked in:
> [    1.333404] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.14.0-rc7-default+ #282
> [    1.333404] RIP: e030:mc146818_get_time+0x1be/0x210
> [    1.333404] Code: c0 64 01 c5 83 fd 45 89 6b 14 7f 06 83 c5 64 89 6b 14 41 83 ec 01 b8 02 00 00 00 44 89 63 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 48 c7 c7 30 0e ef 82 4c 89 e6 e8 71 2a 24 00 48 c7 c0 ff ff
> [    1.333404] RSP: e02b:ffffc90040093df8 EFLAGS: 00010002
> [    1.333404] RAX: 00000000000000ff RBX: ffffc90040093e34 RCX: 0000000000000000
> [    1.333404] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000000000000000d
> [    1.333404] RBP: ffffffff82ef0e30 R08: ffff888005013e60 R09: 0000000000000000
> [    1.333404] R10: ffffffff82373e9b R11: 0000000000033080 R12: 0000000000000200
> [    1.333404] R13: 0000000000000000 R14: 0000000000000002 R15: ffffffff82cdc6d4
> [    1.333404] FS:  0000000000000000(0000) GS:ffff88807d440000(0000) knlGS:0000000000000000
> [    1.333404] CS:  10000e030 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.333404] CR2: 0000000000000000 CR3: 000000000260a000 CR4: 0000000000050660
> [    1.333404] Call Trace:
> [    1.333404]  ? wakeup_sources_sysfs_init+0x30/0x30
> [    1.333404]  ? rdinit_setup+0x2b/0x2b
> [    1.333404]  early_resume_init+0x23/0xa4
> [    1.333404]  ? cn_proc_init+0x36/0x36
> [    1.333404]  do_one_initcall+0x3e/0x200
> [    1.333404]  kernel_init_freeable+0x232/0x28e
> [    1.333404]  ? rest_init+0xd0/0xd0
> [    1.333404]  kernel_init+0x16/0x120
> [    1.333404]  ret_from_fork+0x1f/0x30
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Juergen Gross <jgross@suse.com>


Fixes: 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs") ?


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


