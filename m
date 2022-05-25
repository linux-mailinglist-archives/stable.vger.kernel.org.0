Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BC6533745
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244312AbiEYHUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244313AbiEYHUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:20:16 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECA42626
        for <stable@vger.kernel.org>; Wed, 25 May 2022 00:20:15 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l30so217783wrb.8
        for <stable@vger.kernel.org>; Wed, 25 May 2022 00:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h3wv4OgiOj88vHAqTCtvB+iGGgwfkgSPUu1AywhIbLM=;
        b=Uqr0fVvnhCRCCmtab/+cdusZRXoY/uLUVWE3s/feQMP0iBuwIrY/Eayjn/fLJYn4br
         BDkALRDiooAJt1s8uHZZnl1WPmgZlvo6izgLjHpkEW74fYwu+LG7sW/TVO+0lDDlUY2d
         1B6yYZ3QY8fwhXbRKlAo+l6DYkNFmBqMzgw7KcaY1uiHlYw4+3DPJIGZ1FxOb1Lg31KL
         KEIfLrRKuD8bNrEsujpr/5ilNIMu8ZkZ7Oc8aNXLw3mRLkUsZMUBWXnzSGUC5zinfoHi
         xhbI85ALFIbxH2BegwyXAdOVB3DtP7TlyixY99X7dCGJwijqtxKSEQs4Ir26QcmOUms0
         MitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h3wv4OgiOj88vHAqTCtvB+iGGgwfkgSPUu1AywhIbLM=;
        b=xPGISO37UuPc7Kts8glXZSiqOEYLBx7Pq4drH+fATR3sy3p4UccB9cmCjkGv1AAgEl
         XUARY6KhduB7SIbYZYJPOi///O9p59JW4lJJGCTDh+JytsvKZ/pCFRXIhlONXIp3izGf
         zrwjVmHpPDLbFy1W3T3Oq5Q9lJL49/brcTJPkkBVQJitGrxo4EvKGm//7dbn+kHhX585
         hUFyKM+Q7UJYQ7nydo86jjRUpm7hFJHgUi1mCVklTdoi3YxSmMcjmxDkNe7CEy5wtEkQ
         ANXCqX8jE2oje06/Ihg3OFxlhZuLQminsCXVQZVSSm+rMZkGOZTU+CE2QTSVUv1INZIe
         l/9Q==
X-Gm-Message-State: AOAM530586UD/sPM14m38xrYxZjmvAJAGHp3B833bGYo4NeAQOcdsGQf
        j4DegnpyYa5GDKhJQUNKuSM=
X-Google-Smtp-Source: ABdhPJyXJiYMWdZEzowh0yKQBG0NSh7E0JUDzi9vG/DFLUFhINrt7GJDdtbqGQDfrmI8KQQmJ/rAvg==
X-Received: by 2002:a05:6000:2c5:b0:20f:d604:274d with SMTP id o5-20020a05600002c500b0020fd604274dmr12797082wry.684.1653463214202;
        Wed, 25 May 2022 00:20:14 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id m13-20020a05600c3b0d00b003976fbfbf00sm725406wms.30.2022.05.25.00.20.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 May 2022 00:20:13 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org, maciej.fijalkowski@intel.com,
        bjorn@kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Shaw <jeffrey.b.shaw@intel.com>
Subject: [PATCH 5.15] ice: fix crash at allocation failure
Date:   Wed, 25 May 2022 09:19:53 +0200
Message-Id: <20220525071953.27755-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a crash in the zero-copy driver that occurs when it fails to
allocate buffers from user-space. This crash can easily be triggered
by a malicious program that does not provide any buffers in the fill
ring for the kernel to use.

Note that this bug does not exist in upstream since the batched buffer
allocation interface got introduced in 5.16 and replaced this code.

Reported-by: Jeff Shaw <jeffrey.b.shaw@intel.com>
Tested-by: Jeff Shaw <jeffrey.b.shaw@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2b1873061912..5581747947e5 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -378,7 +378,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 
 	do {
 		*xdp = xsk_buff_alloc(rx_ring->xsk_pool);
-		if (!xdp) {
+		if (!*xdp) {
 			ok = false;
 			break;
 		}

base-commit: 9f43e3ac7e662f352f829077723fa0b92ccaded1
-- 
2.34.1

