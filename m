Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBC56D4874
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbjDCO2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbjDCO2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:28:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D01E2D7ED
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2A1CB81C3C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44374C433EF;
        Mon,  3 Apr 2023 14:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532125;
        bh=IvNyldiVJejHRuc9Ee+FuAlqbzg0YWTHFYCHpIH/xKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOJgfpIvzBzabGtnmp0Nd3xNF3BpemlX7F09Nwt2Y6HCFziOeCfEgBhvnk2qHa3Ak
         YxpmOtTjlm5sh/OgKPz8HLdJWHbpLstcEhaIxqSDzAnTR2vS4MFddQsqXmqQcAVBzB
         32H1D+/of8XUUKbjenqPIueGPHy47cZoiRYZjGBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tony Krowiak <akrowiak@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/173] s390/vfio-ap: fix memory leak in vfio_ap device driver
Date:   Mon,  3 Apr 2023 16:09:11 +0200
Message-Id: <20230403140418.880517839@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

[ Upstream commit 8f8cf767589f2131ae5d40f3758429095c701c84 ]

The device release callback function invoked to release the matrix device
uses the dev_get_drvdata(device *dev) function to retrieve the
pointer to the vfio_matrix_dev object in order to free its storage. The
problem is, this object is not stored as drvdata with the device; since the
kfree function will accept a NULL pointer, the memory for the
vfio_matrix_dev object is never freed.

Since the device being released is contained within the vfio_matrix_dev
object, the container_of macro will be used to retrieve its pointer.

Fixes: 1fde573413b5 ("s390: vfio-ap: base implementation of VFIO AP device driver")
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Link: https://lore.kernel.org/r/20230320150447.34557-1-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 7dc72cb718b0e..22128eb44f7fa 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -82,8 +82,9 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 
 static void vfio_ap_matrix_dev_release(struct device *dev)
 {
-	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
+	struct ap_matrix_dev *matrix_dev;
 
+	matrix_dev = container_of(dev, struct ap_matrix_dev, device);
 	kfree(matrix_dev);
 }
 
-- 
2.39.2



