Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB07D5AB05A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237888AbiIBMw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbiIBMwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:52:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058D8E394F;
        Fri,  2 Sep 2022 05:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1CAD62178;
        Fri,  2 Sep 2022 12:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83D1C433C1;
        Fri,  2 Sep 2022 12:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121659;
        bh=b73JFdEEH0L5zpEOhUoRbXlzxwYfjFJus6um4Pn4iT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMwI0YozS9gwT20hpV+MI/o2IdzGpIABI4D8ig+ZygiLsvKNc8JvsszbSbzXH4cRJ
         ou0HdcCsNL4uQ38GmdG5yS04kYBOgX8BOyaU/MlZfs9MZybjJpSjSkPaeCS2G/8uwb
         ssWx9DgTYR0ezVOCPDxrMdLD3K5cZp81oo7wfD8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH 5.4 05/77] Revert "selftests/bpf: Fix "dubious pointer arithmetic" test"
Date:   Fri,  2 Sep 2022 14:18:14 +0200
Message-Id: <20220902121403.789465369@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

This reverts commit 6098562ed9df1babcc0ba5b89c4fb47715ba3f72.
It shouldn't be in v5.4 because the commit it fixes is only present in
v5.9 onward.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_align.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -475,10 +475,10 @@ static struct bpf_align_test tests[] = {
 			 */
 			{7, "R5_w=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
-			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
+			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 			/* packet pointer + nonnegative (4n+2) */
-			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
-			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
+			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
 			 * We checked the bounds, but it might have been able
 			 * to overflow if the packet pointer started in the
@@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
 			 * So we did not get a 'range' on R6, and the access
 			 * attempt will fail.
 			 */
-			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
+			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 		}
 	},
 	{


