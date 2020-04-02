Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAB019C99B
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388710AbgDBTNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39079 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388892AbgDBTNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id p10so5579338wrt.6
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dJjaCdK3r6IAoOPZX6O1/KwvrCQleqNcbRzJakc7p/s=;
        b=BQDsFe9n5ukI4Nu4h04bWHovTQyqIxOX784kBquD7gPZJ3tFXlcxk0t/iUrMuwn9o1
         kVEKSveh3kBbAKMhPXh77GNyp3qtVor4L2sl3XJwyuLNb0A3ICC5LcPId31Nx/1Pjc8y
         7fY6AW5oWTUsGwelCpPghA2u7hJMdWr9YwyJMcTue2+v9B8uxZzWmvfag/TZX9J9HEZg
         0awBB3Fp9QVmNg/c0AcR42IiviRuLuFxhusrxO/Gp8TT+GQ/Gp3RgI5eSY+1VZYuxzz9
         JpNdILrSomsmis7Z4tfLbJvLt+3eTRyFINXhPpZk4FuUt6rNxMCObFCQUBk+Cd4MW8mr
         rveg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dJjaCdK3r6IAoOPZX6O1/KwvrCQleqNcbRzJakc7p/s=;
        b=eHBFS0dcW7R3qpP+BprjFi/G1KH/KyNOqMncyzSZG73jt5U/fbpxUO/JN1mLOyN+Au
         Z+C5cv6gpXlVJjbmYsdpxRBfJV68fnC1HFV7hOq7GnGKybpjHeoCmr4DV5w/WQRSzZvc
         ncuiOSWoLMPTDpYATrmIXnpQY04IJj4AMzVE5Tic7jbbJuQhsYsPHGULdDHEYkJBQYen
         KOfJKfz39FikN5eRSmqyjQbDFQD7NyMFKq4jvefEPkTV06oZY36xlCU64EdLqQtjOt1u
         fISnQfuS7chcYPcpQRc6ulXh07HGEFIe+iATdEs1CnQoK7CBIUIiC79hJyeflC3ov4cC
         WP4g==
X-Gm-Message-State: AGi0PuZqhIHtx3X0TvZZ3n7wj6oGAUm6Ou5zHQ3qMDj7z023eXqM4ldd
        C70PPt3d1GOHdQpswzbfwy3mQRX4CcvdBA==
X-Google-Smtp-Source: APiQypJhQDySB+zoVrYO8+bTkEsLguBDJE1gYYplc1zyjUYZ3eosSnK/r65pCQN/kqcbKLQiZiRh9Q==
X-Received: by 2002:adf:b258:: with SMTP id y24mr4897334wra.318.1585854799896;
        Thu, 02 Apr 2020 12:13:19 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:19 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 21/33] net: qualcomm: rmnet: Fix casting issues
Date:   Thu,  2 Apr 2020 20:13:41 +0100
Message-Id: <20200402191353.787836-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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

