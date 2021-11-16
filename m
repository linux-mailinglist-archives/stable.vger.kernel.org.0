Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEE4453949
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbhKPSTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239318AbhKPSTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 13:19:04 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F49C061746
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:16:07 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so2997265pja.1
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jZwVIrUtt66FvkTYvH2h4rOOrPwYYNizZZ68EuMUgBw=;
        b=ecCi+3H53VF27o66R95NXZnJLqToFP6UPKVKFDj0YaRXB/RSuRb+mgk/Hqzc2lxRhD
         QD7/orHAhcq2SlU/HtnFNLhSUdKFFyV1/LRBpYv5JIh1u/q8tF1ed8ZHlAmRw4pe21o5
         vDhDtAkkMID7ceMXENJ+zUxyjVtqZg22wQ1hc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jZwVIrUtt66FvkTYvH2h4rOOrPwYYNizZZ68EuMUgBw=;
        b=6LNw8tPeFgDc5mrzzGE7SBGLwLWUwh3CBns0iVU8V7k86AfCxuGtUsXPLAUHZOI3/N
         yAol/PHDa41QWmcfVSHi+p3j0+FFKJped3/BRuMPWO0WpW8+dmwJ//0MMN9t4O5K62Hc
         5W98XG3WFVEUHWGG5EMWAQaKLqjq9AidS49fOmM8Wx555NnQs6r13P2qrG5hcJbwmixR
         ot9k5EQTMhtA10/yGA0Qn4HIFspJ/0r5Nd0b4BnbFGseNP9M4EGZic8akttaLNLxlp+9
         n99K1IhC9BcFKXb7g7rgQiu6j9t3uAgooFH83PO6vvqonCp0BQmhKAIAvBCPn1Yh7lW9
         61Jg==
X-Gm-Message-State: AOAM532REB6lph9AgtSjsJgxmdWnSeWzZXbpznPqCp+7pM8+MtyMPnHd
        SQRGy1qLzpRSZbIuamZlLAdXVoRGUqiO6Q==
X-Google-Smtp-Source: ABdhPJxCE1msMxKhPNjRopniMrwQqm91A1A8Fz9sAnrkiGY+2lB8N/PQviwa4bKwlFNhGo70T1pD6Q==
X-Received: by 2002:a17:90a:a083:: with SMTP id r3mr1299426pjp.55.1637086567311;
        Tue, 16 Nov 2021 10:16:07 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k6sm575416pjt.14.2021.11.16.10.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 10:16:06 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] Revert "mark pstore-blk as broken"
Date:   Tue, 16 Nov 2021 10:15:59 -0800
Message-Id: <20211116181559.3975566-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=817; h=from:subject; bh=0GcyUqnzth9aOQtAkuCBec83+pRmmuCDo+1R3cjV9uk=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhk/VfTIYSW380RAAY7SEI0Q0t90crm0ZHl+mhTfAs cQxRNkmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZP1XwAKCRCJcvTf3G3AJr7VD/ 4nHpwyYGst9SCigK4WFnSp+MCI+9zL+t4UCfdIqDcMz/XluArydZXgzO6TU18k/MTrdhuD7pio7T+0 9rV0xtpI43n1qNdKgIDuHTbu1PqDm2z8BhX+xgIZxnUnEP9rtAJyWq7tB/ThDtHzM6+mht3HJAwY9r ll3Ft2BC2GdM2YVW1biN9DLRWzETY34ctG5OJW7O4z9DlPoLGCRec9o4xz4JyK+gmowN9rQAPrYUmd 2XNVgYLebFwfVkhkwHsLotyvBU2YGfuh9Yz535x2Q8Ks9Fedzp9zvER7ltt2ubxylyAKv/CnbPiEaM Y0CHbJHFIwiKN/wyfNMglq48mMLZ0CQ+Ji/6AUeXnVj4zh5yxFcDMHm4g5Tx6x/ApSBnQ81fJiulQ6 HhpIkW5S2K6YcbWK1iO2LrQR61AcebRvG+iU5d95D8+c3Pg3aHUo9n6BDI7flDA/SmXHVjWQP5bKCO 2wLOzhaU9kuWLu6j/9C3HAmYAr1ovxaBiBPCFrPyTRhpuvHMS/JbKLM7V69jOPb+xMxMrE/TzcZSlK sQaoyBW6bXUhlziKfBn96R/wUHYkmxHmBKOM9sRcv78gkLQO7pB9yhrdtCLCA9EOWPHiof8WjrSvXa 0E2XlIDowb+1elXiT7aKvTpBtkes56xzrrHRHWxkkYoYAOFYlN+n7EUnwJkw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit d07f3b081ee632268786601f55e1334d1f68b997.

pstore-blk was fixed to avoid the unwanted APIs in commit 7bb9557b48fc
("pstore/blk: Use the normal block device I/O path"), which landed in
the same release as the commit adding BROKEN.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index 328da35da390..8adabde685f1 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -173,7 +173,6 @@ config PSTORE_BLK
 	tristate "Log panic/oops to a block device"
 	depends on PSTORE
 	depends on BLOCK
-	depends on BROKEN
 	select PSTORE_ZONE
 	default n
 	help
-- 
2.30.2

