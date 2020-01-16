Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F4B13FEA0
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404393AbgAPXhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:37:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389119AbgAPXbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A446820684;
        Thu, 16 Jan 2020 23:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217483;
        bh=i/BoBTbHaCjR2uOW+bt2S3QNtnumEbfBPYU9+J9pbMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHgbhU/TL2OJxlOhSD7LP3qUKSfxUnaLV1LN9Mms8+sOfNPeVUo4dm/gJK54MKekJ
         ZsxCUZrAWU21Tn+jfViTGUaIbi354OYbF+5ZVk5Wwc47Nd8mmndI4WGtsi/ceq8+O6
         vu6rwur3Y8/bq6iblLwJbQybAf7lRvHaqLsrv3II=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 17/71] iwlwifi: dbg_ini: fix memory leak in alloc_sgtable
Date:   Fri, 17 Jan 2020 00:18:15 +0100
Message-Id: <20200116231711.947825988@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit b4b814fec1a5a849383f7b3886b654a13abbda7d upstream.

In alloc_sgtable if alloc_page fails, the alocated table should be
released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -532,6 +532,7 @@ static struct scatterlist *alloc_sgtable
 				if (new_page)
 					__free_page(new_page);
 			}
+			kfree(table);
 			return NULL;
 		}
 		alloc_size = min_t(int, size, PAGE_SIZE);


