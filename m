Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DE038A587
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhETKRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236473AbhETKPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F335A6198C;
        Thu, 20 May 2021 09:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503932;
        bh=beTbDepfJp+gV3uCFBN0fe35WAaiIPXY1D7wJK7dTI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwmiPT2mqQu7OA/m8dpi6/Zu3AVD9l4mmcWLbKEZgRxI00866Mi3cJ69yCW0+aj9M
         +W6Z6icd7EqWeTlAtoVrqfMoCDpzui+h0L9UEqyGkNQ9Z0aJY3+hutwqolL0aqv93Q
         eYBB/Io+RQ/IZIvq3VFLs4iUq32/3KoH6RSAOTfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Mendoza-Jonas <samjonas@amazon.com>,
        Frank van der Linden <fllinden@amazon.com>,
        Ethan Chen <yishache@amazon.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH 4.14 004/323] bpf: Fix backport of "bpf: restrict unknown scalars of mixed signed bounds for unprivileged"
Date:   Thu, 20 May 2021 11:18:16 +0200
Message-Id: <20210520092120.276176727@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Mendoza-Jonas <samjonas@amazon.com>

The 4.14 backport of 9d7eceede ("bpf: restrict unknown scalars of mixed
signed bounds for unprivileged") adds the PTR_TO_MAP_VALUE check to the
wrong location in adjust_ptr_min_max_vals(), most likely because 4.14
doesn't include the commit that updates the if-statement to a
switch-statement (aad2eeaf4 "bpf: Simplify ptr_min_max_vals adjustment").

Move the check to the proper location in adjust_ptr_min_max_vals().

Fixes: 17efa65350c5a ("bpf: restrict unknown scalars of mixed signed bounds for unprivileged")
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Reviewed-by: Frank van der Linden <fllinden@amazon.com>
Reviewed-by: Ethan Chen <yishache@amazon.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2204,6 +2204,13 @@ static int adjust_ptr_min_max_vals(struc
 				dst);
 		return -EACCES;
 	}
+	if (ptr_reg->type == PTR_TO_MAP_VALUE) {
+		if (!env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
+			verbose("R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
+				off_reg == dst_reg ? dst : src);
+			return -EACCES;
+		}
+	}
 
 	/* In case of 'scalar += pointer', dst_reg inherits pointer type and id.
 	 * The id may be overwritten later if we create a new variable offset.
@@ -2349,13 +2356,6 @@ static int adjust_ptr_min_max_vals(struc
 			verbose("R%d bitwise operator %s on pointer prohibited\n",
 				dst, bpf_alu_string[opcode >> 4]);
 		return -EACCES;
-	case PTR_TO_MAP_VALUE:
-		if (!env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
-			verbose("R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
-				off_reg == dst_reg ? dst : src);
-			return -EACCES;
-		}
-		/* fall-through */
 	default:
 		/* other operators (e.g. MUL,LSH) produce non-pointer results */
 		if (!env->allow_ptr_leaks)


