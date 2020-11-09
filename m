Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4012AB91F
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbgKINF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730964AbgKINFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:05:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14795206C0;
        Mon,  9 Nov 2020 13:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927154;
        bh=3zmPrO5O5D6mLC0yk7Sa7K03eKQW/GI8p0sj0yyITFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ns9XVnu88gZSaNo8uyWmV+F45H/YWcNBboglhvOjMC2RLynFvJt/jyoii0QNmp8PP
         ysC+O0OfPQqzWGs7K90I2COnkCv048iU1DESUm41IeXJd0XWDtOsc8WcCSFiwmsqSM
         kmyC6I+bAaJk9HJ9TqpO7sQ5yeuoBuO8VliEifDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Nemov <sergey.nemov@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 12/48] i40e: add num_vectors checker in iwarp handler
Date:   Mon,  9 Nov 2020 13:55:21 +0100
Message-Id: <20201109125017.344634174@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Nemov <sergey.nemov@intel.com>

commit 7015ca3df965378bcef072cca9cd63ed098665b5 upstream.

Field num_vectors from struct virtchnl_iwarp_qvlist_info should not be
larger than num_msix_vectors_vf in the hw struct.  The iwarp uses the
same set of vectors as the LAN VF driver.

Signed-off-by: Sergey Nemov <sergey.nemov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -419,6 +419,16 @@ static int i40e_config_iwarp_qvlist(stru
 	u32 next_q_idx, next_q_type;
 	u32 msix_vf, size;
 
+	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
+
+	if (qvlist_info->num_vectors > msix_vf) {
+		dev_warn(&pf->pdev->dev,
+			 "Incorrect number of iwarp vectors %u. Maximum %u allowed.\n",
+			 qvlist_info->num_vectors,
+			 msix_vf);
+		goto err;
+	}
+
 	size = sizeof(struct virtchnl_iwarp_qvlist_info) +
 	       (sizeof(struct virtchnl_iwarp_qv_info) *
 						(qvlist_info->num_vectors - 1));


