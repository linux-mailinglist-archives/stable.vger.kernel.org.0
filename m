Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DC33B21E7
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFWUmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFWUmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 16:42:06 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87E9C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:39:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so4547890pjn.1
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 13:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=weOFYHnAt9XHzyijtFN46zZa/bge4PQn7pFxvS+uscM=;
        b=PINKBfWpr3gvTyJ0eFnAv65n6MifZbR/apDoNhNeYQq+pb7Y+nHfI6/29jpyhKRsrA
         kSmtPGNKM36+xWmlgXqHNtUo2kVWovxkLqFL92N+B8M0nbpRfCD32Nat5OMJ3EJp3QwV
         KrPvrHdngyt40imWa1hgx+IPHVy1nFGR4oZAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=weOFYHnAt9XHzyijtFN46zZa/bge4PQn7pFxvS+uscM=;
        b=NWqyvIu0Q24OZklcduxA1j86GaVJD8kG9bXWttqZCsH1cCPVRSzy8DVZOI+RHviRZw
         gmkvt/QQHQ5ZOG/NMgDkB/+iUsVFuufxtOGm/57hTFHtWyA41NxLpIaICVDrB5+XnBSZ
         lxJ0hkNuFDlsWePRAjEKOamVx9O0L2JcmWEOE3XVSVRsF+j3xk+GzavVH5W+vL1Ibzna
         ncaLfdgRt29FD0cJgQdJ6JHUMT6UdWQY06/1yyH2WLa7tWEu2S4o4Y2tShlqUUKagYoG
         dvjbV0+Xyf7UnFEZU8LqudqA9CUZ7XMfQS6hdb66o0UsXWbspuCy83IG0ccUiSXckhMK
         a7ZQ==
X-Gm-Message-State: AOAM532W0NhpIlSyBdmp7mapZf23hcVOV7s+/E2KhiU2DrXPXDTM7iwG
        6Nc9rS/qn4S1h29fE/sZZApJQg==
X-Google-Smtp-Source: ABdhPJx1ypcWLUnUHJBbnBIjhX9m3ZNAxwtdnMUAu2WOpDwAvnSgoGuRx7tr0mmBARqaMdXFPQlhRQ==
X-Received: by 2002:a17:902:c789:b029:110:4933:71ce with SMTP id w9-20020a170902c789b0290110493371cemr1194211pla.56.1624480788561;
        Wed, 23 Jun 2021 13:39:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f5sm640523pfe.79.2021.06.23.13.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:39:45 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        kernelci@groups.io, linux-kselftest@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 4/9] lkdtm/bugs: XFAIL UNALIGNED_LOAD_STORE_WRITE
Date:   Wed, 23 Jun 2021 13:39:31 -0700
Message-Id: <20210623203936.3151093-5-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623203936.3151093-1-keescook@chromium.org>
References: <20210623203936.3151093-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=821; h=from:subject; bh=Ug1zxBYqfqGVjk6HZPE+S2IQ++k8iErOOapO5olSeEg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBg05wGnJvmDSLi1MPOx05nkNSD/27SmvDUPYKaSZ+b ABK1bYKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYNOcBgAKCRCJcvTf3G3AJhiJEA Ciux3+IGOay7Jw49WbIkgIv0TxSZgcO90q+vD3qxYri5Kve5Gl362F2aW0FCOlOtxfzOnGmC53o+vL mnCazUpoqn0dW/Y15W4dfOo+HoN5/Afr2nMEj2cwPYh7e2v3kQ2/JK4gaqP9mMDegUGCvWynQbQq54 md3YCttGo14SuaAMF9Wgo60xgxde5gIvQadm2WfvXU0BLyeZBBQb/iHJb8A06PBRzIBP06Nu+NmVVS 4gjNsMrbg6ltVcNDZ67UJ4sjzuFEP2hO+bd3d6/D/d7os59xJd11AHlpBYfk1gCBMC4wl/ZHgbOsaY ew49zKobbo1qt1K8F7Yct3U3IZZ9e2Ny/XCdM/rQMR0KlGYK/LXREO8mEubV2DBQzQidihoy2cFwBk 5gEjXn+w2QmsY5GXkuCXxsRXVw90q9IyT0Qt6kyJ44vqmTKpUFpcarqthBP1/2nXx243B73YaVCB12 6nd+koQb1m5NQNvzwZ8i/jObt5py/ucSDlpCVQ/PCl3NUt9sRB0S8MRNKXxgEJuNMGGs/BUSoYK5AE 51LAiLpudvJPuDuLgHUfzx1Ig+tAVem+P/7WoryLM/rDXtXqsXoyyHzBPcZGczV6nPm7xCwdkviySP adfzxjhgaQrqToXPyTkus9c6NYZDhVyUcK6oihTYUAjfRzEQc+F7f3grbaNA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When built under CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS, this test is
expected to fail (i.e. not trip an exception).

Fixes: 46d1a0f03d66 ("selftests/lkdtm: Add tests for LKDTM targets")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/bugs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 0e8254d0cf0b..9ff02bdf3153 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -161,6 +161,9 @@ void lkdtm_UNALIGNED_LOAD_STORE_WRITE(void)
 	if (*p == 0)
 		val = 0x87654321;
 	*p = val;
+
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
+		pr_err("XFAIL: arch has CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS\n");
 }
 
 void lkdtm_SOFTLOCKUP(void)
-- 
2.30.2

