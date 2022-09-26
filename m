Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2FC5EA3E7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbiIZLf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238259AbiIZLec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:34:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AB254CA1;
        Mon, 26 Sep 2022 03:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F92760B6A;
        Mon, 26 Sep 2022 10:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4FFC433D7;
        Mon, 26 Sep 2022 10:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189016;
        bh=O9SJA4ghkAux3cvtpQ0yAtf9EdNN19N+uoX2sLICkTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GsX4KT+jMDdAjl3nT03djd0YVGdYZVY/G9am7DbzouXipsG7+oNHeulCs1suJI546
         YnJ5dIkBlHAWsHa65bmuee+WRrVNjUZGcyHWuC7OZ2pYwa6LbxPIr626ylxHifqVv1
         jwVZ9mCtXfUhCp+JI3FPlue+Fv+NEbzfEciU3ABc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gil Fine <gil.fine@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.19 047/207] thunderbolt: Add support for Intel Maple Ridge single port controller
Date:   Mon, 26 Sep 2022 12:10:36 +0200
Message-Id: <20220926100808.724222167@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gil Fine <gil.fine@intel.com>

commit 14c7d905283744809e6b82efae2f490660a11cda upstream.

Add support for Maple Ridge discrete USB4 host controller from Intel
which has a single USB4 port (versus the already supported dual port
Maple Ridge USB4 host controller).

Cc: stable@vger.kernel.org
Signed-off-by: Gil Fine <gil.fine@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/icm.c |    1 +
 drivers/thunderbolt/nhi.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2527,6 +2527,7 @@ struct tb *icm_probe(struct tb_nhi *nhi)
 		tb->cm_ops = &icm_icl_ops;
 		break;
 
+	case PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_2C_NHI:
 	case PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_4C_NHI:
 		icm->is_supported = icm_tgl_is_supported;
 		icm->get_mode = icm_ar_get_mode;
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -55,6 +55,7 @@ extern const struct tb_nhi_ops icl_nhi_o
  * need for the PCI quirk anymore as we will use ICM also on Apple
  * hardware.
  */
+#define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_2C_NHI		0x1134
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_4C_NHI		0x1137
 #define PCI_DEVICE_ID_INTEL_WIN_RIDGE_2C_NHI            0x157d
 #define PCI_DEVICE_ID_INTEL_WIN_RIDGE_2C_BRIDGE         0x157e


