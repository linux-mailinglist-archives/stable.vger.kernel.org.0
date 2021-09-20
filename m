Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4823A411A40
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243289AbhITQs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243025AbhITQrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:47:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E217611AE;
        Mon, 20 Sep 2021 16:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156382;
        bh=6iTU7lGJM32Aa0d+IJG1BTR+lZTC4LxxCYjNTs5nnMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kpVvEP2LYrvc+QEiKRtP6mszpGF0wPEz59NU++ZmxKX+i1whgxnNp0foErGEIqCJ
         pfMUKK6s6mrs0kIr41eDo/xbah6i39Q1kPebYDvwgFUlLw4g1A0wImHYN1OW8B2FfA
         5U5lOmfdHcV6GyO3WZbLiEkpAL6uTL0YsDO/cxLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 034/133] crypto: qat - fix reuse of completion variable
Date:   Mon, 20 Sep 2021 18:41:52 +0200
Message-Id: <20210920163913.739944789@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

[ Upstream commit 3d655732b0199562267a05c7ff69ecdd11632939 ]

Use reinit_completion() to set to a clean state a completion variable,
used to coordinate the VF to PF request-response flow, before every
new VF request.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 5fdbad809343..711706819b05 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -384,6 +384,8 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	msg |= ADF_PFVF_COMPATIBILITY_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
 	BUILD_BUG_ON(ADF_PFVF_COMPATIBILITY_VERSION > 255);
 
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
 	/* Send request from VF to PF */
 	ret = adf_iov_putmsg(accel_dev, msg, 0);
 	if (ret) {
-- 
2.30.2



