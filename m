Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832252ABC19
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbgKINeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730947AbgKINFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:05:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2767820789;
        Mon,  9 Nov 2020 13:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927151;
        bh=j6bCoaNE1qOxcaAdaphhyk4Ayzv5g6dyD4DCbCvBu2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqeSVjE+CEdmQbt/+AoecOXFa28CNQm9T0oaFqF/yNlrfoXRRW8ProF5KuraopVIC
         JltG16sPbpf6m9tF9Xo3Q9FSA8VJk8V2Xbxs1pX6hoTu2BzglQUy/ri3AgcLvRd0QN
         QDlsG1aC7xlBoeB+DIbwCJYlitXM67n1d/8WWSWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 11/48] i40e: Fix a potential NULL pointer dereference
Date:   Mon,  9 Nov 2020 13:55:20 +0100
Message-Id: <20201109125017.295641477@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 54902349ee95045b67e2f0c39b75f5418540064b upstream.

If 'kzalloc()' fails, a NULL pointer will be dereferenced.
Return an error code (-ENOMEM) instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -423,6 +423,9 @@ static int i40e_config_iwarp_qvlist(stru
 	       (sizeof(struct virtchnl_iwarp_qv_info) *
 						(qvlist_info->num_vectors - 1));
 	vf->qvlist_info = kzalloc(size, GFP_KERNEL);
+	if (!vf->qvlist_info)
+		return -ENOMEM;
+
 	vf->qvlist_info->num_vectors = qvlist_info->num_vectors;
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;


