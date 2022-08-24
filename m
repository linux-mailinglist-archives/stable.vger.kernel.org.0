Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E2459FD8B
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 16:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbiHXOsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 10:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239319AbiHXOsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 10:48:13 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57BF7D794
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:48:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h5so20259346wru.7
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=a0nwryXk7Jx91y952yNfQWl+ePzhLd8gmC5lQW7qcb4=;
        b=HKIt/civCuTV1e2OXuH8CZ9rBc7NV8LAIXC3fGvyyqrV2qw3dcGTKyHCrsOr84Up0x
         wOhIYhL81ToZ4vTnFVBfHavPNicWNz2uvmxJgPkltyJvAZmgc+XrOsfPFVEztEHx6xPb
         CSLEZxCW8O0YWPQEZhyUgtnrSl4s+/EP29tfRQ1up8lNMmAa9zXbk/OezdLDhCKElruJ
         /pFrJ9qwDKIm0upGJsUeN72s5vw1qqCFj1wEPL5upmLLClatJtgJ1F5Fmxdk80OV4agd
         v1n7xl05ENJZ+dBtL3Bqm6J5QTnwOxmXgfGrH1+98giT7ND+dUNdWiUzSD4Pisij/YDW
         939A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=a0nwryXk7Jx91y952yNfQWl+ePzhLd8gmC5lQW7qcb4=;
        b=PjP58+dnP8JEI5WWAVYBY/ABAgGhyw6JP/PZS4oOUjQ7cIH42hJJH+V1ax3S/5D89j
         wwEMIpV4f6+JjrDeXHJzFP6g/iK16ISwK/QXV2hCiUFV2lXxwLzNW6njFYJ65GkrVlZ2
         jqg8c1S5xijUgnhdnvczglcJW9Eo5tNxxQRYoUyehU11Nt1WM3Kg8ze1NqJC66YkbWkE
         XhUGwSZqSPaa1Ax9ujpkrN7P2Xil6CDr2/6sB/cYYWoQbSpcpDajunRDa1y3aTTYWcs7
         m5xkz9adfJxGhBoQsxbRyn7TqgRd6zrSoWkNJwTz6NoZilwjSoamSF5jeKTBSupLG671
         7Nkg==
X-Gm-Message-State: ACgBeo3uPvqt9FiVKw1a5WWaWb1UYeqiw3ktMrrxwgGIf4kAm/sStqht
        hybVyPNLvtY7yPnFdjZ6Y0BrqcXgjDtCnPsC
X-Google-Smtp-Source: AA6agR70oA8q13txmTQISjGBOvXdbCsFmcB+aOr2crzoMRJF5SFcePjoxO9DumrPjKwhFO/hiU9j2A==
X-Received: by 2002:a5d:47a6:0:b0:225:6283:3d71 with SMTP id 6-20020a5d47a6000000b0022562833d71mr6524165wrb.694.1661352490239;
        Wed, 24 Aug 2022 07:48:10 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id m6-20020a056000008600b0021d6dad334bsm17277031wrx.4.2022.08.24.07.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 07:48:09 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, raajeshdasari@gmail.com,
        ovidiu.panait@windriver.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH 5.4 2/2] Revert "selftests/bpf: Fix test_align verifier log patterns"
Date:   Wed, 24 Aug 2022 15:43:28 +0100
Message-Id: <20220824144327.277365-3-jean-philippe@linaro.org>
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

This partially reverts commit 6a9b3f0f3bad4ca6421f8c20e1dde9839699db0f.
The upstream commit addresses multiple verifier changes, only one of
which was backported to v5.4. Therefore only keep the relevant changes
and revert the others.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 tools/testing/selftests/bpf/test_align.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index c9c9bdce9d6d..6cc29b58d670 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -475,10 +475,10 @@ static struct bpf_align_test tests[] = {
 			 */
 			{7, "R5_w=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
-			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
 			/* packet pointer + nonnegative (4n+2) */
-			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
-			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
 			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
 			 * We checked the bounds, but it might have been able
 			 * to overflow if the packet pointer started in the
@@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
 			 * So we did not get a 'range' on R6, and the access
 			 * attempt will fail.
 			 */
-			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
 		}
 	},
 	{
@@ -580,18 +580,18 @@ static struct bpf_align_test tests[] = {
 			/* Adding 14 makes R6 be (4n+2) */
 			{11, "R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c))"},
 			/* Subtracting from packet pointer overflows ubounds */
-			{13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c)"},
+			{13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c))"},
 			/* New unknown value in R7 is (4n), >= 76 */
 			{15, "R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc))"},
 			/* Adding it to packet pointer gives nice bounds again */
-			{16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
+			{16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
+			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
 		},
 	},
 };
-- 
2.37.1

