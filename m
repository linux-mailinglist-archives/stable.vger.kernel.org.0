Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F8448EB95
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 15:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbiANOVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 09:21:10 -0500
Received: from mail-eopbgr100134.outbound.protection.outlook.com ([40.107.10.134]:15040
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235465AbiANOVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 09:21:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSv4MLST8Qn8jS4lmRZFe/oW/bhqvaa5GWliM9Ygm/WzooWZvtLZEBPnmDxcfn8adRM/5p4ztBYK+x3SqKkFHnrWid0AW2kRokHk8JCzAi0yBGCpyQrDblbQjrfBwLGFSSzDYRXShrbWtzQoin5+ZlkWkyOSXO/EeMBd2cxCsYLvGLEjAglRWDK87mdhAaZBOt6ug5BkBABJFKhm9fDIHCzk0n9oSo25S4xN//4qgiCOktBa9DVjip5xySsC9GJF6oxiicQV7V0+WLRv7NjDq3ez5REKmQW7BOdqYr5F94AMN7IipqZbroC/G2d2ffGEu9X7Hy+Gfw/7hTKEuoEc0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxVMMb/g6tYoVITroOz1Wc1KREyDTRKNJuZLa+0CsAE=;
 b=oB2BmjcyGtyo2hGBFbmteingC0Dd4EdsPWcqGU3mgdICwsyaXy8xKHdp567pyxk7eL7hzLvso4nA0FC+m6gw1FtAtIbYIldphzFn/GN6V1fqubiGyXh1nXn1Y3rLtTvkfFaCZn6A/LW1WOT2Axgr8Md6Kgs/8qObBT0S4BjG8cbq4opM1hjaVebPNnJDo7BPQhUbu7W/JbcD/EzaWwh87R/CE8AtddhZJTaFAruPWS49cQMMmuwJoeaeLd3ynVjcQH5c9YW1gF8LXq3RsoE4l+D2GwXBNgNArUFnKcd+I7KUgggfW7pKI4udfZt6euu1Pmf+Y77oapezVXywsG8lew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sancloud.com; dmarc=pass action=none header.from=sancloud.com;
 dkim=pass header.d=sancloud.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sancloud.onmicrosoft.com; s=selector2-sancloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxVMMb/g6tYoVITroOz1Wc1KREyDTRKNJuZLa+0CsAE=;
 b=WWyZZoVv7vh6g9yV4rPUb6rfZZM0QJyMkkDWG4/mskPtqPgzPhKMTmE7qjafUwN/dCHspjqiR9eHr8T7vLAWIcnZ+Y0DkW3fqo2mfLvI3LSeQ2TB3Qy5nKOznB9/cCcU7sWTtB3a1NVYsPsfBbYcyVAtKwJgqWsMjce9VQrdbzY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sancloud.com;
Received: from CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:61::19)
 by CWXP123MB3352.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 14 Jan
 2022 14:21:04 +0000
Received: from CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM
 ([fe80::4ce0:d9e3:cb2f:7992]) by CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM
 ([fe80::4ce0:d9e3:cb2f:7992%5]) with mapi id 15.20.4888.012; Fri, 14 Jan 2022
 14:21:04 +0000
From:   Paul Barker <paul.barker@sancloud.com>
To:     stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Paul Barker <paul.barker@sancloud.com>
Subject: [PATCH 5.4.y/4.19.y] kbuild: Add $(KBUILD_HOSTLDFLAGS) to 'has_libelf' test
Date:   Fri, 14 Jan 2022 14:20:26 +0000
Message-Id: <20220114142026.12426-1-paul.barker@sancloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <04598430-7383-b725-2f5f-3f2b16aaca36@sancloud.com>
References: <04598430-7383-b725-2f5f-3f2b16aaca36@sancloud.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0050.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::14) To CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:401:61::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33c2db64-a1d9-4981-f8ec-08d9d769190d
X-MS-TrafficTypeDiagnostic: CWXP123MB3352:EE_
X-Microsoft-Antispam-PRVS: <CWXP123MB3352D837F933538969789D5793549@CWXP123MB3352.GBRP123.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BaDO7ZQpO6R5pGuxwoSoVqaD4knQJz/6AapyaM9PTTHwkM3f8mcPfFvrjMEKjK3Go+OQCVguvGI/EzD6g54S+AUFMLNgrA9e++AfOdF2OSp72pEXmfadSKHlnafYM6uCE88dkY+wdyWic7KsX8vliE3Pnft8+fYgyWdow5IvEeayKsG249g9NSRTIal1EAbojHUigYMLNgJ5MNPOu+z1V4qrKWTyIru8JU4u5hh1tf2n8jD4rXIQPVwNfcWaGMc5RV/50g59d+freFbiAFs4pbUFeWd/QYaGAU3pJzvrcd3OZHabB7c+4ZtJgP4gfxFCZhIP/x40ABX6EfbyhyNboAUplEIfvKR+4iWbOuPWArut8Sxc+S1GTkvs3u4KNFGALgk849RVxCTphxAm5vjbDYSEknzDBExKGx47HEqYVpzDgcJZYDpTOliM6C9jZsRu1jDR3epxN1+aRA2r60/NFiSz6mDl8+a5sO5w1x+84B9skb/jMjAHvvOZVGkveOWOqbBQ4aiRenulMS39v9wz0dDEf3rg7Em5F+54NHHgMurn0rMlG/qLJBstdnazjmxV+9DlNwa1UqRa9Se6NssngGVkW0kACZtDlgvobCUMtx7Rs+URRPb5Ujg4JoXjksYKJyF9eFD7x3yUNkK867+njiL6BUmjzPc1c8Xivhg8eF8IEYKUXSQwpb4t8yAv4amUC+kO0qXHKO1jjKrB8VTddwNQ5+gmMIm3JVtVMW/AynwFzGSQVyqfp3dkSaQ/1hKXMvXEFUkXmvjP5phlOtWsyikTsv3oqmkZhb7LyLyexwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(39830400003)(346002)(136003)(376002)(6512007)(5660300002)(86362001)(66946007)(66476007)(4326008)(2616005)(966005)(107886003)(26005)(6916009)(66556008)(6506007)(508600001)(186003)(52116002)(6666004)(38350700002)(8676002)(36756003)(38100700002)(44832011)(1076003)(8936002)(83380400001)(6486002)(54906003)(316002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N32C5+VbVJD13eJgJ3YbPK26qcIbvnO+p0BE4QK+878XFQ3/kYadZ+zqcpIE?=
 =?us-ascii?Q?pMedgCCqr6pun8vEdz1dVAibQghsBcLDBQfCD3m4MS8rhxJGBfxk3y/ODfED?=
 =?us-ascii?Q?k2Fn1OjCzXfRFjfU0AckME1gWoEZz7KGxDMgGeX9Xi/QYerJtgCRgbT9R5jm?=
 =?us-ascii?Q?o+voTinKd3hbVmbJzqKuARMTXNFE3vM5saDdPK82U7L9k+25UJLPWfhIax7Z?=
 =?us-ascii?Q?hC9T9DB5w/aUNJSOU2bci4rJiWub8AWRHjxD9DM82oYgmmBlwoXvxajB3DlU?=
 =?us-ascii?Q?whlKnu0A0Zr5l7auzIeurylzM8FVj2WDJHvPrGvuaNacLhDpAIreH0FmFYlA?=
 =?us-ascii?Q?30GfLk2IDlEL+209NYxo5w7TzeMP3O7eH7fCyLiAidJ2qQVPLU4sU50HhJJ7?=
 =?us-ascii?Q?2jd4f2woyDfQAftAm6WfUW8HxFp7OW8j6H7wPiwCrXr5wT+OV68SFb+QMb2t?=
 =?us-ascii?Q?jK3XcQ6xccs6BaE1JaTb2/VCiruWAmoFbcF3pibDYLMR3zOYkeHZxp/Ux20g?=
 =?us-ascii?Q?O7khMmMPUkFhhSiQUUOMyyPztLVLXLKJPQFiAo7aoNHiy13KyTJ9dsEOwy7H?=
 =?us-ascii?Q?46n5F4JPfHmKaAr7qV+GKczCRjd7O7fEiF+aYIFCvsvX/k9/9x/FpZxui6P5?=
 =?us-ascii?Q?2eNPbFNPPZhChAH/CUoe7xvToYWjxLEiTy1Si1QBKgZWPqL6ifpwkUctO8rq?=
 =?us-ascii?Q?bnyaMYoynpeQxdVeCidGrvaFxBPBXqLOufZJnG2nPJEHF7kzukUNHdF3myEP?=
 =?us-ascii?Q?vidqkSGuO3AVVYsPrwTbWPrNC4L6OzLQQBdvKUurdlT1DFxiIVdbYsMa+Op0?=
 =?us-ascii?Q?u0Gn/4YT7qoVexjogbQ5Go2TWQhYUcBvMMAo9vnKjkwkRfNcRl/Ms85MIla4?=
 =?us-ascii?Q?wgvhUHZFD6aD4fGHu/burFBoU/GxqWtooXj44lCQKvwU9Pk+wUcqPpiRpQM5?=
 =?us-ascii?Q?lPHvRytEGKmUg3YvIzkBADnWpKAoTADBTwt5TCCFPHKpMpjGN+ZetNx45j4e?=
 =?us-ascii?Q?dC0pSeUh0r+TO1+isZLqxlmF0I5WPIUeKL9ADCmx0YdIvVhTUx3MXRlFREY1?=
 =?us-ascii?Q?0GhqC4wk3jKLs08rCI4C0Ay/AEQqJo8/Ekt55yg/5VwTJLP907Nf/VNknePG?=
 =?us-ascii?Q?KUpQVlfpbK7FPkCIaDNqW0a1c0Vj1KoY6/NgK76Oah5fuep+M94pbbHAxMno?=
 =?us-ascii?Q?fJVA+MoKe2CTz43mlVmcwfvUG0wj9qbr0Sm9XZ+b9j+06BDF5zILXEsLmRLI?=
 =?us-ascii?Q?62S3kwxjCMyBOW64mz8sly2dQOO9JSPX1f2iZJpHOIi+axi8pS7SqDOicaCm?=
 =?us-ascii?Q?dLn1UI6tCS6y0AQ2QElL4venZ2zzgWqmG28QwqDBge5KjnX1QYY2gwaihht9?=
 =?us-ascii?Q?jqI6t3p9hzmFx11bRyUv+7I/vUpOB1Z6JHNvcwrV5OPCBekLcWr9f6VnJlC0?=
 =?us-ascii?Q?XkpnSn5iG+ZvviIW4Hr/VQ8ruFwEVctDgwGbXkufR0qTKPjAfwOmQKJ2DSSi?=
 =?us-ascii?Q?MZHqb0Pj9h3QvO9tbANk0UeOTmh/T/BLvQ7ze702+MqjxGZZ4pvXNYjv1zOo?=
 =?us-ascii?Q?vSQd9IvrB3bCEnnC5S8kC2nhpSWSnW8vdHg+UPYLXwX1QlKWzUfC2T8enHDt?=
 =?us-ascii?Q?K+6wmuPtrIVWcI6dlFOWKTMmuRQQ9yH7iUCYFnt+9gS7L5EKi1DeZme1OkYm?=
 =?us-ascii?Q?p1LcpA=3D=3D?=
X-OriginatorOrg: sancloud.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c2db64-a1d9-4981-f8ec-08d9d769190d
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2022 14:21:04.2613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 840be37c-244a-450e-9bcc-2064862de1f4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1n069CLZyeH3G9YLYFwA6xjJj2IkSsEeFZkxuSQLPiuTBOeteQPz49ncSKdsAAXB86G1gGBw96w7OLjCYsDvGs/BD524JoA7vsnrCFLZ7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB3352
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

Normally, invocations of $(HOSTCC) include $(KBUILD_HOSTLDFLAGS), which
in turn includes $(HOSTLDFLAGS), which allows users to pass in their own
flags when linking. However, the 'has_libelf' test does not, meaning
that if a user requests a specific linker via HOSTLDFLAGS=-fuse-ld=...,
it is not respected and the build might error.

For example, if a user building with clang wants to use all of the LLVM
tools without any GNU tools, they might remove all of the GNU tools from
their system or PATH then build with

$ make HOSTLDFLAGS=-fuse-ld=lld LLVM=1 LLVM_IAS=1

which says use all of the LLVM tools, the integrated assembler, and
ld.lld for linking host executables. Without this change, the build will
error because $(HOSTCC) uses its default linker, rather than the one
requested via -fuse-ld=..., which is GNU ld in clang's case in a default
configuration.

error: Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please
install libelf-dev, libelf-devel or elfutils-libelf-devel
make[1]: *** [Makefile:1260: prepare-objtool] Error 1

Add $(KBUILD_HOSTLDFLAGS) to the 'has_libelf' test so that the linker
choice is respected.

Link: https://github.com/ClangBuiltLinux/linux/issues/479
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

commit f634ca650f72 upstream.
Modified to account for the location of the has_libelf check in 5.4.y &
4.19.y.
Signed-off-by: Paul Barker <paul.barker@sancloud.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index cfcecc33b4c1..ebaec73de53b 100644
--- a/Makefile
+++ b/Makefile
@@ -972,7 +972,7 @@ HOST_LIBELF_LIBS = $(shell pkg-config libelf --libs 2>/dev/null || echo -lelf)
 
 ifdef CONFIG_STACK_VALIDATION
   has_libelf := $(call try-run,\
-		echo "int main() {}" | $(HOSTCC) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,1,0)
+		echo "int main() {}" | $(HOSTCC) $(KBUILD_HOSTLDFLAGS) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,1,0)
   ifeq ($(has_libelf),1)
     objtool_target := tools/objtool FORCE
   else
-- 
2.34.1

