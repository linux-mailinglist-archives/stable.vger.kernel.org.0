Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6800967E1EC
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 11:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjA0Kkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 05:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbjA0Kkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 05:40:41 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2B61E1E8
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:36 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id l8so3128216wms.3
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVFyvvqIkRzvUovTQs0s3jDn0ZcULXdzwuQvtfzyO/k=;
        b=oV9mSWhHUtgHqeSuyXNG423VqtkTvJp3igDAMP/EKKcM5gDvnZBRMdKQPXFVQK5fFr
         mLXZy9MWM2/ZsjrwwPm5n4pIFW84n4wwWhSUOn9YEHl48gj/uWUk4RrPZUuqwKuB9Yuj
         zYqcHPjywp5988sJllSQG7L3aP5BOJH73I/X3U+vG0ba+JqH10Yj+2xPCuPnICZHfTbO
         Vj4FuO/+L14vJwQ4pH2jen7f37oqFfshizKVGVX87V0Qq46hlgNzkhiln4vRk5s+c2kf
         f/M0b8mZ6qiMk+iIEh4nNKlznmM5G/jfqsD83O/XLrDZ5CbYy864dW+Q6LyVl1q8Gmrp
         iWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LVFyvvqIkRzvUovTQs0s3jDn0ZcULXdzwuQvtfzyO/k=;
        b=J4TLFHvaLKb8BO7pnXDLbxjIDF9PSXhgT23Rcju3CiB3nN6X8AcHoIk35fRhztNU+4
         3TPmFGttV0Komly05Bsp2+juHIvSO+/4ZgZQutu8gyqqTnZjpsxjgDTicm+PmcxWJOJr
         q4eV1A7V55MJYRn1yFz6PGL99R+O2nJv3m2VGDMfewjnj3hQNIxqGMStIcMK3VMeX1Vc
         rI8sTF1cuxbp19hKhKEVSQNXQCUKQ0nkqrAycNHaCuzZk7zFdFSubXK0Ulw/mulSUxLt
         g9CJRz2VUWbIzRWQqnnMjRX1kniLm/P7EHpxzpNCxVsWuz7DMRQlqcsVnD3YfuF7m3/o
         cPlw==
X-Gm-Message-State: AO0yUKW/Lw7AFQuuwJjeCSFssJ9bw/7S5+IGwaQUwcvEKyV75LHJE0LU
        jWn8MNKZcaZNGV6BAd1faK2i6w==
X-Google-Smtp-Source: AK7set+YisgTnmyv5U9Og2xueykLP97orptchBjRMp7KuTHvyRn2RlHaX9IN+VxJ+k+o7JAEQ+Mg6A==
X-Received: by 2002:a05:600c:3ca3:b0:3dc:1687:9ba2 with SMTP id bg35-20020a05600c3ca300b003dc16879ba2mr12981094wmb.35.1674816035343;
        Fri, 27 Jan 2023 02:40:35 -0800 (PST)
Received: from localhost.localdomain ([5.133.47.210])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003dc34edacf8sm1619787wmc.31.2023.01.27.02.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:40:34 -0800 (PST)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 10/10] nvmem: qcom-spmi-sdam: fix module autoloading
Date:   Fri, 27 Jan 2023 10:40:15 +0000
Message-Id: <20230127104015.23839-11-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
References: <20230127104015.23839-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

Add the missing module device table so that the driver can be autoloaded
when built as a module.

Fixes: 40ce9798794f ("nvmem: add QTI SDAM driver")
Cc: stable@vger.kernel.org	# 5.6
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/qcom-spmi-sdam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/qcom-spmi-sdam.c b/drivers/nvmem/qcom-spmi-sdam.c
index 4fcb63507ecd..8499892044b7 100644
--- a/drivers/nvmem/qcom-spmi-sdam.c
+++ b/drivers/nvmem/qcom-spmi-sdam.c
@@ -166,6 +166,7 @@ static const struct of_device_id sdam_match_table[] = {
 	{ .compatible = "qcom,spmi-sdam" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, sdam_match_table);
 
 static struct platform_driver sdam_driver = {
 	.driver = {
-- 
2.25.1

