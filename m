Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E811CAF9D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgEHNSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbgEHMn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6782C24979;
        Fri,  8 May 2020 12:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941807;
        bh=tbXcyaZNfFmDHZN22lJI6OOgSV6lty0rPKhvto5JcZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Peu919qpiMbmSNO0jvQ0InaNjfw92gkwEkBlofjGKn2G6rLPOhWWdN3PglJWoEzTq
         NRAqfTGzkF9/CLzQdWlSX71W9yNzVZb0YxtwtO5SlqEoOz+xDwBRYoopvbzqo3Drmy
         WHMEOchP4y19iQseq/aMhRJtwTedB5H+CgeNKoXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 4.4 179/312] i40e: fix an uninitialized variable bug
Date:   Fri,  8 May 2020 14:32:50 +0200
Message-Id: <20200508123137.074665351@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 1c306f7f62a38ee5f05f0ee994dfe82d654cf47c upstream.

We removed this initialization but it is required.  Let's put it back.

Fixes: 895106a577c4 ('i40e: trivial fixes')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/i40e/i40e_hmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
@@ -49,7 +49,7 @@ i40e_status i40e_add_sd_table_entry(stru
 	struct i40e_hmc_sd_entry *sd_entry;
 	bool dma_mem_alloc_done = false;
 	struct i40e_dma_mem mem;
-	i40e_status ret_code;
+	i40e_status ret_code = I40E_SUCCESS;
 	u64 alloc_len;
 
 	if (NULL == hmc_info->sd_table.sd_entry) {


