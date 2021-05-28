Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB958394121
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhE1Kki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:38 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:47388 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236562AbhE1KkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:25 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAaPMb004646;
        Fri, 28 May 2021 03:38:30 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tqu5ra1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBJYFw9KGN/XAXeM4rQXvymnRjuic6+gvMQxHAhDN0HztmsPbRkxj9BAkAVa745GIArrNzehkf/Lltg8MHJY5CuJTcJHhVand96FSf3GEEgIErYU20roV31ZV4esaMsuukCKktmmmqKEgmGKZguiPTuUFkTNpxAt4SsSp4sxigtvAc8n9FOR+KtCnkyBQlnTKgGAVmXZhvU6rGbNMag3PwRWRQplsuNME0VoJpfd4RvYTN9xHM8DWCdocL8uZ6LrzNj39ArU/75x9OtTkMqsXsl2p/Tkm/en2epdXzSco+tmiytY1VTuhQcSqb2ijfnKxMNvWTD57MOgJlngtYTLrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OqAfuOCbQ06P8qynBHMx5II98BKDpZT96w5/pFLjoc=;
 b=KxYGipT39j8hBfup+q8Dsm5V5ptGmNhtjlkkKZDw2Ezy/Yy0yllgI/ZWG6sWuKSnEfjnqJ/zysB6rjP1jsFeHReydmif9ZiQclIQEvZAqh6hPtXSx28OPkodY0AoFpR67MYp5jlm7+FI9tQW8OM2qko+1QYBMJ/DOFX0b445We2UC7v3zB2hLhy4gG19osWz8Zl+LwF5mTMYzOSUHadc+QErzRG6SEwKn1Dhuag//GdVhInB92AgRRCRwNqe8YYpNqOAua1fyk/oemHJufTMW5G34Cy9CvAObw0/7L5wvVyQuG0f0Javlyidppb3vMcfZNN8X9UcwaqY4Yy3gRbGpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OqAfuOCbQ06P8qynBHMx5II98BKDpZT96w5/pFLjoc=;
 b=To7PmmEQfsooAzyISxtbztSBHtll7d+K/B0RyWRDRdHnxw1IU+i93bSBGt8P7CXkOlYK4j9bE4AueOnoYQvYY4Hc4yQLbytHqCQy4iREAnHPmCMdrU/g19qCc8/n6RPHwgUv7gsdUTKlTxyG6h08VBOCJoFmXJN+vucHbM0/b9I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:28 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:28 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 00/19] bpf: fix verifier selftests, add CVE-2021-29155, CVE-2021-33200 fixes
Date:   Fri, 28 May 2021 13:37:51 +0300
Message-Id: <20210528103810.22025-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [46.97.150.20]
X-ClientProxiedBy: VI1PR0102CA0083.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::24) To BN6PR11MB1956.namprd11.prod.outlook.com
 (2603:10b6:404:104::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32aa00de-32f7-4a00-ca31-08d921c4ba79
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2097A512A04FBC6C37A8382FFE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eg6cPdC+n+zjq6+b7KjJ/yNIKUOmYA4NqK5C7E6bSTHUAkKtfFteKOX2c3S29qPJe/OMXYvJs9OjMNhye6e8tsWzjHHEhiJjcGWMlGBskx7Tt1GTkf6g7uKKl0UcmBTaS34R0/EZ1SQKN9jPddrERj00AzLvoKDfYmzLX5dHlpm8krVFZFLx8A2U2SUc1MiGlFy60qOlp8/ZhOEhnF9Fab5Bu9mEI2DOqmhiVqQjUUERGv7x9lCbp3v88hCoIr4fGjRrAGRp6zRAolEw89L2qr20wsXTlheoPXH/vyFukJmbPTnFrPSdJJiLUkQagS4VdRKRvyNqOkG0y+/MwH5CZLF24K+rZSw0uilGBHQijbRnOmGMRYn93iA/DOvaDdUkZlUX2tsfYvPUxMS7MT/NkFycruhMPRCWyP/BQ6pNE/QALjgKOYImlWOxZxMBXLpZgEdLFYEIzxSu6093W6dU2Zdrq4nUo3Nv8xWePo4t5F5ph5fKIDKrNAxnMjzRHGL2wMP1VPd62EiX8jks83xUPScfgYRQmGj0/2JtpO3JD5NVIOus91HXSroLLsp8KC01EcwT37SizAm+VkTq4Bk3KdPk+DyUaF3kYteGJxIzbHWeMQpMJgAfyXhyBWqti7nKUGJVjgu073UiStPjwJyFSVPMMLDijamDWGZriblQhR9JhRj49/YSxNGiLPrZ9Eg1j0Ot+8Rpayyd0ay2wchnqJ3BTRADMw33QQ0NaFDzM+w9+Hzp8PHg+sEceuKUOAfjYIPTp/9mfagjNq+WuDdGDFl0UnI/3vin4hl4qY8eWnnplEqlVT9sZP6KB7rsHEDG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(966005)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mcU3+jWDB5QG6sgDV9QNa0Bqdn7YImtbmxt1KUfNnM2RTYNH6xaQczYMMsBz?=
 =?us-ascii?Q?kNMksgX+dKC+hv6XclHuljbbr6mCo6Iz9BAapb4cHxk0GlsahGbChNS4UP5Y?=
 =?us-ascii?Q?GpTNx4dy0XAagQAWRA5Bi1AcfhlmpVF4ENrPy/t5aAzEb5jyWJiwEdAGwVd5?=
 =?us-ascii?Q?74mf4smmr1D1Z3lz8v64eLQBLldjGOlPCG5p7LrR0Q4ySgc3SWSljlZmsSSY?=
 =?us-ascii?Q?Pr8fpt+qo0OVrGsDLFmly2RIEJzZ9lpl8/bCNWBM3HDSvjATAZFpDQRv9bQ+?=
 =?us-ascii?Q?NM7DbyrMHwkGlnz45iiaICc2ICTbjgiVNFHrHtARRR3bMR02t9EHY/6yw7Qv?=
 =?us-ascii?Q?/ym+QfiX2muPcoryPCW4Uj7u/EwZvvipCUXmn6aTE7DhiCGQRA33gAB/fKkB?=
 =?us-ascii?Q?ZBp+vzkEc00LZSYEj1ueTbJnB1F5f/mogYI5LTjHGKGPxGypBHjl/jHQLYJX?=
 =?us-ascii?Q?Cn/hEoPzKaA9rCS58FY3kaFLnoWmWQUE/lhPJ0GiQGN6I0hMPVs46mihS2O5?=
 =?us-ascii?Q?4srKYDZqMQ5yaUlMjdHZc3H/wBj2WQWUytuzBKKZsNu1R/y9hB+iTiz3f8vN?=
 =?us-ascii?Q?42XkQOKJ5l7CQB3f6ZmuBY8O2IwC/50Y2MFGayo5UgrnTgIFk1QTwU6lNaBa?=
 =?us-ascii?Q?O4tmfTiFOREhnjrPkoYtVghlyjTrA0C0RFsaJmzB9PtxAF72D/cWOJSlOio0?=
 =?us-ascii?Q?mIG9caKwqEHRmn98Xli3rF69yTSV1Sx+tUitHFemqW6tZl1V9z8TGIFWfc7Y?=
 =?us-ascii?Q?zDzpTQkJmJ2CIXo6HxPT3BD7sG/14NEda9zPDAnQEcLqRSTv4LoekJfXUg0a?=
 =?us-ascii?Q?QOhinVh/dqNHb5Wev8lzJn1EQSa3YIrw2VTh1Oc5Oez+8JgRjO1Bk2IreZxP?=
 =?us-ascii?Q?GIvKZnhaX3vumYua+FwTcLqt+TPWmmtVAsDvC/M6b6nwodULjYcUKiqyGapn?=
 =?us-ascii?Q?M0Mi8vJTtCgoxlufl65pwEqh305EFtA7EhgsxjuzRpHDzO/NFNv2hkpsHTNz?=
 =?us-ascii?Q?TBEt1YvCmJ3TQzmGqrHhb0qvL7OTCm4LMi0/MNpv96k7qSsTLn+l5cQh3O+9?=
 =?us-ascii?Q?PPO8I4GnkltcjZoySmkusgmVBW3gLzM9X2bSPg/F9CafvVHCnpI1bC2JznV3?=
 =?us-ascii?Q?b9y76F5KBeFNKwEbXHTzqf5EpRqmMkr5yshj8AlN2BfnmdeaSZpGERYBn9wD?=
 =?us-ascii?Q?riUa94HFvXTIgcNNFvnSaZYXn/q0kLm5SB2+vS00XSQzBlO6ncoYqriyhJ2h?=
 =?us-ascii?Q?Vex0r9H4otiFtRe8VVLwp+KNu9jERR5NNjhuRSEYGRuZy+yhzf5AmbBxCL0n?=
 =?us-ascii?Q?0MozgQFr4HIfoREaakJqDH+Y?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32aa00de-32f7-4a00-ca31-08d921c4ba79
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:27.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUMsoZfSbajcwitIDA4EWdDjVCVnipmu7uc6AuM693dRB2LmN+kX+iGq/YxOE3pCufPDGPpgeTowPCe0qzFumfeTSi1O0KSkkaAYSKuqIFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-ORIG-GUID: 6dIWRLX2w-CkYXEF0elz3570IOVeRxzh
X-Proofpoint-GUID: 6dIWRLX2w-CkYXEF0elz3570IOVeRxzh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280069
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v2 updates:
- fix the last failing verfifier selftest by backporting the following
  commits:
* https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fb8d251ee2a6bf4d7f4af5548e9c8f4fb5f90402
* https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=37e1cdff90c1bc448edb4d73a18d89e05e36ab55
* https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=a801a05ca7145fd2b72dad35bd01977014241e55
- add CVE-2021-33200 fixes + support patch from 5.4:
* https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=8ba25a9ef9b9ca84d085aea4737e6c0852aa5bfd
* https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3d0220f6861d713213b015b582e9f21e5b28d2e0
* https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bb01a1bba579b4b1c5566af24d95f1767859771e
* https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a7036191277f9fa68d92f2071ddc38c09b1e5ee5

The CVE-2021-29155 part of this series is based on Frank van der Linden's
backport to 5.4 and 4.14:
https://lore.kernel.org/stable/20210429220839.15667-1-fllinden@amazon.com/
https://lore.kernel.org/stable/20210501043014.33300-1-fllinden@amazon.com/

With this series, all verifier selftests pass:
/root# ./test_verifier
...
Summary: 916 PASSED, 0 SKIPPED, 0 FAILED

What the series does is:
* Fix verifier selftests by backporting various bpf/selftest upstream commits +
  add two 4.19 specific fixes
* Backport fixes for CVE-2021-29155 from 5.4 stable, including selftest
  changes. Only minor context adjustements were made for 4.19 backport.
* Backport CVE-2021-33200 fixes. No modifications were made, all patches
  apply cleanly.

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

Alexei Starovoitov (1):
  bpf: extend is_branch_taken to registers

Andrey Ignatov (1):
  selftests/bpf: Test narrow loads with off > 0 in test_verifier

Daniel Borkmann (13):
  bpf, test_verifier: switch bpf_get_stack's 0 s> r8 test
  bpf: Move off_reg into sanitize_ptr_alu
  bpf: Ensure off_reg has no mixed signed bounds for all types
  bpf: Rework ptr_limit into alu_limit and add common error path
  bpf: Improve verifier error messages for users
  bpf: Refactor and streamline bounds check into helper
  bpf: Move sanitize_val_alu out of op switch
  bpf: Tighten speculative pointer arithmetic mask
  bpf: Update selftests to reflect new error states
  bpf: Fix leakage of uninitialized bpf stack under speculation
  bpf: Wrap aux data inside bpf_sanitize_info container
  bpf: Fix mask direction swap upon off reg sign change
  bpf: No need to simulate speculative domain for immediates

John Fastabend (1):
  bpf: Test_verifier, bpf_get_stack return value add <0

Ovidiu Panait (2):
  bpf: fix up selftests after backports were fixed
  selftests/bpf: add selftest part of "bpf: improve verifier branch
    analysis"

Piotr Krysiuk (1):
  bpf, selftests: Fix up some test_verifier cases for unprivileged

 include/linux/bpf_verifier.h                |   5 +-
 kernel/bpf/verifier.c                       | 300 +++++++++++++-------
 tools/testing/selftests/bpf/test_verifier.c | 112 ++++++--
 3 files changed, 294 insertions(+), 123 deletions(-)

-- 
2.17.1

