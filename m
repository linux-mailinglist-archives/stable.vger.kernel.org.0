Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB2F1B266C
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgDUMlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728924AbgDUMlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:06 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D23C0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:06 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so16276817wrs.9
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dJjaCdK3r6IAoOPZX6O1/KwvrCQleqNcbRzJakc7p/s=;
        b=oxfny/DXizDQSpFFHOE0L5UimQVryNg7dnyLlDCvrdjfSFvkYrWbWKPUnapDT3D3L0
         63O4yuKRX78niqMxRoSKtMULwLfrJgtm8WZyiuV0m+XEBU4UwQ2VpWKnwq6K0cJDTCYP
         fSP5BHvjqTSBAfOrO+AUBjkzx7OyVrOTu9+Ke+PPMH9dJIkLPeDLObA43dD8uJXDR1JC
         Ps2A0Hrw6TC2XSjATlGST/0ZDVULpAIz1/8MfoBlurV/vvbahN2lq+xHfe5HkBEX5GgB
         Ra7YD0xylgumNGTp8ohZcGDmqr9C4FywtdouY/5ZtOOn2FhFdx2bH5S1DdQhtXmGXvca
         nKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJjaCdK3r6IAoOPZX6O1/KwvrCQleqNcbRzJakc7p/s=;
        b=ho5Pt6X4h0xtGO0eDzepvgjQZcApsADZ9GmxEQ6PA7dtMMSg2haAiCmTxb99P6VrF4
         9mQFHfNzD8lpzxTDGOch4Wlsf2MCCpmPWKBmjqJu7ZIH1h+RryE7otScvqYVWCJyHnxC
         9lmBXIII1J5WQw1KRJcc3n9wR5yN1ZNYEG6at9i1/xhOXc56IqYHW6p+x2SA1PYfFeRN
         ULR2EKhLfoviwZiH/qa0o3Sl3+6+C7juEK51jax/7lCgzBlv9+TU5nQnO3t8atHqY6WA
         6CYPEnR4OFShz6w4BfUGzDjkrvMEM3JIpcNCdrTKcDgVy6GBKIdUs0wjMmZ9y0HrBWCl
         oxwA==
X-Gm-Message-State: AGi0Pub+3nzifmtZXnF+KGsf1/1jQYKUgRzmEVODSD4s3WxyuXWaO+sF
        9KJKGfmCRVoIGYTUQR8PwRxzF0xWwDo=
X-Google-Smtp-Source: APiQypJxIKOpxo04GM7IBN1An0jeMkNEWcCIiWg85xyiJSx+VJcGRWqkc2tD23739JDe5+5u8tSeGw==
X-Received: by 2002:adf:ff89:: with SMTP id j9mr23809071wrr.245.1587472864982;
        Tue, 21 Apr 2020 05:41:04 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 15/24] net: qualcomm: rmnet: Fix casting issues
Date:   Tue, 21 Apr 2020 13:40:08 +0100
Message-Id: <20200421124017.272694-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

[ Upstream commit 6e010dd9b16b1a320bbf8312359ac294d7e1d9a8 ]

Fix warnings which were reported when running with sparse
(make C=1 CF=-D__CHECK_ENDIAN__)

drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c:81:15:
warning: cast to restricted __be16
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:271:37:
warning: incorrect type in assignment (different base types)
expected unsigned short [unsigned] [usertype] pkt_len
got restricted __be16 [usertype] <noident>
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:287:29:
warning: incorrect type in assignment (different base types)
expected unsigned short [unsigned] [usertype] pkt_len
got restricted __be16 [usertype] <noident>
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:310:22:
warning: cast to restricted __be16
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:319:13:
warning: cast to restricted __be16
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c:49:18:
warning: cast to restricted __be16
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c:50:18:
warning: cast to restricted __be32
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c:74:21:
warning: cast to restricted __be16

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index ce2302c25b128..41fa881e4540e 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -23,8 +23,8 @@ struct rmnet_map_control_command {
 		struct {
 			u16 ip_family:2;
 			u16 reserved:14;
-			u16 flow_control_seq_num;
-			u32 qos_id;
+			__be16 flow_control_seq_num;
+			__be32 qos_id;
 		} flow_control;
 		u8 data[0];
 	};
@@ -53,7 +53,7 @@ struct rmnet_map_header {
 	u8  reserved_bit:1;
 	u8  cd_bit:1;
 	u8  mux_id;
-	u16 pkt_len;
+	__be16 pkt_len;
 }  __aligned(1);
 
 #define RMNET_MAP_GET_MUX_ID(Y) (((struct rmnet_map_header *) \
-- 
2.25.1

