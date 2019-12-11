Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB1311B585
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbfLKPRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731717AbfLKPRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCE0020663;
        Wed, 11 Dec 2019 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077455;
        bh=DskxH4nDed/fTxBnpZHfThwnlrqdlMuYDLk36DG9sts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NmM2Z0Fv9OVasN2t/Zw4KtxqnHetGAIWJVV8ihTCIzfok8iriTMMb7B5vffzAvGt
         N1EPaGxBeeb5831RZur0pNdNncv6Csd7fb31hee8yfiMOf63o9H8ZM1+D4YMG9jRZ8
         jhZlibYu4DnMmaHyIf88wAFkA1Wwavrb5w2xhCqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alice Michael <alice.michael@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/243] virtchnl: Fix off by one error
Date:   Wed, 11 Dec 2019 16:03:28 +0100
Message-Id: <20191211150342.217595902@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

[ Upstream commit 843faff87af261bf55eda719a06087af0486a168 ]

When calculating the valid length for a VIRTCHNL_OP_ENABLE_CHANNELS
message, we accidentally allowed messages with one extra
virtchnl_channel_info structure on the end. This happened due
to an off by one error, because we forgot that valid_len already
accounted for one virtchnl_channel_info structure, so we need to
subtract one from the num_tc value.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/avf/virtchnl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 212b3822d1804..92d179fb6d59e 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -798,8 +798,8 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 		if (msglen >= valid_len) {
 			struct virtchnl_tc_info *vti =
 				(struct virtchnl_tc_info *)msg;
-			valid_len += vti->num_tc *
-				sizeof(struct virtchnl_channel_info);
+			valid_len += (vti->num_tc - 1) *
+				     sizeof(struct virtchnl_channel_info);
 			if (vti->num_tc == 0)
 				err_msg_format = true;
 		}
-- 
2.20.1



