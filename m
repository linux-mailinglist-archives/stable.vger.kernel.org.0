Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5FE5F2A94
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiJCHiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiJCHgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:36:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CA553033;
        Mon,  3 Oct 2022 00:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CAAC60FC8;
        Mon,  3 Oct 2022 07:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6271BC433C1;
        Mon,  3 Oct 2022 07:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781636;
        bh=1oxNERi3eXgXWzf8KJU9HsfF8QTxjcjbZkWj4/oMzss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QK2Xd9bIRc4b71UiejSMk8JRDJ7M3DwUjWeqcVe0W1ZzA2+QYzM22YbBLXGivNfHx
         5co34UGOJdEs6RJdox4iCMfM0+CH3YX83qwPvaALl1kh9rFil0rN6b2cgbrZMYyxpc
         KNYmhWSth0FDUX5urbXWSk+kiMRmjlhaxy4XWzRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/52] thunderbolt: Add support for Intel Maple Ridge
Date:   Mon,  3 Oct 2022 09:11:08 +0200
Message-Id: <20221003070718.735626674@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit db0746e3399ee87ee5f957880811da16faa89fb8 ]

Maple Ridge is first discrete USB4 host controller from Intel. It comes
with firmware based connection manager and the flows are similar as used
in Intel Titan Ridge.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 14c7d9052837 ("thunderbolt: Add support for Intel Maple Ridge single port controller")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/icm.c | 11 +++++++++++
 drivers/thunderbolt/nhi.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index 82c46b200c34..fa24ea8cae75 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2300,6 +2300,17 @@ struct tb *icm_probe(struct tb_nhi *nhi)
 		icm->rtd3_veto = icm_icl_rtd3_veto;
 		tb->cm_ops = &icm_icl_ops;
 		break;
+
+	case PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_4C_NHI:
+		icm->is_supported = icm_tgl_is_supported;
+		icm->get_mode = icm_ar_get_mode;
+		icm->driver_ready = icm_tr_driver_ready;
+		icm->device_connected = icm_tr_device_connected;
+		icm->device_disconnected = icm_tr_device_disconnected;
+		icm->xdomain_connected = icm_tr_xdomain_connected;
+		icm->xdomain_disconnected = icm_tr_xdomain_disconnected;
+		tb->cm_ops = &icm_tr_ops;
+		break;
 	}
 
 	if (!icm->is_supported || !icm->is_supported(tb)) {
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 4e0861d75072..69770beca792 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -55,6 +55,7 @@ extern const struct tb_nhi_ops icl_nhi_ops;
  * need for the PCI quirk anymore as we will use ICM also on Apple
  * hardware.
  */
+#define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_4C_NHI		0x1137
 #define PCI_DEVICE_ID_INTEL_WIN_RIDGE_2C_NHI            0x157d
 #define PCI_DEVICE_ID_INTEL_WIN_RIDGE_2C_BRIDGE         0x157e
 #define PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_LP_NHI		0x15bf
-- 
2.35.1



