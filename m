Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11FDFE7D6
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfKOWd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:33:59 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35511 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfKOWd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:33:59 -0500
Received: by mail-pg1-f193.google.com with SMTP id k32so917882pgl.2
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Tc+IEmTbMBJCj4EiVIkUr9PV2atSgJthk3up+qVhyOE=;
        b=BoaaaX8RsyTJpotwcaZaTD6Tyhn833MOIIDHMWr3NTNPT5Mmx71uuoUUG3DF6Dup9s
         lAeMeISC4gG/92nA7AyPgTb37ys0iuHbAxbDO3MU0OERSfxWYFUPDT113kahRoqHbacV
         1t2mCpDH0ZffJLXrG8zehsSd086kaA621p1+yYiMxgHdxcG5EAUKq3YCqy6MmqrI/Es/
         jcnzhcv9t4AopOYTO8EQg53V68MNnuwplarZG6y/N4NId2Rw73Yj2+YdKFtJGEvW7J+1
         VuZbzXMxe1W0aqKbfqGyJgz/TEKm+UhMbJtGGZ6czxRqmh5bNfZmhSfjIiVFZ/z7ZgGU
         1VrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Tc+IEmTbMBJCj4EiVIkUr9PV2atSgJthk3up+qVhyOE=;
        b=XjATz8fO2khgMR8eEhbQc6/fpLqPOLgE95HWgVc8Hs9sNddbG/cDtZwnJec4Xuab1u
         sh8u71QEa7jcMYjdbTamfraBYIHYzLeIHhhScx6S7dVfQP7GY4EELwmuEEvdZmFc5Suq
         6yuj41qLmqOUydmEhNgggJEbV1buah8ki8ABXklH9dVRu7giSc/nnx8zw8/8eUPPDtHt
         gIRPrRKutCdmmbB8+CpBOx+ze8olSEWCWSp4ZmPcWDcPGiX+0fFsyRm7ARqUJAxn1Ii4
         fqrKXGZRRo6FApGawdNQjRicJavyUN8ZwMwVUeyNM98ngXuhDx+yG7d1aH2OS9Xx9BDD
         F54Q==
X-Gm-Message-State: APjAAAWTvDK5WivP50iSWlSmNjJ1ZsVJTi0Jnf5/XurwMvLM7W2UIL1u
        eqbB4e95Om63G3JMkW4XTQJKjkp9NCE=
X-Google-Smtp-Source: APXvYqzUrFqYWdMgMuMww+ixzlV+FmQouQrALIgHfRTCaefzB7ScRo91nDaA8H/KKozVPoI12PkkMQ==
X-Received: by 2002:aa7:870c:: with SMTP id b12mr20357084pfo.30.1573857238096;
        Fri, 15 Nov 2019 14:33:58 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:33:57 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 01/20] i2c: stm32f7: fix first byte to send in slave mode
Date:   Fri, 15 Nov 2019 15:33:37 -0700
Message-Id: <20191115223356.27675-1-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

commit 915da2b794ce4fc98b1acf64d64354f22a5e4931 upstream

The slave-interface documentation [1] states "the bus driver should
transmit the first byte" upon I2C_SLAVE_READ_REQUESTED slave event:
- 'val': backend returns first byte to be sent
The driver currently ignores the 1st byte to send on this event.

[1] https://www.kernel.org/doc/Documentation/i2c/slave-interface

Fixes: 60d609f30de2 ("i2c: i2c-stm32f7: Add slave support")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/i2c/busses/i2c-stm32f7.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index ac9c9486b834..48521bc8a4d2 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1177,6 +1177,8 @@ static void stm32f7_i2c_slave_start(struct stm32f7_i2c_dev *i2c_dev)
 			STM32F7_I2C_CR1_TXIE;
 		stm32f7_i2c_set_bits(base + STM32F7_I2C_CR1, mask);
 
+		/* Write 1st data byte */
+		writel_relaxed(value, base + STM32F7_I2C_TXDR);
 	} else {
 		/* Notify i2c slave that new write transfer is starting */
 		i2c_slave_event(slave, I2C_SLAVE_WRITE_REQUESTED, &value);
-- 
2.17.1

