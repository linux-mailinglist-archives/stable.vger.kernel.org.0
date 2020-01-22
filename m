Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C22B1455B8
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgAVNYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:24:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730135AbgAVNYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:24:38 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5733A24688;
        Wed, 22 Jan 2020 13:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699478;
        bh=r8lgdM+IAdnVU5nqqGbAAWjmh/qm6nZ37gDcmBTo/Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Njp86w47clMERUyd8/ggMTu7fkS/Qw1xxbYawbGdgtPFFs5JZ0v5q9JxZrifYmMRF
         4Plzh39VOyJS2QMiOZCF6kUtc/FPt4EYwbthhibz7nIORKZaBwRfOeh3sll0j0O3Mb
         bkQWNHjOjaE3psWT1pVXq+WPZHwQ8QVBsRdT5ETE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5.4 158/222] i40e: prevent memory leak in i40e_setup_macvlans
Date:   Wed, 22 Jan 2020 10:29:04 +0100
Message-Id: <20200122092845.031107875@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 27d461333459d282ffa4a2bdb6b215a59d493a8f ]

In i40e_setup_macvlans if i40e_setup_channel fails the allocated memory
for ch should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7168,6 +7168,7 @@ static int i40e_setup_macvlans(struct i4
 		ch->num_queue_pairs = qcnt;
 		if (!i40e_setup_channel(pf, vsi, ch)) {
 			ret = -EINVAL;
+			kfree(ch);
 			goto err_free;
 		}
 		ch->parent_vsi = vsi;


