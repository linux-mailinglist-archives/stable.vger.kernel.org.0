Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB57A59FD89
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 16:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbiHXOsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 10:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiHXOsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 10:48:11 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9337D793
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:48:10 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id bs25so21083406wrb.2
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=G5/xgeKSAlRXp4X/BoNtwwsaMOFH+NuxbXdqvx4HoIY=;
        b=BYtA00s/OrZgQwvv/8zzCVAoFoY16Ay5g7bjgpBgG7e1TXRxIsUfkjWvrMiVH4U+0x
         Z8zl0l8V4iKjBbhaOerRCKRKSYwUlfzkV68/2tjIuus5IJ5B0E0kvpL3Kf82jVnA5+N9
         /ES+QKw16KPmPz5MsBQSRyOIP//xTKIA81LHkFGMuWCsLoMtSF3SSAiFrfhFnZnGOMYq
         DaJyCMwUxylyOlUuy6fcrDrmZSyuTIDtYtlv0tJNHwU/CmWQ6VtTPxe98d9R/zIgGgqj
         rYFKb8+HgZ/2nzbPLFHMxShj4ovKotJ9pWeHsmZn75oJ8t1N/r8wz8ySMzzhOyhTGf8I
         +9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=G5/xgeKSAlRXp4X/BoNtwwsaMOFH+NuxbXdqvx4HoIY=;
        b=qDAzMCeBcS14VLWVam8aMg6lt2hTUEyNINwSjRKIpuF7cZRLltzess0Fd/juYUBHGf
         PW8hAbZ7rmDY+fzEKlsggrq2Q/9aKpRyNG/n9/86OBXqT4Rdy7QBWu5uUcfqE8KOwASj
         S6k4o5S4ONMG20Iy0nb0ZtCUZfm90kEuDwLfwLzLJOfL4cnjbs3pf+gqOL0ULRM+hsy3
         WiWZTlB+zDWxudmx2oAZI0P40S7cQ47CXGrJ9XeDAKnkh9pDgkqTTvvhL2TOjn1K8cYm
         /AdEY+2mJdlZIhOLoO/qhvfkVuLVHaU8qZNgZ8v22hxWK+BHWKc1SZrXtpuCqDrwQ+/Y
         4slw==
X-Gm-Message-State: ACgBeo0za0pkQQdKuB0AQp/KuFNfcT4NhK5JRjAo/06jx228fFrNpbfy
        loFpv+IFMcmjGCe6D1LHKSFwqC/yabFQmoDa
X-Google-Smtp-Source: AA6agR5a06GAi4/xz8mk41PGy9/2Gin1BIyidl/F66kBfgb4gKC5gZYb7so7KO21h8T6n8e9H3rFUA==
X-Received: by 2002:a5d:6481:0:b0:225:6c68:def9 with SMTP id o1-20020a5d6481000000b002256c68def9mr3669771wri.52.1661352489505;
        Wed, 24 Aug 2022 07:48:09 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id m6-20020a056000008600b0021d6dad334bsm17277031wrx.4.2022.08.24.07.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 07:48:09 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, raajeshdasari@gmail.com,
        ovidiu.panait@windriver.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH 5.4 1/2] Revert "selftests/bpf: Fix "dubious pointer arithmetic" test"
Date:   Wed, 24 Aug 2022 15:43:27 +0100
Message-Id: <20220824144327.277365-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220824144327.277365-1-jean-philippe@linaro.org>
References: <20220824144327.277365-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 6098562ed9df1babcc0ba5b89c4fb47715ba3f72.
It shouldn't be in v5.4 because the commit it fixes is only present in
v5.9 onward.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 tools/testing/selftests/bpf/test_align.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 4b9a26caa2c2..c9c9bdce9d6d 100644
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
-- 
2.37.1

