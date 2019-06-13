Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B64440E7
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389899AbfFMQK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731250AbfFMInu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:43:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AAA32063F;
        Thu, 13 Jun 2019 08:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415430;
        bh=bumPwjUYm3KbL5tQQxLWSkjwkzOdzcWPzdKnPfV+b6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCsiuTd0jGxj06PtqMor9Ux6AFDfQRIuCQJaO1LbZUY+iu+g4+qknTr+a94/6biHQ
         uDCfhy6WYEUe8WQfv4kjpwQvCfGvZWi2zDTf4lqIYsB88Jdm/se6yB8ttV2pkNtly1
         cvMjiWAP3467qwNhQpExFsgnd0ab9IazOrrEIHiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/118] ice: Add missing case in print_link_msg for printing flow control
Date:   Thu, 13 Jun 2019 10:34:02 +0200
Message-Id: <20190613075650.090753020@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 203a068ac9e2722e4d118116acaa3a5586f9468a ]

Currently we aren't checking for the ICE_FC_NONE case for the current
flow control mode. This is causing "Unknown" to be printed for the
current flow control method if flow control is disabled. Fix this by
adding the case for ICE_FC_NONE to print "None".

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index db1543bca701..875f97aba6e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -652,6 +652,9 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	case ICE_FC_RX_PAUSE:
 		fc = "RX";
 		break;
+	case ICE_FC_NONE:
+		fc = "None";
+		break;
 	default:
 		fc = "Unknown";
 		break;
-- 
2.20.1



