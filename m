Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6ED3934EF
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhE0RkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:17 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:37174 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234594AbhE0RkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:16 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHXKjk026033;
        Thu, 27 May 2021 17:38:24 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh81bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpPOxShhOPwTLdxVIui0kvhNJK+wOBTCzmq+G5mnOIFG/HAl78pZsLqg//7ae6kI/B1aeGZ9tfnyTjXHxogz2dFrbtBh8X9kzoQTbU8dmjIZw9G/l1ahQUQ4C+LVXuRntrBgkNIXaKYtjU6Q1QfwCODiVqqUWXuDHUTigN6NFOnrCM/vfZmwOn3DKc/Q+tvux51DOD9brlNlc3Hh3rekCXBAUsMl4j5VW9MfxQdQstleoDW3lcgwIJ8fNrKeTkpMy0Dzj/b2nqBHwJfk53kmGxetlcO49EneZh3Q1ukrGpfTkJxjBnsr7Ci5qTKg6k+afDvwPLGU0T5Nm9rZ9dHlFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vI7iO8T07vAL4u02uJKWVuke7aoCIBDfaCW3KZ8EXZw=;
 b=h7Cf+PEs3HWVx9Hpoyej65rXqCZ8/wd79nfQA1pMMv+k5YWvRmi/xRFP3wXnAQsdvRzaWS7lDS29wclEAD/qHwyzqDmFGdqsV88jThhtERNvIWn7ywoNvy40Qv23jZZNorNsqWjGQ0uPmsseSrLdFOLxgdLwkulfHezrZrRmRVMsr1yxk5/addysjCpGBKFdULa1jVP8fvfzhQ33z6S2lRciD98fP1U6I9kf9G25M4UifqHTqYs8B7fxraOHw7NBti+uWr8SoiUkNow5MB5k+RFW0LZDePJZJvKvGjcqtQoocO6O8azFxh1tTlCdK8UCXXRbCCgVq217+vG/GC8+Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vI7iO8T07vAL4u02uJKWVuke7aoCIBDfaCW3KZ8EXZw=;
 b=BAlfwdaLD918+9nkyX3J6cIyyBtEZwR2mjnF9CnRtPJWhWVNvSBm4eh34dez4AaoX4KK5UpOwB1UMqCJWyspzbA/WAmPy76hS8niB0NzLC5Tdm6YX820zUQcQ19BVZAXk+KU9iBRA8vVXave23fFspNb8MVBysaUpcc8P+iCYLI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:21 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 00/12] bpf: fix verifier selftests, add CVE-2021-29155 fixes
Date:   Thu, 27 May 2021 20:37:20 +0300
Message-Id: <20210527173732.20860-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [46.97.150.20]
X-ClientProxiedBy: VI1P189CA0013.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::26) To BN6PR11MB1956.namprd11.prod.outlook.com
 (2603:10b6:404:104::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2329c247-3d88-47a0-3f2e-08d92136382d
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB21625B86DAE73E75F06F7AE3FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:400;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WVj+jgnxoKCDhPq6WkLehKgobiiU+AOW+ZRT9s1br+e7+revpSTAv3PX4xfp1qv52YPUexAmESk2RZIuaHlY9J5mLpGIQZjUm1+BD4y0XjK3Z2WfY02M0FOzw3JWpVlnb80A9S17xusgL1RoGbkr20sCF71ds8SWX0hGO9iu49s3ruNc+WR8vGkZfNSiMjmJO/j1G/yFZpGxJkl4yQFu/f0lk3m43nWrlb8J+6BZlgRKmIwvnKBohsj4nQ5iTvPcR2D7cpeYbLuWj2N9+iloq9Y/xzC2lgQzfICM++E/J6D3Oc/MpeTmtxz5Z6bH+cQIy6/nTY3QLiSSpeTvA9HNNoksy+OekceXIbo+poaw4hngjTzfDWn7f82S3UOjY3qwKyy7mBv/FGrfypqJ/DdbN2Kn/4SHIRONg3OO5cniBYzi95TEuZBK2PAt6z4r6uBSOFQXRtT4BuBACI9mmwcmFayTkTrmmmgOBsvDhZ9SdYldiOqcvxjtgGyUA/pXQqgGFHXWBY4fqklT/A5BM1wFuZiJS7MkXNRx3aS1i4fq8fHZPzsVZQZ3bLIvjgALdSNNeXCwyeiHvUbEOKo7I7BQqA1DePps/vFiPUqOF0I473ZlHLlOLYCD8yeVO03ZJXxUsZX+hiZDIQfQ+fDBYu0MZD567v5lwy5zbcehl8MPJwJ0QnukgJNmFl1/JWEO1GnyW3l6+FsUK/nM1Qq+v8s0WNyieNVdV+rzZFfG9aDpWkQKvY/6+NST6vGptrsW6D9JQj2vj5YzzzsDaOi2Y6SW0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(966005)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(6666004)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sLV14HVTPz18oJJ8kUh/T6iAYrpHtwbwutSyF82yWALIXxEVtTIDtLVOy/bD?=
 =?us-ascii?Q?t+JW2yAja1lzlSx8hhWN4lMuYd4VzD5/xPeCWa0Nj2OEJ2GFdxttlOLoADUy?=
 =?us-ascii?Q?TAt5Cm58AKI+r7ReeeZsXXphb7KR7u4sswMB1Mth+d0QWrv46LCkvD4IHVwT?=
 =?us-ascii?Q?N5KP0W/w0x4rEZ864OylUbTGtZY9Z7T+PlSJ7srCSJkVw9niRxYlTWU+AObw?=
 =?us-ascii?Q?hOXPPSapwqiKXG5cXC3oCSMwQ36J1BPBOZcR0lOteZsI1ACgIi2VG/BYyUAw?=
 =?us-ascii?Q?QYCwftGG8MacsoUKh8hRJC0iPd7aQckXmQvUGtr3k9Y6dcQwUcsmwKISvwSl?=
 =?us-ascii?Q?pIpkWmSlcwIRZ+Oq1Y6oEz02wmc3adjlJglYdLTgWrXnHP6Ph2zw989qUJ+R?=
 =?us-ascii?Q?TBDKwseL+QRQCqGuAQ+9j0rPukSHOX27Z1RWRXXfx/MyzACLM/mFuYHGVF/f?=
 =?us-ascii?Q?/ASR+qAGxmLiDnOH0S3yOlwI4SsLY/z8cKsrEqSesXRGJDrhvOaHfWFdRir2?=
 =?us-ascii?Q?vjvID+exje/u7bF9oVFUfSZT4QQt+yLlVgadVvJgO0AmdtwqebaLxXhIvNiE?=
 =?us-ascii?Q?bg4PVQ/D70MzKkNHrtMoyF6ydKvIGp3iRmciq9hW0uWQnJAsm5BjrYIy7WGL?=
 =?us-ascii?Q?gM/9ggZJhpJXmGvnRrc8yEVHXtQD0ucuRwWrUnnz7mtbPTsuFUoXvxNtfT8S?=
 =?us-ascii?Q?Y268C7yCxjz+4KlasWcrWPUWwkoe8b8DLBpB2sNdCVE9+ai+ez/v14m2zy4b?=
 =?us-ascii?Q?STdzCz9DwQ+0lvgm9//0CgcOc8LPDNPRSUCoSgSV75JCLAyMldHk50RyN0k8?=
 =?us-ascii?Q?6+BLtCXklafob5FuLLskr4IcgwGM2175vHcBqNKUOu8DdROBW2oEYYbOuBjV?=
 =?us-ascii?Q?BI/9/JQpw1mHAz7MrPRN091mg6UUnqWUhop/t3fBJAGwmWrcSltg8FFaJe1d?=
 =?us-ascii?Q?5t3HlIT/7TkvoAgqsX5aTWXjwz/f1ytY1RobLkZYFZRr7a8YGynwYC6hMc4O?=
 =?us-ascii?Q?b7G2ydlUOJehUXK3j9MCyx3hJ9bCrlN2l2s/77PtgMyKkWrQekmh4/uk3k6Z?=
 =?us-ascii?Q?ulHLgyyVSrRgoHFfl9Ir3uAHCncIJgV5yK/5mOMVXkKePrUirxGKBQZOZS4Z?=
 =?us-ascii?Q?9drvAk/gJLE4Hswp5B+QwEAy1VS5CijA3YvOscCyOFw/Te2Rv5bjVSEOC4eK?=
 =?us-ascii?Q?+eBig4TtuNYf2iXi2/23MSGCUj2QEUVhitf7X8mA0fP7WH2z7YGEm6hVLJcP?=
 =?us-ascii?Q?9WBFSDvY8VhacjZmCdEeq+3H/nc9joVGJ3lpQji0SWbqRr/6PFxC6jEq07FO?=
 =?us-ascii?Q?zd86xcp6mAQ9mJcSPEf/uDhB?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2329c247-3d88-47a0-3f2e-08d92136382d
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:20.6044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpXOQGX6wFKI4I0AWQSGl6srZ8ye23D6Nvc61F5370kC4ShkSch0uEqLnn00j9lmwtkg6dIBUFut5/AIiSl+BG5d3Mu/PbKrQ47s+F3M81k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-ORIG-GUID: 77Z3avKMku0uEHWunNuflWLVJCBWsM9S
X-Proofpoint-GUID: 77Z3avKMku0uEHWunNuflWLVJCBWsM9S
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_09:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1011 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patchset is based on Frank van der Linden's backport of CVE-2021-29155
fixes to 5.4 and 4.14:
https://lore.kernel.org/stable/20210429220839.15667-1-fllinden@amazon.com/
https://lore.kernel.org/stable/20210501043014.33300-1-fllinden@amazon.com/

With this series, all verifier selftests but one (that has already been
failing, see [1] for more details) succeed.

What the series does is:
* Fix verifier selftests by backporting various bpf/selftest upstream commits +
  add two 4.19 specific fixes
* Backport fixes for CVE-2021-29155 from 5.4 stable, including selftest
  changes. Only minor context adjustements were made for 4.19 backport.

The following commits that fix selftests are 4.19 specific:
Ovidiu Panait (2):
   1. bpf: fix up selftests after backports were fixed

      This is the 4.19 equivalent of
      https://lore.kernel.org/stable/20210501043014.33300-3-fllinden@amazon.com/

      Basically a backport of upstream commit 80c9b2fae87b ("bpf: add various
      test cases to selftests") adapted to 4.19 in order to fix the
      selftests that began to fail after CVE-2019-7308 fixes.

  2. selftests/bpf: add selftest part of "bpf: improve verifier branch
     analysis"

     This is a cherry-pick of the selftest parts that have been left out when
     backporting 4f7b3e82589e0 ("bpf: improve verifier branch analysis") to 4.19.

[1] Note:
There is one verifier selftest that still fails:
...
#640/p bpf_get_stack return R0 within range FAIL
Failed to load prog 'Invalid argument'!
0: (bf) r6 = r1
1: (7a) *(u64 *)(r10 -8) = 0
2: (bf) r2 = r10
3: (07) r2 += -8
4: (18) r1 = 0xffff89a8f5503000
6: (85) call bpf_map_lookup_elem#1
7: (15) if r0 == 0x0 goto pc+28
 R0=map_value(id=0,off=0,ks=8,vs=48,imm=0) R6=ctx(id=0,off=0,imm=0) R10=fp0,call_-1
8: (bf) r7 = r0
9: (b7) r9 = 48
10: (bf) r1 = r6
11: (bf) r2 = r7
12: (b7) r3 = 48
13: (b7) r4 = 256
14: (85) call bpf_get_stack#67
 R0=map_value(id=0,off=0,ks=8,vs=48,imm=0) R1_w=ctx(id=0,off=0,imm=0) R2_w=map_value(id=0,off=0,ks=8,vs=48,imm=0) R3_w=inv48 R4_w=inv256 R6=ctx(id=0,off=0,imm=0) R7_w=map_value(id=0,off=0,ks=8,vs=48,imm=0) R9_w=inv48 R10=fp0,call_-1
15: (b7) r1 = 0
16: (bf) r8 = r0
17: (67) r8 <<= 32
18: (c7) r8 s>>= 32
19: (cd) if r1 s< r8 goto pc+16
 R0=inv(id=0,umax_value=48,var_off=(0x0; 0x3f)) R1=inv0 R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=8,vs=48,imm=0) R8=inv0 R9=inv48 R10=fp0,call_-1
20: (1f) r9 -= r8
21: (bf) r2 = r7
22: (0f) r2 += r8
23: (bf) r1 = r9
24: (67) r1 <<= 32
25: (c7) r1 s>>= 32
26: (bf) r3 = r2
27: (0f) r3 += r1
28: (bf) r1 = r7
29: (b7) r5 = 48
30: (0f) r1 += r5
31: (3d) if r3 >= r1 goto pc+4
 R0=inv(id=0,umax_value=48,var_off=(0x0; 0x3f)) R1=map_value(id=0,off=48,ks=8,vs=48,imm=0) R2=map_value(id=0,off=0,ks=8,vs=48,imm=0) R3=map_value(id=0,off=48,ks=8,vs=48,imm=0) R5=inv48 R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=8,vs=48,imm=0) R8=inv0 R9=inv48 R10=fp0,call_-1
32: (bf) r1 = r6
33: (bf) r3 = r9
34: (b7) r4 = 0
35: (85) call bpf_get_stack#67
 R0=inv(id=0,umax_value=48,var_off=(0x0; 0x3f)) R1_w=ctx(id=0,off=0,imm=0) R2=map_value(id=0,off=0,ks=8,vs=48,imm=0) R3_w=inv48 R4_w=inv0 R5=inv48 R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=8,vs=48,imm=0) R8=inv0 R9=inv48 R10=fp0,call_-1
36: (95) exit

from 35 to 36: R0=inv(id=0,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=8,vs=48,imm=0) R8=inv0 R9=inv48 R10=fp0,call_-1
36: (95) exit

from 31 to 36: safe

from 19 to 36: safe

from 14 to 15: R0=inv(id=0,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=8,vs=48,imm=0) R9=inv48 R10=fp0,call_-1
15: (b7) r1 = 0
16: (bf) r8 = r0
17: (67) r8 <<= 32
18: (c7) r8 s>>= 32
19: (cd) if r1 s< r8 goto pc+16
 R0=inv(id=0,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) R1=inv0 R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=8,vs=48,imm=0) R8=inv(id=0,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) R9=inv48 R10=fp0,call_-1
20: (1f) r9 -= r8
21: (bf) r2 = r7
22: (0f) r2 += r8
value -2147483648 makes map_value pointer be out of bounds

This failure was introduced after the following 4.19 fix:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.19.y&id=e0b80b7d646646273af0770a2bd4d105719387e3

In 5.4 it was fixed by the following commits, but backporting them to 4.19 is
not enough to fix the failing test:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=37e1cdff90c1bc448edb4d73a18d89e05e36ab55
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=a801a05ca7145fd2b72dad35bd01977014241e55

After bisect, the following upstream commit needs to be present as well in
order for the selftest to pass, but I am not sure if it is suitable for stable
backport:
https://github.com/torvalds/linux/commit/2589726d12a1b12eaaa93c7f1ea64287e383c7a5

Andrey Ignatov (1):
  selftests/bpf: Test narrow loads with off > 0 in test_verifier

Daniel Borkmann (8):
  bpf: Move off_reg into sanitize_ptr_alu
  bpf: Ensure off_reg has no mixed signed bounds for all types
  bpf: Rework ptr_limit into alu_limit and add common error path
  bpf: Improve verifier error messages for users
  bpf: Refactor and streamline bounds check into helper
  bpf: Move sanitize_val_alu out of op switch
  bpf: Tighten speculative pointer arithmetic mask
  bpf: Update selftests to reflect new error states

Ovidiu Panait (2):
  bpf: fix up selftests after backports were fixed
  selftests/bpf: add selftest part of "bpf: improve verifier branch
    analysis"

Piotr Krysiuk (1):
  bpf, selftests: Fix up some test_verifier cases for unprivileged

 kernel/bpf/verifier.c                       | 229 ++++++++++++++------
 tools/testing/selftests/bpf/test_verifier.c | 104 +++++++--
 2 files changed, 241 insertions(+), 92 deletions(-)

-- 
2.17.1

