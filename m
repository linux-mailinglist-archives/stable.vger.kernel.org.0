Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4B75EFB53
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 18:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbiI2QwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 12:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiI2QwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 12:52:11 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6172413F29A
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 09:52:09 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id s6so3110957lfo.7
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 09:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=+GbD/ptGZHf8MZCMuj0GgHu63QZYzq8/heGLYQazOEM=;
        b=n5YuJfo6RJMbh+Gr3vilh0eN1CmMTwmV7Fc0LDeUXy4WvxTghMaGezSEnyGp17t6ts
         G+0h1p4GrijCWs9i5JnNWJ45Sg56rl0BNTWA7ubopq52hHhsPdvk1vaSQtDZsa9q0ofU
         99uued9iIHjUq3C8caPdjCvgEyn8d6Bw7rtJWqPyFL9Q65IkTxYEpCbZWb+p6ZXUBkxB
         feky5J55VcMqv7qr83g04i1Dbj226Rf0f0dxryCGvGzBRC4X8XRpNct6qMzpYWevXEjS
         hHe4+HPca/7Qsn7EEP/W5SxceesGcDG2gAn0OteF5sPhSYcm8zNQZY4B7DjzMO132TCQ
         skzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=+GbD/ptGZHf8MZCMuj0GgHu63QZYzq8/heGLYQazOEM=;
        b=EWwC5Xz4mvhyS+IEQWYzfoxiId1yTTtvXKlEnHcv/mQm6Lwntbg3dUpeRSWm44FIDH
         9TLiT6T08RyCaYCkJi7aY4Wb61fcyBy77MxxG+qnzzkDUGKKq9eKSF6HAVX2WqqUcrLD
         kcqk/Q8fyh+ntYDXhCCJeV+urZ+To1B+BsuiZcB7szRQazL6E6FZV3nJC/JM/I4MQ6+l
         fav/t9+C41IKV1zpq+DscJT0+gUgF0cS5JEYutaCdcpb48OZeQGac0GhhF/PWh0veHkm
         3epBQNN9p84Oe0e2VmKSST+d/Hw0luAlseWp3AmdnIVoJW4hhuIxHz8TqRRJf8fCjS3t
         FA4w==
X-Gm-Message-State: ACrzQf1bppKop0rQfJvXiOEpEWAJj/ApehI36XXQnTYQi0Ajnrx/Klp0
        P/Y0Rk6JoSX1YpUWWcO1oFpP7RZmeMSTLw==
X-Google-Smtp-Source: AMsMyM6jTQgE5bnVMrph3MLPUCREMEaURGqXdZHkT9RIy4iONmZApQw5Ac/I2w0wwUlnO3gDGzTJhA==
X-Received: by 2002:a05:6512:6c3:b0:49a:d227:1b5b with SMTP id u3-20020a05651206c300b0049ad2271b5bmr1732964lff.386.1664470327773;
        Thu, 29 Sep 2022 09:52:07 -0700 (PDT)
Received: from krzk-bin.. (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id be12-20020a056512250c00b00492ea54beeasm825423lfb.306.2022.09.29.09.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 09:52:07 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] slimbus: stream: correct presence rate frequencies
Date:   Thu, 29 Sep 2022 18:52:02 +0200
Message-Id: <20220929165202.410937-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Correct few frequencies in presence rate table - multiplied by 10
(110250 instead of 11025 Hz).

Fixes: abb9c9b8b51b ("slimbus: stream: add stream support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/slimbus/stream.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/slimbus/stream.c b/drivers/slimbus/stream.c
index f7da72ab504c..a476fa6549cc 100644
--- a/drivers/slimbus/stream.c
+++ b/drivers/slimbus/stream.c
@@ -67,10 +67,10 @@ static const int slim_presence_rate_table[] = {
 	384000,
 	768000,
 	0, /* Reserved */
-	110250,
-	220500,
-	441000,
-	882000,
+	11025,
+	22050,
+	44100,
+	88200,
 	176400,
 	352800,
 	705600,
-- 
2.34.1

