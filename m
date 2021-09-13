Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D65408E47
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbhIMNck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242857AbhIMNau (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:30:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DB7B6135F;
        Mon, 13 Sep 2021 13:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539492;
        bh=d87ynHd6h2SUZY3lBKivyacyvCQ6TK6aS87wsCH9HkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZYVYOIEubPHu3UtXEzFs+Vnn6VjXjN69Gw3aYxHg+OOetbqPk0+1BdJ1mJ8dSF1p
         uzVej7t9XATK4h4oySGwyT3Kt26wwOLJUqmJM7lrYcnPjD30x1dOWQcfccbHcExByu
         JYE4CRl4CNVm/lkOxagTweO05Wt/GecxmUDIaBJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/236] crypto: qat - do not ignore errors from enable_vf2pf_comms()
Date:   Mon, 13 Sep 2021 15:12:13 +0200
Message-Id: <20210913131101.304509230@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 5147f0906d50a9d26f2b8698cd06b5680e9867ff ]

The function adf_dev_init() ignores the error code reported by
enable_vf2pf_comms(). If the latter fails, e.g. the VF is not compatible
with the pf, then the load of the VF driver progresses.
This patch changes adf_dev_init() so that the error code from
enable_vf2pf_comms() is returned to the caller.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 42029153408e..5c78433d19d4 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -61,6 +61,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	struct service_hndl *service;
 	struct list_head *list_itr;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	int ret;
 
 	if (!hw_data) {
 		dev_err(&GET_DEV(accel_dev),
@@ -127,9 +128,9 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	}
 
 	hw_data->enable_error_correction(accel_dev);
-	hw_data->enable_vf2pf_comms(accel_dev);
+	ret = hw_data->enable_vf2pf_comms(accel_dev);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_dev_init);
 
-- 
2.30.2



