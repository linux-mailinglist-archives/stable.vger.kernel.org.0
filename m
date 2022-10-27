Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D8260FDAD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbiJ0Q5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiJ0Q5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:57:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4714D16D8BA
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:57:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6442623E8
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC20C433C1;
        Thu, 27 Oct 2022 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889867;
        bh=4kHUZF+AjruafifTCU4XMIzd0AbmpcJJB3gItGOU/5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWXLVWlzVwYUyzwuRZjXDeE8orbSiEYXunxJD1dNhAWlzzzrmZs+2Rm3WLrJ5jyIk
         6Q/n7ySS3Q8b0l15Nw/kPZeXIodYJuWmN6VrflPX8vuIGF5VUnE6fJOwQglJkcMr3B
         yGWcgwTGr/b5wg7X1CgFokxtDsuuIwz1ed4t1Xf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabien Parent <fabien.parent@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.0 14/94] cpufreq: qcom: fix memory leak in error path
Date:   Thu, 27 Oct 2022 18:54:16 +0200
Message-Id: <20221027165057.675123658@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Parent <fabien.parent@linaro.org>

commit 9f42cf54403a42cb092636804d2628d8ecf71e75 upstream.

If for some reason the speedbin length is incorrect, then there is a
memory leak in the error path because we never free the speedbin buffer.
This commit fixes the error path to always free the speedbin buffer.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Fixes: a8811ec764f9 ("cpufreq: qcom: Add support for krait based socs")
Signed-off-by: Fabien Parent <fabien.parent@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -213,6 +213,7 @@ static int qcom_cpufreq_krait_name_versi
 	int speed = 0, pvs = 0, pvs_ver = 0;
 	u8 *speedbin;
 	size_t len;
+	int ret = 0;
 
 	speedbin = nvmem_cell_read(speedbin_nvmem, &len);
 
@@ -230,7 +231,8 @@ static int qcom_cpufreq_krait_name_versi
 		break;
 	default:
 		dev_err(cpu_dev, "Unable to read nvmem data. Defaulting to 0!\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto len_error;
 	}
 
 	snprintf(*pvs_name, sizeof("speedXX-pvsXX-vXX"), "speed%d-pvs%d-v%d",
@@ -238,8 +240,9 @@ static int qcom_cpufreq_krait_name_versi
 
 	drv->versions = (1 << speed);
 
+len_error:
 	kfree(speedbin);
-	return 0;
+	return ret;
 }
 
 static const struct qcom_cpufreq_match_data match_data_kryo = {


