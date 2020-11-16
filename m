Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F3C2B5420
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 23:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgKPWKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 17:10:25 -0500
Received: from mail-eopbgr770101.outbound.protection.outlook.com ([40.107.77.101]:30248
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbgKPWKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 17:10:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKxURucejhN94TIVJMVupYv9PZuN/CzUu3E7ceCdVd1GCyYWJPQz5IEbDLPU9i31R1PPqQTAD4FRhwqhCidy9dcmP/u73t2XXS6BkwWYWjNKWihj7c0fS6nm95OfI4AUMsyzEc55MSxmqMuVrrQm87JWgHcouU7Eff7CBFb/U9j0d4S8vnh/Um4/JjD+AzMvth25PonF2r1gsLg80E1t9VNTbcCyXgpj1q2u1ukKwP2019PCVBGw3uOhCeNcB02/2DrghVGlHPPsNliszKOo164NTFAxJ1Rl54LplYCHLcEyYAUAhcoYvpIoGV4EFcgrqsiqScizsow3v+sLZ8DhLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7unqnR35j05lmlQ0jZwf7HsGLlgeeboAXXKUlRNyg8=;
 b=m+uRqecqoG1Q8n3YQNSj1bq21JId7gfdRP8LN6rE+sTXCSaQDu4YBHPweAul7FlQ/PhOhlfI8/07pkJ3FVCNgxqHAi9G1kJzK4Gocz9y5AHqtDXKrCloYT6jj0jvWv3YTO7AKx+QdC27IR/+ad0GvYtnSX9mFDrDpL2i7OOoub5aRW5S4/quCfFfijbPb8DK5XE7UTvbva5mSbJJCu6ZRCEFw2GwWc2ypvwWQY/581eL1VOAfgN8yVJqNkCBAr8lgGWB90IcZDMy1ZAcKoAXlwjTKc32MkpIvI+fNoKcpBJxY8oc9r2KvTh+PdWxfPT7cnCje/Esga/AVBLHZ+8bzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=concurrent-rt.com; dmarc=pass action=none
 header.from=concurrent-rt.com; dkim=pass header.d=concurrent-rt.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=concurrentrt.onmicrosoft.com; s=selector2-concurrentrt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7unqnR35j05lmlQ0jZwf7HsGLlgeeboAXXKUlRNyg8=;
 b=WrrfV3DpkJFiwXxcQU28NAdsVlyaIz1bwyWhHi9JYzFCg2UIVLlzdmoTONbijnpFny1AMcy6x8JNAXcTOX8rWIJtTjWCFNtC26ZQ5a5X4c2SEXt2poG7WDUm+Gwc95AOMcjj3o3sIdkaS16x4WbSjwwUBwt59Rizh+cEBMrOmuU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=concurrent-rt.com;
Received: from BN6PR11MB3874.namprd11.prod.outlook.com (2603:10b6:405:81::18)
 by BN6PR1101MB2210.namprd11.prod.outlook.com (2603:10b6:405:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Mon, 16 Nov
 2020 22:10:19 +0000
Received: from BN6PR11MB3874.namprd11.prod.outlook.com
 ([fe80::8036:d1d5:1b59:ee34]) by BN6PR11MB3874.namprd11.prod.outlook.com
 ([fe80::8036:d1d5:1b59:ee34%7]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 22:10:19 +0000
From:   siarhei.liakh@concurrent-rt.com
To:     linux-kernel@vger.kernel.org
Cc:     initramfs@vger.kernel.org, stable@vger.kernel.org,
        kyungsik.lee@lge.com, yinghai@kernel.org,
        4sschmid@informatik.uni-hamburg.de, JBeulich@suse.com
Subject: [PATCH] unlz4: Handle 0-size chunks, discard trailing padding/garbage
Date:   Mon, 16 Nov 2020 17:09:59 -0500
Message-Id: <20201116220959.16593-1-siarhei.liakh@concurrent-rt.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [174.70.73.170]
X-ClientProxiedBy: BN0PR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:408:e7::6) To BN6PR11MB3874.namprd11.prod.outlook.com
 (2603:10b6:405:81::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sl-s76.concurrent-rt.com (174.70.73.170) by BN0PR03CA0031.namprd03.prod.outlook.com (2603:10b6:408:e7::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 22:10:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffd2cfa3-2198-4146-51c2-08d88a7c6707
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2210:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2210370F44544FBA6521C1F5B1E30@BN6PR1101MB2210.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: foVxKeWqyMsxDAGFmjNDclsQlmqouABWaT0R+6lx22h6ju8IjCshCqtPeVQ2TU/pJvs7ioDuqekHFS28inz2odiXtJw45WU4+RG057fQMiSc/nCm0wt/n01hxLHQaRL3bP5L1z4YatB6Nclrmm18PEn7YeOwOa0+Y+snyAkcBqpIlF4Bd1KGo1AmH9CLDZIUD8NQkLu6FhuDfEPJFsG7H6osXKm9l46en5QTY8+sVAkDNp6Tt+FAtYVNKm496EPOpOH9tkIth9pqowckWuD18m/DTl74iNDkhPn92JhKi13brwxM7EaU7gdgiADKQnoSzdHIV5oXmtel5uI3pskuWHxTEiwYkZ3UJwOzMBM7N7JWuIGY68MBKFQAeM5kwCDUkK9asZAqqMxB2gjhYMUC2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(39840400004)(366004)(7696005)(2616005)(52116002)(1076003)(186003)(6666004)(6486002)(86362001)(66946007)(956004)(5660300002)(16526019)(2906002)(83380400001)(36756003)(66476007)(8676002)(9686003)(966005)(316002)(8936002)(66556008)(26005)(4326008)(16799955002)(6916009)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jhwsPPN5Hd6A0ra+dgkNkeXdJN3yQ+hN8+fTWSoicaZIdT6MtdSHx06H9c/YthVLSEAw4HZOuaRewQITisXq+tlDov8ohHI+6fkRTa87EL2r+KxL/f8FJhyvYGAqECJfGtRyQZ7qtgj8q9qRH4iPSns0DPJTpPHvuJR6Te817bLXS/Wo/xJFAhZgfyYQBuB5AoNk56OFLb6Dfgd1SP0Gda9xz2evZiJ/VgYx/pAQ1O6X/C9ug9LBF2+ht4FjPuaUhSaI7h6RG9vWe8+EoiUNDGVkqD/s2bfKukMFA14876aOE3qyMUxun5KDSXVUfiiNbWnyOGL9GmLkPICNOxtjWD37K2M8m8x5tD1f1/4Bd2ggKy9Qqu5YzPZKkcSI6g9IFnLTlTpr+rJ1j789YU0jzW7nml5BdoWnPQhN54RPKyrOfhoJst0rMmpXPXRfPxeoamld7cdE2Sb6+FhsQsn3glle+83g/ITPum1xazXpjtRLsawn8/e+mD9Mb2apZCI6OsxDzkidk8JM6oKicwz5sBfFF+DK+th+66PZ8Seafq7d2tSiJOKO/IxLd0ki7pIcdW0t+SY5LPWRtfS/WbDy9n4XKRZjJMjvpYCtDDYzoeQA+PdxMvTCtp1/rrGhz93g7bLLuCgH8e2LgpBuSLzJBI/NBGYPoevkKeng7AyvOYpEhvMWAMo7jtPjrlcdPeTekRlwELntAqpu3E7G9er+JyXYCX5umtKC9iQW2abWWLGF670gBBpnDV1B1iUPvuSS2xjb1NmjZ2qnClBw0oTXV9xfx5bT5mry3ft7PYaNSpqVQnk4r6PPSNSnkMsAcnddFGrL/V1LZNPP4/HKK4g3EGM02eMrUCeM3CatGaaHsugZZOV/+va2TJ84Y1KuwyDUe6P0voUqOU7ctV99NPyBLg==
X-OriginatorOrg: concurrent-rt.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd2cfa3-2198-4146-51c2-08d88a7c6707
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 22:10:19.2270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38747689-e6b0-4933-86c0-1116ee3ef93e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBEgFJq3sBbKtj5TaPpN0B7qe5iSe3BL8X0Vk03Br6uB8F2Zw+ZM5f284P40Cl5Tjfx4LAwlXZCJFTZfUBOawOgNmr9KngoJCl++Vl/6ua8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2210
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siarhei Liakh <siarhei.liakh@concurrent-rt.com>

TL;DR:

There are two places in unlz4() function where reads beyond the end of a buffer
might happen under certain conditions which had been observed in real life on
stock Ubuntu 20.04 x86_64 with several vanilla mainline kernels, including 5.10.
As a result of this issue, the kernel fails to decompress LZ4-compressed
initramfs with following message showing up in the logs:

initramfs unpacking failed: Decoding failed

Note that in most cases the affected system is still able to proceed with the
boot process to completion.

LONG STORY:

Background.

Not so long ago we've noticed that some of our Ubuntu 20.04 x86_64 test systems
often fail to boot newly generated initramfs image. After extensive
investigation we determined that a failure required the following combination
for our 5.4.66-rt38 kernel with some additional custom patches:

Real x86_64 hardware or QEMU
UEFI boot
Ubunutu 20.04 (or 20.04.1) x86_64
CONFIG_BLK_DEV_RAM=y in .config
COMPRESS=lz4 in initramfs.conf
Freshly compiled and installed kernel
Freshly generated and installed initramfs image

In our testing, such a combination would often produce a non-bootable system. It
is important to note that [un]bootability of the system was later tracked down
to particular instances of initramfs images, and would follow them if they were
to be switched around/transferred to other systems. What is even more important
is that consecutive re-generations of initramfs images from the same source and
binary materials would yield about 75% of "bad" images. Further, once the image
is identified as "bad",it always stays "bad"; once one is "good" it always stays
"good". Reverting CONFIG_BLK_DEV_RAM to "m" (default in Ubuntu), or changing
COMPRESS to "gzip" yields a 100% bootable system. Decompressing "bad" initramfs
image with "unmkinitramfs" yields *exactly* the same set of binaries, as
verified by matching MD5 sums to those from "good" image.

Speculation.

Based on general observations, it appears that Ubuntu's userland toolchain
cannot consistently generate exactly the same compressed initramfs image, likely
due to some variations in timestamps between the runs. This causes variations in
compressed lz4 data stream. Further, either initramfs tools or lz4 libraries
appear to pad compressed lz4 output to closest 4-byte boundary. lz4 v1.9.2 that
ships with Ubuntu 20.04 appears to be able to handle such padding just fine,
while lz4 (supposedly v1.8.3) within Linux kernel cannot.
Several reports of somewhat similar behavior had been recently circulation
through different bug tracking systems and discussion forums [1-4].
I also suspect only that systems which can mount permanent root directly (or
with help of modules contained in first, supposedly uncompressed, part of
initramfs, or the ones with statically linked modules) can actually complete the
boot when LZ4 decompression fails. This would certainly explain why most of
Ubuntu systems still manage to boot even after failing to decompress the image.

The facts.

Regardless of whether Ubuntu 20.04 toolchain produces a valid lz4-compressed
initramfs image or not, current version of unlz4() function in kernel has two
code paths which had been observed attempting to read beyond the buffer end when
presented with one of the "padded"/"bad" initramfs images generated by stock
Ubuntu 20.04 toolchain. Some configurations of some 5.4 kernels are known to
fail to boot in such cases. This behavior also becomes evident on vanilla
5.10.0-rc3 and 5.10.0-rc4 kernels with addition of two logging statements for
corresponding edge cases, even though it does not prevent system from booting in
most generic configurations.

Further investigation is likely warranted to confirm whether userland toolchain
contains any bugs and/or whether any of these cases constitute violation of LZ4
and/or initramfs specification.

References

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1835660
[2] https://github.com/linuxmint/mint20-beta/issues/90
[3] https://askubuntu.com/questions/1245458/getting-the-message-0-283078-initramfs-unpacking-failed-decoding-failed-wh
[4] https://forums.linuxmint.com/viewtopic.php?t=323152

Signed-off-by: Siarhei Liakh <siarhei.liakh@concurrent-rt.com>

---

Please CC: me directly on all replies.

 lib/decompress_unlz4.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index c0cfcfd486be..a016643a6dc5 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -125,6 +125,21 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 			continue;
 		}
 
+		if (chunksize == 0) {
+			/*
+			 * Nothing to decode...
+			 * FIXME: this could be an error condition due
+			 * to invalid or corrupt data. However, some
+			 * userspace tools had been observed producing
+			 * otherwise valid initramfs images which happen
+			 * to hit this condition.
+			 * TODO: need to figure out whether the latest
+			 * LZ4 and initramfs specifications allows for
+			 * zero-sized chunks.
+			 * See similar message below.
+			 */
+			break;
+		}
 
 		if (posp)
 			*posp += 4;
@@ -179,6 +194,20 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 			else if (size < 0) {
 				error("data corrupted");
 				goto exit_2;
+			} else if (size < 4) {
+				/*
+				 * Ignore any undesized junk/padding...
+				 * FIXME: this could be an error condition due
+				 * to invalid or corrupt data. However, some
+				 * userspace tools had been observed producing
+				 * otherwise valid initramfs images which happen
+				 * to hit this condition.
+				 * TODO: need to figure out whether the latest
+				 * LZ4 and initramfs specifications allows for
+				 * small padding at the end of the chunk.
+				 * See similar message above.
+				 */
+				break;
 			}
 			inp += chunksize;
 		}
-- 
2.17.1

