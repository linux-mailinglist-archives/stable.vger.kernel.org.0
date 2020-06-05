Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF521EFB0A
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgFEOSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728586AbgFEOSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:18:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DCF02086A;
        Fri,  5 Jun 2020 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366682;
        bh=nZhiGEfILEKMt44G8xrubVFUgbwYyN4KAnoxAwiFdG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+e/6Jn5meqKiw9UxtdOxczvINjDcUJ3fGL1BzDQMb5A+W+3294M6XMViQFs8hn3q
         L330NEyW5JqR9xJxUUnog64ZbI6oUVkVLfMdhY2I6o9sZTWB15jjVkFjQ7bo5GGiHX
         55F35RNA2KEtXBaECUa+VK8+L30ZAfyVsV6wwcIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 11/38] media: staging: ipu3-imgu: Move alignment attribute to field
Date:   Fri,  5 Jun 2020 16:14:54 +0200
Message-Id: <20200605140253.247509122@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 8c038effd893920facedf18c2c0976cec4a33408 upstream.

Move the alignment attribute of struct ipu3_uapi_awb_fr_config_s to the
field in struct ipu3_uapi_4a_config, the other location where the struct
is used.

Fixes: commit c9d52c114a9f ("media: staging: imgu: Address a compiler warning on alignment")
Reported-by: Tomasz Figa <tfiga@chromium.org>
Tested-by: Bingbu Cao <bingbu.cao@intel.com>
Cc: stable@vger.kernel.org # for v5.3 and up
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/ipu3/include/intel-ipu3.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/ipu3/include/intel-ipu3.h
+++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
@@ -450,7 +450,7 @@ struct ipu3_uapi_awb_fr_config_s {
 	__u32 bayer_sign;
 	__u8 bayer_nf;
 	__u8 reserved2[7];
-} __attribute__((aligned(32))) __packed;
+} __packed;
 
 /**
  * struct ipu3_uapi_4a_config - 4A config
@@ -466,7 +466,8 @@ struct ipu3_uapi_4a_config {
 	struct ipu3_uapi_ae_grid_config ae_grd_config;
 	__u8 padding[20];
 	struct ipu3_uapi_af_config_s af_config;
-	struct ipu3_uapi_awb_fr_config_s awb_fr_config;
+	struct ipu3_uapi_awb_fr_config_s awb_fr_config
+		__attribute__((aligned(32)));
 } __packed;
 
 /**


